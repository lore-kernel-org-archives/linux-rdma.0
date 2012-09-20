From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 6/8] Use BlueFlame for RDMA_WRITE/WITH_IMM without data
Date: Thu, 20 Sep 2012 23:31:05 +0300
Message-ID: <1348173067-12116-7-git-send-email-ogerlitz@mellanox.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173067-12116-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Use Blue-Flame for RDMA Write and RDMA Write with immediate without any
data (no s/g). This improves latency for those messages.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/qp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index 812e6ec..e770ec8 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -267,6 +267,8 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				/* fall through */
 			case IBV_WR_RDMA_WRITE:
 			case IBV_WR_RDMA_WRITE_WITH_IMM:
+				if (!wr->num_sge)
+					inl = 1;
 				set_raddr_seg(wqe, wr->wr.rdma.remote_addr,
 					      wr->wr.rdma.rkey);
 				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
