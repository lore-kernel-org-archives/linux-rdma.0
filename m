From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: saquery avoid a potential seg fault in
 libibmad
Date: Fri, 1 Jun 2012 15:59:12 -0700
Message-ID: <20120601155912.483fc9aa.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The common function sa_query should pass the correct data size to mad_build_pkt
for it's internal memcpy.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    2 +-
 src/ibdiag_common.c     |    5 +++--
 src/saquery.c           |   34 ++++++++++++++++++----------------
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 6dade10..7e6d5c1 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -122,7 +122,7 @@ struct sa_query_result {
 };
 int sa_query(struct bind_handle *h, uint8_t method,
 	     uint16_t attr, uint32_t mod, uint64_t comp_mask, uint64_t sm_key,
-	     void *data, struct sa_query_result *result);
+	     void *data, size_t datasz, struct sa_query_result *result);
 void sa_free_result_mad(struct sa_query_result *result);
 void *sa_get_query_rec(void *mad, unsigned i);
 void sa_report_err(int status);
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index e242175..6b8aea0 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -725,7 +725,8 @@ void sa_free_bind_handle(bind_handle_t h)
 
 int sa_query(bind_handle_t h, uint8_t method,
 		    uint16_t attr, uint32_t mod, uint64_t comp_mask,
-		    uint64_t sm_key, void *data, struct sa_query_result *result)
+		    uint64_t sm_key, void *data, size_t datasz,
+		    struct sa_query_result *result)
 {
 	ib_rpc_t rpc;
 	void *umad, *mad;
@@ -737,7 +738,7 @@ int sa_query(bind_handle_t h, uint8_t method,
 	rpc.attr.id = attr;
 	rpc.attr.mod = mod;
 	rpc.mask = comp_mask;
-	rpc.datasz = IB_SA_DATA_SIZE;
+	rpc.datasz = datasz;
 	rpc.dataoffs = IB_SA_DATA_OFFS;
 
 	umad = calloc(1, len + umad_size());
diff --git a/src/saquery.c b/src/saquery.c
index 6e09374..c599e0c 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -724,10 +724,11 @@ static void dump_results(struct sa_query_result *r, void (*dump_func) (void *))
 static int get_any_records(bind_handle_t h,
 			   uint16_t attr_id, uint32_t attr_mod,
 			   ib_net64_t comp_mask, void *attr,
+			   size_t attr_size,
 			   struct sa_query_result *result)
 {
 	int ret = sa_query(h, IB_MAD_METHOD_GET_TABLE, attr_id, attr_mod,
-			   cl_ntoh64(comp_mask), ibd_sakey, attr, result);
+			   cl_ntoh64(comp_mask), ibd_sakey, attr, attr_size, result);
 	if (ret) {
 		fprintf(stderr, "Query SA failed: %s\n", strerror(ret));
 		return ret;
@@ -744,11 +745,12 @@ static int get_any_records(bind_handle_t h,
 static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 				    uint32_t attr_mod, ib_net64_t comp_mask,
 				    void *attr,
+				    size_t attr_size,
 				    void (*dump_func) (void *))
 {
 	struct sa_query_result result;
 	int ret = get_any_records(h, attr_id, attr_mod, comp_mask, attr,
-				  &result);
+				  attr_size, &result);
 	if (ret)
 		return ret;
 
@@ -763,7 +765,7 @@ static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 static int get_all_records(bind_handle_t h, uint16_t attr_id,
 			   struct sa_query_result *result)
 {
-	return get_any_records(h, attr_id, 0, 0, NULL, result);
+	return get_any_records(h, attr_id, 0, 0, NULL, 0, result);
 }
 
 static int get_and_dump_all_records(bind_handle_t h, uint16_t attr_id,
@@ -890,7 +892,7 @@ static int get_issm_records(bind_handle_t h, ib_net32_t capability_mask,
 	attr.port_info.capability_mask = capability_mask;
 
 	return get_any_records(h, IB_SA_ATTR_PORTINFORECORD, 1 << 31,
-			       IB_PIR_COMPMASK_CAPMASK, &attr, result);
+			       IB_PIR_COMPMASK_CAPMASK, &attr, sizeof(attr), result);
 }
 
 static int print_node_records(bind_handle_t h)
@@ -942,7 +944,7 @@ static int get_print_class_port_info(bind_handle_t h)
 {
 	struct sa_query_result result;
 	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
-			   ibd_sakey, NULL, &result);
+			   ibd_sakey, NULL, 0, &result);
 	if (ret) {
 		fprintf(stderr, "ERROR: Query SA failed: %s\n", strerror(ret));
 		return ret;
@@ -989,7 +991,7 @@ static int query_path_records(const struct query_cmd *q, bind_handle_t h,
 				  SELEC);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PATHRECORD, 0, comp_mask,
-					&pr, dump_path_record);
+					&pr, sizeof(pr), dump_path_record);
 }
 
 static int print_issm_records(bind_handle_t h)
