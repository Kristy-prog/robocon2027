#!/usr/bin/env python3
"""CLI regression tests. Set OPENSCAD to a shell-split executable command.
Example on this Mac: OPENSCAD='arch -x86_64 /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
"""
import ast
import math
import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIBRARY = ROOT / 'scad-parametric-timing-belt-generator/timing_belt_generator.scad'
COMMAND = shlex.split(os.environ.get('OPENSCAD', 'openscad'))


def compile_scad(source):
    with tempfile.TemporaryDirectory(prefix='belt-check-') as folder:
        src, dst = Path(folder)/'test.scad', Path(folder)/'test.csg'
        src.write_text(f'use <{LIBRARY}>\n'+source)
        run = subprocess.run([*COMMAND, '-o', str(dst), str(src)], text=True, capture_output=True, timeout=600)
        return run.stdout+run.stderr, dst.read_text() if dst.exists() else ''


class GeneratorTests(unittest.TestCase):
    def test_invalid_inputs(self):
        base = dict(print_layout='"folded_loop"', tooth_profile='"HTD_5mm"', tooth_count='254', max_size='[170,170]')
        invalid = [('tooth_profile','"unknown"'), ('tooth_count','0'), ('tooth_count','-2'),
                   ('tooth_count','2.5'), ('tooth_count','"254"'), ('tooth_count','undef'),
                   ('max_size','[170]'), ('max_size','[0,170]'), ('max_size','"170"'),
                   ('belting_width','-1'), ('backing_thickness','0'), ('backing_thickness','0.001'),
                   ('min_track_gap','-1'), ('min_bend_radius','0'),
                   ('length_tolerance','0'), ('geometry_tolerance','-0.1'),
                   ('tooth_count','1/0'), ('max_size','[170,1/0]'), ('printer','"unknown"'),
                   ('solver_quality','"exhaustive"'), ('allow_rotate','1'),
                   ('belting_width','"9"'), ('backing_thickness','"1"'), ('min_track_gap','"2"')]
        for key, value in invalid:
            with self.subTest(key=key, value=value):
                args = dict(base, **{key:value})
                log, csg = compile_scad('belting('+','.join(f'{k}={v}' for k,v in args.items())+');')
                self.assertIn('ERROR: Assertion', log)
                self.assertNotIn('polygon(', csg)
                self.assertNotIn('WARNING:', log)

    def test_no_solution(self):
        log, csg = compile_scad('belting("folded_loop","HTD_5mm",254,max_size=[10,10]);')
        self.assertIn('No valid layout found within', log)
        self.assertNotIn('polygon(', csg)
        self.assertNotIn('WARNING:', log)

    def test_existing_layouts_and_import(self):
        for layout in ['straight','loop','loop_inner','loop_outer','loop_match','loop_offset','spiral']:
            with self.subTest(layout=layout):
                log, csg = compile_scad(f'belting("{layout}","HTD_5mm",20);')
                self.assertNotIn('ERROR:', log)
                self.assertNotIn('WARNING:', log)
                self.assertEqual(log.count('Generating a '), 1)
                self.assertIn('polygon(', csg)
        log, csg = compile_scad('')
        self.assertNotIn('Generating a ', log)
        self.assertNotIn('polygon(', csg)

    def test_math_and_independent_quadrature(self):
        import numpy as np
        from scipy.integrate import quad
        script = (ROOT/'tests/folded_loop_math.scad').read_text().replace(
            '../scad-parametric-timing-belt-generator/folded_loop.scad',
            str(ROOT/'scad-parametric-timing-belt-generator/folded_loop.scad'))
        log, _ = compile_scad(script)
        self.assertNotIn('ERROR:', log)
        self.assertNotIn('WARNING:', log)
        self.assertIn('MATH CHECKS PASSED', log)
        def decode(v):
            return v[0]+v[1]/100000 if len(v)==2 and all(isinstance(a,(int,float)) for a in v) else [decode(a) for a in v]
        path = decode(ast.literal_eval(re.search(r'ECHO: "analytic_path", (.*)',log)[1]))
        poses = decode(ast.literal_eval(re.search(r'ECHO: "tooth_poses", (.*)',log)[1]))
        def segment_length(s):
            if s[0] == 0: return np.linalg.norm(np.array(s[2])-s[1])
            if s[0] == 1: return s[2]*abs(math.radians(s[4]))
            _, ri, b, start, end = s
            return abs(quad(lambda t: math.hypot(ri+b*t,b),math.radians(start),math.radians(end),epsabs=1e-9)[0])
        self.assertAlmostEqual(sum(map(segment_length,path)),1270,delta=.001)
        self.assertEqual(len(poses),254)
        self.assertLess(max(abs(poses[i][3]-5*i) for i in range(254)),.00003)

    @unittest.skipUnless(os.environ.get('BELT_FULL_TESTS'),'Set BELT_FULL_TESTS=1 for repeated solver cases')
    def test_solver_variants(self):
        cases = [
            ('tooth_count=255,max_size=[170,170]',255),
            ('belt_length=1269.1,max_size=[170,170],max_diameter=0',254),
            ('tooth_count=254,belt_length=-1,max_diameter=170',254),
            ('tooth_count=254,max_size=[170,170],geometry_tolerance=.01',254),
        ]
        for args,count in cases:
            with self.subTest(args=args):
                log,csg=compile_scad('belting("folded_loop","HTD_5mm",'+args+');')
                self.assertNotIn('ERROR:',log)
                self.assertNotIn('WARNING:',log)
                self.assertIn(f'PATH VALID: count={count}',log)
                self.assertEqual(csg.count('polygon('),count+2)

