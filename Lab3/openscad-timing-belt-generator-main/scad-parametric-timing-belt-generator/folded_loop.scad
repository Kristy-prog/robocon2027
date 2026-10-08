/* Generic compact closed timing-belt layout. Units: mm; internal angles: degrees.
 * Analytic lines/arcs/spirals are authoritative; polygons are derived.
 * Imported by timing_belt_generator.scad. No top-level geometry.
 */
function fl_finite(x) = is_num(x) && x-x == 0;
function fl_positive(x) = fl_finite(x) && x > 0;
function fl_mod(x, y) = x-y*floor(x/y);
function fl_sum(v, i=0, a=0) = i == len(v) ? a : fl_sum(v,i+1,a+v[i]);
function fl_prefix(v, i=0, a=0, out=[0]) = i == len(v) ? out : fl_prefix(v,i+1,a+v[i],concat(out,[a+v[i]]));
function fl_unit(a) = [cos(a),sin(a)];
function fl_normal(a) = [-sin(a),cos(a)];
function fl_angle(v) = atan2(v[1],v[0]);
function fl_cross(a,b) = a[0]*b[1]-a[1]*b[0];
function fl_reverse(v) = [for(i=[len(v)-1:-1:0]) v[i]];
function fl_clamp(x,a,b) = min(b,max(a,x));

// Segment records: [0,p,q], [1,center,r,start,sweep], [2,ri,b,start,end].
// Spiral r = ri + b * theta_radians, including reversed intervals.
function fl_arc(c,p,q,side,r) = let(a=fl_angle(p-c), z=fl_angle(q-c))
    [1,c,r,a,side*fl_mod(side*(z-a),360)];
function fl_spiral_integral(r,b) = (r*sqrt(r*r+b*b)+b*b*ln((r+sqrt(r*r+b*b))/b))/(2*b);
function fl_length(s) = s[0]==0 ? norm(s[2]-s[1]) : s[0]==1 ? s[2]*abs(s[4])*PI/180 :
    abs(fl_spiral_integral(s[1]+s[2]*s[4]*PI/180,s[2])-fl_spiral_integral(s[1]+s[2]*s[3]*PI/180,s[2]));
function fl_point(s,u) = s[0]==0 ? s[1]+u*(s[2]-s[1]) : s[0]==1 ? s[1]+s[2]*fl_unit(s[3]+u*s[4]) :
    let(t=s[3]+u*(s[4]-s[3])) (s[1]+s[2]*t*PI/180)*fl_unit(t);
function fl_tangent(s,u) = s[0]==0 ? fl_angle(s[2]-s[1]) : s[0]==1 ? s[3]+u*s[4]+sign(s[4])*90 :
    let(t=s[3]+u*(s[4]-s[3]),r=s[1]+s[2]*t*PI/180) t+atan2(r,s[2])+(s[4]<s[3]?180:0);
function fl_radius(s) = s[0]==0 ? 1e100 : s[0]==1 ? s[2] :
    let(r=s[1]+s[2]*min(s[3],s[4])*PI/180,b=s[2]) pow(r*r+b*b,1.5)/(r*r+2*b*b);
function fl_reverse_segment(s) = s[0]==0 ? [0,s[2],s[1]] : s[0]==1 ? [1,s[1],s[2],s[3]+s[4],-s[4]] : [2,s[1],s[2],s[4],s[3]];
function fl_reverse_path(path) = [for(s=fl_reverse(path)) fl_reverse_segment(s)];
function fl_partial_length(s,u) = s[0]!=2 ? u*fl_length(s) : fl_length([2,s[1],s[2],s[3],s[3]+u*(s[4]-s[3])]);
function fl_inverse(s,d,tol,lo=0,hi=1,k=0) = s[0]!=2 ? d/fl_length(s) :
    let(u=(lo+hi)/2,v=fl_partial_length(s,u))
    abs(v-d)<=tol ? u : assert(k<64,"Spiral station inversion did not converge")
    v<d ? fl_inverse(s,d,tol,u,hi,k+1) : fl_inverse(s,d,tol,lo,u,k+1);
