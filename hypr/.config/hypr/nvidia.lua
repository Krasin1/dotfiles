-- █▄░█ █░█ █ █▀▄ █ ▄▀█
-- █░▀█ ▀▄▀ █ █▄▀ █ █▀█
--
-- See https://wiki.hypr.land/Configuring/Nvidia/
-- Only applied when the NVIDIA driver utilities are installed.

local nvidiaSmi = io.open("/usr/bin/nvidia-smi", "r")
if nvidiaSmi then
    nvidiaSmi:close()

    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("__GL_VRR_ALLOWED", "1")
    hl.env("WLR_DRM_NO_ATOMIC", "1")

    hl.config({
        cursor = {
            no_hardware_cursors = true,
        },
    })
end
