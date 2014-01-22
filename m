From: <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/libibverbs: Display proper speed for RoCE devices
Date: Wed, 22 Jan 2014 17:19:03 +0530
Message-ID: <4b5b3757-bfbe-49a6-aa12-3267a11187d0@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

currently ibv_devinfo -v display active_width. However, on RoCE link_width
is not defined. Therefore adding checks on link_layer while displaying
active_link_speed and active_link_width.
Also adding check on link_layer while displaying LID, SM_LID and LMC.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 examples/devinfo.c |   36 +++++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index ff078e4..85c8c0a 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -149,6 +149,17 @@ static const char *speed_str(uint8_t speed)
 	}
 }
 
+static const char *roce_speed_str (uint8_t speed)
+{
+	switch (speed) {
+	case 1: return "2.5 Gbps";
+	case 2: return "5.0 Gbps";
+	case 4: return "10.0 Gbps";
+	case 8: return "40.0 Gbps";
+	default: return "invalid speed";
+	}
+}
+
 static const char *vl_str(uint8_t vl_num)
 {
 	switch (vl_num) {
@@ -305,9 +316,13 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		       mtu_str(port_attr.max_mtu), port_attr.max_mtu);
 		printf("\t\t\tactive_mtu:\t\t%s (%d)\n",
 		       mtu_str(port_attr.active_mtu), port_attr.active_mtu);
-		printf("\t\t\tsm_lid:\t\t\t%d\n", port_attr.sm_lid);
-		printf("\t\t\tport_lid:\t\t%d\n", port_attr.lid);
-		printf("\t\t\tport_lmc:\t\t0x%02x\n", port_attr.lmc);
+
+		if (port_attr.link_layer != IBV_LINK_LAYER_ETHERNET) {
+			printf("\t\t\tsm_lid:\t\t\t%d\n", port_attr.sm_lid);
+			printf("\t\t\tport_lid:\t\t%d\n", port_attr.lid);
+			printf("\t\t\tport_lmc:\t\t0x%02x\n", port_attr.lmc);
+		}
+
 		printf("\t\t\tlink_layer:\t\t%s\n",
 					link_layer_str(port_attr.link_layer));
 
@@ -323,10 +338,17 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 			printf("\t\t\tgid_tbl_len:\t\t%d\n", port_attr.gid_tbl_len);
 			printf("\t\t\tsubnet_timeout:\t\t%d\n", port_attr.subnet_timeout);
 			printf("\t\t\tinit_type_reply:\t%d\n", port_attr.init_type_reply);
-			printf("\t\t\tactive_width:\t\t%sX (%d)\n",
-			       width_str(port_attr.active_width), port_attr.active_width);
-			printf("\t\t\tactive_speed:\t\t%s (%d)\n",
-			       speed_str(port_attr.active_speed), port_attr.active_speed);
+
+			if (port_attr.link_layer != IBV_LINK_LAYER_ETHERNET) {
+				printf("\t\t\tactive_width:\t\t%sX (%d)\n",
+			               width_str(port_attr.active_width), port_attr.active_width);
+				printf("\t\t\tactive_speed:\t\t%s (%d)\n",
+			               speed_str(port_attr.active_speed), port_attr.active_speed);
+			} else {
+				printf("\t\t\tactive_speed:\t\t%s (%d)\n",
+                                       roce_speed_str(port_attr.active_speed * port_attr.active_width),
+                                       port_attr.active_speed * port_attr.active_width);
+			}
 			if (ib_dev->transport_type == IBV_TRANSPORT_IB)
 				printf("\t\t\tphys_state:\t\t%s (%d)\n",
 				       port_phy_state_str(port_attr.phys_state), port_attr.phys_state);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
