

module mirror_copy(vec=[1,0,0]) {
    /*
    Same as mirror command, but makes a copy of the original.
    */
    children();
    mirror(vec) children();
}