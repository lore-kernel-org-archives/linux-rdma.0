From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/libibnetdisc/ibnetdisc.c: Fix possible overrun
 of path
Date: Wed, 08 Jun 2011 08:47:15 -0400
Message-ID: <4DEF6F53.4060304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


when path->cnt is 63 in add_port_to_dpath

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 7ba87fd..4a4f33b 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -80,7 +80,7 @@ static int query_switch_info(smp_engine_t * engine, ib_portid_t * portid,
 
 static int add_port_to_dpath(ib_dr_path_t * path, int nextport)
 {
-	if (path->cnt > sizeof(path->p) - 1)
+	if (path->cnt > sizeof(path->p) - 2)
 		return -1;
 	++path->cnt;
 	path->p[path->cnt] = (uint8_t) nextport;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
