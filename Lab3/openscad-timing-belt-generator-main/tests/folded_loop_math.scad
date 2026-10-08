use <../scad-parametric-timing-belt-generator/folded_loop.scad>

// Explicit primitives check closed-form lengths, inverse stationing, and signs.
assert(abs(fl_length([0,[0,0],[3,4]])-5)<1e-10);
assert(abs(fl_length([1,[0,0],15,0,180])-15*PI)<1e-10);
assert(fl_point([1,[0,0],15,0,180],0)==[15,0]);
assert(abs(fl_tangent([1,[0,0],15,0,180],0)-90)<1e-10);
assert(fl_finite(5) && !fl_finite(undef) && !fl_finite("5"));
assert(fl_distance([0,0],[2,0],[1,-1],[1,1])==0);
assert(abs(fl_distance([0,0],[2,0],[0,3],[2,3])-3)<1e-10);
for(ib=[0:7]) {
    connector=fl_connector([0,0],20,[30,20],150,15,ib);
    if(!is_undef(connector)) {
        assert(norm(fl_point(connector[0],0)-[0,0])<1e-8);
        assert(norm(fl_point(connector[2],1)-[30,20])<1e-8);
        for(i=[0:1]) {
            assert(norm(fl_point(connector[i],1)-fl_point(connector[i+1],0))<1e-8);
            assert(abs(fl_mod(fl_tangent(connector[i],1)-fl_tangent(connector[i+1],0)+180,360)-180)<1e-8);
        }
    }
}

// A known feasible branch, solved again rather than freezing a sampled path.
L=1270;
lo=550; hi=560;
t=fl_root(35,10,15,4,3,L,lo,hi,fl_residual(35,10,lo,15,4,3,L),fl_residual(35,10,hi,15,4,3,L),0.00001);
p=fl_candidate(35,10,t,15,4,3);
assert(fl_joins_ok(p));
assert(abs(fl_path_length(p)-L)<0.00002);
assert(fl_basic_ok(p,15,[170,170],norm([1.89036,2.198511]),.005));
assert(fl_clearance(p,15,norm([1.89036,2.198511]),.005,2)>=2);
cum=fl_prefix([for(s=p)fl_length(s)]);
poses=[for(i=[0:253])fl_pose(p,cum,5*i,0.00001)];
assert(max([for(i=[0:252])abs(poses[i+1][3]-poses[i][3]-5)])<0.00003);
assert(abs(fl_path_length(p)-poses[253][3]+poses[0][3]-5)<0.00004);
assert(norm(fl_point(p[0],0)-fl_point(p[len(p)-1],1))<0.001);
// Encode numbers without losing significant digits to OpenSCAD's echo format.
function encoded(x)=is_list(x)?[for(v=x)encoded(v)]:[floor(x),round((x-floor(x))*100000)];
echo("analytic_path",encoded(p));
echo("tooth_poses",encoded(poses));
echo("MATH CHECKS PASSED");