function fl_segment_at(cum,d,i=0) = i>=len(cum)-2 || d<cum[i+1] ? i : fl_segment_at(cum,d,i+1);
function fl_pose(path,cum,d,tol) = let(i=fl_segment_at(cum,d),u=fl_inverse(path[i],d-cum[i],tol),p=fl_point(path[i],u))
    [p[0],p[1],fl_tangent(path[i],u),cum[i]+fl_partial_length(path[i],u)];

// All six Dubins families, with both circle-intersection branches for CCC.
// Branches 0..3: LSL, LSR, RSL, RSR; 4..7: LRL+/-, RLR+/-.
function fl_connector(p,a,q,z,r,branch) = branch<4 ?
    let(side=branch<2?1:-1,side2=branch%2==0?1:-1,c=p+side*r*fl_normal(a),d=q+side2*r*fl_normal(z),v=d-c,dist=norm(v),h=(side2-side)*r)
    dist<=abs(h)+1e-8 ? undef :
    let(t=fl_angle(v)-asin(h/dist),u=c-side*r*fl_normal(t),w=d-side2*r*fl_normal(t))
    [fl_arc(c,p,u,side,r),[0,u,w],fl_arc(d,w,q,side2,r)] :
    let(side=branch<6?1:-1,sgn=branch%2==0?1:-1,c=p+side*r*fl_normal(a),d=q+side*r*fl_normal(z),v=d-c,dist=norm(v))
    dist<1e-8 || dist>4*r ? undef :
    let(m=(c+d)/2+sgn*sqrt(max(0,4*r*r-dist*dist/4))*[-v[1],v[0]]/dist,u=(c+m)/2,w=(d+m)/2)
    [fl_arc(c,p,u,side,r),fl_arc(m,u,w,-side,r),fl_arc(d,w,q,side,r)];
function fl_candidate(ri,spacing,extent,r,inner,outer,delta=-180/PI) =
    let(b=spacing/PI,A=[2,ri,b,0,extent],B=[2,ri+spacing,b,extent+delta,delta],
        ic=fl_connector(fl_point(B,1),fl_tangent(B,1),fl_point(A,0),fl_tangent(A,0),r,inner),
        oc=fl_connector(fl_point(A,1),fl_tangent(A,1),fl_point(B,0),fl_tangent(B,0),r,outer))
    is_undef(ic)||is_undef(oc) ? undef :
    // This arm convention traverses clockwise; normalize to CCW.
    fl_reverse_path([for(s=concat([A],oc,[B],ic)) if(fl_length(s)>1e-8) s]);
function fl_path_length(p) = is_undef(p) ? undef : fl_sum([for(s=p) fl_length(s)]);
function fl_residual(ri,sp,t,r,ib,ob,L,delta=-180/PI) = let(p=fl_candidate(ri,sp,t,r,ib,ob,delta)) is_undef(p)?undef:fl_path_length(p)-L;
// A wrapped circular sweep changes by almost 360 degrees at a branch cut.
// Discard such brackets instead of bisecting across a different arc branch.
function fl_same_branch(a,b) = is_undef(a)||is_undef(b)||len(a)!=len(b)?false:
    min([for(i=[0:len(a)-1]) a[i][0]!=b[i][0]?0:
        a[i][0]==1 && abs(a[i][4]-b[i][4])>=180?0:1])==1;
// Root refinement remains within a fixed branch. Reject discontinuous roots
// by residual and final pose/geometry validation; never switch branches here.
function fl_root(ri,sp,r,ib,ob,L,lo,hi,flo,fhi,tol,k=0,delta=-180/PI) =
    let(mid=(lo+hi)/2,p=fl_candidate(ri,sp,mid,r,ib,ob,delta),f=is_undef(p)?undef:fl_path_length(p)-L,
        continuous=fl_same_branch(fl_candidate(ri,sp,lo,r,ib,ob,delta),p)&&fl_same_branch(p,fl_candidate(ri,sp,hi,r,ib,ob,delta)))
    is_undef(f)||!continuous ? undef : abs(f)<=tol ? mid : k>=64 ? undef :
    flo*f<=0 ? fl_root(ri,sp,r,ib,ob,L,lo,mid,flo,f,tol,k+1,delta) : fl_root(ri,sp,r,ib,ob,L,mid,hi,f,fhi,tol,k+1,delta);

