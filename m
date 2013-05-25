From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] saquery.c: Dump SwitchInfoRecord based on
 IsSetMulticastFDBTopSupported SA capability
Date: Sat, 25 May 2013 09:36:27 -0400
Message-ID: <51A0BE5B.2070409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Husam Kahalah <HKahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Only include MulticastFDBTop when SA
ClassPortInfo:CapabilityMask2.IsSetMulticastFDBTopSupported is set

In order to do this, SA capmask2 was needed to be passed to all dump functions
 
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/saquery.c b/src/saquery.c
index a5f9171..5293851 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2006,2007 The Regents of the University of California.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2013 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -65,6 +65,8 @@
 				  IB_PR_COMPMASK_SERVICEID_LSB)
 #endif
 
+#define SA_CAP_MASK2_IS_MCAST_TOP_SUPPORTED (1 << 3)
+
 struct query_params {
 	uint64_t service_id;
 	ib_gid_t sgid, dgid, gid, mgid;
@@ -137,7 +139,7 @@ static void print_node_desc(ib_node_record_t * node_record)
 	}
 }
 
-static void dump_node_record(void *data)
+static void dump_node_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_node_record_t *nr = data;
 	ib_node_info_t *ni = &nr->node_info;
@@ -201,10 +203,10 @@ static void print_node_record(ib_node_record_t * node_record)
 		break;
 	}
 
-	dump_node_record(node_record);
+	dump_node_record(node_record, 0);
 }
 
-static void dump_path_record(void *data)
+static void dump_path_record(void *data, uint32_t sa_cap_mask2)
 {
 	char gid_str[INET6_ADDRSTRLEN];
 	char gid_str2[INET6_ADDRSTRLEN];
@@ -238,7 +240,7 @@ static void dump_path_record(void *data)
 	       p_pr->resv2[3], p_pr->resv2[4], p_pr->resv2[5]);
 }
 
-static void dump_class_port_info(void *data)
+static void dump_class_port_info(void *data, uint32_t sa_cap_mask2)
 {
 	char gid_str[INET6_ADDRSTRLEN];
 	char gid_str2[INET6_ADDRSTRLEN];
@@ -274,7 +276,7 @@ static void dump_class_port_info(void *data)
 	       cl_ntoh32(cpi->trap_qkey));
 }
 
-static void dump_portinfo_record(void *data)
+static void dump_portinfo_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_portinfo_record_t *p_pir = data;
 	const ib_port_info_t *const p_pi = &p_pir->port_info;
@@ -290,7 +292,7 @@ static void dump_portinfo_record(void *data)
 	       cl_ntoh32(p_pi->capability_mask));
 }
 
-static void dump_one_portinfo_record(void *data)
+static void dump_one_portinfo_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_portinfo_record_t *pir = data;
 	ib_port_info_t *pi = &pir->port_info;
@@ -305,7 +307,7 @@ static void dump_one_portinfo_record(void *data)
 	dump_portinfo(pi, sizeof(*pi), 2);
 }
 
-static void dump_one_mcmember_record(void *data)
+static void dump_one_mcmember_record(void *data, uint32_t sa_cap_mask2)
 {
 	char mgid[INET6_ADDRSTRLEN], gid[INET6_ADDRSTRLEN];
 	ib_member_rec_t *mr = data;
@@ -336,7 +338,7 @@ static void dump_one_mcmember_record(void *data)
 	       flow, hop, scope, join, mr->proxy_join);
 }
 
-static void dump_multicast_group_record(void *data)
+static void dump_multicast_group_record(void *data, uint32_t sa_cap_mask2)
 {
 	char gid_str[INET6_ADDRSTRLEN];
 	ib_member_rec_t *p_mcmr = data;
@@ -401,7 +403,7 @@ static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
 	free(node_name);
 }
 
