From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors: Reformat the output of the
 xmtdiscard details.
Date: Tue, 10 Nov 2009 14:04:40 -0800
Message-ID: <20091110140440.c6b30018.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 13:58:03 -0800
Subject: [PATCH] infiniband-diags/ibqueryerrors: Reformat the output of the xmtdiscard details.

Old:
Errors for 0x2c9020040fec8 "Infiniscale-IV Mellanox Technologies"
   GUID 0x2c9020040fec8 port 27: [XmtDiscards == 8]
   GUID 0x2c9020040fec8 port 27: [PortNeighborMTUDiscards == 8]

New:
Errors for 0x2c9020040fec8 "Infiniscale-IV Mellanox Technologies"
   GUID 0x2c9020040fec8 port 27: [XmtDiscards == 8] [PortNeighborMTUDiscards == 8]

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   77 ++++++++++++++++------------------
 1 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 61a34e4..c8122e7 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -199,8 +199,35 @@ static void report_suppressed(void)
 	}
 }
 
-static void print_results(char *node_name, ibnd_node_t * node, uint8_t * pc,
-			  int portnum, int *header_printed)
+static int print_xmitdisc_details(char *buf, size_t size, ib_portid_t * portid,
+				  ibnd_node_t * node, char * node_name, int portnum)
+{
+	uint8_t pc[1024];
+	uint32_t val = 0;
+	int n = 0;
+	int i = 0;
+
+	memset(pc, 0, 1024);
+
+	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
+			  IB_GSI_PORT_XMIT_DISCARD_DETAILS,
+			  ibmad_port)) {
+		IBWARN("IB_GSI_PORT_XMIT_DISCARD_DETAILS query failed on %s, %s port %d",
+		node_name, portid2str(portid), portnum);
+		return 0;
+	}
+
+	for (n = 0, i = IB_PC_XMT_INACT_DISC_F; i <= IB_PC_XMT_SW_HOL_DISC_F; i++) {
+		mad_decode_field(pc, i, (void *)&val);
+		if (val)
+			n += snprintf(buf + n, size - n, " [%s == %d]",
+				      mad_field_name(i), val);
+	}
+	return n;
+}
+
+static void print_results(ib_portid_t * portid, char *node_name, ibnd_node_t * node,
+			  uint8_t * pc, int portnum, int *header_printed)
 {
 	char buf[1024];
 	char *str = buf;
@@ -219,6 +246,12 @@ static void print_results(char *node_name, ibnd_node_t * node, uint8_t * pc,
 		if (val)
 			n += snprintf(str + n, 1024 - n, " [%s == %d]",
 				      mad_field_name(i), val);
+
+		/* If there are PortXmitDiscards, get details (if supported) */
+		if (i == IB_PC_XMT_DISCARDS_F && details && val) {
+			n += print_xmitdisc_details(str + n, 1024-n, portid,
+						    node, node_name, portnum);
+		}
 	}
 
 	if (!suppress(IB_PC_XMT_WAIT_F)) {
@@ -274,35 +307,10 @@ static int query_cap_mask(ib_portid_t *portid, char *node_name, int portnum,
 	return 0;
 }
 
-static void print_xmitdisc_details(ibnd_node_t * node, char * node_name,
-				   uint8_t * pc, int portnum)
-{
-	char buf[1024];
-	char *str = buf;
-	uint32_t val = 0;
-	int n = 0;
-	int i = 0;
-
-	buf[0] = 0;
-	for (n = 0, i = IB_PC_XMT_INACT_DISC_F; i <= IB_PC_XMT_SW_HOL_DISC_F; i++) {
-		mad_decode_field(pc, i, (void *)&val);
-		if (val)
-			n += snprintf(str + n, 1024 - n, " [%s == %d]",
-				      mad_field_name(i), val);
-	}
-	if (n > 0) {
-		printf("   GUID 0x%" PRIx64 " port %d:%s\n", node->guid,
-		       portnum, str);
-		if (port_config)
-			print_port_config(node_name, node, portnum);
-	}
-}
-
 static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 		       ibnd_node_t * node, int portnum, int *header_printed)
 {
 	uint8_t pc[1024];
-	uint32_t xmtdisc;
 
 	memset(pc, 0, 1024);
 
@@ -317,20 +325,7 @@ static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 		uint32_t foo = 0;
 		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
 	}
-	print_results(node_name, node, pc, portnum, header_printed);
-
-	/* If there are PortXmitDiscards, get details (if supported) */
-	mad_decode_field(pc, IB_PC_XMT_DISCARDS_F, &xmtdisc);
-	if (details && xmtdisc) {
-		if (!pma_query_via(pc, portid, portnum, ibd_timeout,
-				   IB_GSI_PORT_XMIT_DISCARD_DETAILS,
-				   ibmad_port)) {
-			IBWARN("IB_GSI_PORT_XMIT_DISCARD_DETAILS query failed on %s, %s port %d",
-			       node_name, portid2str(portid), portnum);
-			return;
-		}
-		print_xmitdisc_details(node, node_name, pc, portnum);
-	}
+	print_results(portid, node_name, node, pc, portnum, header_printed);
 }
 
 static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
