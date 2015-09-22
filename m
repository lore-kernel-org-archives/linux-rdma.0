From: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [v1 2/2] libmlx4: Add support for TX/RX checksum offload
Date: Tue, 22 Sep 2015 23:22:06 +0300
Message-ID: <1442953326-105006-3-git-send-email-bodong@mellanox.com>
References: <1442953326-105006-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442953326-105006-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RX checksum verification status is reported through wc_flag when polling CQ if
device supports checksum offload. When IBV_WC_IP_CSUM_OK is set, that means
both IPv4 header checksum and TCP/UDP checksum are OK.

TX checksum offload will be enabled for TCP/UDP over IPv4 if user sets
send_flag IBV_SEND_IP_CSUM and device supports checksum offload.

A new field: qp_cap_cache, is added to mlx4_qp in order to 'cache' the device
capabilities to minimize performance hit on poll_one and post_send function.
The capabilities are set inside mlx4_modify_qp. Post_send will return error
if device doesn't support checksum but user sets flag IBV_SEND_IP_CSUM.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    |  6 ++++++
 src/mlx4.h  | 19 ++++++++++++++++++-
 src/qp.c    | 19 +++++++++++++++++++
 src/verbs.c | 24 ++++++++++++++++++++++++
 src/wqe.h   |  8 +++++---
 5 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8b27795..32c9070 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -329,6 +329,12 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 			wc->sl	   = ntohs(cqe->sl_vid) >> 13;
 		else
 			wc->sl	   = ntohs(cqe->sl_vid) >> 12;
+
+		if ((*cur_qp) && ((*cur_qp)->qp_cap_cache & MLX4_RX_CSUM_VALID)) {
+			wc->wc_flags |= ((cqe->status & htonl(MLX4_CQE_STATUS_IPV4_CSUM_OK)) ==
+					 htonl(MLX4_CQE_STATUS_IPV4_CSUM_OK)) <<
+					IBV_WC_IP_CSUM_OK_SHIFT;
+		}
 	}
 
 	return CQ_OK;
diff --git a/src/mlx4.h b/src/mlx4.h
index d71450f..6de2dd2 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -257,6 +257,7 @@ struct mlx4_qp {
 	struct mlx4_wq			rq;
 
 	uint8_t				link_layer;
+	uint32_t			qp_cap_cache;
 };
 
 struct mlx4_av {
@@ -279,6 +280,22 @@ struct mlx4_ah {
 	uint8_t				mac[6];
 };
 
+enum {
+	MLX4_CSUM_SUPPORT_UD_OVER_IB	= (1 <<  0),
+	MLX4_CSUM_SUPPORT_RAW_OVER_ETH	= (1 <<  1),
+	/* Only report rx checksum when the validation is valid */
+	MLX4_RX_CSUM_VALID		= (1 <<  16),
+};
+
+enum mlx4_cqe_status {
+	MLX4_CQE_STATUS_TCP_UDP_CSUM_OK	= (1 <<  2),
+	MLX4_CQE_STATUS_IPV4_PKT	= (1 << 22),
+	MLX4_CQE_STATUS_IP_HDR_CSUM_OK	= (1 << 28),
+	MLX4_CQE_STATUS_IPV4_CSUM_OK	= MLX4_CQE_STATUS_IPV4_PKT |
+					MLX4_CQE_STATUS_IP_HDR_CSUM_OK |
+					MLX4_CQE_STATUS_TCP_UDP_CSUM_OK
+};
+
 struct mlx4_cqe {
 	uint32_t	vlan_my_qpn;
 	uint32_t	immed_rss_invalid;
@@ -286,7 +303,7 @@ struct mlx4_cqe {
 	uint8_t		sl_vid;
 	uint8_t		reserved1;
 	uint16_t	rlid;
-	uint32_t	reserved2;
+	uint32_t	status;
 	uint32_t	byte_cnt;
 	uint16_t	wqe_index;
 	uint16_t	checksum;
diff --git a/src/qp.c b/src/qp.c
index 721bed4..057490b 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -289,12 +289,31 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			set_datagram_seg(wqe, wr);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+
+			if (wr->send_flags & IBV_SEND_IP_CSUM) {
+				if (!(qp->qp_cap_cache & MLX4_CSUM_SUPPORT_UD_OVER_IB)) {
+					ret = EINVAL;
+					*bad_wr = wr;
+					goto out;
+				}
+				ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_IP_HDR_CSUM |
+							   MLX4_WQE_CTRL_TCP_UDP_CSUM);
+			}
 			break;
 
 		case IBV_QPT_RAW_PACKET:
 			/* For raw eth, the MLX4_WQE_CTRL_SOLICIT flag is used
 			 * to indicate that no icrc should be calculated */
 			ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_SOLICIT);
+			if (wr->send_flags & IBV_SEND_IP_CSUM) {
+				if (!(qp->qp_cap_cache & MLX4_CSUM_SUPPORT_RAW_OVER_ETH)) {
+					ret = EINVAL;
+					*bad_wr = wr;
+					goto out;
+				}
+				ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_IP_HDR_CSUM |
+							   MLX4_WQE_CTRL_TCP_UDP_CSUM);
+			}
 			break;
 
 		default:
diff --git a/src/verbs.c b/src/verbs.c
index 623d576..39d6412 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -606,14 +606,38 @@ int mlx4_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	struct ibv_modify_qp cmd;
 	struct ibv_port_attr port_attr;
 	struct mlx4_qp *mqp = to_mqp(qp);
+	struct ibv_device_attr device_attr;
 	int ret;
 
+	memset(&device_attr, 0, sizeof(device_attr));
 	if (attr_mask & IBV_QP_PORT) {
 		ret = ibv_query_port(qp->context, attr->port_num,
 				     &port_attr);
 		if (ret)
 			return ret;
 		mqp->link_layer = port_attr.link_layer;
+
+		ret = ibv_query_device(qp->context, &device_attr);
+		if (ret)
+			return ret;
+
+		switch(qp->qp_type) {
+		case IBV_QPT_UD:
+			if ((mqp->link_layer == IBV_LINK_LAYER_INFINIBAND) &&
+			    (device_attr.device_cap_flags & IBV_DEVICE_UD_IP_CSUM))
+				mqp->qp_cap_cache |= MLX4_CSUM_SUPPORT_UD_OVER_IB |
+						MLX4_RX_CSUM_VALID;
+			break;
+		case IBV_QPT_RAW_PACKET:
+			if ((mqp->link_layer == IBV_LINK_LAYER_ETHERNET) &&
+			    (device_attr.device_cap_flags & IBV_DEVICE_RAW_IP_CSUM))
+				mqp->qp_cap_cache |= MLX4_CSUM_SUPPORT_RAW_OVER_ETH |
+						MLX4_RX_CSUM_VALID;
+			break;
+		default:
+			break;
+		}
+
 	}
 
 	if (qp->state == IBV_QPS_RESET &&
diff --git a/src/wqe.h b/src/wqe.h
index bbd22ba..bbfd7df 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -38,9 +38,11 @@ enum {
 };
 
 enum {
-	MLX4_WQE_CTRL_FENCE	= 1 << 6,
-	MLX4_WQE_CTRL_CQ_UPDATE	= 3 << 2,
-	MLX4_WQE_CTRL_SOLICIT	= 1 << 1,
+	MLX4_WQE_CTRL_FENCE		= 1 << 6,
+	MLX4_WQE_CTRL_CQ_UPDATE		= 3 << 2,
+	MLX4_WQE_CTRL_SOLICIT		= 1 << 1,
+	MLX4_WQE_CTRL_IP_HDR_CSUM	= 1 << 4,
+	MLX4_WQE_CTRL_TCP_UDP_CSUM	= 1 << 5,
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