-static void dump_service_record(void *data)
+static void dump_service_record(void *data, uint32_t sa_cap_mask2)
 {
 	char gid[INET6_ADDRSTRLEN];
 	char buf_service_key[35];
@@ -487,10 +489,11 @@ static void dump_service_record(void *data)
 	       cl_ntoh64(p_sr->service_data64[1]));
 }
 
-static void dump_switch_info_record(void *data)
+static void dump_switch_info_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_switch_info_record_t *p_sir = data;
 
+//sa_cap_mask2 & SA_CAP_MASK2_IS_MCAST_TOP_SUPPORTED
 	printf("SwitchInfoRecord dump:\n"
 		"\t\tRID\n"
 		"\t\tLID.....................................%u\n"
@@ -505,8 +508,7 @@ static void dump_switch_info_record(void *data)
 		"\t\tLifeTimeValue/PortStateChange/OpSL2VL...0x%X\n"
 		"\t\tLIDsPerPort.............................0x%X\n"
 		"\t\tPartitionEnforcementCap.................0x%X\n"
-		"\t\tflags...................................0x%X\n"
-		"\t\tMulticastFDBTop.........................0x%X\n",
+		"\t\tflags...................................0x%X\n",
 		cl_ntoh16(p_sir->lid),
 		cl_ntoh16(p_sir->switch_info.lin_cap),
 		cl_ntoh16(p_sir->switch_info.rand_cap),
@@ -518,11 +520,13 @@ static void dump_switch_info_record(void *data)
 		p_sir->switch_info.life_state,
 		cl_ntoh16(p_sir->switch_info.lids_per_port),
 		cl_ntoh16(p_sir->switch_info.enforce_cap),
-		p_sir->switch_info.flags,
-		cl_ntoh16(p_sir->switch_info.mcast_top));
+		p_sir->switch_info.flags);
+	if (sa_cap_mask2 & SA_CAP_MASK2_IS_MCAST_TOP_SUPPORTED)
+		printf("\t\tMulticastFDBTop.........................0x%X\n",
+		       cl_ntoh16(p_sir->switch_info.mcast_top));
 }
 
-static void dump_inform_info_record(void *data)
+static void dump_inform_info_record(void *data, uint32_t sa_cap_mask2)
 {
 	char gid_str[INET6_ADDRSTRLEN];
 	char gid_str2[INET6_ADDRSTRLEN];
@@ -608,7 +612,7 @@ static void dump_inform_info_record(void *data)
 	}
 }
 
-static void dump_one_link_record(void *data)
+static void dump_one_link_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_link_record_t *lr = data;
 	printf("LinkRecord dump:\n"
@@ -620,7 +624,7 @@ static void dump_one_link_record(void *data)
 	       lr->to_port_num, cl_ntoh16(lr->to_lid));
 }
 
-static void dump_one_slvl_record(void *data)
+static void dump_one_slvl_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_slvl_table_record_t *slvl = data;
 	ib_slvl_table_t *t = &slvl->slvl_tbl;
@@ -642,7 +646,7 @@ static void dump_one_slvl_record(void *data)
 	       ib_slvl_table_get(t, 14), ib_slvl_table_get(t, 15));
 }
 
-static void dump_one_vlarb_record(void *data)
+static void dump_one_vlarb_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_vl_arb_table_record_t *vlarb = data;
 	ib_vl_arb_element_t *e = vlarb->vl_arb_tbl.vl_entry;
@@ -669,7 +673,7 @@ static void dump_one_vlarb_record(void *data)
 		       e[i + 15].weight);
 }
 
-static void dump_one_pkey_tbl_record(void *data)
+static void dump_one_pkey_tbl_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_pkey_table_record_t *pktr = data;
 	ib_net16_t *p = pktr->pkey_tbl.pkey_entry;
@@ -690,7 +694,7 @@ static void dump_one_pkey_tbl_record(void *data)
 	printf("\n");
 }
 
