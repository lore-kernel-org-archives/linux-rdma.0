From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osmtest: Add grh test
Date: Tue, 17 Jun 2014 07:27:25 -0400
Message-ID: <53A0261D.20008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add GRH to all SA queries that osmtest sends.
Note: All SA queries except GetMulti MultiPathRecord query.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/vendor/osm_vendor_sa_api.h |    8 ++
 libvendor/osm_vendor_ibumad_sa.c   |   14 +++
 osmtest/include/osmtest.h          |    2 +
 osmtest/main.c                     |    9 ++-
 osmtest/osmtest.c                  |  157 ++++++++++++++++++++++++++++++++++++
 5 files changed, 189 insertions(+), 1 deletions(-)

diff --git a/include/vendor/osm_vendor_sa_api.h b/include/vendor/osm_vendor_sa_api.h
index 336251a..a5ecd24 100644
--- a/include/vendor/osm_vendor_sa_api.h
+++ b/include/vendor/osm_vendor_sa_api.h
@@ -740,6 +740,8 @@ typedef struct _osmv_query_req {
 
 	const void *query_context;
 	osmv_pfn_query_cb_t pfn_query_cb;
+	int with_grh;
+	ib_gid_t gid;
 } osmv_query_req_t;
 /*
 * FIELDS
@@ -777,6 +779,12 @@ typedef struct _osmv_query_req {
 *		A user-defined callback that is invoked upon completion of the
 *		query.
 *
+*	with_grh
+*		Indicates that all sa queries need to sent with GRH.
+*
+*	gid
+*		Used to store the SM/SA gid.
+*
 * NOTES
 *	This structure is used when requesting an osm vendor provided query
 *	of subnet administration.  Clients specify the type of query through
diff --git a/libvendor/osm_vendor_ibumad_sa.c b/libvendor/osm_vendor_ibumad_sa.c
index e51a40f..58dc5a8 100644
--- a/libvendor/osm_vendor_ibumad_sa.c
+++ b/libvendor/osm_vendor_ibumad_sa.c
@@ -417,6 +417,20 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 	p_madw->fail_msg = CL_DISP_MSGID_NONE;
 
 	/*
+	   add grh
+	 */
+	if (p_query_req->with_grh) {
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "sending sa query with GRH "
+			"GID : 0x%016" PRIx64 " 0x%016" PRIx64 "\n",
+			p_query_req->gid.unicast.prefix,
+			p_query_req->gid.unicast.interface_id);
+		p_madw->mad_addr.addr_type.gsi.global_route = 1;
+		memset(&p_madw->mad_addr.addr_type.gsi.grh_info, 0,
+		       sizeof(p_madw->mad_addr.addr_type.gsi.grh_info));
+		memcpy(&p_madw->mad_addr.addr_type.gsi.grh_info.dest_gid, &(p_query_req->gid), 16);
+	}
+
+	/*
 	   Provide MAD context such that the call back will know what to do.
 	   We have to keep the entire request structure so we know the CB.
 	   Since we can not rely on the client to keep it around until
diff --git a/osmtest/include/osmtest.h b/osmtest/include/osmtest.h
index f63ea74..f66d3a8 100644
--- a/osmtest/include/osmtest.h
+++ b/osmtest/include/osmtest.h
@@ -78,6 +78,7 @@ typedef struct _osmtest_opt {
 	uint32_t transaction_timeout;
 	boolean_t force_log_flush;
 	boolean_t create;
+	boolean_t with_grh;
 	uint32_t retry_count;
 	uint32_t stress;
 	uint32_t mmode;
@@ -129,6 +130,7 @@ typedef struct _osmtest {
 	osmtest_opt_t opt;
 	ib_port_attr_t local_port;
 	ib_gid_t local_port_gid;
+	ib_gid_t sm_port_gid;
 	subnet_t exp_subn;
 	cl_qpool_t node_pool;
 	cl_qpool_t port_pool;
diff --git a/osmtest/main.c b/osmtest/main.c
index 6129674..006708d 100644
--- a/osmtest/main.c
+++ b/osmtest/main.c
@@ -145,6 +145,10 @@ void show_usage()
 	       "          -s3  - Multi-MAD (RMPP) Path Record SA queries\n"
 	       "          -s4  - Single-MAD (non RMPP) get Path Record SA queries\n"
 	       "          Without -s, stress testing is not performed\n\n");
+	printf("-G\n"
+	       "--grh\n"
+	       "          sends all sa queries with grh with exception of\n"
+	       "	  GetMulti for MultiPathRecord\n\n");
 	printf("-M\n"
 	       "--Multicast_Mode\n"
 	       "          This option specify length of Multicast test:\n"
@@ -297,6 +301,7 @@ int main(int argc, char *argv[])
 		{"port", 0, NULL, 'p'},
 		{"help", 0, NULL, 'h'},
 		{"stress", 1, NULL, 's'},
+		{"grh", 0, NULL, 'G'},
 		{"Multicast_Mode", 1, NULL, 'M'},
 		{"timeout", 1, NULL, 't'},
 		{"verbose", 0, NULL, 'v'},
@@ -558,7 +563,9 @@ int main(int argc, char *argv[])
 			    ("\t\t\t\tVerbose option -vf (log flags = 0x%X)\n",
 			     log_flags);
 			break;
-
+		case 'G':
+			opt.with_grh = TRUE;
+			break;
 		case -1:
 			printf("Done with args\n");
 			break;
diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index d7aef60..710282f 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -571,6 +571,11 @@ osmtest_get_all_recs(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0004: "
@@ -631,6 +636,12 @@ ib_api_status_t osmtest_validate_sa_class_port_info(IN osmtest_t * const p_osmt)
 	req.p_query_input = 0;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.flow != OSMT_FLOW_CREATE_INVENTORY &&
+	    p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0065: "
@@ -727,6 +738,11 @@ osmtest_get_node_rec(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0071: "
@@ -800,6 +816,11 @@ osmtest_get_node_rec_by_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0073: "
@@ -865,6 +886,11 @@ osmtest_get_path_rec_by_half_world_query(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0063: "
@@ -928,6 +954,11 @@ osmtest_get_path_rec_by_guid_pair(IN osmtest_t * const p_osmt,
 		"Query for path from 0x%" PRIx64 " to 0x%" PRIx64 "\n",
 		cl_ntoh64(sguid), cl_ntoh64(dguid));
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0063: "
@@ -995,6 +1026,11 @@ osmtest_get_path_rec_by_gid_pair(IN osmtest_t * const p_osmt,
 		cl_ntoh64(dgid.unicast.prefix),
 		cl_ntoh64(dgid.unicast.interface_id));
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 006A: "
@@ -1128,6 +1164,11 @@ osmtest_get_port_rec(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0075: "
@@ -1200,6 +1241,11 @@ osmtest_get_port_rec_by_num(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0077: "
@@ -1690,6 +1736,11 @@ ib_api_status_t osmtest_wrong_sm_key_ignored(IN osmtest_t * const p_osmt)
 	req.sm_key = 9999;
 	context.result.p_result_madw = NULL;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_START "\n");
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, EXPECTING_ERRORS_END "\n");
@@ -2046,6 +2097,10 @@ osmtest_get_path_rec_by_lid_pair(IN osmtest_t * const p_osmt,
 
 	req.p_query_input = &lid_pair;
 	req.sm_key = 0;
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
 
 	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE,
 		"Query for path from 0x%X to 0x%X\n",
@@ -4308,6 +4363,11 @@ osmtest_get_link_rec_by_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 007A: "
@@ -4386,6 +4446,11 @@ osmtest_get_guidinfo_rec_by_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 007C: "
@@ -4464,6 +4529,11 @@ osmtest_get_pkeytbl_rec_by_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = sm_key;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 007E: "
@@ -4542,6 +4612,11 @@ osmtest_get_sw_info_rec_by_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 006C: "
@@ -4620,6 +4695,11 @@ osmtest_get_lft_rec_by_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 008A: "
@@ -4698,6 +4778,11 @@ osmtest_get_mft_rec_by_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 009B: "
@@ -4789,6 +4874,11 @@ osmtest_sminfo_record_request(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 008C: "
@@ -4898,6 +4988,11 @@ osmtest_informinfo_request(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 008E: "
@@ -5028,6 +5123,11 @@ osmtest_validate_single_node_rec_lid(IN osmtest_t * const p_osmt,
 	req.p_query_input = &user;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 
 	if (status != IB_SUCCESS) {
@@ -5165,6 +5265,11 @@ osmtest_validate_single_path_rec_guid_pair(IN osmtest_t * const p_osmt,
 	req.p_query_input = p_pair;
 	req.sm_key = 0;
 
+	if (p_osmt->opt.with_grh) {
+		req.with_grh = 1;
+		memcpy(&req.gid, &p_osmt->sm_port_gid, 16);
+	}
+
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0110: "
@@ -5249,6 +5354,45 @@ Exit:
 }
 
 static ib_api_status_t
+osmtest_get_sm_gid(IN osmtest_t * const p_osmt)
+{
+	cl_status_t status = IB_SUCCESS;
+	node_t *p_node;
+	const cl_qmap_t *p_tbl;
+	osmtest_req_context_t context;
+	ib_port_attr_t *local_port;
+	OSM_LOG_ENTER(&p_osmt->log);
+
+	memset(&context, 0, sizeof(context));
+	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE,
+		"retrieve sm gid for future sa queries\n");
+
+	local_port = &p_osmt->local_port;
+	p_osmt->sm_port_gid.unicast.prefix =
+		cl_hton64(p_osmt->local_port_gid.unicast.prefix);
+
+	if (local_port->lid != local_port->sm_lid) {
+		p_tbl = &p_osmt->exp_subn.node_lid_tbl;
+		p_node = (node_t *) cl_qmap_get(p_tbl, local_port->sm_lid);
+		if (p_node == (node_t *) cl_qmap_end(p_tbl)) {
+			OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0154 "
+				"SM LID 0x%X doesn't exist\n", local_port->sm_lid);
+			status = IB_ERROR;
+			goto Exit;
+		}
+		p_osmt->sm_port_gid.unicast.interface_id = p_node->rec.node_info.port_guid;
+
+	} else {
+		p_osmt->sm_port_gid.unicast.interface_id =
+			cl_hton64(p_osmt->local_port_gid.unicast.interface_id);
+	}
+
+Exit:
+	OSM_LOG_EXIT(&p_osmt->log);
+	return (status);
+}
+
+static ib_api_status_t
 osmtest_validate_single_path_recs(IN osmtest_t * const p_osmt)
 {
 	path_t *p_path;
@@ -7304,6 +7448,19 @@ ib_api_status_t osmtest_run(IN osmtest_t * const p_osmt)
 	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(&p_osmt->log);
+	if (p_osmt->opt.flow != OSMT_FLOW_CREATE_INVENTORY &&
+	    p_osmt->opt.with_grh) {
+		/*
+		 * get gid for GRH
+		 */
+		status = osmtest_get_sm_gid(p_osmt);
+		if (status != IB_SUCCESS) {
+			OSM_LOG(&p_osmt->log, OSM_LOG_ERROR,
+				"ERR 0153: getting SM GID failed: (%s)\n",
+				ib_get_err_str(status));
+			goto Exit;
+		}
+	}
 
 	status = osmtest_validate_sa_class_port_info(p_osmt);
 	if (status != IB_SUCCESS) {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
