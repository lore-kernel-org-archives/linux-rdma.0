From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libmlx4: Add RAW_ETH to post_send
Date: Sun, 19 Dec 2010 11:30:37 +0200
Message-ID: <4D0DD0BD.5080801@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add RAW_ETH QP to post_send function.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 fixes/add_raw_eth_to_post_send.patch |   52 ++++++++++++++++++++++++++++++++++
 fixes/series                         |    1 +
 2 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 fixes/add_raw_eth_to_post_send.patch

diff --git a/fixes/add_raw_eth_to_post_send.patch b/fixes/add_raw_eth_to_post_send.patch
new file mode 100644
index 0000000..ce4e873
--- /dev/null
+++ b/fixes/add_raw_eth_to_post_send.patch
@@ -0,0 +1,52 @@
+From c31190ddc735cd2a28598846f5b57c9cf8434272 Mon Sep 17 00:00:00 2001
+From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
+Date: Sun, 19 Dec 2010 11:11:23 +0200
+Subject: [PATCH] Add RAW_ETH case to post_send
+
+Add controling checksum calculation when using RAW QP type.
+
+Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
+---
+ src/qp.c  |    6 ++++++
+ src/wqe.h |    1 +
+ 2 files changed, 7 insertions(+), 0 deletions(-)
+
+diff --git a/src/qp.c b/src/qp.c
+index d194ae3..580afff 100644
+--- a/src/qp.c
++++ b/src/qp.c
+@@ -231,6 +231,8 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
+ 			 htonl(MLX4_WQE_CTRL_CQ_UPDATE) : 0) |
+ 			(wr->send_flags & IBV_SEND_SOLICITED ?
+ 			 htonl(MLX4_WQE_CTRL_SOLICIT) : 0)   |
++			(wr->send_flags & IBV_SEND_IP_CSUM ?
++			 htonl(MLX4_WQE_CTRL_IP_CSUM) : 0)   |
+ 			qp->sq_signal_bits;
+ 
+ 		if (wr->opcode == IBV_WR_SEND_WITH_IMM ||
+@@ -283,6 +285,10 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
+ 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+ 			break;
+ 
++		case IBV_QPT_RAW_ETH:
++			/* For raw eth, the MLX4_WQE_CTRL_SOLICIT flag is used
++			 * to indicate that no icrc should be calculated */
++			ctrl->xrcrb_flags |= htonl(MLX4_WQE_CTRL_SOLICIT);
+ 		default:
+ 			break;
+ 		}
+diff --git a/src/wqe.h b/src/wqe.h
+index 6f7f309..007b617 100644
+--- a/src/wqe.h
++++ b/src/wqe.h
+@@ -41,6 +41,7 @@ enum {
+ 	MLX4_WQE_CTRL_FENCE	= 1 << 6,
+ 	MLX4_WQE_CTRL_CQ_UPDATE	= 3 << 2,
+ 	MLX4_WQE_CTRL_SOLICIT	= 1 << 1,
++	MLX4_WQE_CTRL_IP_CSUM	= 3 << 4,
+ };
+ 
+ enum {
+-- 
+1.6.4.2
+
diff --git a/fixes/series b/fixes/series
index 83516ec..2d04b25 100644
--- a/fixes/series
+++ b/fixes/series
@@ -8,3 +8,4 @@ rocee_add_support.patch
 add_supported_devices.patch
 post_rcv_end_of_sg.patch
 fix_inline_size.patch
+add_raw_eth_to_post_send.patch
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
