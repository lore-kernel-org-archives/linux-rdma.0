From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibnetdisc.c: Add additional supported device
 IDs to is_mlnx_ext_port_info_supported
Date: Tue, 13 Jan 2015 08:58:15 -0500
Message-ID: <54B52477.7060506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Similar to previous ibdiag_common.c patch, this adds additional device IDs
to be supported to the ibnetdiscover internal is_mlnx_ext_port_info routine.
These IDs are ConnectX-4, some ConnectX-3s, and Switch-IB.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 121fe35..f3c6000 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -203,9 +203,9 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
 {
 	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
 
-	if (devid == 0xc738)
+	if (devid == 0xc738 || devid == 0xcb84)
 		return 1;
-	if (devid >= 0x1003 && devid <= 0x1011)
+	if (devid >= 0x1003 && devid <= 0x1016)
 		return 1;
 	return 0;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
