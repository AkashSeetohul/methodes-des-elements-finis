function mesh_s = mesh_new(name, coords, triangles)
    mesh_s = struct('name', name, 'coords', coords, 'triangles', triangles);