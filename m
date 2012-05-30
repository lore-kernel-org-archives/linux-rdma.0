From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3.1 7/8] ib-diags/saquery: Fix smkey handling
Date: Wed, 30 May 2012 15:14:20 -0700
Message-ID: <1338416060-14025-1-git-send-email-foraker1@llnl.gov>
References: <1338398497-12444-7-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338398497-12444-7-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

smkey is already defined as a global inside saquery.c, so remove
broken support for passing it around as a function parameter

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    1 +
 src/ibdiag_common.c     |    1 +
 src/saquery.c           |   60 +++++++++++++++++++++++------------------------
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 0120203..6dade10 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -52,6 +52,7 @@ extern ib_portid_t *ibd_sm_id;
 extern int ibd_timeout;
 extern uint32_t ibd_ibnetdisc_flags;
 extern uint64_t ibd_mkey;
+extern uint64_t ibd_sakey;
 extern int show_keys;
 
 /*========================================================*/
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index d7d784f..eaf504f 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -72,6 +72,7 @@ int ibd_ca_port = 0;
 int ibd_timeout = 0;
 uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
 uint64_t ibd_mkey;
+uint64_t ibd_sakey;
 int show_keys = 0;
 
 static const char *prog_name;
diff --git a/src/saquery.c b/src/saquery.c
index dec990a..7a7878b 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -85,7 +85,6 @@ struct query_cmd {
 
 static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
-static uint64_t smkey = 1;
 
 /**
  * Declare some globals because I don't want this to be too complex.
@@ -724,11 +723,11 @@ static void dump_results(struct sa_query_result *r, void (*dump_func) (void *))
  */
 static int get_any_records(bind_handle_t h,
 			   uint16_t attr_id, uint32_t attr_mod,
-			   ib_net64_t comp_mask, void *attr, uint64_t sm_key,
+			   ib_net64_t comp_mask, void *attr,
 			   struct sa_query_result *result)
 {
 	int ret = sa_query(h, IB_MAD_METHOD_GET_TABLE, attr_id, attr_mod,
-			   cl_ntoh64(comp_mask), sm_key, attr, result);
+			   cl_ntoh64(comp_mask), ibd_sakey, attr, result);
 	if (ret) {
 		fprintf(stderr, "Query SA failed: %s\n", strerror(ret));
 		return ret;
@@ -744,12 +743,12 @@ static int get_any_records(bind_handle_t h,
 
 static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 				    uint32_t attr_mod, ib_net64_t comp_mask,
-				    void *attr, uint64_t sm_key,
+				    void *attr,
 				    void (*dump_func) (void *))
 {
 	struct sa_query_result result;
 	int ret = get_any_records(h, attr_id, attr_mod, comp_mask, attr,
-				  sm_key, &result);
+				  &result);
 	if (ret)
 		return ret;
 
@@ -761,18 +760,17 @@ static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 /**
  * Get all the records available for requested query type.
  */
-static int get_all_records(bind_handle_t h, uint16_t attr_id, int trusted,
+static int get_all_records(bind_handle_t h, uint16_t attr_id,
 			   struct sa_query_result *result)
 {
-	return get_any_records(h, attr_id, 0, 0, NULL, trusted ? smkey : 0,
-			       result);
+	return get_any_records(h, attr_id, 0, 0, NULL, result);
 }
 
 static int get_and_dump_all_records(bind_handle_t h, uint16_t attr_id,
-				    int trusted, void (*dump_func) (void *))
+				    void (*dump_func) (void *))
 {
 	struct sa_query_result result;
-	int ret = get_all_records(h, attr_id, 0, &result);
+	int ret = get_all_records(h, attr_id, &result);
 	if (ret)
 		return ret;
 
@@ -792,7 +790,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 	int ret;
 	struct sa_query_result result;
 
-	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0, &result);
+	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, &result);
 	if (ret)
 		return ret;
 
@@ -892,7 +890,7 @@ static int get_issm_records(bind_handle_t h, ib_net32_t capability_mask,
 	attr.port_info.capability_mask = capability_mask;
 
 	return get_any_records(h, IB_SA_ATTR_PORTINFORECORD, 1 << 31,
-			       IB_PIR_COMPMASK_CAPMASK, &attr, 0, result);
+			       IB_PIR_COMPMASK_CAPMASK, &attr, result);
 }
 
 static int print_node_records(bind_handle_t h)
@@ -901,7 +899,7 @@ static int print_node_records(bind_handle_t h)
 	int ret;
 	struct sa_query_result result;
 
-	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0, &result);
+	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, &result);
 	if (ret)
 		return ret;
 
@@ -944,7 +942,7 @@ static int get_print_class_port_info(bind_handle_t h)
 {
 	struct sa_query_result result;
 	int ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
-			   0, NULL, &result);
+			   ibd_sakey, NULL, &result);
 	if (ret) {
 		fprintf(stderr, "ERROR: Query SA failed: %s\n", strerror(ret));
 		return ret;
@@ -991,7 +989,7 @@ static int query_path_records(const struct query_cmd *q, bind_handle_t h,
 				  SELEC);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PATHRECORD, 0, comp_mask,
-					&pr, 0, dump_path_record);
+					&pr, dump_path_record);
 }
 
 static int print_issm_records(bind_handle_t h)
@@ -1027,11 +1025,11 @@ static int print_multicast_member_records(bind_handle_t h)
 	int ret;
 	unsigned i;
 
-	ret = get_all_records(h, IB_SA_ATTR_MCRECORD, 1, &mc_group_result);
+	ret = get_all_records(h, IB_SA_ATTR_MCRECORD, &mc_group_result);
 	if (ret)
 		return ret;
 
