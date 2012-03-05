From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: saquery further error value clean up.
Date: Mon,  5 Mar 2012 13:45:41 -0800
Message-ID: <1330983941-13727-1-git-send-email-weiny2@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 097d9dd..e5fdb25 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -798,7 +798,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 	if (ret)
 		return ret;
 
-	ret = IB_NOT_FOUND;
+	ret = ENONET;
 	for (i = 0; i < result.result_cnt; i++) {
 		node_record = sa_get_query_rec(result.p_result_madw, i);
 		p_ni = &(node_record->node_info);
@@ -807,7 +807,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 			       sizeof(node_record->node_desc.description)) ==
 		    0) {
 			*lid = cl_ntoh16(node_record->lid);
-			ret = IB_SUCCESS;
+			ret = 0;
 			break;
 		}
 	}
@@ -817,14 +817,16 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 
 static uint16_t get_lid(bind_handle_t h, const char *name)
 {
+	int rc = 0;
 	uint16_t rc_lid = 0;
 
 	if (!name)
 		return 0;
 	if (isalpha(name[0])) {
-		if (get_lid_from_name(h, name, &rc_lid) != 0) {
-			fprintf(stderr, "Failed to find lid for \"%s\"\n", name);
-			exit(EINVAL);
+		if ((rc = get_lid_from_name(h, name, &rc_lid)) != 0) {
+			fprintf(stderr, "Failed to find lid for \"%s\": %s\n",
+				name, strerror(rc));
+			exit(rc);
 		}
 	} else {
 		long val;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
