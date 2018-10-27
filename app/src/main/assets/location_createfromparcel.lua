-- This file is part of XPrivacyLua.

-- XPrivacyLua is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- XPrivacyLua is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with XPrivacyLua.  If not, see <http://www.gnu.org/licenses/>.

-- Copyright 2017-2018 Marcel Bokhorst (M66B)

function after(hook, param)
    local result = param:getResult()
    if result == nil then
        return false
    end
    local old = result:toString()

    local latitude = param:getSetting('location.latitude')
    local longitude = param:getSetting('location.longitude')
    local type = param:getSetting('location.type')
    if type == 'coarse' then
        local accuracy = param:getSetting('location.accuracy')
        latitude, longitude = randomoffset(latitude, longitude, accuracy)
    end

    result:setLatitude(latitude)
    result:setLongitude(longitude)
    return true, old, result:toString()
end

function randomoffset(latitude, longitude, radius)
    local r = radius / 111000; -- degrees

    local w = r * math.sqrt(math.random())
    local t = 2 * math.pi * math.random()
    local lonoff = w * math.cos(t)
    local latoff = w * math.sin(t)

    lonoff = lonoff / math.cos(math.rad(latitude))

    return latitude + latoff, longitude + lonoff
end
