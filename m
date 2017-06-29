From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2 infiniband-diags] ibqueryerrors.c: Add support for
 additional counters in PortCountersExtended
Date: Thu, 29 Jun 2017 14:22:09 -0400
Message-ID: <86f95f32-ed79-3b6d-7a6e-7a5675ceb117@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Support 64 bit thresholds

 src/ibdiag_common.c |   2 +-
 src/ibqueryerrors.c | 119 +++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 81 insertions(+), 40 deletions(-)

diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index cd8f707..9245146 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -439,7 +439,7 @@ conv_cnt_human_readable(uint64_t val64, float *val, int data)
 {
 	uint64_t tmp = val64;
 	int ui = 0;
-	int div = 1;
+	uint64_t div = 1;
 
 	tmp /= 1024;
 	while (tmp) {
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 304dc15..4ea762a 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -105,15 +105,15 @@ static unsigned valid_gid(ib_gid_t * gid)
 	return memcmp(&zero_gid, gid, sizeof(*gid));
 }
 
-static void set_thres(char *name, uint32_t val)
+static void set_thres(char *name, uint64_t val)
 {
 	int f;
 	int n;
 	char tmp[256];
-	for (f = IB_PC_FIRST_F; f <= IB_PC_LAST_F; f++) {
+	for (f = IB_PC_EXT_ERR_SYM_F; f <= IB_PC_EXT_XMT_WAIT_F; f++) {
 		if (strcmp(name, mad_field_name(f)) == 0) {
 			mad_encode_field(thresholds, f, &val);
-			snprintf(tmp, 255, "[%s = %u]", name, val);
+			snprintf(tmp, 255, "[%s = %lu]", name, val);
 			threshold_str = realloc(threshold_str,
 					strlen(threshold_str)+strlen(tmp)+1);
 			if (!threshold_str) {
@@ -130,7 +130,7 @@ static void set_thres(char *name, uint32_t val)
 static void set_thresholds(char *threshold_file)
 {
 	char buf[1024];
-	int val = 0;
+	uint64_t val = 0;
 	FILE *thresf = fopen(threshold_file, "r");
 	char *p_prefix, *p_last;
 	char *name;
@@ -166,9 +166,9 @@ static void set_thresholds(char *threshold_file)
 	fclose(thresf);
 }
 
-static int exceeds_threshold(int field, unsigned val)
+static int exceeds_threshold(int field, uint64_t val)
 {
-	uint32_t thres = 0;
+	uint64_t thres = 0;
 	mad_decode_field(thresholds, field, &thres);
 	return (val > thres);
 }
@@ -392,28 +392,57 @@ static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
 	return n;
 }
 
+static int check_threshold(uint8_t *pc, uint8_t *pce, uint32_t cap_mask2,
+			 int i, int ext_i, int *n, char *str, size_t size)
+{
+	uint32_t val32 = 0;
+	uint64_t val64 = 0;
+	int is_exceeds = 0;
+	float val = 0;
+	char *unit = "";
+
+	if (htonl(cap_mask2) & IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP) {
+		mad_decode_field(pce, ext_i, (void *)&val64);
+		if (exceeds_threshold(ext_i, val64)) {
+			unit = conv_cnt_human_readable(val64, &val, 0);
+			*n += snprintf(str + *n, size - *n, " [%s == %lu (%5.3f%s)]",
+					  mad_field_name(ext_i), val64, val, unit);
+			is_exceeds = 1;
+		}
+
+	} else {
+		mad_decode_field(pc, i, (void *)&val32);
+		if (exceeds_threshold(ext_i, val32)) {
+			*n += snprintf(str + *n, size - *n, " [%s == %u]",
+					  mad_field_name(i), val32);
+			is_exceeds = 1;
+		}
+	}
+
+	return is_exceeds;
+}
 
 static int print_results(ib_portid_t * portid, char *node_name,
 			 ibnd_node_t * node, uint8_t * pc, int portnum,
-			 int *header_printed, uint8_t *pce, uint16_t cap_mask)
+			 int *header_printed, uint8_t *pce, uint16_t cap_mask,
+			 uint32_t cap_mask2)
 {
-	char buf[1024];
+	char buf[2048];
 	char *str = buf;
-	uint32_t val = 0;
-	int i, n;
+	int i, ext_i, n;
 
-	for (n = 0, i = IB_PC_ERR_SYM_F; i <= IB_PC_VL15_DROPPED_F; i++) {
+	for (n = 0, i = IB_PC_ERR_SYM_F, ext_i = IB_PC_EXT_ERR_SYM_F;
+			i <= IB_PC_VL15_DROPPED_F; i++, ext_i++ ) {
 		if (suppress(i))
 			continue;
 
 		/* this is not a counter, skip it */
-		if (i == IB_PC_COUNTER_SELECT2_F)
+		if (i == IB_PC_COUNTER_SELECT2_F) {
+			ext_i--;
 			continue;
+		}
 
-		mad_decode_field(pc, i, (void *)&val);
-		if (exceeds_threshold(i, val)) {
-			n += snprintf(str + n, 1024 - n, " [%s == %u]",
-				      mad_field_name(i), val);
+		if (check_threshold(pc, pce, cap_mask2, i, ext_i, &n, str, sizeof(buf))) {
 
 			/* If there are PortXmitDiscards, get details (if supported) */
 			if (i == IB_PC_XMT_DISCARDS_F && details) {
@@ -436,10 +465,8 @@ static int print_results(ib_portid_t * portid, char *node_name,
 	}
 
 	if (!suppress(IB_PC_XMT_WAIT_F)) {
-		mad_decode_field(pc, IB_PC_XMT_WAIT_F, (void *)&val);
-		if (exceeds_threshold(IB_PC_XMT_WAIT_F, val))
-			n += snprintf(str + n, 1024 - n, " [%s == %u]",
-				      mad_field_name(IB_PC_XMT_WAIT_F), val);
+		check_threshold(pc, pce, cap_mask2, IB_PC_XMT_WAIT_F,
+				IB_PC_EXT_XMT_WAIT_F, &n, str, sizeof(buf));
 	}
 
 	/* if we found errors. */
@@ -472,7 +499,7 @@ static int print_results(ib_portid_t * portid, char *node_name,
 						data = 1;
 					unit = conv_cnt_human_readable(val64,
 								&val, data);
-					n += snprintf(str + n, 1024 - n,
+					n += snprintf(str + n, sizeof(buf) - n,
 						" [%s == %" PRIu64
 						" (%5.3f%s)]",
 						mad_field_name(i), val64, val,
@@ -507,10 +534,11 @@ static int print_results(ib_portid_t * portid, char *node_name,
 }
 
 static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
-			  uint16_t * cap_mask)
+			  uint16_t * cap_mask, uint32_t * cap_mask2)
 {
 	uint8_t pc[1024] = { 0 };
 	uint16_t rc_cap_mask;
+	uint32_t rc_cap_mask2;
 
 	portid->sl = lid2sl_table[portid->lid];
 
@@ -525,8 +553,11 @@ static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
 
 	/* ClassPortInfo should be supported as part of libibmad */
 	memcpy(&rc_cap_mask, pc + 2, sizeof(rc_cap_mask));	/* CapabilityMask */
+	memcpy(&rc_cap_mask2, pc + 4, sizeof(rc_cap_mask2));	/* CapabilityMask2 */
+	rc_cap_mask2 = ntohl(rc_cap_mask2) >> 5;
 
 	*cap_mask = rc_cap_mask;
+	*cap_mask2 = rc_cap_mask2;
 	return 0;
 }
 
@@ -601,7 +632,7 @@ static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
 	return (0);
 }
 
-static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
+static int print_errors(ib_portid_t * portid, uint16_t cap_mask, uint32_t cap_mask2,
 			char *node_name, ibnd_node_t * node, int portnum,
 			int *header_printed)
 {
@@ -639,7 +670,7 @@ static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
 		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
 	}
 	return (print_results(portid, node_name, node, pc, portnum,
-			      header_printed, pc_ext, cap_mask));
+			      header_printed, pc_ext, cap_mask, cap_mask2));
 }
 
 uint8_t *reset_pc_ext(void *rcvbuf, ib_portid_t * dest,
@@ -668,6 +699,8 @@ uint8_t *reset_pc_ext(void *rcvbuf, ib_portid_t * dest,
 	/* Same for attribute IDs */
 	mad_set_field(rcvbuf, 0, IB_PC_EXT_PORT_SELECT_F, port);
 	mad_set_field(rcvbuf, 0, IB_PC_EXT_COUNTER_SELECT_F, mask);
+	mask = mask >> 16;
+	mad_set_field(rcvbuf, 0, IB_PC_EXT_COUNTER_SELECT2_F, mask);
 	rpc.attr.mod = 0;
 	rpc.timeout = timeout;
 	rpc.datasz = IB_PC_DATA_SZ;
@@ -680,7 +713,7 @@ uint8_t *reset_pc_ext(void *rcvbuf, ib_portid_t * dest,
 	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
 }
 
-static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
+static void clear_port(ib_portid_t * portid, uint16_t cap_mask, uint32_t cap_mask2,
 		       char *node_name, int port)
 {
 	uint8_t pc[1024] = { 0 };
@@ -714,15 +747,22 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 				      ibmad_port);
 	}
 
-	if (clear_counts &&
-	    (cap_mask &
-	     (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP))) {
-		if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED)
-			mask = 0xFF;
-		else
-			mask = 0x0F;
+	if (cap_mask & (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP)) {
+		mask = 0;
+		if (clear_counts) {
+			if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED)
+				mask = 0xFF;
+			else
+				mask = 0x0F;
+		}
+
+		if (clear_errors && (htonl(cap_mask2) & IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP)) {
+			mask |= 0xfff0000;
+			if (cap_mask & IB_PM_PC_XMIT_WAIT_SUP)
+				mask |= (1 << 28);
+		}
 
-		if (!reset_pc_ext(pc, portid, port, mask, ibd_timeout,
+		if (mask && !reset_pc_ext(pc, portid, port, mask, ibd_timeout,
 		    ibmad_port))
 			fprintf(stderr, "Failed to reset extended data counters %s, "
 				"%s port %d\n", node_name, portid2str(portid),
@@ -739,6 +779,7 @@ void print_node(ibnd_node_t * node, void *user_data)
 	int all_port_sup = 0;
 	ib_portid_t portid = { 0 };
 	uint16_t cap_mask = 0;
+	uint32_t cap_mask2 = 0;
 	char *node_name = NULL;
 
 	switch (node->type) {
@@ -775,7 +816,7 @@ void print_node(ibnd_node_t * node, void *user_data)
 		}
 	}
 
-	if ((query_cap_mask(&portid, node_name, p, &cap_mask) == 0) &&
+	if ((query_cap_mask(&portid, node_name, p, &cap_mask, &cap_mask2) == 0) &&
 	    (cap_mask & IB_PM_ALL_PORT_SELECT))
 		all_port_sup = 1;
 
@@ -792,12 +833,12 @@ void print_node(ibnd_node_t * node, void *user_data)
 						&header_printed);
 				summary.ports_checked++;
 				if (!all_port_sup)
-					clear_port(&portid, cap_mask, node_name, p);
+					clear_port(&portid, cap_mask, cap_mask2, node_name, p);
 			}
 		}
 	} else {
 		if (all_port_sup)
-			if (!print_errors(&portid, cap_mask, node_name, node,
+			if (!print_errors(&portid, cap_mask, cap_mask2, node_name, node,
 					  0xFF, &header_printed)) {
 				summary.ports_checked += node->numports;
 				goto clear;
@@ -811,11 +852,11 @@ void print_node(ibnd_node_t * node, void *user_data)
 					ib_portid_set(&portid, node->ports[p]->base_lid,
 						      0, 0);
 
-				print_errors(&portid, cap_mask, node_name, node, p,
+				print_errors(&portid, cap_mask, cap_mask2, node_name, node, p,
 					     &header_printed);
 				summary.ports_checked++;
 				if (!all_port_sup)
-					clear_port(&portid, cap_mask, node_name, p);
+					clear_port(&portid, cap_mask, cap_mask2, node_name, p);
 			}
 		}
 	}
@@ -823,7 +864,7 @@ void print_node(ibnd_node_t * node, void *user_data)
 clear:
 	summary.nodes_checked++;
 	if (all_port_sup)
-		clear_port(&portid, cap_mask, node_name, 0xFF);
+		clear_port(&portid, cap_mask, cap_mask2, node_name, 0xFF);
 
 	free(node_name);
 }
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
