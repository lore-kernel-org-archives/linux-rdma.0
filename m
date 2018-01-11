From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 09/17] verbs: Use kernel uapi header for ibv_query_device_resp_ex
Date: Thu, 11 Jan 2018 15:13:32 -0700
Message-ID: <20180111221340.965-10-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For some reason the struct member names do not match the kernel version,
fix it.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c          | 28 ++++++++++++++--------------
 libibverbs/driver.h       |  2 +-
 libibverbs/kern-abi.h     | 15 ---------------
 providers/mlx4/mlx4-abi.h |  2 +-
 providers/mlx5/mlx5-abi.h |  2 +-
 5 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index ad0e0dc3736756..d7ca35b924a81c 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -134,7 +134,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 			    struct ibv_query_device_ex *cmd,
 			    size_t cmd_core_size,
 			    size_t cmd_size,
-			    struct ibv_query_device_resp_ex *resp,
+			    struct ib_uverbs_ex_query_device_resp *resp,
 			    size_t resp_core_size,
 			    size_t resp_size)
 {
@@ -147,7 +147,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 			sizeof(attr->comp_mask))
 		return EINVAL;
 
-	if (resp_core_size < offsetof(struct ibv_query_device_resp_ex,
+	if (resp_core_size < offsetof(struct ib_uverbs_ex_query_device_resp,
 				      response_length) +
 			     sizeof(resp->response_length))
 		return EINVAL;
@@ -171,7 +171,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, odp_caps) +
 			 sizeof(attr->odp_caps)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, odp_caps) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, odp_caps) +
 		    sizeof(resp->odp_caps)) {
 			attr->odp_caps.general_caps = resp->odp_caps.general_caps;
 			attr->odp_caps.per_transport_caps.rc_odp_caps =
@@ -187,7 +187,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 				  completion_timestamp_mask) +
 			 sizeof(attr->completion_timestamp_mask)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, timestamp_mask) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, timestamp_mask) +
 		    sizeof(resp->timestamp_mask))
 			attr->completion_timestamp_mask = resp->timestamp_mask;
 	}
@@ -195,7 +195,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, hca_core_clock) +
 			 sizeof(attr->hca_core_clock)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, hca_core_clock) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, hca_core_clock) +
 		    sizeof(resp->hca_core_clock))
 			attr->hca_core_clock = resp->hca_core_clock;
 	}
@@ -203,7 +203,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, device_cap_flags_ex) +
 			 sizeof(attr->device_cap_flags_ex)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, device_cap_flags_ex) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, device_cap_flags_ex) +
 		    sizeof(resp->device_cap_flags_ex))
 			attr->device_cap_flags_ex = resp->device_cap_flags_ex;
 	}
@@ -211,7 +211,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, rss_caps) +
 			 sizeof(attr->rss_caps)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, rss_caps) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, rss_caps) +
 		    sizeof(resp->rss_caps)) {
 			attr->rss_caps.supported_qpts = resp->rss_caps.supported_qpts;
 			attr->rss_caps.max_rwq_indirection_tables = resp->rss_caps.max_rwq_indirection_tables;
@@ -222,7 +222,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, max_wq_type_rq) +
 			 sizeof(attr->max_wq_type_rq)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, max_wq_type_rq) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, max_wq_type_rq) +
 		    sizeof(resp->max_wq_type_rq))
 			attr->max_wq_type_rq = resp->max_wq_type_rq;
 	}
@@ -230,7 +230,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, raw_packet_caps) +
 			 sizeof(attr->raw_packet_caps)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, raw_packet_caps) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, raw_packet_caps) +
 		    sizeof(resp->raw_packet_caps))
 			attr->raw_packet_caps = resp->raw_packet_caps;
 	}
@@ -238,7 +238,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, tm_caps) +
 			 sizeof(attr->tm_caps)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, tm_caps) +
+		    offsetof(struct ib_uverbs_ex_query_device_resp, tm_caps) +
 		    sizeof(resp->tm_caps)) {
 			attr->tm_caps.max_rndv_hdr_size =
 				resp->tm_caps.max_rndv_hdr_size;
@@ -255,10 +255,10 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 	if (attr_size >= offsetof(struct ibv_device_attr_ex, cq_mod_caps) +
 			 sizeof(attr->cq_mod_caps)) {
 		if (resp->response_length >=
-		    offsetof(struct ibv_query_device_resp_ex, cq_mod_caps) +
-		    sizeof(resp->cq_mod_caps)) {
-			attr->cq_mod_caps.max_cq_count = resp->cq_mod_caps.max_cq_moderation_count;
-			attr->cq_mod_caps.max_cq_period = resp->cq_mod_caps.max_cq_moderation_period;
+		    offsetof(struct ib_uverbs_ex_query_device_resp, cq_moderation_caps) +
+		    sizeof(resp->cq_moderation_caps)) {
+			attr->cq_mod_caps.max_cq_count = resp->cq_moderation_caps.max_cq_moderation_count;
+			attr->cq_mod_caps.max_cq_period = resp->cq_moderation_caps.max_cq_moderation_period;
 		}
 	}
 
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 0c5a8e9a43f366..f9adf80df76cb0 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -331,7 +331,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 			    struct ibv_query_device_ex *cmd,
 			    size_t cmd_core_size,
 			    size_t cmd_size,
-			    struct ibv_query_device_resp_ex *resp,
+			    struct ib_uverbs_ex_query_device_resp *resp,
 			    size_t resp_core_size,
 			    size_t resp_size);
 int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 6a697987799c68..96b98ebc229980 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -110,21 +110,6 @@ struct ibv_query_device_ex {
 	__u32		reserved;
 };
 
-struct ibv_query_device_resp_ex {
-	struct ib_uverbs_query_device_resp base;
-	__u32 comp_mask;
-	__u32 response_length;
-	struct ib_uverbs_odp_caps odp_caps;
-	__u64 timestamp_mask;
-	__u64 hca_core_clock;
-	__u64 device_cap_flags_ex;
-	struct ib_uverbs_rss_caps rss_caps;
-	__u32  max_wq_type_rq;
-	__u32 raw_packet_caps;
-	struct ib_uverbs_tm_caps tm_caps;
-	struct ib_uverbs_cq_moderation_caps cq_mod_caps;
-};
-
 struct ibv_query_port {
 	__u32 command;
 	__u16 in_words;
diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index 5f8ce28d70713d..3b58ff5eb83306 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -106,7 +106,7 @@ struct mlx4_rss_caps {
 };
 
 struct mlx4_query_device_ex_resp {
-	struct ibv_query_device_resp_ex ibv_resp;
+	struct ib_uverbs_ex_query_device_resp ibv_resp;
 	__u32				comp_mask;
 	__u32				response_length;
 	__u64				hca_core_clock_offset;
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 0f2db819889cf9..661c774c7553ea 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -304,7 +304,7 @@ struct mlx5_striding_rq_caps {
 };
 
 struct mlx5_query_device_ex_resp {
-	struct ibv_query_device_resp_ex ibv_resp;
+	struct ib_uverbs_ex_query_device_resp ibv_resp;
 	__u32				comp_mask;
 	__u32				response_length;
 	struct ibv_tso_caps		tso_caps;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