// The second derivative bound for a spiral with respect to theta is
// sqrt(r^2+4*b^2). Linear interpolation deviates by at most M*dt^2/8.
// For the normal offset, bound |n''| by 4+2*(b/rmin)^3.
function fl_steps(s,e,thickness=0) = s[0]==0 ? max(1,ceil(fl_length(s)/5)) : s[0]==1 ?
    max(1,ceil(abs(s[4])/(2*acos(max(-1,1-e/(s[2]+thickness)))))) :
    let(r=s[1]+s[2]*max(s[3],s[4])*PI/180,rmin=s[1]+s[2]*min(s[3],s[4])*PI/180,
        M=sqrt(r*r+4*s[2]*s[2])+thickness*(4+2*pow(s[2]/rmin,3)))
    max(1,ceil(abs(s[4]-s[3])*PI/180/sqrt(8*e/M)));
function fl_samples(path,e,thickness=0) = [for(s=path) let(n=fl_steps(s,e,thickness)) for(i=[0:n-1]) fl_point(s,i/n)];
function fl_sample_records(path,e) = let(c=fl_prefix([for(s=path) fl_length(s)]))
    [for(j=[0:len(path)-1]) let(s=path[j],n=fl_steps(s,e)) for(i=[0:n-1])
        [fl_point(s,i/n),c[j]+fl_partial_length(s,i/n)]];
function fl_bounds(pts,pad=0) = [[min([for(p=pts)p[0]])-pad,min([for(p=pts)p[1]])-pad],
                               [max([for(p=pts)p[0]])+pad,max([for(p=pts)p[1]])+pad]];
function fl_size(bounds) = bounds[1]-bounds[0];
function fl_area(pts) = fl_sum([for(i=[0:len(pts)-1]) fl_cross(pts[i],pts[(i+1)%len(pts)])])/2;
function fl_point_distance(p,a,b) = let(v=b-a,t=fl_clamp((p-a)*v/(v*v),0,1)) norm(p-a-t*v);
function fl_distance(a,b,c,d) =
    let(v=b-a,w=d-c,den=fl_cross(v,w),u=abs(den)<1e-12?2:fl_cross(c-a,w)/den,t=abs(den)<1e-12?2:fl_cross(c-a,v)/den)
    u>=0&&u<=1&&t>=0&&t<=1 ? 0 : min(fl_point_distance(a,c,d),fl_point_distance(b,c,d),fl_point_distance(c,a,b),fl_point_distance(d,a,b));
function fl_boxes_near(a,b,c,d,limit) =
    max(min(a[0],b[0])-max(c[0],d[0]),min(c[0],d[0])-max(a[0],b[0]))<=limit &&
    max(min(a[1],b[1])-max(c[1],d[1]),min(c[1],d[1])-max(a[1],b[1]))<=limit;
// Local continuity: a regular tube of radius < R is locally embedded through
// a half-turn of a curve with curvature <= 1/R. Check all chord pairs whose
// supporting intervals can be farther apart than pi*R, including seam pairs.
function fl_clearance(path,radius,envelope,e,gap) =
    let(rec=fl_sample_records(path,e),N=len(rec),L=fl_path_length(path),limit=2*(envelope+e)+gap,
        near=[for(i=[0:N-1]) let(a=rec[i][0],b=rec[(i+1)%N][0],si=rec[i][1],ei=i==N-1?L:rec[i+1][1])
            for(j=[i+1:1:N-1]) let(c=rec[j][0],d=rec[(j+1)%N][0],sj=rec[j][1],ej=j==N-1?L:rec[j+1][1],
                mid=(sj+ej-si-ei)/2,apart=min(mid,L-mid)+(ei-si+ej-sj)/2)
            if(apart>=PI*radius && fl_boxes_near(a,b,c,d,limit)) fl_distance(a,b,c,d)],
        // Pairs outside the broad-phase boxes certify only the requested gap.
        // Do not report a larger minimum based on the remaining subset.
        lower=len(near)==0?gap:min(near)-2*(envelope+e)) min(gap,lower);
