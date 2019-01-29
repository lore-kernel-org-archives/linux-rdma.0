From: Joel Nider <joeln@il.ibm.com>
Subject: [PATCH 2/5] RDMA/uverbs: add owner parameter to reg_user_mr
Date: Tue, 29 Jan 2019 15:26:23 +0200
Message-ID: <1548768386-28289-3-git-send-email-joeln@il.ibm.com>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>, Joel Nider <joeln@il.ibm.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Add a new parameter 'owner' to the reg_user_mr function. The owner
parameter specifies the owning process of the memory for which the
MR is being registered. Until now, the function assumed that the
process calling the function is also the owner. This patch relaxes
that assumption, and allows for the caller and registree to be
different processes, which is required for the reg_remote_mr verb
implemented in the following patches. No functional changes in
these files.

Signed-off-by: Joel Nider <joeln@il.ibm.com>
---
 drivers/infiniband/core/uverbs_cmd.c         | 2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 1 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.h     | 1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  | 3 ++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       | 1 +
 drivers/infiniband/hw/cxgb4/mem.c            | 3 ++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    | 1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h         | 1 +
 drivers/infiniband/hw/mlx4/mr.c              | 1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         | 4 +++-
 drivers/infiniband/hw/mlx5/mr.c              | 2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c | 3 ++-
 drivers/infiniband/hw/nes/nes_verbs.c        | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  | 3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  | 3 ++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h | 1 +
 drivers/infiniband/sw/rdmavt/mr.c            | 1 +
 drivers/infiniband/sw/rdmavt/mr.h            | 1 +
 drivers/infiniband/sw/rxe/rxe_verbs.c        | 4 +++-
 include/rdma/ib_verbs.h                      | 1 +
 21 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6b12cc5..034d595 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -724,7 +724,7 @@ static int ib_uverbs_reg_mr(struct uverbs_attr_bundle *attrs)
 	}
 
 	mr = pd->device->ops.reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
-					 cmd.access_flags,
+					 cmd.access_flags, NULL,
 					 &attrs->driver_udata);
 	if (IS_ERR(mr)) {
 		ret = PTR_ERR(mr);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 1e2515e..0828f27 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3557,6 +3557,7 @@ static int fill_umem_pbl_tbl(struct ib_umem *umem, u64 *pbl_tbl_orig,
 /* uverbs */
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 				  u64 virt_addr, int mr_access_flags,
+				  struct pid *owner,
 				  struct ib_udata *udata)
 {
 	struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index c4af726..5af76f6 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -215,6 +215,7 @@ struct ib_mw *bnxt_re_alloc_mw(struct ib_pd *ib_pd, enum ib_mw_type type,
 int bnxt_re_dealloc_mw(struct ib_mw *mw);
 struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int mr_access_flags,
+				  struct pid *owner,
 				  struct ib_udata *udata);
 struct ib_ucontext *bnxt_re_alloc_ucontext(struct ib_device *ibdev,
 					   struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index b34b1a1..54d8b38 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -519,7 +519,8 @@ static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
 }
 
 static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-				      u64 virt, int acc, struct ib_udata *udata)
+				      u64 virt, int acc, struct pid *owner,
+				      struct ib_udata *udata)
 {
 	__be64 *pages;
 	int shift, n, len;
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index f0fcead..8d382fe 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -1059,6 +1059,7 @@ struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 			    struct ib_udata *udata);
 struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
 					   u64 length, u64 virt, int acc,
+					   struct pid *owner,
 					   struct ib_udata *udata);
 struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc);
 int c4iw_dereg_mr(struct ib_mr *ib_mr);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 7b76e6f..ec9b0b4 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -499,7 +499,8 @@ struct ib_mr *c4iw_get_dma_mr(struct ib_pd *pd, int acc)
 }
 
 struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-			       u64 virt, int acc, struct ib_udata *udata)
+			       u64 virt, int acc, struct pid *owner,
+			       struct ib_udata *udata)
 {
 	__be64 *pages;
 	int shift, n, len;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 0b675b0..fc2e6c8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1827,6 +1827,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 				       u64 length,
 				       u64 virt,
 				       int acc,
+				       struct pid *owner,
 				       struct ib_udata *udata)
 {
 	struct i40iw_pd *iwpd = to_iwpd(pd);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e491f3e..80bb83c 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -731,6 +731,7 @@ int mlx4_ib_umem_write_mtt(struct mlx4_ib_dev *dev, struct mlx4_mtt *mtt,
 			   struct ib_umem *umem);
 struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
+				  struct pid *owner,
 				  struct ib_udata *udata);
 int mlx4_ib_dereg_mr(struct ib_mr *mr);
 struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index c7c85c2..76fa83c 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -403,6 +403,7 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_ucontext *context, u64 start,
 
 struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
+				  struct pid *owner,
 				  struct ib_udata *udata)
 {
 	struct mlx4_ib_dev *dev = to_mdev(pd->device);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b06d3b1..4060461 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1085,6 +1085,7 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata);
 struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc);
 struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
