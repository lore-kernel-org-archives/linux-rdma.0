From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH 1/8] IB/mlx5: add a new parameter to __mlx_ib_populated_pas for ODP with HMM.
Date: Fri, 17 Jul 2015 15:00:58 -0400
Message-ID: <1437159665-6612-2-git-send-email-jglisse@redhat.com>
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
page table iterator for __mlx_ib_populated_pas() function benefit. Add
void parameter for this.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
---
 drivers/infiniband/hw/mlx5/mem.c     | 8 +++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
 drivers/infiniband/hw/mlx5/mr.c      | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/m=
lx5/mem.c
index 40df2cc..df56b7d 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -145,11 +145,13 @@ static u64 umem_dma_to_mtt(dma_addr_t umem_dma)
  * num_pages - total number of pages to fill
  * pas - bus addresses array to fill
  * access_flags - access flags to set on all present pages.
-		  use enum mlx5_ib_mtt_access_flags for this.
+ *                use enum mlx5_ib_mtt_access_flags for this.
+ * data - intended for odp with hmm, it should point to current mirror=
 page
+ *        table iterator.
  */
 void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *u=
mem,
 			    int page_shift, size_t offset, size_t num_pages,
-			    __be64 *pas, int access_flags)
+			    __be64 *pas, int access_flags, void *data)
 {
 	unsigned long umem_page_shift =3D ilog2(umem->page_size);
 	int shift =3D page_shift - umem_page_shift;
@@ -201,7 +203,7 @@ void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, =
struct ib_umem *umem,
 {
 	return __mlx5_ib_populate_pas(dev, umem, page_shift, 0,
 				      ib_umem_num_pages(umem), pas,
-				      access_flags);
+				      access_flags, NULL);
 }
 int mlx5_ib_get_buf_offset(u64 addr, int page_shift, u32 *offset)
 {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
index 7cae098..d4dbd8e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -622,7 +622,7 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 a=
ddr, int *count, int *shift,
 			int *ncont, int *order);
 void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *u=
mem,
 			    int page_shift, size_t offset, size_t num_pages,
-			    __be64 *pas, int access_flags);
+			    __be64 *pas, int access_flags, void *data);
 void mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *ume=
m,
 			  int page_shift, __be64 *pas, int access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/ml=
x5/mr.c
index bc9a0de..ef63e5f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -912,7 +912,7 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 s=
tart_page_index, int npages,
 		if (!zap) {
 			__mlx5_ib_populate_pas(dev, umem, PAGE_SHIFT,
 					       start_page_index, npages, pas,
-					       MLX5_IB_MTT_PRESENT);
+					       MLX5_IB_MTT_PRESENT, NULL);
 			/* Clear padding after the pages brought from the
 			 * umem. */
 			memset(pas + npages, 0, size - npages * sizeof(u64));
--=20
1.9.3
