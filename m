From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4] Add support for TX/RX checksum offload
Date: Mon, 17 Aug 2015 18:53:20 +0300
Message-ID: <1439826800-6804-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RX checksum verification status is reported through wc_flag when polling
CQ. When IBV_WC_IP_CSUM_OK is set, that means both IPv4 header checksum and
TCP/UDP checksum are OK.

TX checksum offload will be enabled for TCP/UDP over IPv4 if user sets
send_flag IBV_SEND_IP_CSUM.

A new field, qp_cap_cache, is added to mlx4_qp in order to 'cache'
the device capabilities to minimize perfromance hit on poll_one
function. The capabilities are set during mlx4_modify_qp for RAW ETH
and UD QPs.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    |  8 ++++++++
 src/mlx4.h  | 16 +++++++++++++++-
 src/qp.c    | 11 ++++++++++-
 src/verbs.c | 12 ++++++++++++
 src/wqe.h   |  5 +++++
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8b27795..186b960 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -329,6 +329,14 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 			wc->sl	   = ntohs(cqe->sl_vid) >> 13;
 		else
 			wc->sl	   = ntohs(cqe->sl_vid) >> 12;
+
+		if ((*cur_qp) && ((*cur_qp)->qp_cap_cache & MLX4_RX_CSUM_IPV4)) {
+			uint32_t status = ntohl(cqe->status);
+			wc->wc_flags |= ((status & MLX4_CQE_STATUS_IPV4_CSUM_OK) ==
+					 MLX4_CQE_STATUS_IPV4_CSUM_OK) <<
+					IBV_WC_IP_CSUM_OK_SHIFT;
+		}
+
 	}
 
 	return CQ_OK;
diff --git a/src/mlx4.h b/src/mlx4.h
index d71450f..ec7c58d 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -257,6 +257,7 @@ struct mlx4_qp {
 	struct mlx4_wq			rq;
 
 	uint8_t				link_layer;
+	uint8_t				qp_cap_cache;
 };
 
 struct mlx4_av {
@@ -279,6 +280,19 @@ struct mlx4_ah {
 	uint8_t				mac[6];
 };
 
+enum {
+	MLX4_RX_CSUM_IPV4 = (1 <<  0),
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
@@ -286,7 +300,7 @@ struct mlx4_cqe {
 	uint8_t		sl_vid;
 	uint8_t		reserved1;
 	uint16_t	rlid;
-	uint32_t	reserved2;
+	uint32_t	status;
 	uint32_t	byte_cnt;
 	uint16_t	wqe_index;
 	uint16_t	checksum;
diff --git a/src/qp.c b/src/qp.c
index 721bed4..eb4c488 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -200,6 +200,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	int ret = 0;
 	int size;
 	int i;
+	int is_csum;
 
 	pthread_spin_lock(&qp->sq.lock);
 
@@ -286,15 +287,23 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			break;
 
 		case IBV_QPT_UD:
+			is_csum = !!(wr->send_flags & IBV_SEND_IP_CSUM);
 			set_datagram_seg(wqe, wr);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+
+			ctrl->srcrb_flags |=
+				htonl((is_csum << MLX4_WQE_CTRL_IP_HDR_CSUM_SHIFT) |
+				      (is_csum << MLX4_WQE_CTRL_TCP_UDP_CSUM_SHIFT));
 			break;
 
 		case IBV_QPT_RAW_PACKET:
+			is_csum = !!(wr->send_flags & IBV_SEND_IP_CSUM);
 			/* For raw eth, the MLX4_WQE_CTRL_SOLICIT flag is used
 			 * to indicate that no icrc should be calculated */
-			ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_SOLICIT);
+			ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_SOLICIT |
+				(is_csum << MLX4_WQE_CTRL_IP_HDR_CSUM_SHIFT) |
+				(is_csum << MLX4_WQE_CTRL_TCP_UDP_CSUM_SHIFT));
 			break;
 
 		default:
diff --git a/src/verbs.c b/src/verbs.c
index 623d576..3fbbbf9 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -606,14 +606,26 @@ int mlx4_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
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
+		if ((qp->qp_type == IBV_QPT_UD) || (qp->qp_type == IBV_QPT_RAW_PACKET))
+		{
+			ret = ibv_query_device(qp->context, &device_attr);
+			if (ret)
+				return ret;
+
+			if (device_attr.device_cap_flags & IBV_DEVICE_IP_CSUM)
+				mqp->qp_cap_cache |= MLX4_RX_CSUM_IPV4;
+		}
 	}
 
 	if (qp->state == IBV_QPS_RESET &&
diff --git a/src/wqe.h b/src/wqe.h
index bbd22ba..1a98559 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -44,6 +44,11 @@ enum {
 };
 
 enum {
+	MLX4_WQE_CTRL_IP_HDR_CSUM_SHIFT	 = 4,
+	MLX4_WQE_CTRL_TCP_UDP_CSUM_SHIFT = 5
+};
+
+enum {
 	MLX4_INLINE_SEG		= 1 << 31,
 	MLX4_INLINE_ALIGN	= 64,
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