@@ -1074,7 +1076,7 @@ static int query_node_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(lid, 16, 0, nr.lid, NR, LID);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_NODERECORD, 0, comp_mask,
-					&nr, dump_node_record);
+					&nr, sizeof(nr), dump_node_record);
 }
 
 static int query_portinfo_records(const struct query_cmd *q,
@@ -1094,7 +1096,7 @@ static int query_portinfo_records(const struct query_cmd *q,
 	CHECK_AND_SET_VAL(options, 8, -1, pir.options, PIR, OPTIONS);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PORTINFORECORD, 0,
-					comp_mask, &pir,
+					comp_mask, &pir, sizeof(pir),
 					dump_one_portinfo_record);
 }
 
@@ -1127,7 +1129,7 @@ static int query_mcmember_records(const struct query_cmd *q,
 	CHECK_AND_SET_VAL(p->proxy_join, 8, -1, mr.proxy_join, MCR, PROXY);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_MCRECORD, 0, comp_mask,
-					&mr, dump_one_mcmember_record);
+					&mr, sizeof(mr), dump_one_mcmember_record);
 }
 
 static int query_service_records(const struct query_cmd *q, bind_handle_t h,
@@ -1165,7 +1167,7 @@ static int query_link_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(to_port, 8, -1, lr.to_port_num, LR, TO_PORT);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_LINKRECORD, 0, comp_mask,
-					&lr, dump_one_link_record);
+					&lr, sizeof(lr), dump_one_link_record);
 }
 
 static int query_sl2vl_records(const struct query_cmd *q, bind_handle_t h,
@@ -1184,7 +1186,7 @@ static int query_sl2vl_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(out_port, 8, -1, slvl.out_port_num, SLVL, OUT_PORT);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_SL2VLTABLERECORD, 0,
-					comp_mask, &slvl,
+					comp_mask, &slvl, sizeof(slvl),
 					dump_one_slvl_record);
 }
 
@@ -1204,7 +1206,7 @@ static int query_vlarb_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(block, 8, -1, vlarb.block_num, VLA, BLOCK);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_VLARBTABLERECORD, 0,
-					comp_mask, &vlarb,
+					comp_mask, &vlarb, sizeof(vlarb),
 					dump_one_vlarb_record);
 }
 
@@ -1225,7 +1227,7 @@ static int query_pkey_tbl_records(const struct query_cmd *q,
 	CHECK_AND_SET_VAL(block, 16, -1, pktr.block_num, PKEY, BLOCK);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PKEYTABLERECORD, 0,
-					comp_mask, &pktr,
+					comp_mask, &pktr, sizeof(pktr),
 					dump_one_pkey_tbl_record);
 }
 
@@ -1244,7 +1246,7 @@ static int query_lft_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(block, 16, -1, lftr.block_num, LFTR, BLOCK);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_LFTRECORD, 0, comp_mask,
-					&lftr, dump_one_lft_record);
+					&lftr, sizeof(lftr), dump_one_lft_record);
 }
 
 static int query_guidinfo_records(const struct query_cmd *q, bind_handle_t h,
@@ -1262,7 +1264,7 @@ static int query_guidinfo_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(block, 8, -1, gir.block_num, GIR, BLOCKNUM);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_GUIDINFORECORD, 0,
-					comp_mask, &gir,
+					comp_mask, &gir, sizeof(gir),
 					dump_one_guidinfo_record);
 }
 
@@ -1285,7 +1287,7 @@ static int query_mft_records(const struct query_cmd *q, bind_handle_t h,
 	mftr.position_block_num |= cl_hton16(pos << 12);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_MFTRECORD, 0, comp_mask,
-					&mftr, dump_one_mft_record);
+					&mftr, sizeof(mftr), dump_one_mft_record);
 }
 
 static const struct query_cmd query_cmds[] = {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
