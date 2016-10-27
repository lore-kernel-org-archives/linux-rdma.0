From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 12/12] IB/mlx5: Limit mkey page size to 2GB
Date: Thu, 27 Oct 2016 16:36:47 +0300
Message-ID: <1477575407-20562-13-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The maximum page size in the mkey context is 2GB.

Until today, we didn't enforce this requirement in the code,
and therefore, if we got a page size larger than 2GB, we
have passed zeros in the log_page_shift instead of the actual value
and the registration failed.

This patch limits the driver to use compound pages of 2GB for mkeys.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c      | 4 ++--
 drivers/infiniband/hw/mlx5/mem.c     | 7 ++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 6 +++++-
 drivers/infiniband/hw/mlx5/mr.c      | 3 ++-
 drivers/infiniband/hw/mlx5/qp.c      | 4 ++--
 drivers/infiniband/hw/mlx5/srq.c     | 2 +-
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index fcd04b8..af4450c 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -770,7 +770,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	if (err)
 		goto err_umem;
 
-	mlx5_ib_cont_pages(cq->buf.umem, ucmd.buf_addr, &npages, &page_shift,
+	mlx5_ib_cont_pages(cq->buf.umem, ucmd.buf_addr, 0, &npages, &page_shift,
 			   &ncont, NULL);
 	mlx5_ib_dbg(dev, "addr 0x%llx, size %u, npages %d, page_shift %d, ncont %d\n",
 		    ucmd.buf_addr, entries * ucmd.cqe_size, npages, page_shift, ncont);
@@ -1124,7 +1124,7 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 		return err;
 	}
 
-	mlx5_ib_cont_pages(umem, ucmd.buf_addr, &npages, page_shift,
+	mlx5_ib_cont_pages(umem, ucmd.buf_addr, 0, &npages, page_shift,
 			   npas, NULL);
 
 	cq->resize_umem = umem;
diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
index 996b54e..6851357 100644
--- a/drivers/infiniband/hw/mlx5/mem.c
+++ b/drivers/infiniband/hw/mlx5/mem.c
@@ -37,12 +37,15 @@
 
 /* @umem: umem object to scan
  * @addr: ib virtual address requested by the user
+ * @max_page_shift: high limit for page_shift - 0 means no limit
  * @count: number of PAGE_SIZE pages covered by umem
  * @shift: page shift for the compound pages found in the region
  * @ncont: number of compund pages
  * @order: log2 of the number of compound pages
  */
-void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
+void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,
+			unsigned long max_page_shift,
+			int *count, int *shift,
 			int *ncont, int *order)
 {
 	unsigned long tmp;
@@ -72,6 +75,8 @@ void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
 	addr = addr >> page_shift;
 	tmp = (unsigned long)addr;
 	m = find_first_bit(&tmp, BITS_PER_LONG);
+	if (max_page_shift)
+		m = min_t(unsigned long, max_page_shift - page_shift, m);
 	skip = 1 << m;
 	mask = skip - 1;
 	i = 0;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7d68990..9a5fe63 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -63,6 +63,8 @@ pr_warn("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 #define MLX5_IB_DEFAULT_UIDX 0xffffff
 #define MLX5_USER_ASSIGNED_UIDX_MASK __mlx5_mask(qpc, user_index)
 
+#define MLX5_MKEY_PAGE_SHIFT_MASK __mlx5_mask(mkc, log_page_size)
+
 enum {
 	MLX5_IB_MMAP_CMD_SHIFT	= 8,
 	MLX5_IB_MMAP_CMD_MASK	= 0xff,
@@ -825,7 +827,9 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 		       struct ib_port_attr *props);
 int mlx5_ib_init_fmr(struct mlx5_ib_dev *dev);
 void mlx5_ib_cleanup_fmr(struct mlx5_ib_dev *dev);
-void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr, int *count, int *shift,
+void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,
+			unsigned long max_page_shift,
+			int *count, int *shift,
 			int *ncont, int *order);
 void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 			    int page_shift, size_t offset, size_t num_pages,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 55e2fee..d19cde5 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -856,7 +856,8 @@ static struct ib_umem *mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
 		return (void *)umem;
 	}
 
-	mlx5_ib_cont_pages(umem, start, npages, page_shift, ncont, order);
+	mlx5_ib_cont_pages(umem, start, MLX5_MKEY_PAGE_SHIFT_MASK, npages,
+			   page_shift, ncont, order);
 	if (!*npages) {
 		mlx5_ib_warn(dev, "avoid zero region\n");
 		ib_umem_release(umem);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9806868..1c5e618 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -675,7 +675,7 @@ static int mlx5_ib_umem_get(struct mlx5_ib_dev *dev,
 		return PTR_ERR(*umem);
 	}
 
-	mlx5_ib_cont_pages(*umem, addr, npages, page_shift, ncont, NULL);
+	mlx5_ib_cont_pages(*umem, addr, 0, npages, page_shift, ncont, NULL);
 
 	err = mlx5_ib_get_buf_offset(addr, *page_shift, offset);
 	if (err) {
@@ -728,7 +728,7 @@ static int create_user_rq(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		return err;
 	}
 
-	mlx5_ib_cont_pages(rwq->umem, ucmd->buf_addr, &npages, &page_shift,
+	mlx5_ib_cont_pages(rwq->umem, ucmd->buf_addr, 0, &npages, &page_shift,
 			   &ncont, NULL);
 	err = mlx5_ib_get_buf_offset(ucmd->buf_addr, page_shift,
 				     &rwq->rq_page_offset);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 3857dbd..f384db5 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -118,7 +118,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 		return err;
 	}
 
-	mlx5_ib_cont_pages(srq->umem, ucmd.buf_addr, &npages,
+	mlx5_ib_cont_pages(srq->umem, ucmd.buf_addr, 0, &npages,
 			   &page_shift, &ncont, NULL);
 	err = mlx5_ib_get_buf_offset(ucmd.buf_addr, page_shift,
 				     &offset);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
