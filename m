From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/3] infiniband-diags: saquery, exit with ENODEV when
 queries fail to find results
Date: Fri, 8 Apr 2011 13:45:08 -0700
Message-ID: <20110408134508.dfd7e8b9.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Subject: [PATCH 1/3] infiniband-diags: saquery, exit with ENODEV when queries fail to find results

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 03869e3..d7c8e6f 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -876,6 +876,9 @@ static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 	if (ret)
 		return ret;
 
+	if (result.result_cnt == 0)
+		return ENODEV;
+
 	dump_results(&result, dump_func);
 
 	return 0;
@@ -896,7 +899,14 @@ static int get_and_dump_all_records(bind_handle_t h, uint16_t attr_id,
 	if (ret)
 		return ret;
 
+	if (result.result_cnt == 0) {
+		ret = ENODEV;
+		goto Exit;
+	}
+
 	dump_results(&result, dump_func);
+
+Exit:
 	return_mad();
 	return ret;
 }
@@ -915,7 +925,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 	if (ret)
 		return ret;
 
-	ret = IB_NOT_FOUND;
+	ret = ENODEV;
 	for (i = 0; i < result.result_cnt; i++) {
 		node_record = get_query_rec(result.p_result_madw, i);
 		p_ni = &(node_record->node_info);
@@ -924,7 +934,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 			       sizeof(node_record->node_desc.description)) ==
 		    0) {
 			*lid = cl_ntoh16(node_record->lid);
-			ret = IB_SUCCESS;
+			ret = 0;
 			break;
 		}
 	}
@@ -939,7 +949,7 @@ static uint16_t get_lid(bind_handle_t h, const char *name)
 	if (!name)
 		return 0;
 	if (isalpha(name[0])) {
-		if (get_lid_from_name(h, name, &rc_lid) != IB_SUCCESS) {
+		if (get_lid_from_name(h, name, &rc_lid) != 0) {
 			fprintf(stderr, "Failed to find lid for \"%s\"\n", name);
 			exit(EINVAL);
 		}
@@ -1040,6 +1050,8 @@ static int print_node_records(bind_handle_t h)
 	if (ret)
 		return ret;
 
+	ret = ENODEV;
+
 	if (node_print_desc == ALL_DESC) {
 		printf("   LID \"name\"\n");
 		printf("================\n");
@@ -1049,14 +1061,18 @@ static int print_node_records(bind_handle_t h)
 		node_record = get_query_rec(result.p_result_madw, i);
 		if (node_print_desc == ALL_DESC) {
 			print_node_desc(node_record);
+			ret = 0;
 		} else if (node_print_desc == NAME_OF_LID) {
-			if (requested_lid == cl_ntoh16(node_record->lid))
+			if (requested_lid == cl_ntoh16(node_record->lid)) {
 				print_node_record(node_record);
+				ret = 0;
+			}
 		} else if (node_print_desc == NAME_OF_GUID) {
 			ib_node_info_t *p_ni = &(node_record->node_info);
-
-			if (requested_guid == cl_ntoh64(p_ni->port_guid))
+			if (requested_guid == cl_ntoh64(p_ni->port_guid)) {
 				print_node_record(node_record);
+				ret = 0;
+			}
 		} else {
 			if (!requested_name ||
 			    (strncmp(requested_name,
@@ -1068,6 +1084,7 @@ static int print_node_records(bind_handle_t h)
 					return_mad();
 					exit(0);
 				}
+				ret = 0;
 			}
 		}
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