-	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, 0, &nr_result);
+	ret = get_all_records(h, IB_SA_ATTR_NODERECORD, &nr_result);
 	if (ret)
 		goto return_mc;
 
@@ -1052,7 +1050,7 @@ return_mc:
 
 static int print_multicast_group_records(bind_handle_t h)
 {
-	return get_and_dump_all_records(h, IB_SA_ATTR_MCRECORD, 0,
+	return get_and_dump_all_records(h, IB_SA_ATTR_MCRECORD,
 					dump_multicast_group_record);
 }
 
@@ -1076,7 +1074,7 @@ static int query_node_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(lid, 16, 0, nr.lid, NR, LID);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_NODERECORD, 0, comp_mask,
-					&nr, 0, dump_node_record);
+					&nr, dump_node_record);
 }
 
 static int query_portinfo_records(const struct query_cmd *q,
@@ -1096,7 +1094,7 @@ static int query_portinfo_records(const struct query_cmd *q,
 	CHECK_AND_SET_VAL(options, 8, -1, pir.options, PIR, OPTIONS);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PORTINFORECORD, 0,
-					comp_mask, &pir, 0,
+					comp_mask, &pir,
 					dump_one_portinfo_record);
 }
 
@@ -1129,13 +1127,13 @@ static int query_mcmember_records(const struct query_cmd *q,
 	CHECK_AND_SET_VAL(p->proxy_join, 8, -1, mr.proxy_join, MCR, PROXY);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_MCRECORD, 0, comp_mask,
-					&mr, smkey, dump_one_mcmember_record);
+					&mr, dump_one_mcmember_record);
 }
 
 static int query_service_records(const struct query_cmd *q, bind_handle_t h,
 				 struct query_params *p, int argc, char *argv[])
 {
-	return get_and_dump_all_records(h, IB_SA_ATTR_SERVICERECORD, 0,
+	return get_and_dump_all_records(h, IB_SA_ATTR_SERVICERECORD,
 					dump_service_record);
 }
 
@@ -1143,7 +1141,7 @@ static int query_informinfo_records(const struct query_cmd *q,
 				    bind_handle_t h, struct query_params *p,
 				    int argc, char *argv[])
 {
-	return get_and_dump_all_records(h, IB_SA_ATTR_INFORMINFORECORD, 0,
+	return get_and_dump_all_records(h, IB_SA_ATTR_INFORMINFORECORD,
 					dump_inform_info_record);
 }
 
@@ -1167,7 +1165,7 @@ static int query_link_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(to_port, 8, -1, lr.to_port_num, LR, TO_PORT);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_LINKRECORD, 0, comp_mask,
-					&lr, 0, dump_one_link_record);
+					&lr, dump_one_link_record);
 }
 
 static int query_sl2vl_records(const struct query_cmd *q, bind_handle_t h,
@@ -1186,7 +1184,7 @@ static int query_sl2vl_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(out_port, 8, -1, slvl.out_port_num, SLVL, OUT_PORT);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_SL2VLTABLERECORD, 0,
-					comp_mask, &slvl, 0,
+					comp_mask, &slvl,
 					dump_one_slvl_record);
 }
 
@@ -1206,7 +1204,7 @@ static int query_vlarb_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(block, 8, -1, vlarb.block_num, VLA, BLOCK);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_VLARBTABLERECORD, 0,
-					comp_mask, &vlarb, 0,
+					comp_mask, &vlarb,
 					dump_one_vlarb_record);
 }
 
@@ -1227,7 +1225,7 @@ static int query_pkey_tbl_records(const struct query_cmd *q,
 	CHECK_AND_SET_VAL(block, 16, -1, pktr.block_num, PKEY, BLOCK);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PKEYTABLERECORD, 0,
-					comp_mask, &pktr, smkey,
+					comp_mask, &pktr,
 					dump_one_pkey_tbl_record);
 }
 
@@ -1246,7 +1244,7 @@ static int query_lft_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(block, 16, -1, lftr.block_num, LFTR, BLOCK);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_LFTRECORD, 0, comp_mask,
-					&lftr, 0, dump_one_lft_record);
+					&lftr, dump_one_lft_record);
 }
 
 static int query_guidinfo_records(const struct query_cmd *q, bind_handle_t h,
@@ -1264,7 +1262,7 @@ static int query_guidinfo_records(const struct query_cmd *q, bind_handle_t h,
 	CHECK_AND_SET_VAL(block, 8, -1, gir.block_num, GIR, BLOCKNUM);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_GUIDINFORECORD, 0,
-					comp_mask, &gir, 0,
+					comp_mask, &gir,
 					dump_one_guidinfo_record);
 }
 
@@ -1287,7 +1285,7 @@ static int query_mft_records(const struct query_cmd *q, bind_handle_t h,
 	mftr.position_block_num |= cl_hton16(pos << 12);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_MFTRECORD, 0, comp_mask,
-					&mftr, 0, dump_one_mft_record);
+					&mftr, dump_one_mft_record);
 }
 
 static const struct query_cmd query_cmds[] = {
@@ -1399,7 +1397,7 @@ static int process_opt(void *context, int ch, char *optarg)
 			fprintf(stderr, "cannot get SM_Key\n");
 			ibdiag_show_usage();
 		}
-		smkey = strtoull(optarg, NULL, 0);
+		ibd_sakey = strtoull(optarg, NULL, 0);
 		break;
 	case 'p':
 		query_type = IB_SA_ATTR_PATHRECORD;
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
