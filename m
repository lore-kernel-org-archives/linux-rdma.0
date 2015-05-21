From: j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 30/36] IB/mlx5: add a new paramter to mlx5_ib_update_mtt() for ODP with HMM.
Date: Thu, 21 May 2015 15:23:47 -0400
Message-ID: <1432236233-4035-31-git-send-email-j.glisse@gmail.com>
References: <1432236233-4035-1-git-send-email-j.glisse@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432236233-4035-1-git-send-email-j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brendan Conoboy <blc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Donohue <jdonohue-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

When using HMM for ODP it will be usefull to pass the current mirror
page table iterator for mlx5_ib_update_mtt() function benefit. Add
void parameter for this.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 4 ++--
 drivers/infiniband/hw/mlx5/odp.c     | 8 +++++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
index ec532f0..ec629f2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -569,7 +569,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd,=
 u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata);
 int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index,
-		       int npages, int zap);
+		       int npages, int zap, void *data);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 int mlx5_ib_destroy_mr(struct ib_mr *ibmr);
 struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/ml=
x5/mr.c
index 51a7775..759ed15 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -845,7 +845,7 @@ free_mr:
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, in=
t npages,
-		       int zap)
+		       int zap, void *data)
 {
 	struct mlx5_ib_dev *dev =3D mr->dev;
 	struct device *ddev =3D dev->ib_dev.dma_device;
@@ -912,7 +912,7 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 s=
tart_page_index, int npages,
 		if (!zap) {
 			__mlx5_ib_populate_pas(dev, umem, PAGE_SHIFT,
 					       start_page_index, npages, pas,
-					       MLX5_IB_MTT_PRESENT, NULL);
+					       MLX5_IB_MTT_PRESENT, data);
 			/* Clear padding after the pages brought from the
 			 * umem. */
 			memset(pas + npages, 0, size - npages * sizeof(u64));
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/m=
lx5/odp.c
index 5099db0..5171959 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -91,14 +91,15 @@ void mlx5_ib_invalidate_range(struct ib_umem *umem,=
 unsigned long start,
=20
 			if (in_block && umr_offset =3D=3D 0) {
 				mlx5_ib_update_mtt(mr, blk_start_idx,
-						   idx - blk_start_idx, 1);
+						   idx - blk_start_idx, 1,
+						   NULL);
 				in_block =3D 0;
 			}
 		}
 	}
 	if (in_block)
 		mlx5_ib_update_mtt(mr, blk_start_idx, idx - blk_start_idx + 1,
-				   1);
+				   1, NULL);
=20
 	/*
 	 * We are now sure that the device will not access the
@@ -256,7 +257,8 @@ static int pagefault_single_data_segment(struct mlx=
5_ib_qp *qp,
 			 * this MR, since ib_umem_odp_map_dma_pages already
 			 * checks this.
 			 */
-			ret =3D mlx5_ib_update_mtt(mr, start_idx, npages, 0);
+			ret =3D mlx5_ib_update_mtt(mr, start_idx,
+						 npages, 0, NULL);
 		} else {
 			ret =3D -EAGAIN;
 		}
--=20
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
