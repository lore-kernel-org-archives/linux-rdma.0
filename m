From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/libibnetdisc/ibnetdisc.c: Better error message
Date: Tue, 24 May 2011 14:26:33 -0400
Message-ID: <4DDBF859.7000503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

include node GUID and port number

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index e4487c1..7ba87fd 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -171,7 +171,8 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	if (!port) {
 		port = node->ports[port_num] = calloc(1, sizeof(*port));
 		if (!port) {
-			IBND_ERROR("Failed to allocate port\n");
+			IBND_ERROR("Failed to allocate 0x%" PRIx64 " port %u\n",
+				    node->guid, port_num);
 			return -1;
 		}
 		port->guid =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
