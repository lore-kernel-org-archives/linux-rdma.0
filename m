From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/4] infiniband-diags: saquery; remove "result" global
Date: Tue, 5 Jul 2011 12:08:12 -0700
Message-ID: <20110705120812.797c07e0.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


make struct sa_query_result a paramenter of sa_query.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |  124 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 69 insertions(+), 55 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 7933fec..73acea5 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -64,7 +64,7 @@ struct bind_handle {
 	ib_portid_t dport;
 };
 
-struct query_res {
+struct sa_query_result {
 	uint32_t status;
 	unsigned result_cnt;
 	void *p_result_madw;
@@ -105,7 +105,6 @@ static uint64_t smkey = 1;
  */
 #define MAX_PORTS (8)
 #define DEFAULT_SA_TIMEOUT_MS (1000)
-static struct query_res result;
 
 enum {
 	ALL,
@@ -166,7 +165,7 @@ static inline void report_err(int status)
 
 static int sa_query(struct bind_handle *h, uint8_t method,
 		    uint16_t attr, uint32_t mod, uint64_t comp_mask,
-		    uint64_t sm_key, void *data)
+		    uint64_t sm_key, void *data, struct sa_query_result *result)
 {
 	ib_rpc_t rpc;
 	void *umad, *mad;
@@ -218,21 +217,21 @@ recv_mad:
 
 	method = (uint8_t) mad_get_field(mad, 0, IB_MAD_METHOD_F);
 	offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
-	result.status = mad_get_field(mad, 0, IB_MAD_STATUS_F);
-	result.p_result_madw = mad;
-	if (result.status != IB_SA_MAD_STATUS_SUCCESS)
-		result.result_cnt = 0;
+	result->status = mad_get_field(mad, 0, IB_MAD_STATUS_F);
+	result->p_result_madw = mad;
+	if (result->status != IB_SA_MAD_STATUS_SUCCESS)
+		result->result_cnt = 0;
 	else if (method != IB_MAD_METHOD_GET_TABLE)
-		result.result_cnt = 1;
+		result->result_cnt = 1;
 	else if (!offset)
-		result.result_cnt = 0;
+		result->result_cnt = 0;
 	else
-		result.result_cnt = (len - IB_SA_DATA_OFFS) / (offset << 3);
+		result->result_cnt = (len - IB_SA_DATA_OFFS) / (offset << 3);
 
 	return 0;
 }
 
-static void *get_query_rec(void *mad, unsigned i)
+static void *sa_get_query_rec(void *mad, unsigned i)
 {
 	int offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
 	return (uint8_t *) mad + IB_SA_DATA_OFFS + i * (offset << 3);
@@ -483,11 +482,11 @@ static void dump_multicast_group_record(void *data)
 	       p_mcmr->mtu, cl_ntoh16(p_mcmr->pkey), p_mcmr->rate, sl);
 }
 
-static void dump_multicast_member_record(void *data)
+static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
+					 struct sa_query_result *nr_result)
 {
 	char gid_str[INET6_ADDRSTRLEN];
 	char gid_str2[INET6_ADDRSTRLEN];
-	ib_member_rec_t *p_mcmr = data;
 	uint16_t mlid = cl_ntoh16(p_mcmr->mlid);
 	unsigned i = 0;
 	char *node_name = "<unknown>";
@@ -496,8 +495,8 @@ static void dump_multicast_member_record(void *data)
 	 * this port gid interface id.
 	 * This gives us a node name to print, if available.
 	 */
-	for (i = 0; i < result.result_cnt; i++) {
-		ib_node_record_t *nr = get_query_rec(result.p_result_madw, i);
+	for (i = 0; i < nr_result->result_cnt; i++) {
+		ib_node_record_t *nr = sa_get_query_rec(nr_result->p_result_madw, i);
 		if (nr->node_info.port_guid ==
 		    p_mcmr->port_gid.unicast.interface_id) {
 			node_name =
@@ -829,20 +828,20 @@ static void dump_one_mft_record(void *data)
 	printf("\n");
 }
 
-static void dump_results(struct query_res *r, void (*dump_func) (void *))
+static void dump_results(struct sa_query_result *r, void (*dump_func) (void *))
 {
 	unsigned i;
 	for (i = 0; i < r->result_cnt; i++) {
-		void *data = get_query_rec(r->p_result_madw, i);
+		void *data = sa_get_query_rec(r->p_result_madw, i);
 		dump_func(data);
 	}
 }
 
-static void return_mad(void)
+static void sa_free_result_mad(struct sa_query_result *result)
 {
-	if (result.p_result_madw) {
-		free((uint8_t *) result.p_result_madw - umad_size());
-		result.p_result_madw = NULL;
+	if (result->p_result_madw) {
+		free((uint8_t *) result->p_result_madw - umad_size());
+		result->p_result_madw = NULL;
 	}
 }
 
@@ -851,17 +850,18 @@ static void return_mad(void)
  */
 static int get_any_records(bind_handle_t h,
 			   uint16_t attr_id, uint32_t attr_mod,
-			   ib_net64_t comp_mask, void *attr, uint64_t sm_key)
+			   ib_net64_t comp_mask, void *attr, uint64_t sm_key,
+			   struct sa_query_result *result)
 {
 	int ret = sa_query(h, IB_MAD_METHOD_GET_TABLE, attr_id, attr_mod,
-			   cl_ntoh64(comp_mask), sm_key, attr);
+			   cl_ntoh64(comp_mask), sm_key, attr, result);
 	if (ret) {
 		fprintf(stderr, "Query SA failed: %s\n", ib_get_err_str(ret));
 		return ret;
 	}
 
-	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
-		report_err(result.status);
+	if (result->status != IB_SA_MAD_STATUS_SUCCESS) {
+		report_err(result->status);
 		return EIO;
 	}
 
@@ -873,33 +873,37 @@ static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 				    void *attr, uint64_t sm_key,
 				    void (*dump_func) (void *))
 {
+	struct sa_query_result result;
 	int ret = get_any_records(h, attr_id, attr_mod, comp_mask, attr,
-				  sm_key);
+				  sm_key, &result);
 	if (ret)
 		return ret;
 
 	dump_results(&result, dump_func);
-	return_mad();
+	sa_free_result_mad(&result);
 	return 0;
 }
 
 /**
  * Get all the records available for requested query type.
  */
-static int get_all_records(bind_handle_t h, uint16_t attr_id, int trusted)
+static int get_all_records(bind_handle_t h, uint16_t attr_id, int trusted,
+			   struct sa_query_result *result)
 {
-	return get_any_records(h, attr_id, 0, 0, NULL, trusted ? smkey : 0);
+	return get_any_records(h, attr_id, 0, 0, NULL, trusted ? smkey : 0,
+			       result);
 }
 
 static int get_and_dump_all_records(bind_handle_t h, uint16_t attr_id,
 				    int trusted, void (*dump_func) (void *))
 {
-	int ret = get_all_records(h, attr_id, 0);
+	struct sa_query_result result;
+	int ret = get_all_records(h, attr_id, 0, &result);
 	if (ret)
 		return ret;
 
 	dump_results(&result, dump_func);
-	return_mad();
+	sa_free_result_mad(&result);
 	return ret;
 }
 
@@ -912,14 +916,15 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 	ib_node_info_t *p_ni = NULL;
 	unsigned i;
 	int ret;
+	struct sa_query_result result;
 
-	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0);
+	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0, &result);
 	if (ret)
 		return ret;
 
 	ret = IB_NOT_FOUND;
 	for (i = 0; i < result.result_cnt; i++) {
-		node_record = get_query_rec(result.p_result_madw, i);
+		node_record = sa_get_query_rec(result.p_result_madw, i);
 		p_ni = &(node_record->node_info);
 		if (name
 		    && strncmp(name, (char *)node_record->node_desc.description,
@@ -930,7 +935,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 			break;
 		}
 	}
-	return_mad();
+	sa_free_result_mad(&result);
 	return ret;
 }
 
