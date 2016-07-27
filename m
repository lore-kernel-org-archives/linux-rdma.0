From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/mlx4: Make function use_tunnel_data return void
Date: Wed, 27 Jul 2016 01:24:52 -0700
Message-ID: <1469607893-10657-2-git-send-email-yuval.shaia@oracle.com>
References: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469607893-10657-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No need to return int if function always returns 0

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 9f8b516..4c2e1b0 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -576,8 +576,8 @@ static int mlx4_ib_ipoib_csum_ok(__be16 status, __be16 checksum)
 		checksum == cpu_to_be16(0xffff);
 }
 
-static int use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq, struct ib_wc *wc,
-			   unsigned tail, struct mlx4_cqe *cqe, int is_eth)
+static void use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq, struct ib_wc *wc,
+			    unsigned tail, struct mlx4_cqe *cqe, int is_eth)
 {
 	struct mlx4_ib_proxy_sqp_hdr *hdr;
 
@@ -600,8 +600,6 @@ static int use_tunnel_data(struct mlx4_ib_qp *qp, struct mlx4_ib_cq *cq, struct
 		wc->slid        = be16_to_cpu(hdr->tun.slid_mac_47_32);
 		wc->sl          = (u8) (be16_to_cpu(hdr->tun.sl_vid) >> 12);
 	}
-
-	return 0;
 }
 
 static void mlx4_ib_qp_sw_comp(struct mlx4_ib_qp *qp, int num_entries,
@@ -853,8 +851,9 @@ repoll:
 			if ((*cur_qp)->mlx4_ib_qp_type &
 			    (MLX4_IB_QPT_PROXY_SMI_OWNER |
 			     MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI))
-				return use_tunnel_data(*cur_qp, cq, wc, tail,
-						       cqe, is_eth);
+				use_tunnel_data(*cur_qp, cq, wc, tail, cqe,
+						is_eth);
+				return 0;
 		}
 
 		wc->slid	   = be16_to_cpu(cqe->rlid);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
