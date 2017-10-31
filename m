From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH rdma-core] libibumad/umad.c: In get_port, ignore sysfs rate
 file errors
Date: Tue, 31 Oct 2017 08:14:58 -0400
Message-ID: <f4ae658c-0e2a-c264-e0b6-f1ed639237eb@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This can cause ibpanic in ibstat when width is not set properly
as can occur when QSPF is not plugged into port.

ibpanic: [7851] main: stat of IB device 'mlx5_1' failed: Invalid argument

It's caused by kernel sysfs.c:show_rate returning -EINVAL
and that error being treated as failure in umad.c:get_port.
With this change, Rate is displayed as 0 with ibstat for this scenario.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibumad/umad.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libibumad/umad.c b/libibumad/umad.c
index 535256e..dcb2c68 100644
--- a/libibumad/umad.c
+++ b/libibumad/umad.c
@@ -150,8 +150,7 @@ static int get_port(const char *ca_name, const char *dir, int portnum, umad_port
 		goto clean;
 	if (sys_read_uint(port_dir, SYS_PORT_PHY_STATE, &port->phys_state) < 0)
 		goto clean;
-	if (sys_read_uint(port_dir, SYS_PORT_RATE, &port->rate) < 0)
-		goto clean;
+	sys_read_uint(port_dir, SYS_PORT_RATE, &port->rate);
 	if (sys_read_uint(port_dir, SYS_PORT_CAPMASK, &capmask) < 0)
 		goto clean;
 
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