function fl_joins_ok(path) = min([for(i=[0:len(path)-1]) let(a=path[i],b=path[(i+1)%len(path)])
    norm(fl_point(a,1)-fl_point(b,0))<=0.001 && abs(fl_mod(fl_tangent(a,1)-fl_tangent(b,0)+180,360)-180)<=0.001 ? 1:0])==1;
function fl_basic_ok(p,r,size,env,e,allow_rotate=false) = is_undef(p)?false:
    let(pts=fl_samples(p,e),bounds=fl_size(fl_bounds(pts,env+e)))
    min([for(s=p) fl_radius(s)])>=r-1e-8 && fl_joins_ok(p) && fl_area(pts)>0 && fl_fits(bounds,size,allow_rotate);

function fl_fits(bounds,size,allow_rotate) =
    (bounds[0]<=size[0] && bounds[1]<=size[1]) ||
    (allow_rotate && bounds[1]<=size[0] && bounds[0]<=size[1]);
function fl_rotation(bounds,size) = bounds[0]<=size[0] && bounds[1]<=size[1] ? 0 : 90;
// Search breadth changes candidates, never accuracy or validation constraints.
function fl_quality(q) = assert(q=="fast"||q=="normal"||q=="high",str("Unknown solver_quality: ",q)) q;
function fl_unique(v) = [for(i=[0:len(v)-1])if(len([for(j=[0:1:i-1])if(v[j]==v[i])j])==0)v[i]];
function fl_search_radii(r,q) = q=="fast"?[7*r/3]:q=="normal"?[2.1*r,7*r/3,2.5*r]:[1.9*r,2.1*r,7*r/3,2.5*r,2.7*r];
function fl_search_spacings(r,env,gap,q) = let(base=2*env+gap+max(gap,.1*r),
    normal=[max(2*r/3,base),max(.8*r,1.2*base),max(r,1.5*base)])
    fl_unique(q=="fast"?[normal[0]]:q=="normal"?normal:concat(normal,[1.05*base,1.8*base]));
function fl_solutions(L,r,size,env,gap,lt,e,allow_rotate=false,quality="normal") =
    let(q=fl_quality(quality),intervals=q=="fast"?8:q=="normal"?16:32)
    [for(ri=fl_search_radii(r,q)) for(sp=fl_search_spacings(r,env,gap,q))
        for(delta=q=="high"?[-180/PI,-1.25*180/PI,-.75*180/PI]:[-180/PI])
        let(b=sp/PI,hi=max(0,(norm(size)/2-ri-sp)/b*180/PI),lo=1)
        if(hi>lo) for(ib=[0:7]) for(ob=[0:7])
        let(ts=[for(k=[0:intervals]) lo+(hi-lo)*k/intervals],fs=[for(t=ts) fl_residual(ri,sp,t,r,ib,ob,L,delta)])
        for(k=[0:intervals-1]) if(!is_undef(fs[k])&&!is_undef(fs[k+1])&&fs[k]*fs[k+1]<=0)
        let(t=fl_root(ri,sp,r,ib,ob,L,ts[k],ts[k+1],fs[k],fs[k+1],lt/2,0,delta)) if(!is_undef(t))
        let(p=fl_candidate(ri,sp,t,r,ib,ob,delta)) if(fl_basic_ok(p,r,size,env,e,allow_rotate))
        let(bounds=fl_size(fl_bounds(fl_samples(p,e),env+e)))
        [bounds[0]*bounds[1],p,[ri,sp,t,ib,ob,delta],fl_rotation(bounds,size)]];
