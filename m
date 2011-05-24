From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] infiniband-diags: perfquery; print cap_mask for
 information
Date: Tue, 24 May 2011 14:42:02 -0700
Message-ID: <20110524144202.839a2682.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 12 May 2011 17:31:15 -0700
Subject: [PATCH 1/2] infiniband-diags: perfquery; print cap_mask for information

Also fix cap_mask endianess in error print

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/perfquery.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/src/perfquery.c b/src/perfquery.c
index d24c3c7..165c419 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -188,7 +188,8 @@ static void aggregate_perfcounters(void)
 	aggregate_32bit(&perf_count.xmtwait, val);
 }
 
-static void output_aggregate_perfcounters(ib_portid_t * portid)
+static void output_aggregate_perfcounters(ib_portid_t * portid,
+					  uint16_t cap_mask)
 {
 	char buf[1024];
 	uint32_t val = ALL_PORTS;
@@ -222,8 +223,8 @@ static void output_aggregate_perfcounters(ib_portid_t * portid)
 
 	mad_dump_perfcounters(buf, sizeof buf, pc, sizeof pc);
 
-	printf("# Port counters: %s port %d\n%s", portid2str(portid), ALL_PORTS,
-	       buf);
+	printf("# Port counters: %s port %d (CapMask: 0x%02X)\n%s",
+	       portid2str(portid), ALL_PORTS, ntohs(cap_mask), buf);
 }
 
 static void aggregate_perfcounters_ext(void)
@@ -253,7 +254,8 @@ static void aggregate_perfcounters_ext(void)
 	aggregate_64bit(&perf_count_ext.portmulticastrcvpkts, val64);
 }
 
-static void output_aggregate_perfcounters_ext(ib_portid_t * portid)
+static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
+					      uint16_t cap_mask)
 {
 	char buf[1024];
 	uint32_t val = ALL_PORTS;
@@ -280,8 +282,8 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid)
 
 	mad_dump_perfcounters_ext(buf, sizeof buf, pc, sizeof pc);
 
-	printf("# Port extended counters: %s port %d\n%s", portid2str(portid),
-	       ALL_PORTS, buf);
+	printf("# Port extended counters: %s port %d (CapMask: 0x%02X)\n%s",
+	       portid2str(portid), ALL_PORTS, ntohs(cap_mask), buf);
 }
 
 static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
@@ -313,7 +315,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 		if (!(cap_mask & IB_PM_EXT_WIDTH_SUPPORTED))	/* 1.2 errata: bit 9 is extended counter support */
 			IBWARN
 			    ("PerfMgt ClassPortInfo 0x%x extended counters not indicated\n",
-			     cap_mask);
+			     ntohs(cap_mask));
 
 		memset(pc, 0, sizeof(pc));
 		if (!pma_query_via(pc, portid, port, timeout,
@@ -328,11 +330,13 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 
 	if (!aggregate) {
 		if (extended)
-			printf("# Port extended counters: %s port %d\n%s",
-			       portid2str(portid), port, buf);
+			printf("# Port extended counters: %s port %d "
+			       "(CapMask: 0x%02X)\n%s",
+			       portid2str(portid), port, ntohs(cap_mask), buf);
 		else
-			printf("# Port counters: %s port %d\n%s",
-			       portid2str(portid), port, buf);
+			printf("# Port counters: %s port %d "
+			       "(CapMask: 0x%02X)\n%s",
+			       portid2str(portid), port, ntohs(cap_mask), buf);
 	}
 }
 
@@ -601,9 +605,11 @@ int main(int argc, char **argv)
 						       && !loop_ports));
 		if (all_ports_loop && !loop_ports) {
 			if (extended != 1)
-				output_aggregate_perfcounters(&portid);
+				output_aggregate_perfcounters(&portid,
+							      cap_mask);
 			else
-				output_aggregate_perfcounters_ext(&portid);
+				output_aggregate_perfcounters_ext(&portid,
+								  cap_mask);
 		}
 	} else
 		dump_perfcounters(extended, ibd_timeout, cap_mask, &portid,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