-static void dump_one_lft_record(void *data)
+static void dump_one_lft_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_lft_record_t *lftr = data;
 	unsigned block = cl_ntoh16(lftr->block_num);
@@ -704,7 +708,7 @@ static void dump_one_lft_record(void *data)
 	printf("\n");
 }
 
-static void dump_one_guidinfo_record(void *data)
+static void dump_one_guidinfo_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_guidinfo_record_t *gir = data;
 	printf("GUIDInfo Record dump:\n"
@@ -729,7 +733,7 @@ static void dump_one_guidinfo_record(void *data)
 	       cl_ntoh64(gir->guid_info.guid[7]));
 }
 
-static void dump_one_mft_record(void *data)
+static void dump_one_mft_record(void *data, uint32_t sa_cap_mask2)
 {
 	ib_mft_record_t *mftr = data;
 	unsigned position = cl_ntoh16(mftr->position_block_num) >> 12;
@@ -751,12 +755,14 @@ static void dump_one_mft_record(void *data)
 	printf("\n");
 }
 
-static void dump_results(struct sa_query_result *r, void (*dump_func) (void *))
+static void dump_results(struct sa_query_result *r,
+			 void (*dump_func) (void *, uint32_t),
+			 uint32_t sa_cap_mask2)
 {
 	unsigned i;
 	for (i = 0; i < r->result_cnt; i++) {
 		void *data = sa_get_query_rec(r->p_result_madw, i);
-		dump_func(data);
+		dump_func(data, sa_cap_mask2);
 	}
 }
 
@@ -788,7 +794,8 @@ static int get_and_dump_any_records(struct sa_handle * h, uint16_t attr_id,
 				    uint32_t attr_mod, ib_net64_t comp_mask,
 				    void *attr,
 				    size_t attr_size,
-				    void (*dump_func) (void *))
+				    void (*dump_func) (void *, uint32_t),
+				    uint32_t sa_cap_mask2)
 {
 	struct sa_query_result result;
 	int ret = get_any_records(h, attr_id, attr_mod, comp_mask, attr,
@@ -796,7 +803,7 @@ static int get_and_dump_any_records(struct sa_handle * h, uint16_t attr_id,
 	if (ret)
 		return ret;
 
-	dump_results(&result, dump_func);
+	dump_results(&result, dump_func, sa_cap_mask2);
 	sa_free_result_mad(&result);
 	return 0;
 }
@@ -811,14 +818,15 @@ static int get_all_records(struct sa_handle * h, uint16_t attr_id,
 }
 
 static int get_and_dump_all_records(struct sa_handle * h, uint16_t attr_id,
-				    void (*dump_func) (void *))
+				    void (*dump_func) (void *, uint32_t),
+				    uint32_t sa_cap_mask2)
 {
 	struct sa_query_result result;
 	int ret = get_all_records(h, attr_id, &result);
 	if (ret)
 		return ret;
 
-	dump_results(&result, dump_func);
+	dump_results(&result, dump_func, sa_cap_mask2);
 	sa_free_result_mad(&result);
 	return ret;
 }
@@ -1006,7 +1014,7 @@ static int get_print_class_port_info(struct sa_handle * h)
 		ret = EIO;
 		goto Exit;
 	}
-	dump_results(&result, dump_class_port_info);
+	dump_results(&result, dump_class_port_info, 0);
 Exit:
 	sa_free_result_mad(&result);
 	return ret;
@@ -1044,7 +1052,7 @@ static int query_path_records(const struct query_cmd *q, struct sa_handle * h,
 				  SELEC);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PATHRECORD, 0, comp_mask,
-					&pr, sizeof(pr), dump_path_record);
+					&pr, sizeof(pr), dump_path_record, 0);
 }
 
 static int print_issm_records(struct sa_handle * h)
@@ -1058,7 +1066,7 @@ static int print_issm_records(struct sa_handle * h)
 		return (ret);
 
 	printf("IsSM ports\n");
