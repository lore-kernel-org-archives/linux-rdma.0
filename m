From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH 2/8] IB/mlx5: add a new parameter to mlx5_ib_update_mtt() for ODP with HMM.
Date: Fri, 17 Jul 2015 15:00:59 -0400
Message-ID: <1437159665-6612-3-git-send-email-jglisse@redhat.com>
References: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christophe Harle <charle@nvidia.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Mark Hairgrove <mhairgrove@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Haggai Eran <haggaie@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Liran Liss <liranl@mellanox.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
List-Id: linux-rdma@vger.kernel.org

When using HMM for ODP it will be useful to pass the current mirror
page table iterator for mlx5_ib_update_mtt() function benefit. Add
void parameter for this.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 4 ++--
 drivers/infiniband/hw/mlx5/odp.c     | 8 +++++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
index d4dbd8e..79d1e7c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -571,7 +571,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd,=
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
index ef63e5f..3ad371d 100644
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
index aa8391e..df86d05 100644
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
@@ -249,7 +250,8 @@ static int pagefault_single_data_segment(struct mlx=
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
