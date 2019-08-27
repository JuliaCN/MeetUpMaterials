const RL = 3.09727
const BL = 1.9856
const FIELD_W = 220
const FIELD_H = 180
const SPEED_MAX = 125

function instruction(s::MyStrategy, field, id)
    self = field.self_robots[id]
    if id in [2,3,4,5]
        state = s.robot_state[id]
        return move(state, self, field.ball)
    end
    return (0, 0)
end

function drive(deg, maxspeed = SPEED_MAX)
    ω = deg / 180 * π
    v1 = maxspeed
    v2 = v1 - abs(ω) * RL
    return ω > 0 ? (v2, v1) : (v1, v2)
end

function angle(origin, target)
    (dx, dy) = target .- origin
    atand(dy, dx)
end

function anglediff(d1, d2)
    d=(d2 - d1 + 180) % 360 - 180
    return d < -180 ? d + 360 : d
end

function move(state, self, target)
    at = angle(self.position, target)
    as = self.rotation
    e = anglediff(as, at)
    #addsample(e)
    e_int = state[:e_int]
    e_last = state[:e_last]
    # You may need to adjust these parameters
    Kp = 5.5
    Ki = 0.25
    Kd = 2.7
    u = Kp * e+Ki * e_int + Kd * (e - e_last)
    state[:e_int] = e_int + e
    state[:e_last] = e
    drive(u, 50)
end
