From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Expose extended error counters
Date: Mon, 19 Jun 2017 07:19:37 +0300
Message-ID: <20170619041937.10120-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds below requester and responder side error counters,
which will be exposed by hardware counters interface and are supported
as part of query Q counters command extension.

 +---------------------------+-------------------------------------+
 |      Name                 |           Description               |
 |---------------------------+-------------------------------------|
 |resp_local_length_error    | Number of times responder detected  |
 |                           | local length errors                 |
 |---------------------------+-------------------------------------|
 |resp_cqe_error             | Number of CQEs completed with error |
 |                           | at responder                        |
 |---------------------------+-------------------------------------|
 |req_cqe_error              | Number of CQEs completed with error |
 |                           | at requester                        |
 |---------------------------+-------------------------------------|
 |req_remote_invalid_request | Number of times requester detected  |
 |                           | remote invalid request error        |
 |---------------------------+-------------------------------------|
 |req_remote_access_error    | Number of times requester detected  |
 |                           | remote access error                 |
 |---------------------------+-------------------------------------|
 |resp_remote_access_error   | Number of times responder detected  |
 |                           | remote access error                 |
 |---------------------------+-------------------------------------|
 |resp_cqe_flush_error       | Number of CQEs completed with       |
 |                           | flushed with error at responder     |
 |---------------------------+-------------------------------------|
 |req_cqe_flush_error        | Number of CQEs completed with       |
 |                           | flushed with error at requester     |
 +---------------------------+-------------------------------------+

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 22 ++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h     | 44 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9f3ba320ce70..2f3775d99a7c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3315,6 +3315,17 @@ static const struct mlx5_ib_counter cong_cnts[] = {
 	INIT_CONG_COUNTER(np_cnp_sent),
 };

+static const struct mlx5_ib_counter extended_err_cnts[] = {
+	INIT_Q_COUNTER(resp_local_length_error),
+	INIT_Q_COUNTER(resp_cqe_error),
+	INIT_Q_COUNTER(req_cqe_error),
+	INIT_Q_COUNTER(req_remote_invalid_request),
+	INIT_Q_COUNTER(req_remote_access_errors),
+	INIT_Q_COUNTER(resp_remote_access_errors),
+	INIT_Q_COUNTER(resp_cqe_flush_error),
+	INIT_Q_COUNTER(req_cqe_flush_error),
+};
+
 static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 {
 	unsigned int i;
@@ -3339,6 +3350,10 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,

 	if (MLX5_CAP_GEN(dev->mdev, retransmission_q_counters))
 		num_counters += ARRAY_SIZE(retrans_q_cnts);
+
+	if (MLX5_CAP_GEN(dev->mdev, enhanced_error_q_counters))
+		num_counters += ARRAY_SIZE(extended_err_cnts);
+
 	cnts->num_q_counters = num_counters;

 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
@@ -3388,6 +3403,13 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 		}
 	}

+	if (MLX5_CAP_GEN(dev->mdev, enhanced_error_q_counters)) {
+		for (i = 0; i < ARRAY_SIZE(extended_err_cnts); i++, j++) {
+			names[j] = extended_err_cnts[i].name;
+			offsets[j] = extended_err_cnts[i].offset;
+		}
+	}
+
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
 		for (i = 0; i < ARRAY_SIZE(cong_cnts); i++, j++) {
 			names[j] = cong_cnts[i].name;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 32de0724b400..adcb3c3c9f79 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -838,7 +838,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         pcam_reg[0x1];
 	u8         local_ca_ack_delay[0x5];
 	u8         port_module_event[0x1];
-	u8         reserved_at_1b1[0x1];
+	u8         enhanced_error_q_counters[0x1];
 	u8         ports_check[0x1];
 	u8         reserved_at_1b3[0x1];
 	u8         disable_link_up[0x1];
@@ -3916,7 +3916,47 @@ struct mlx5_ifc_query_q_counter_out_bits {

 	u8         local_ack_timeout_err[0x20];

-	u8         reserved_at_320[0x4e0];
+	u8         reserved_at_320[0xa0];
+
+	u8         resp_local_length_error[0x20];
+
+	u8         req_local_length_error[0x20];
+
+	u8         resp_local_qp_error[0x20];
+
+	u8         local_operation_error[0x20];
+
+	u8         resp_local_protection[0x20];
+
+	u8         req_local_protection[0x20];
+
+	u8         resp_cqe_error[0x20];
+
+	u8         req_cqe_error[0x20];
+
+	u8         req_mw_binding[0x20];
+
+	u8         req_bad_response[0x20];
+
+	u8         req_remote_invalid_request[0x20];
+
+	u8         resp_remote_invalid_request[0x20];
+
+	u8         req_remote_access_errors[0x20];
+
+	u8	   resp_remote_access_errors[0x20];
+
+	u8         req_remote_operation_errors[0x20];
+
+	u8         req_transport_retries_exceeded[0x20];
+
+	u8         cq_overflow[0x20];
+
+	u8         resp_cqe_flush_error[0x20];
+
+	u8         req_cqe_flush_error[0x20];
+
+	u8         reserved_at_620[0x1e0];
 };

 struct mlx5_ifc_query_q_counter_in_bits {
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
