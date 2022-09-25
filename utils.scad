

module mirror_copy(vec=[1,0,0]) {
    /*
    Same as mirror command, but makes a copy of the original.
    */
    children();
    mirror(vec) children();
}


function unsigned_vector_angle(v0, v1) =
    acos( (v0 * v1) / (norm(v0) * norm(v1)) );


function signed_vector_angle(v0, v1, normal) =
    atan2(cross(v0, v1) * normal, v0 * v1);


function normalize(v) = 
    v / norm(v);