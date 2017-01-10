From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 3/3] mlx5: Add packet pacing support
Date: Tue, 10 Jan 2017 17:08:19 +0200
Message-ID: <1484060899-29924-4-git-send-email-yishaih@mellanox.com>
References: <1484060899-29924-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484060899-29924-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add packet pacing support, it includes:
- Using the extended command to pass rate limit
  to the kernel. (i.e. ibv_cmd_modify_qp_ex).
- Reporting device capabilities.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  2 ++
 providers/mlx5/verbs.c    | 18 +++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 4b5b577..38220ec 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -253,6 +253,8 @@ struct mlx5_query_device_ex_resp {
 	__u32				response_length;
 	struct ibv_tso_caps		tso_caps;
 	struct mlx5_rss_caps            rss_caps; /* vendor data channel */
+	__u64				reserved_cqe_comp;
+	struct ibv_packet_pacing_caps	packet_pacing_caps;
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index ae68c84..43f6a57 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1498,10 +1498,16 @@ int mlx5_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	return 0;
 }
 
+enum {
+	MLX5_MODIFY_QP_EX_ATTR_MASK = IBV_QP_RATE_LIMIT,
+};
+
 int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask)
 {
 	struct ibv_modify_qp cmd = {};
+	struct ibv_modify_qp_ex cmd_ex = {};
+	struct ibv_modify_qp_resp_ex resp = {};
 	struct mlx5_qp *mqp = to_mqp(qp);
 	struct mlx5_context *context = to_mctx(qp->context);
 	int ret;
@@ -1533,7 +1539,15 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		}
 	}
 
-	ret = ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof(cmd));
+	if (attr_mask & MLX5_MODIFY_QP_EX_ATTR_MASK)
+		ret = ibv_cmd_modify_qp_ex(qp, attr, attr_mask,
+					   &cmd_ex,
+					   sizeof(cmd_ex), sizeof(cmd_ex),
+					   &resp,
+					   sizeof(resp), sizeof(resp));
+	else
+		ret = ibv_cmd_modify_qp(qp, attr, attr_mask,
+					&cmd, sizeof(cmd));
 
 	if (!ret		       &&
 	    (attr_mask & IBV_QP_STATE) &&
@@ -1887,6 +1901,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	attr->tso_caps = resp.tso_caps;
 	attr->rss_caps.rx_hash_fields_mask = resp.rss_caps.rx_hash_fields_mask;
 	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
+	attr->packet_pacing_caps = resp.packet_pacing_caps;
+
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
 	sub_minor = raw_fw_ver & 0xffff;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
