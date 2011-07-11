From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH/libmlx4] Use BlueFlame for RDMA_WRITE_WITH_IMM without data requests too
Date: Mon, 11 Jul 2011 14:02:09 +0300
Message-ID: <201107111402.10897.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use BlueFlame for RDMA Write with immediate without any data (no s/g) too.
This improves latency.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 src/qp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index e046da1..10ccbff 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -283,8 +283,11 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			case IBV_WR_RDMA_READ:
 				inl = 1;
 				/* fall through */
-			case IBV_WR_RDMA_WRITE:
 			case IBV_WR_RDMA_WRITE_WITH_IMM:
+				if (!wr->num_sge)
+					inl = 1;
+				/* fall through */
+			case IBV_WR_RDMA_WRITE:
 				set_raddr_seg(wqe, wr->wr.rdma.remote_addr,
 					      wr->wr.rdma.rkey);
 				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