+				  struct pid *owner,
 				  struct ib_udata *udata);
 int mlx5_ib_advise_mr(struct ib_pd *pd,
 		      enum ib_uverbs_advise_mr_advice advice,
@@ -1098,7 +1099,8 @@ int mlx5_ib_dealloc_mw(struct ib_mw *mw);
 int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 		       int page_shift, int flags);
 struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
-					     int access_flags);
+					     int access_flags,
+					     struct pid *owner);
 void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *mr);
 int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			  u64 length, u64 virt_addr, int access_flags,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fd6ea1f7..6add486 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-
 #include <linux/kref.h>
 #include <linux/random.h>
 #include <linux/debugfs.h>
@@ -1313,6 +1312,7 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 
 struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
+				  struct pid *owner,
 				  struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 82cb6b7..77e678e 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -904,7 +904,8 @@ static struct ib_mr *mthca_get_dma_mr(struct ib_pd *pd, int acc)
 }
 
 static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-				       u64 virt, int acc, struct ib_udata *udata)
+				       u64 virt, int acc, struct pid *owner,
+				       struct ib_udata *udata)
 {
 	struct mthca_dev *dev = to_mdev(pd->device);
 	struct scatterlist *sg;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 4e7f08e..e07cb02 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2097,7 +2097,7 @@ static struct ib_mr *nes_get_dma_mr(struct ib_pd *pd, int acc)
  * nes_reg_user_mr
  */
 static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
-		u64 virt, int acc, struct ib_udata *udata)
+		u64 virt, int acc, struct pid *owner, struct ib_udata *udata)
 {
 	u64 iova_start;
 	__le64 *pbl;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 287c332..01d076a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -900,7 +900,8 @@ static void build_user_pbes(struct ocrdma_dev *dev, struct ocrdma_mr *mr,
 }
 
 struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
-				 u64 usr_addr, int acc, struct ib_udata *udata)
+				 u64 usr_addr, int acc, struct pid *owner,
+				 struct ib_udata *udata)
 {
 	int status = -ENOMEM;
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index b69cfdce..75ea82f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -106,7 +106,8 @@ int ocrdma_post_srq_recv(struct ib_srq *, const struct ib_recv_wr *,
 int ocrdma_dereg_mr(struct ib_mr *);
 struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *, int acc);
 struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *, u64 start, u64 length,
-				 u64 virt, int acc, struct ib_udata *);
+				 u64 virt, int acc, struct pid *owner,
+				 struct ib_udata *);
 struct ib_mr *ocrdma_alloc_mr(struct ib_pd *pd,
 			      enum ib_mr_type mr_type,
 			      u32 max_num_sg);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 1d4abef..2c8fe13 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -638,6 +638,7 @@ int usnic_ib_destroy_cq(struct ib_cq *cq)
 
 struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 					u64 virt_addr, int access_flags,
+					struct pid *owner,
 					struct ib_udata *udata)
 {
 	struct usnic_ib_mr *mr;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index e331442..4eb42c9 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -68,6 +68,7 @@ struct ib_cq *usnic_ib_create_cq(struct ib_device *ibdev,
 int usnic_ib_destroy_cq(struct ib_cq *cq);
 struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 				u64 virt_addr, int access_flags,
+				struct pid *owner,
 				struct ib_udata *udata);
 int usnic_ib_dereg_mr(struct ib_mr *ibmr);
 struct ib_ucontext *usnic_ib_alloc_ucontext(struct ib_device *ibdev,
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 49c9541..2bc95c9 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -377,6 +377,7 @@ struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc)
  */
 struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			      u64 virt_addr, int mr_access_flags,
+			      struct pid *owner,
 			      struct ib_udata *udata)
 {
 	struct rvt_mr *mr;
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index 132800e..8e6add0 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -77,6 +77,7 @@ void rvt_mr_exit(struct rvt_dev_info *rdi);
 struct ib_mr *rvt_get_dma_mr(struct ib_pd *pd, int acc);
 struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			      u64 virt_addr, int mr_access_flags,
+			      struct pid *owner,
 			      struct ib_udata *udata);
 int rvt_dereg_mr(struct ib_mr *ibmr);
 struct ib_mr *rvt_alloc_mr(struct ib_pd *pd,
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index b20e6e0..188e038 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -982,7 +982,9 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
 				     u64 start,
 				     u64 length,
 				     u64 iova,
-				     int access, struct ib_udata *udata)
+				     int access,
+				     struct pid *owner,
+				     struct ib_udata *udata)
 {
 	int err;
 	struct rxe_dev *rxe = to_rdev(ibpd->device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a3ceed3..3432404 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2408,6 +2408,7 @@ struct ib_device_ops {
 	struct ib_mr *(*get_dma_mr)(struct ib_pd *pd, int mr_access_flags);
 	struct ib_mr *(*reg_user_mr)(struct ib_pd *pd, u64 start, u64 length,
 				     u64 virt_addr, int mr_access_flags,
+				     struct pid *owner,
 				     struct ib_udata *udata);
 	int (*rereg_user_mr)(struct ib_mr *mr, int flags, u64 start, u64 length,
 			     u64 virt_addr, int mr_access_flags,
-- 
2.7.4