-	dump_results(&result, dump_portinfo_record);
+	dump_results(&result, dump_portinfo_record, 0);
 	sa_free_result_mad(&result);
 
 	/* Now, get IsSMdisabled records */
@@ -1067,7 +1075,7 @@ static int print_issm_records(struct sa_handle * h)
 		return (ret);
 
 	printf("\nIsSMdisabled ports\n");
-	dump_results(&result, dump_portinfo_record);
+	dump_results(&result, dump_portinfo_record, 0);
 	sa_free_result_mad(&result);
 
 	return (ret);
@@ -1106,7 +1114,7 @@ return_mc:
 static int print_multicast_group_records(struct sa_handle * h)
 {
 	return get_and_dump_all_records(h, IB_SA_ATTR_MCRECORD,
-					dump_multicast_group_record);
+					dump_multicast_group_record, 0);
 }
 
 static int query_class_port_info(const struct query_cmd *q, struct sa_handle * h,
@@ -1129,7 +1137,7 @@ static int query_node_records(const struct query_cmd *q, struct sa_handle * h,
 	CHECK_AND_SET_VAL(lid, 16, 0, nr.lid, NR, LID);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_NODERECORD, 0, comp_mask,
-					&nr, sizeof(nr), dump_node_record);
+					&nr, sizeof(nr), dump_node_record, 0);
 }
 
 static int query_portinfo_records(const struct query_cmd *q,
@@ -1150,7 +1158,7 @@ static int query_portinfo_records(const struct query_cmd *q,
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PORTINFORECORD, 0,
 					comp_mask, &pir, sizeof(pir),
-					dump_one_portinfo_record);
+					dump_one_portinfo_record, 0);
 }
 
 static int query_mcmember_records(const struct query_cmd *q,
@@ -1182,23 +1190,42 @@ static int query_mcmember_records(const struct query_cmd *q,
 	CHECK_AND_SET_VAL(p->proxy_join, 8, -1, mr.proxy_join, MCR, PROXY);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_MCRECORD, 0, comp_mask,
-					&mr, sizeof(mr), dump_one_mcmember_record);
+					&mr, sizeof(mr), dump_one_mcmember_record, 0);
 }
 
 static int query_service_records(const struct query_cmd *q, struct sa_handle * h,
 				 struct query_params *p, int argc, char *argv[])
 {
 	return get_and_dump_all_records(h, IB_SA_ATTR_SERVICERECORD,
-					dump_service_record);
+					dump_service_record, 0);
 }
 
 static int query_switchinfo_records(const struct query_cmd *q,
 				struct sa_handle * h, struct query_params *p,
 				int argc, char *argv[])
 {
+	struct sa_query_result result;
+	ib_class_port_info_t *cpi;
 	ib_switch_info_record_t swir;
 	ib_net64_t comp_mask = 0;
-	int lid = 0;
+	int lid = 0, ret;
+	uint32_t sa_cap_mask2;
+
+	ret = sa_query(h, IB_MAD_METHOD_GET, CLASS_PORT_INFO, 0, 0,
+		       ibd_sakey, NULL, 0, &result);
+	if (ret) {
+		fprintf(stderr, "Query SA failed: %s\n", strerror(ret));
+		return ret;
+	}
+
+	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
+		sa_report_err(result.status);
+		sa_free_result_mad(&result);
+		return -EIO;
+	}
+	cpi = sa_get_query_rec(result.p_result_madw, 0);
+	sa_cap_mask2 = ib_class_cap_mask2(cpi);
+	sa_free_result_mad(&result);
 
 	if (argc > 0)
 		parse_lid_and_ports(h, argv[0], &lid, NULL, NULL);