@@ -1022,7 +1027,8 @@ static int parse_lid_and_ports(bind_handle_t h,
 /*
  * Get the portinfo records available with IsSM or IsSMdisabled CapabilityMask bit on.
  */
-static int get_issm_records(bind_handle_t h, ib_net32_t capability_mask)
+static int get_issm_records(bind_handle_t h, ib_net32_t capability_mask,
+			    struct sa_query_result *result)
 {
 	ib_portinfo_record_t attr;
 
@@ -1030,15 +1036,16 @@ static int get_issm_records(bind_handle_t h, ib_net32_t capability_mask)
 	attr.port_info.capability_mask = capability_mask;
 
 	return get_any_records(h, IB_SA_ATTR_PORTINFORECORD, 1 << 31,
-			       IB_PIR_COMPMASK_CAPMASK, &attr, 0);
+			       IB_PIR_COMPMASK_CAPMASK, &attr, 0, result);
 }
 
 static int print_node_records(bind_handle_t h)
 {
 	unsigned i;
 	int ret;
+	struct sa_query_result result;
 
-	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0);
+	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0, &result);
 	if (ret)
 		return ret;
 
@@ -1048,7 +1055,7 @@ static int print_node_records(bind_handle_t h)
 	}
 	for (i = 0; i < result.result_cnt; i++) {
 		ib_node_record_t *node_record;
-		node_record = get_query_rec(result.p_result_madw, i);
+		node_record = sa_get_query_rec(result.p_result_madw, i);
 		if (node_print_desc == ALL_DESC) {
 			print_node_desc(node_record);
 		} else if (node_print_desc == NAME_OF_LID) {
@@ -1067,20 +1074,21 @@ static int print_node_records(bind_handle_t h)
 					    node_desc.description)) == 0)) {
 				print_node_record(node_record);
 				if (node_print_desc == UNIQUE_LID_ONLY) {
-					return_mad();
+					sa_free_result_mad(&result);
 					exit(0);
 				}
 			}
 		}
 	}
