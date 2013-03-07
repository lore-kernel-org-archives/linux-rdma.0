From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3] opensm/osmtest.c: half_world_query when creating, inventory
 file
Date: Thu, 07 Mar 2013 07:47:55 -0500
Message-ID: <51388C7B.6090007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When osmtest needs to create path records for inventory file, it will
do n half-world queries (instead of full world query) where n is
the number of end ports which was previously determined.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmtest.c |  130 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 104 insertions(+), 26 deletions(-)

diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 36b9dc8..5dbf0db 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -832,6 +832,69 @@ Exit:
 }
 
 static ib_api_status_t
+osmtest_get_path_rec_by_half_world_query(IN osmtest_t * const p_osmt,
+				  IN ib_net64_t sguid,
+				  IN osmtest_req_context_t * p_context)
+{
+	cl_status_t status = IB_SUCCESS;
+	osmv_query_req_t req;
+	osmv_user_query_t user;
+	ib_path_rec_t record;
+
+	OSM_LOG_ENTER(&p_osmt->log);
+
+	memset(&req, 0, sizeof(req));
+	memset(p_context, 0, sizeof(*p_context));
+	memset(&record, 0, sizeof(record));
+	memset(&user, 0, sizeof(user));
+
+        ib_gid_set_default(&(record.sgid), sguid);
+	record.num_path = 0x01;
+
+	p_context->p_osmt = p_osmt;
+	user.comp_mask = (IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
+	user.attr_id = IB_MAD_ATTR_PATH_RECORD;
+	user.p_attr = &record;
+
+	req.query_type = OSMV_QUERY_USER_DEFINED;
+	req.timeout_ms = p_osmt->opt.transaction_timeout;
+	req.retry_cnt = p_osmt->opt.retry_count;
+	req.flags = OSM_SA_FLAGS_SYNC;
+	req.query_context = p_context;
+	req.pfn_query_cb = osmtest_query_res_cb;
+	req.p_query_input = &user;
+	req.sm_key = 0;
+
+	status = osmv_query_sa(p_osmt->h_bind, &req);
+	if (status != IB_SUCCESS) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0063: "
+			"ib_query failed (%s)\n", ib_get_err_str(status));
+		goto Exit;
+	}
+
+	status = (*p_context).result.status;
+
+	if (status != IB_SUCCESS) {
+		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0066: "
+			"ib_query failed (%s)\n", ib_get_err_str(status));
+
+		if (status == IB_REMOTE_ERROR) {
+			OSM_LOG(&p_osmt->log, OSM_LOG_ERROR,
+				"Remote error = %s\n",
+				ib_get_mad_status_str(osm_madw_get_mad_ptr
+						      ((*p_context).result.
+						       p_result_madw)));
+		}
+		goto Exit;
+	}
+
+Exit:
+
+	OSM_LOG_EXIT(&p_osmt->log);
+	return (status);
+}
+
+static ib_api_status_t
 osmtest_get_path_rec_by_guid_pair(IN osmtest_t * const p_osmt,
 				  IN ib_net64_t sguid,
 				  IN ib_net64_t dguid,
@@ -2028,6 +2091,7 @@ osmtest_write_all_node_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 	cl_status_t status;
 	size_t num_recs;
 	int result;
+	node_t *p_guid_node;
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
@@ -2065,6 +2129,16 @@ osmtest_write_all_node_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 		p_rec =
 		    osmv_get_query_node_rec(context.result.p_result_madw, i);
 		osmtest_write_node_info(p_osmt, fh, p_rec);
+
+		/* create a subnet object */
+		p_guid_node = node_new();
+		CL_ASSERT(p_node != NULL);
+
+		/* copy the info to the subnet node object */
+		p_guid_node->rec = *p_rec;
+		cl_qmap_insert(&p_osmt->exp_subn.node_guid_tbl,
+				p_guid_node->rec.node_info.port_guid,
+				&p_guid_node->map_item);
 	}
 
 Exit:
@@ -2156,33 +2230,16 @@ osmtest_write_all_path_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 	osmtest_req_context_t context;
 	const ib_path_rec_t *p_rec;
 	uint32_t i;
-	cl_status_t status;
+	cl_status_t status = CL_SUCCESS;
 	size_t num_recs;
 	int result;
+	node_t *p_dst_node;
+	cl_qmap_t *p_tbl;
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
-	memset(&context, 0, sizeof(context));
-
-	/*
-	 * Do a blocking query for all PathRecords in the subnet.
-	 */
-	status = osmtest_get_all_recs(p_osmt, IB_MAD_ATTR_PATH_RECORD,
-				      sizeof(*p_rec), &context);
-
-	if (status != IB_SUCCESS) {
-		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0025: "
-			"osmtest_get_all_recs failed (%s)\n",
-			ib_get_err_str(status));
-		goto Exit;
-	}
-
-	/*
-	 * Write the received records out to the file.
-	 */
-	num_recs = context.result.result_cnt;
-
-	OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Received %zu records\n", num_recs);
+	p_tbl = &p_osmt->exp_subn.node_guid_tbl;
+	p_dst_node = (node_t *) cl_qmap_head(p_tbl);
 
 	result = fprintf(fh, "#\n" "# Path Records\n" "#\n");
 	if (result < 0) {
@@ -2192,10 +2249,31 @@ osmtest_write_all_path_recs(IN osmtest_t * const p_osmt, IN FILE * fh)
 		goto Exit;
 	}
 
-	for (i = 0; i < num_recs; i++) {
-		p_rec =
-		    osmv_get_query_path_rec(context.result.p_result_madw, i);
-		osmtest_write_path_info(p_osmt, fh, p_rec);
+	while (p_dst_node != (node_t *) cl_qmap_end(p_tbl)) {
+
+		OSM_LOG(&p_osmt->log, OSM_LOG_DEBUG,"Source : lid = 0x%d type = %d\n",
+				cl_ntoh16(p_dst_node->rec.lid),
+				p_dst_node->rec.node_info.node_type);
+
+		status = osmtest_get_path_rec_by_half_world_query(p_osmt, p_dst_node->rec.node_info.port_guid, &context);
+		if (status != IB_SUCCESS) {
+			OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0025: "
+					"osmtest_get_all_path_recs failed (%s)\n",
+					ib_get_err_str(status));
+			goto Exit;
+		}
+		/*
+		 * Write the received records out to the file.
+		 */
+		num_recs = context.result.result_cnt;
+		OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE, "Received %zu records\n", num_recs);
+
+		for (i = 0; i < num_recs; i++) {
+			p_rec =
+				osmv_get_query_path_rec(context.result.p_result_madw, i);
+			osmtest_write_path_info(p_osmt, fh, p_rec);
+		}
+		p_dst_node = (node_t *) cl_qmap_next(&p_dst_node->map_item);
 	}
 
 Exit:
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