@@ -1206,8 +1233,9 @@ static int query_switchinfo_records(const struct query_cmd *q,
 	memset(&swir, 0, sizeof(swir));
 	CHECK_AND_SET_VAL(lid, 16, 0, swir.lid, SWIR, LID);
 
-	return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0, comp_mask,
-					&swir, sizeof(swir), dump_switch_info_record);
+	return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0,
+					comp_mask, &swir, sizeof(swir),
+					dump_switch_info_record, sa_cap_mask2);
 }
 
 static int query_inform_info_records(const struct query_cmd *q,
@@ -1226,7 +1254,7 @@ static int query_inform_info_records(const struct query_cmd *q,
        }
 
        return get_and_dump_any_records(h, IB_SA_ATTR_INFORMINFORECORD, 0, comp_mask,
-				       &ir, sizeof(ir), dump_inform_info_record);
+				       &ir, sizeof(ir), dump_inform_info_record, 0);
 
 }
 
@@ -1250,7 +1278,7 @@ static int query_link_records(const struct query_cmd *q, struct sa_handle * h,
 	CHECK_AND_SET_VAL(to_port, 8, -1, lr.to_port_num, LR, TO_PORT);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_LINKRECORD, 0, comp_mask,
-					&lr, sizeof(lr), dump_one_link_record);
+					&lr, sizeof(lr), dump_one_link_record, 0);
 }
 
 static int query_sl2vl_records(const struct query_cmd *q, struct sa_handle * h,
@@ -1270,7 +1298,7 @@ static int query_sl2vl_records(const struct query_cmd *q, struct sa_handle * h,
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_SL2VLTABLERECORD, 0,
 					comp_mask, &slvl, sizeof(slvl),
-					dump_one_slvl_record);
+					dump_one_slvl_record, 0);
 }
 
 static int query_vlarb_records(const struct query_cmd *q, struct sa_handle * h,
@@ -1290,7 +1318,7 @@ static int query_vlarb_records(const struct query_cmd *q, struct sa_handle * h,
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_VLARBTABLERECORD, 0,
 					comp_mask, &vlarb, sizeof(vlarb),
-					dump_one_vlarb_record);
+					dump_one_vlarb_record, 0);
 }
 
 static int query_pkey_tbl_records(const struct query_cmd *q,
@@ -1311,7 +1339,7 @@ static int query_pkey_tbl_records(const struct query_cmd *q,
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PKEYTABLERECORD, 0,
 					comp_mask, &pktr, sizeof(pktr),
-					dump_one_pkey_tbl_record);
+					dump_one_pkey_tbl_record, 0);
 }
 
 static int query_lft_records(const struct query_cmd *q, struct sa_handle * h,
@@ -1329,7 +1357,7 @@ static int query_lft_records(const struct query_cmd *q, struct sa_handle * h,
 	CHECK_AND_SET_VAL(block, 16, -1, lftr.block_num, LFTR, BLOCK);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_LFTRECORD, 0, comp_mask,
-					&lftr, sizeof(lftr), dump_one_lft_record);
+					&lftr, sizeof(lftr), dump_one_lft_record, 0);
 }
 
 static int query_guidinfo_records(const struct query_cmd *q, struct sa_handle * h,
@@ -1348,7 +1376,7 @@ static int query_guidinfo_records(const struct query_cmd *q, struct sa_handle *
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_GUIDINFORECORD, 0,
 					comp_mask, &gir, sizeof(gir),
-					dump_one_guidinfo_record);
+					dump_one_guidinfo_record, 0);
 }
 
 static int query_mft_records(const struct query_cmd *q, struct sa_handle * h,
@@ -1370,7 +1398,7 @@ static int query_mft_records(const struct query_cmd *q, struct sa_handle * h,
 	mftr.position_block_num |= cl_hton16(pos << 12);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_MFTRECORD, 0, comp_mask,
-					&mftr, sizeof(mftr), dump_one_mft_record);
+					&mftr, sizeof(mftr), dump_one_mft_record, 0);
 }
 
 static const struct query_cmd query_cmds[] = {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