// Select minimum footprint area among validated candidates. Expensive
// clearance checks only run when a candidate can improve the current best.
function fl_choose(candidates,r,env,e,gap,i=0,best=undef) = i==len(candidates)?best:
    let(c=candidates[i],promising=is_undef(best)?true:c[0]<=best[0],
        coarse=promising?fl_clearance(c[1],r,env,0.4,gap):-100,
        clearance=promising && coarse+1.6>=gap ? fl_clearance(c[1],r,env,e,gap):-1,
        better=clearance>=gap && (is_undef(best)?true:c[0]<best[0]||clearance>best[4]))
    fl_choose(candidates,r,env,e,gap,i+1,better?concat(c,[clearance]):best);

module folded_loop_belt(tooth_pitch,tooth_envelope,tooth_root,tooth_count,belt_length,belt_width,backing_thickness,
                        max_size,min_bend_radius=15,min_track_gap=2,length_tolerance=0.01,geometry_tolerance=0.02,allow_rotate=true,solver_quality="normal") {
    assert(fl_positive(tooth_pitch)&&fl_positive(tooth_envelope)&&fl_positive(tooth_root),"Invalid resolved tooth metadata")
    assert(is_bool(allow_rotate),"allow_rotate must be true or false")
    assert(fl_quality(solver_quality)==solver_quality)
    assert(is_list(max_size)&&len(max_size)==2,"max_size must be [width,height]")
    assert(fl_positive(max_size[0])&&fl_positive(max_size[1]),"max_size dimensions must be finite and positive")
    assert(fl_positive(belt_width)&&fl_positive(backing_thickness),"Belt width and backing thickness must be finite and positive")
    assert(fl_positive(min_bend_radius)&&fl_finite(min_track_gap)&&min_track_gap>=0,"Invalid bend radius or track gap")
    assert(fl_positive(length_tolerance)&&fl_positive(geometry_tolerance),"Tolerances must be finite and positive")
    assert(is_undef(tooth_count)?fl_positive(belt_length):fl_positive(tooth_count)&&floor(tooth_count)==tooth_count,
           "Provide a positive integer tooth_count or positive belt_length")
    fl_generate(is_undef(tooth_count)?ceil(belt_length/tooth_pitch):tooth_count,
                belt_width,backing_thickness,max_size,min_bend_radius,
                min_track_gap,length_tolerance,geometry_tolerance,tooth_pitch,tooth_envelope,tooth_root,allow_rotate,solver_quality) children();
}

module fl_generate(count,belt_width,backing_thickness,max_size,min_bend_radius,
                   min_track_gap,length_tolerance,geometry_tolerance,tooth_pitch,tooth_envelope,tooth_root,allow_rotate,solver_quality) {
    L=count*tooth_pitch;
    // Bounding disk contains the entire unchanged tooth polygon, including
    // its tangential width and negative root. The backing is also enclosed.
    env=max(tooth_envelope,backing_thickness);
    e=min(geometry_tolerance/2,0.01,tooth_root/10);
    assert(env+e<min_bend_radius,"Belt envelope must be smaller than minimum bend radius")
    assert(backing_thickness>e*2,"Backing too thin for requested geometry tolerance")
    assert(length_tolerance<tooth_pitch/2,"length_tolerance must be less than half a tooth pitch")
    assert(L*1e-12<length_tolerance/10,"Requested length tolerance is below the floating-point budget")
    fl_search_and_render(count,belt_width,backing_thickness,max_size,min_bend_radius,
                         min_track_gap,length_tolerance,e,env,tooth_pitch,allow_rotate,solver_quality) children();
}

