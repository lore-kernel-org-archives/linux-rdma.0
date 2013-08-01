From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] perfquery.c: Fix dumping of PortSamplesControl
Date: Thu, 01 Aug 2013 14:11:06 -0400
Message-ID: <51FAA4BA.7080800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


was stopping after CounterSelect10 field as insufficient buffer size for
dumping this attribute.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/perfquery.c b/src/perfquery.c
index 9a69ee1..112d92c 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -566,7 +566,7 @@ static void vlxmittimecc_query(ib_portid_t * portid, int port, int mask)
 
 void dump_portsamples_control(ib_portid_t * portid, int port)
 {
-	char buf[1024];
+	char buf[1280];
 
 	memset(pc, 0, sizeof(pc));
 	if (!pma_query_via(pc, portid, port, ibd_timeout,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