class GenericTests(unittest.TestCase):
    def test_profile_coordinates_and_defaults(self):
        import json,hashlib
        baseline=json.loads((ROOT/'tests/profile_baseline.json').read_text())
        source='use <'+str(LIBRARY.parent/'profiles.scad')+'>\n'
        source+='for(p=belt_profiles()) echo("PROFILE",p,tooth_points(p[0]));'
        log,_=compile_scad(source)
        self.assertNotIn('ERROR:',log)
        for row in re.findall(r'ECHO: "PROFILE", (.*)',log):
            data,points=ast.literal_eval('['+row+']')
            self.assertEqual(data[1:],baseline[data[0]]['defaults'])
            # Echo rounds large coordinates; inspect the authoritative source
            # for a bit-for-bit polygon preservation check instead.
            source=(LIBRARY.parent/'profiles.scad').read_text()
            match=re.search(r'name=='+re.escape(json.dumps(data[0]))+r' \? (\[.*?\]) :',source)
            exact=ast.literal_eval(match[1]) if match else []
            self.assertEqual(hashlib.sha256(json.dumps(exact).encode()).hexdigest(),baseline[data[0]]['polygon_sha256'])

    def test_presets_aliases_and_rotation(self):
        source='use <'+str(LIBRARY.parent/'profiles.scad')+'>\n'
        source+='use <'+str(LIBRARY.parent/'printer_presets.scad')+'>\n'
        source+='use <'+str(LIBRARY.parent/'folded_loop.scad')+'>\n'
        source+='''assert(normalize_profile("GT2")=="GT2_2mm");
assert(normalize_profile("HTD-8M")=="HTD_8mm");
assert(printer_size("Bambu_A1_mini")==[170,170]);
assert(printer_size("Bambu_H2S")==[330,310]);
assert(printer_size("Bambu_H2D")==[290,310]);
assert(resolved_printer_size([100,120],"Bambu_A1_mini",0)==[100,120]);
assert(resolved_printer_size(undef,undef,180)==[180,180]);
assert(fl_fits([164,136],[140,180],true));
assert(!fl_fits([164,136],[140,180],false));
assert(fl_rotation([164,136],[140,180])==90);
assert(fl_quality("fast")=="fast" && fl_quality("high")=="high");
assert(len(fl_search_radii(15,"fast"))<len(fl_search_radii(15,"normal")));
assert(len(fl_search_radii(15,"normal"))<len(fl_search_radii(15,"high")));
echo("CONFIG CHECKS PASSED");'''
        log,_=compile_scad(source)
        self.assertNotIn('ERROR:',log)
        self.assertNotIn('WARNING:',log)
        self.assertIn('CONFIG CHECKS PASSED',log)

    def test_beginner_advanced_equivalence_and_positional_compatibility(self):
        simple='belting("folded_loop","GT2",40,printer="Bambu_A1_mini");'
        explicit='belting("folded_loop","GT2_2mm",40,undef,6,.76,0,[170,170],3*(norm([.747183,-.5])+2),2,.01,.02);'
        a,ca=compile_scad(simple);b,cb=compile_scad(explicit)
        self.assertNotIn('ERROR:',a+b)
        # Group nesting is fixed by the shared implementation, so CSG must match.
        self.assertEqual(ca,cb)
        a,ca=compile_scad('belting("loop","XL",35,undef,6.35,1.03,200);')
        b,cb=compile_scad('belting("loop","XL",tooth_count=35,belting_width=6.35,backing_thickness=1.03,max_diameter=200);')
        self.assertEqual(ca,cb)
        self.assertNotIn('ERROR:',a+b)

    def test_fractional_length_rounding(self):
        for profile,pitch in [('MXL',2.032),('XL',5.08),('40DP',2.073)]:
            for length,count in [(40*pitch,40),(40*pitch+.01,41)]:
                log,csg=compile_scad(f'belting("folded_loop","{profile}",belt_length={length},printer="Bambu_A1_mini");')
                self.assertNotIn('ERROR:',log)
                self.assertIn(f'PATH VALID: count={count}',log)
                self.assertEqual(csg.count('polygon('),count+2)

    @unittest.skipUnless(os.environ.get('BELT_FULL_TESTS'),'Set BELT_FULL_TESTS=1 for folded STL integration')
    def test_folded_generic_and_rotation(self):
        from verify_folded_belt import verify
        cases=[('GT2_2mm',369,6,.76,[110,110],3*(math.hypot(.747183,.5)+2)),
               ('HTD_5mm',254,9,1.73,[140,170],15)]
        for profile,count,width,back,size,radius in cases:
            with self.subTest(profile=profile),tempfile.TemporaryDirectory(prefix='belt-folded-') as folder:
                src,csg,stl=Path(folder)/'belt.scad',Path(folder)/'belt.csg',Path(folder)/'belt.stl'
                src.write_text(f'use <{LIBRARY}>\nbelting("folded_loop","{profile}",{count},max_size={size});')
                run=subprocess.run([*COMMAND,'-o',str(csg),'-o',str(stl),str(src)],capture_output=True,text=True,timeout=600)
                self.assertNotIn('ERROR:',run.stderr)
                self.assertNotIn('WARNING:',run.stderr)
                if profile=='HTD_5mm':self.assertIn('rotation=90',run.stderr)
                verify(csg,stl,count,2,width,back,size,radius)

    def test_saved_customizer_preset(self):
        with tempfile.TemporaryDirectory(prefix='belt-preset-') as folder:
            dst=Path(folder)/'preset.csg'
            run=subprocess.run([*COMMAND,'-o',str(dst),'-p',str(ROOT/'belt.json'),'-P','GT2 100T - A1 mini',str(ROOT/'belt.scad')],capture_output=True,text=True,timeout=120)
            self.assertNotIn('ERROR:',run.stderr)
            self.assertIn('count=100, nominal pitch=2',run.stderr)
            log,direct=compile_scad('belting("folded_loop","GT2_2mm",100,printer="Bambu_A1_mini");')
            self.assertNotIn('ERROR:',log)
            # Customizer adds assertion groups but leaves all geometry identical.
            self.assertEqual(re.findall(r'(?:polygon|multmatrix)\(.*',dst.read_text()),re.findall(r'(?:polygon|multmatrix)\(.*',direct))

    def test_all_profile_stls(self):
        import json
        from verify_folded_belt import verify
        baseline=json.loads((ROOT/'tests/profile_baseline.json').read_text())
        for profile,record in baseline.items():
            if profile=='belt':continue
            with self.subTest(profile=profile),tempfile.TemporaryDirectory(prefix='belt-profile-') as folder:
                pitch,back,width=record['defaults']
                src,stl,csg=Path(folder)/'belt.scad',Path(folder)/'belt.stl',Path(folder)/'belt.csg'
                src.write_text(f'use <{LIBRARY}>\nbelting("folded_loop","{profile}",40,max_size=[170,170]);')
                run=subprocess.run([*COMMAND,'-o',str(stl),'-o',str(csg),str(src)],capture_output=True,text=True,timeout=120)
                self.assertNotIn('ERROR:',run.stderr)
                self.assertNotIn('WARNING:',run.stderr)
                self.assertIn(f'nominal pitch={pitch:g}',run.stderr)
                verify(csg,stl,40,2,width,back,[170,170],3*pitch)

if __name__=='__main__':
    unittest.main(verbosity=2)
