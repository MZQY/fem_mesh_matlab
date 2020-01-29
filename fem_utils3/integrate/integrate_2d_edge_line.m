function v_int = integrate_2d_edge_line(geom, data_x, data_y)

assert(geom.is_2d==true, 'invalid geom');

v_int = {};
for i=1:length(geom.line)
    dx = geom.line{i}.dx;
    dy = geom.line{i}.dy;
    
    vx = data_x(geom.line{i}.idx);
    vy = data_y(geom.line{i}.idx);
    
    vx = (vx(1:end-1, :)+vx(2:end, :))./2.0;
    vy = (vy(1:end-1, :)+vy(2:end, :))./2.0;
        
    v_int{i} = abs(dx*vx+dy*vy);
end

end