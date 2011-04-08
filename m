From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/3] infiniband-diags: saquery, clean up error code/return
 types
Date: Fri, 8 Apr 2011 13:46:22 -0700
Message-ID: <20110408134622.dd038862.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Subject: [PATCH 3/3] infiniband-diags: saquery, clean up error code/return types

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 9314e4f..e3304a6 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -65,7 +65,7 @@ struct bind_handle {
 };
 
 struct query_res {
-	int status;
+	uint32_t status;
 	unsigned result_cnt;
 	void *p_result_madw;
 };
@@ -218,7 +218,7 @@ recv_mad:
 	offset = mad_get_field(mad, 0, IB_SA_ATTROFFS_F);
 	result.status = mad_get_field(mad, 0, IB_MAD_STATUS_F);
 	result.p_result_madw = mad;
-	if (result.status)
+	if (result.status != IB_SA_MAD_STATUS_SUCCESS)
 		result.result_cnt = 0;
 	else if (method != IB_MAD_METHOD_GET_TABLE)
 		result.result_cnt = 1;
@@ -858,9 +858,9 @@ static int get_any_records(bind_handle_t h,
 		return ret;
 	}
 
-	if (result.status != IB_SUCCESS) {
+	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
 		report_err(result.status);
-		return result.status;
+		return EIO;
 	}
 
 	return ret;
@@ -1105,11 +1105,13 @@ static int get_print_class_port_info(bind_handle_t h)
 			ib_get_err_str(ret));
 		return ret;
 	}
-	if (result.status != IB_SUCCESS) {
+	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
 		report_err(result.status);
-		return (result.status);
+		ret = EIO;
+		goto Exit;
 	}
 	dump_results(&result, dump_class_port_info);
+Exit:
 	return_mad();
 	return ret;
 }
@@ -1148,29 +1150,29 @@ static int query_path_records(const struct query_cmd *q, bind_handle_t h,
 					&pr, 0, dump_path_record);
 }
 
-static ib_api_status_t print_issm_records(bind_handle_t h)
+static int print_issm_records(bind_handle_t h)
 {
-	ib_api_status_t status;
+	int ret = 0;
 
 	/* First, get IsSM records */
-	status = get_issm_records(h, IB_PORT_CAP_IS_SM);
-	if (status != IB_SUCCESS)
-		return (status);
+	ret = get_issm_records(h, IB_PORT_CAP_IS_SM);
+	if (ret != 0)
+		return (ret);
 
 	printf("IsSM ports\n");
 	dump_results(&result, dump_portinfo_record);
 	return_mad();
 
 	/* Now, get IsSMdisabled records */
-	status = get_issm_records(h, IB_PORT_CAP_SM_DISAB);
-	if (status != IB_SUCCESS)
-		return (status);
+	ret = get_issm_records(h, IB_PORT_CAP_SM_DISAB);
+	if (ret != 0)
+		return (ret);
 
 	printf("\nIsSMdisabled ports\n");
 	dump_results(&result, dump_portinfo_record);
 	return_mad();
 
-	return (status);
+	return (ret);
 }
 
 static int print_multicast_member_records(bind_handle_t h)
@@ -1719,7 +1721,7 @@ int main(int argc, char **argv)
 	bind_handle_t h;
 	struct query_params params;
 	const struct query_cmd *q;
-	ib_api_status_t status;
+	int status;
 	int n;
 
 	const struct ibdiag_opt opts[] = {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
