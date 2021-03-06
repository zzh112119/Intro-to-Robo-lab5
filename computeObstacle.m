% computes the force feedback when EE interacts with obstacle
function Fn = computeObstacle(obs)
global posEE

Fn = [0;0;0];
c_obs = 0.10;
if norm(posEE' - obs.pos) < obs.r
    Fn = c_obs * (obs.r - norm(posEE' - obs.pos)) .* (posEE' - obs.pos) / norm(posEE' - obs.pos);
    disp(Fn);
end
