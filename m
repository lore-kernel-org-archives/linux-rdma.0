From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 1/8] Add raw packet QP support
Date: Thu, 20 Sep 2012 23:31:00 +0300
Message-ID: <1348173067-12116-2-git-send-email-ogerlitz@mellanox.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173067-12116-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implement raw packet QPs for Ethernet ports.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/qp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index 40a6689..90c4e80 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -286,6 +286,10 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
 			break;
 
+		case IBV_QPT_RAW_PACKET:
+			/* For raw eth, the MLX4_WQE_CTRL_SOLICIT flag is used
+			 * to indicate that no icrc should be calculated */
+			ctrl->srcrb_flags |= htonl(MLX4_WQE_CTRL_SOLICIT);
 		default:
 			break;
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
