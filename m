From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/perfquery: merge some code
Date: Fri, 30 Oct 2009 00:51:59 +0200
Message-ID: <20091029225159.GM20136@me>
References: <20090923130017.GB7307@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090923130017.GB7307-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Merge some obviously repeated code in optional counters processing
functions.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/perfquery.c |   91 ++++++++++++--------------------------
 1 files changed, 29 insertions(+), 62 deletions(-)

diff --git a/infiniband-diags/src/perfquery.c b/infiniband-diags/src/perfquery.c
index 74f9235..42fffe6 100644
--- a/infiniband-diags/src/perfquery.c
+++ b/infiniband-diags/src/perfquery.c
@@ -346,81 +346,48 @@ static void reset_counters(int extended, int timeout, int mask,
 static int reset, reset_only, all_ports, loop_ports, port, extended, xmt_sl,
     rcv_sl, xmt_disc;
 
-void xmt_sl_query(ib_portid_t * portid, int port, int mask)
+static void common_func(ib_portid_t *portid, int port_num, int mask,
+			unsigned query, unsigned reset,
+			const char *name, uint16_t attr,
+			void dump_func(char *, int, void *, int))
 {
 	char buf[1024];
 
-	if (reset_only) {
-		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
-					   IB_GSI_PORT_XMIT_DATA_SL, srcport))
-			IBERROR("perfslreset");
-		return;
-	}
+	if (query) {
+		if (!pma_query_via(pc, portid, port_num, ibd_timeout, attr,
+				   srcport))
+			IBERROR("cannot query %s", name);
 
-	if (!pma_query_via(pc, portid, port, ibd_timeout,
-			   IB_GSI_PORT_XMIT_DATA_SL, srcport))
-		IBERROR("perfslquery");
+		dump_func(buf, sizeof(buf), pc, sizeof(pc));
 
-	mad_dump_perfcounters_xmt_sl(buf, sizeof buf, pc, sizeof pc);
-	printf("# PortXmitDataSL counters: %s port %d\n%s", portid2str(portid),
-	       port, buf);
+		printf("# %s counters: %s port %d\n%s", name,
+		       portid2str(portid), port_num, buf);
+	}
 
-	if (reset)
-		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
-					   IB_GSI_PORT_XMIT_DATA_SL, srcport))
-			IBERROR("perfslreset");
+	if (reset && !performance_reset_via(pc, portid, port, mask, ibd_timeout,
+					    attr, srcport))
+		IBERROR("cannot reset %s", name);
 }
 
-void rcv_sl_query(ib_portid_t * portid, int port, int mask)
+static void xmt_sl_query(ib_portid_t * portid, int port, int mask)
 {
-	char buf[1024];
-
-	if (reset_only) {
-		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
-					   IB_GSI_PORT_RCV_DATA_SL, srcport))
-			IBERROR("perfslreset");
-		return;
-	}
-
-	if (!pma_query_via(pc, portid, port, ibd_timeout,
-			   IB_GSI_PORT_RCV_DATA_SL, srcport))
-		IBERROR("perfslquery");
-
-	mad_dump_perfcounters_rcv_sl(buf, sizeof buf, pc, sizeof pc);
-	printf("# PortRcvDataSL counters: %s port %d\n%s", portid2str(portid),
-	       port, buf);
-
-	if (reset)
-		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
-					   IB_GSI_PORT_RCV_DATA_SL, srcport))
-			IBERROR("perfslreset");
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortXmitDataSL", IB_GSI_PORT_XMIT_DATA_SL,
+		    mad_dump_perfcounters_xmt_sl);
 }
 
-void xmt_disc_query(ib_portid_t * portid, int port, int mask)
+static void rcv_sl_query(ib_portid_t * portid, int port, int mask)
 {
-	char buf[1024];
-
-	if (reset_only) {
-		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
-					   IB_GSI_PORT_XMIT_DISCARD_DETAILS,
-					   srcport))
-		IBERROR("xmtdiscreset");
-		return;
-	}
-
-	if (!pma_query_via(pc, portid, port, ibd_timeout,
-			   IB_GSI_PORT_XMIT_DISCARD_DETAILS, srcport))
-		IBERROR("xmtdiscquery");
-
-	mad_dump_perfcounters_xmt_disc(buf, sizeof buf, pc, sizeof pc);
-	printf("# PortXmitDiscardDetails: %s port %d\n%s", portid2str(portid),
-	       port, buf);
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortRcvDataSL", IB_GSI_PORT_RCV_DATA_SL,
+		    mad_dump_perfcounters_rcv_sl);
+}
 
-	if (reset)
-		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
-					   IB_GSI_PORT_XMIT_DISCARD_DETAILS,
-					   srcport))
-			IBERROR("xmtdiscreset");
+static void xmt_disc_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortXmitDiscardDetails", IB_GSI_PORT_XMIT_DISCARD_DETAILS,
+		    mad_dump_perfcounters_xmt_disc);
 }
 
 static int process_opt(void *context, int ch, char *optarg)
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