-	return_mad();
+	sa_free_result_mad(&result);
 	return ret;
 }
 
 static int get_print_class_port_info(bind_handle_t h)
 {
+	struct sa_query_result result;
 	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
-			   0, NULL);
+			   0, NULL, &result);
 	if (ret) {
 		fprintf(stderr, "ERROR: Query SA failed: %s\n",
 			ib_get_err_str(ret));
@@ -1093,7 +1101,7 @@ static int get_print_class_port_info(bind_handle_t h)
 	}
 	dump_results(&result, dump_class_port_info);
 Exit:
-	return_mad();
+	sa_free_result_mad(&result);
 	return ret;
 }
 
@@ -1133,50 +1141,56 @@ static int query_path_records(const struct query_cmd *q, bind_handle_t h,
 
 static int print_issm_records(bind_handle_t h)
 {
+	struct sa_query_result result;
 	int ret = 0;
 
 	/* First, get IsSM records */
-	ret = get_issm_records(h, IB_PORT_CAP_IS_SM);
+	ret = get_issm_records(h, IB_PORT_CAP_IS_SM, &result);
 	if (ret != 0)
 		return (ret);
 
 	printf("IsSM ports\n");
 	dump_results(&result, dump_portinfo_record);
-	return_mad();
+	sa_free_result_mad(&result);
 
 	/* Now, get IsSMdisabled records */
-	ret = get_issm_records(h, IB_PORT_CAP_SM_DISAB);
+	ret = get_issm_records(h, IB_PORT_CAP_SM_DISAB, &result);
 	if (ret != 0)
 		return (ret);
 
 	printf("\nIsSMdisabled ports\n");
 	dump_results(&result, dump_portinfo_record);
-	return_mad();
+	sa_free_result_mad(&result);
 
 	return (ret);
 }
 
 static int print_multicast_member_records(bind_handle_t h)
 {
-	struct query_res mc_group_result;
+	struct sa_query_result mc_group_result;
+	struct sa_query_result nr_result;
 	int ret;
+	unsigned i;
 
-	ret = get_all_records(h, IB_SA_ATTR_MCRECORD, 1);
+	ret = get_all_records(h, IB_SA_ATTR_MCRECORD, 1, &mc_group_result);
 	if (ret)
 		return ret;
 
-	mc_group_result = result;
-
-	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0);
+	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0, &nr_result);
 	if (ret)
 		goto return_mc;
 
-	dump_results(&mc_group_result, dump_multicast_member_record);
-	return_mad();
+	for (i = 0; i < mc_group_result.result_cnt; i++) {
+		ib_member_rec_t *rec = (ib_member_rec_t *)
+				sa_get_query_rec(mc_group_result.p_result_madw,
+					      i);
+		dump_multicast_member_record(rec, &nr_result);
+	}
+
+	sa_free_result_mad(&nr_result);
 
 return_mc:
-	if (mc_group_result.p_result_madw)
-		free((uint8_t *) mc_group_result.p_result_madw - umad_size());
+	sa_free_result_mad(&mc_group_result);
 
 	return ret;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
