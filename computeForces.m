% Check for collisions with objects in the environment and compute the
% total force on the end effector

function [F, obsts_dull] = computeForces(surfs, texts, obsts, btns, pts)
%Input:
%surfs -- a cell of matrices showing surface position
%texts -- a matrix of structs, .area shows position, .character gives the
%       character of texture
%obsts -- a cell of (spherical) obstacles, position only? Position can
%       change
%btns -- a cell of buttons, will be pressed down if pressed and btnpressed is 0,
%       otherwise will pop up
%pts -- a matrix of structs, .pos gives point position, boolean value
%      .isattract indicates whether it gives attractive or repulsive field 


global posEE;
global velocity;

% Fill this in
F = [0;0;0];
obsts_dull(1) = struct('mass', 1, 'r', 0, 'pos', [0;0;0], 'v', [0;0;0]);

% Ensure the 0 configuration is in free space
[X0, ~] = updateQ([0, 0, 0]);
pos0 = X0(4, :);


for i = 1 : length(surfs)
    %Model surface repel force
    F = F + computeSurfaceRepel(posEE, surfs{i}, pos0);
end

for i  = 1 : length(texts)
    %Model and adding friction by texture
    Fn = computeSurfaceRepel(posEE, texts{i}.area, pos0);
    F = F + Fn;
    Fk = computeTextureForce(Fn, texts{i}.character, velocity) .* [0;1;1];
    F = F + Fk;
end

for i = 1 : length(obsts)
    %Model collision with obstacles
    Fk = computeObstacle(obsts(i));
    F = F + Fk;
    %Model the movement of obstacles
    obsts_dull(i) = updateObsPosition(obsts(i), pts{1}.pos, Fk, surfs);
end

for i = 1 : length(btns)
    %Model button event
    F = F + computeBtnForce(btns{i}.area, btns{i}.c, pos0);
end

for i = 1 : length(pts)
    %Model attractive and repulsive points -- warning: former code should
    %be modified
    if pts{i}.isattract
         F = F + computeAttForce(pts{i}.pos, pts{i}.strength);
     else
         F = F + computeRepForce();
    end
end

end