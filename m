From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/libibnetdisc/ibnetdisc.c: Remove compile
 warning
Date: Wed, 03 Aug 2011 13:58:04 -0400
Message-ID: <4E398C2C.4020403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


src/ibnetdisc.c: In function 'ibnd_find_port_dr':
src/ibnetdisc.c:676: warning: 'rc' may be used uninitialized in this function

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 07f2a3f..9800c9d 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -673,7 +673,7 @@ ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric, char *dr_str)
 {
 	int i = 0;
 	ibnd_node_t *cur_node;
-	ibnd_port_t *rc;
+	ibnd_port_t *rc = NULL;
 	ib_dr_path_t path;
 
 	if (!fabric) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