module fl_search_and_render(count,belt_width,backing_thickness,max_size,min_bend_radius,
                           min_track_gap,length_tolerance,e,env,tooth_pitch,allow_rotate,solver_quality) {
    L=count*tooth_pitch;
    echo(str("folded_loop search: resolved teeth=",count,", target=",L,
             "; quality=",solver_quality,"; radii=",fl_search_radii(min_bend_radius,solver_quality),
             "; spacings=",fl_search_spacings(min_bend_radius,env,min_track_gap,solver_quality),"; 8 x 8 connector branches; max 64 refinements"));
    // A circle needs no packing when it already fits. It uses the same analytic
    // segment, stationing, validation, and rendering pipeline as folded paths.
    circle=[[1,[0,0],L/(2*PI),0,360]];
    circle_clearance=fl_basic_ok(circle,min_bend_radius,max_size,env,e,allow_rotate)?fl_clearance(circle,min_bend_radius,env,e,min_track_gap):-1;
    circle_ok=circle_clearance>=min_track_gap;
    candidates=circle_ok?[]:fl_solutions(L,min_bend_radius,max_size,env,min_track_gap,length_tolerance,e,allow_rotate,solver_quality);
    best=circle_ok?[pow(L/PI+2*(env+e),2),circle,["circle"],0,circle_clearance]:fl_choose(candidates,min_bend_radius,env,e,min_track_gap);
    assert(!is_undef(best),str("No valid layout found within the configured candidate family and search limits. Requested ",count,
        " teeth at pitch ",tooth_pitch,", ",L," mm reference length, ",max_size," mm footprint, radius ",min_bend_radius,
        ", gap ",min_track_gap,". Length/pose/footprint candidates: ",len(candidates),
        "; none passed conservative envelope clearance. Try a larger max_size or solver_quality=high; constraints are never relaxed automatically."));
    if (!is_undef(best))
        fl_render(best,count,belt_width,backing_thickness,length_tolerance,e,env,tooth_pitch) children();
}

module fl_render(best,count,belt_width,backing_thickness,length_tolerance,e,env,tooth_pitch) {
    L=count*tooth_pitch;
    path=best[1];
    cum=fl_prefix([for(s=path)fl_length(s)]);
    actual=cum[len(cum)-1];
    poses=[for(i=[0:count-1])fl_pose(path,cum,i*tooth_pitch,length_tolerance/10)];
    assert(abs(actual-L)<=length_tolerance*0.6,"Reference length error exceeds budget");
    assert(max([for(i=[0:count-2])abs(poses[i+1][3]-poses[i][3]-tooth_pitch)])<=length_tolerance/5+1e-8,"Station interval error exceeds budget");
    assert(abs(actual-poses[count-1][3]+poses[0][3]-tooth_pitch)<=length_tolerance,"Closing station interval exceeds budget");
    records=[for(s=path)let(n=fl_steps(s,e,backing_thickness))for(i=[0:n-1]) [fl_point(s,i/n),fl_normal(fl_tangent(s,i/n))]];
    inner=[for(v=records)v[0]];
    outer=[for(v=records)v[0]-backing_thickness*v[1]];
    bounds=fl_bounds(fl_samples(path,e),env+e);
    center=(bounds[0]+bounds[1])/2;
    echo(str("folded_loop PATH VALID: count=",count,", nominal pitch=",tooth_pitch,"; reference length=",actual,
        "; residual=",actual-L,"; closing interval=",actual-poses[count-1][3]+poses[0][3],
        "; conservative footprint=",best[3]==0?fl_size(bounds):fl_reverse(fl_size(bounds)),"; rotation=",best[3],"; minimum radius=",min([for(s=path)fl_radius(s)]),
        "; certified clearance lower bound=",best[4],"; candidate [ri,spacing,extent,inner,outer,phase]=",best[2],
        "; geometry error <= ",e,"; station error <= ",length_tolerance/10));
    echo("Exported-mesh topology: not evaluated in SCAD. Physical pulley fit: not tested.");
    // Union in 2D before extrusion. A 3D union of coplanar tooth/backing
    // faces can leave sub-micron slivers in otherwise manifold STL output.
    rotate([0,0,best[3]]) translate([-center[0],-center[1],0])
    linear_extrude(height=belt_width,convexity=20) union() {
        difference() {
            polygon(outer);
            polygon(inner);
        }
        for(p=poses)translate([p[0],p[1],0])rotate([0,0,p[2]])projection(cut=false)children();
    }
}
