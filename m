From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 4/4] add Raw Packet QP support
Date: Tue, 17 Jan 2012 13:42:25 +0200
Message-ID: <alpine.LRH.2.00.1201171342030.26871@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201171330540.24946-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Basic support for RAW Packet QP.

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
1.6.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
