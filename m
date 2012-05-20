From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_switch.c: In osm_switch_set_hops, return, error
 when port_num is invalid
Date: Sun, 20 May 2012 10:45:03 -0400
Message-ID: <4FB9036F.7080803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From d9c3d7500e1a3abe871fc41a3c17246d6fede695 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Fri, 11 May 2012 14:58:17 +0300
Subject: [PATCH 1/2] opensm/osm_switch.c: In osm_switch_set_hops, return
 error when port_num is invalid

Port number can be 255 (which means drop) and such port number is past the end
of the hops array for that LID.

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff0f84700 (LWP 9890)]
0x0000000000440d33 in osm_switch_set_hops (p_sw=0x7fffc839c340, lid_ho=9447,
    port_num=255 '\377', num_hops=<value optimized out>) at osm_switch.c:74
74              p_sw->hops[lid_ho][port_num] = num_hops;
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.25.el6.x86_64
(gdb) bt
    lid_ho=9447, port_num=255 '\377', num_hops=<value optimized out>)
    at osm_switch.c:74
    at osm_ucast_ftree.c:750
    at osm_ucast_mgr.c:1058
    signal=<value optimized out>) at osm_state_mgr.c:1341
    at osm_state_mgr.c:1468
    at cl_thread.c:57

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_switch.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 6377742..d756e24 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -64,6 +64,8 @@ cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
 {
 	if (!lid_ho || lid_ho > p_sw->max_lid_ho)
 		return -1;
+	if (port_num >= p_sw->num_ports)
+		return -1;
 	if (!p_sw->hops[lid_ho]) {
 		p_sw->hops[lid_ho] = malloc(p_sw->num_ports);
 		if (!p_sw->hops[lid_ho])
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
