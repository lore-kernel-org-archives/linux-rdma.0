From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH REPOST libmlx4] Add IP and TCP/UDP TX checksum offload support
Date: Sun, 14 Jun 2015 13:13:38 +0300
Message-ID: <1434276818-15972-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for IBV_SEND_IP_CSUM for posted send work-requests.

When this flag is set, enable the HW checksum calculation by setting
MLX4_WQE_CTRL_IP_CSUM and MLX4_WQE_CTRL_TCP_UDP_CSUM flags in the WQE
control segment.

Signed-off-by: Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/qp.c  |   11 ++++++++++-
 src/wqe.h |    2 ++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index 721bed4..5b800e7 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -286,6 +286,10 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			break;
 
 		case IBV_QPT_UD:
+			ctrl->srcrb_flags |=
+				wr->send_flags & IBV_SEND_IP_CSUM ?
+				htonl(MLX4_WQE_CTRL_IP_CSUM |
+				      MLX4_WQE_CTRL_TCP_UDP_CSUM) : 0;
 			set_datagram_seg(wqe, wr);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
@@ -294,7 +298,12 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		case IBV_QPT_RAW_PACKET:
 			/* For raw eth, the MLX4_WQE_CTRL_SOLICIT flag is used
 			 * to indicate that no icrc should be calculated */
-			ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_SOLICIT);
+			ctrl->srcrb_flags |=
+				wr->send_flags & IBV_SEND_IP_CSUM ?
+				htonl(MLX4_WQE_CTRL_IP_CSUM |
+				      MLX4_WQE_CTRL_TCP_UDP_CSUM |
+				      MLX4_WQE_CTRL_SOLICIT) :
+				htonl(MLX4_WQE_CTRL_SOLICIT);
 			break;
 
 		default:
diff --git a/src/wqe.h b/src/wqe.h
index bbd22ba..ebd5167 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -41,6 +41,8 @@ enum {
 	MLX4_WQE_CTRL_FENCE	= 1 << 6,
 	MLX4_WQE_CTRL_CQ_UPDATE	= 3 << 2,
 	MLX4_WQE_CTRL_SOLICIT	= 1 << 1,
+	MLX4_WQE_CTRL_IP_CSUM	= 1 << 4,
+	MLX4_WQE_CTRL_TCP_UDP_CSUM = 1 << 5
 };
 
 enum {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
