MZ = MZ or {}
MZ.Config = MZ.Config or {}

-- Role definitions
-- Roles are listed in ascending order of permission level.
-- Add or rename roles here - commands reference these by name.
MZ.Config.Roles = {
    'user',        -- Default role, no elevated permissions
    'mod',         -- Moderator — can teleport (goto, bring)
    'admin',       -- Admin — can kick, ban, goto, bring
    'superadmin',  -- Super admin — all commands including setgroup
}
