o_require = require
function copyt(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
  end

require = function(mod)
    local r = o_require(mod)
    if mod == "socket" then
      local orig = copyt(r)
        r.receive = function(self,...)
           local s = orig:receive(...)
           print("received value: " .. s)
           return s
         end
         r.send = function(self, z)
           local s = orig:send(z)
           print("received value: " .. z)
           return s
         end
        local r_udp = r.udp()
        r.udp = function(self)
            local fu = {
                settimeout = function(s, t) print(tostring(t)); return r_udp:settimeout(t) end,
                setsockname = function(s, t,d) print(("%s | %s"):format(t,d)); return r_udp:setsockname(t,d) end,
                setpeername = function(s, t,d) print(("%s | %s"):format(t,d)); return r_udp:setpeername(t,d) end,
                send = function(s, t) print("SENDED: " .. tostring(t)); return r_udp:send(t) end,
                receive = function(s) local t = r_udp:receive() print("RECEIVED " .. tostring(t)); if t =="ERR" then return "something but error" elseif t =="nil" then return "nenill" end return t end
              }
            -local o_send = fake_udp.send
            --local orig = copyt(fake_udp)
            fake_udp.send = function(self, s)
              local received = o_send(fake_udp, s) 
              print(s)
                return received
            end
            return fu
        end
    end
    return r
end
string.dump = "builtin"
io.read = nil

io_open = io.open
io.open = function(a, b)
  print("[!] io open -> ".. a .." | ".. b .. "\n")
  return io_open(a, b)
end

os.remove = function (a)
   print(a)
   end

__S = string.gsub
string.gsub = function(a,b,c)
    print(("SOURCE STRING ->  %s          %s   %s  "):format(a,b,c))
    return __S(a,b,c)
end
