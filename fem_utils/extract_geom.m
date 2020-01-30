function geom = extract_geom(geom)

geom = find_duplicate_pts(geom);

switch geom.type
    case 'edge_2d'
        geom = compute_edge_2d(geom);
    case 'edge_3d'
        geom = compute_edge_3d(geom);
    case 'surface_2d'
        geom = compute_surface_2d(geom);
    case 'surface_3d'
        geom = compute_surface_3d(geom);
    case 'volume_3d'
        geom = compute_volume_3d(geom);
    otherwise
        error('invalid type')
end

end

function geom_new = find_duplicate_pts(geom)

switch geom.type
    case {'edge_2d', 'surface_2d'}
        pts = [geom.x ; geom.y];
    case {'edge_3d', 'surface_3d', 'volume_3d'}
        pts = [geom.x ; geom.y ; geom.z];
    otherwise
        error('invalid type')
end

[pts_unique, idx, idx_rev] = unique(pts.','rows');
tri_unique = changem(geom.tri, idx_rev, 1:geom.n);
tri_unique = unique(tri_unique,'rows');

geom_new.type = geom.type;
geom_new.n = length(idx);
geom_new.idx = idx;
geom_new.idx_rev = idx_rev;
geom_new.tri = tri_unique;
switch geom.type
    case {'edge_2d', 'surface_2d'}
        geom_new.x = geom.x(idx);
        geom_new.y = geom.y(idx);
    case {'edge_3d', 'surface_3d', 'volume_3d'}
        geom_new.x = geom.x(idx);
        geom_new.y = geom.y(idx);
        geom_new.z = geom.z(idx);
    otherwise
        error('invalid type')
end

end

function geom = compute_edge_3d(geom)

% assign
x = geom.x;
y = geom.y;
z = geom.z;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];

% get the direction vector
d_x = AB(1,:);
d_y = AB(2,:);
d_z = AB(3,:);

% get the length
length_tri = sqrt(d_x.^2+d_y.^2+d_z.^2);

% assign
geom.length_tri = length_tri;
geom.length = sum(length_tri);
geom.d_x = d_x;
geom.d_y = d_y;
geom.d_z = d_z;

end

function geom = compute_edge_2d(geom)

% assign
x = geom.x;
y = geom.y;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1))];

% get the direction vector
d_x = AB(1,:);
d_y = AB(2,:);

% get the length
length_tri = sqrt(d_x.^2+d_y.^2);

% assign
geom.length_tri = length_tri;
geom.length = sum(length_tri);
geom.d_x = d_x;
geom.d_y = d_y;

end

function geom = compute_surface_2d(geom)

% assign
x = geom.x;
y = geom.y;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1))];

% get the cross product
cross = AB(1,:).*AC(2,:)-AB(2,:).*AC(1,:);

% get the area
area_tri = cross./2;

% assign
geom.area_tri = area_tri;
geom.area = sum(area_tri);

end

function geom = compute_surface_3d(geom)

% assign
x = geom.x;
y = geom.y;
z = geom.z;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1)) ; z(tri(:,3))-z(tri(:,1))];

% get the cross product
cross = [AB(2,:).*AC(3,:)-AB(3,:).*AC(2,:) ; AB(3,:).*AC(1,:)-AB(1,:).*AC(3,:) ; AB(1,:).*AC(2,:)-AB(2,:).*AC(1,:)];

% assign the normal vector
n_x = cross(1,:);
n_y = cross(2,:);
n_z = cross(3,:);

% get the area
area_tri = sqrt(n_x.^2+n_y.^2+n_z.^2)./2;

% assign
geom.area_tri = area_tri;
geom.area = sum(area_tri);
geom.n_x = n_x;
geom.n_y = n_y;
geom.n_z = n_z;

end

function geom = compute_volume_3d(geom)

% assign
x = geom.x;
y = geom.y;
z = geom.z;
tri = geom.tri;

% get the vector
AB = [x(tri(:,2))-x(tri(:,1)) ; y(tri(:,2))-y(tri(:,1)) ; z(tri(:,2))-z(tri(:,1))];
AC = [x(tri(:,3))-x(tri(:,1)) ; y(tri(:,3))-y(tri(:,1)) ; z(tri(:,3))-z(tri(:,1))];
AD = [x(tri(:,4))-x(tri(:,1)) ; y(tri(:,4))-y(tri(:,1)) ; z(tri(:,4))-z(tri(:,1))];

% compute the determinent
det_p = AB(1,:).*AC(2,:).*AD(3,:)+AC(1,:).*AD(2,:).*AB(3,:)+AD(1,:).*AB(2,:).*AC(3,:);
det_m = AB(3,:).*AC(2,:).*AD(1,:)+AC(3,:).*AD(2,:).*AB(1,:)+AD(3,:).*AB(2,:).*AC(1,:);

% compute the volume
volume_tri = abs(det_p-det_m)./6;

% assign
geom.volume_tri = volume_tri;
geom.volume = sum(volume_tri);

end