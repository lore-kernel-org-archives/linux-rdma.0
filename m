From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] infiniband-diags/perfquery.c: Fix display of PortExtendedSpeedsCounters
Date: Thu, 01 Dec 2011 11:21:12 -0500
Message-ID: <4ED7A978.7060605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add additional buffer space for output
so no longer chopped after FECCorrectableBlockCtrLane11 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/perfquery.c b/src/perfquery.c
index 0dbb80d..c747d11 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -377,7 +377,7 @@ static void common_func(ib_portid_t * portid, int port_num, int mask,
 			const char *name, uint16_t attr,
 			void dump_func(char *, int, void *, int))
 {
-	char buf[1024];
+	char buf[1536];
 
 	if (query) {
 		memset(pc, 0, sizeof(pc));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
