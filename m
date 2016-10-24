From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] IB/mlx5: avoid bogus -Wmaybe-uninitialized warning
Date: Mon, 24 Oct 2016 22:48:21 +0200
Message-ID: <20161024204830.620592-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Noa Osherovich <noaos@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We get a false-positive warning in linux-next for the mlx5 driver:

infiniband/hw/mlx5/mr.c: In function ‘mlx5_ib_reg_user_mr’:
infiniband/hw/mlx5/mr.c:1172:5: error: ‘order’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
infiniband/hw/mlx5/mr.c:1161:6: note: ‘order’ was declared here
infiniband/hw/mlx5/mr.c:1173:6: error: ‘ncont’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
infiniband/hw/mlx5/mr.c:1160:6: note: ‘ncont’ was declared here
infiniband/hw/mlx5/mr.c:1173:6: error: ‘page_shift’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
infiniband/hw/mlx5/mr.c:1158:6: note: ‘page_shift’ was declared here
infiniband/hw/mlx5/mr.c:1143:13: error: ‘npages’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
infiniband/hw/mlx5/mr.c:1159:6: note: ‘npages’ was declared here

I had a trivial workaround for gcc-5 or higher, but that didn't work
on gcc-4.9 unfortunately.

The only way I found to avoid the warnings for gcc-4.9, short of
initializing each of the arguments first was to change the calling
conventions to separate the error code from the umem pointer. This
avoids casting the error codes from one pointer to another incompatible
pointer, and lets gcc figure out when that the data is actually valid
whenever we return successfully.

Acked-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/mlx5/mr.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

v2: fix whitespace typo

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d4ad672b905b..9ea74fca568a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -815,29 +815,33 @@ static void prep_umr_unreg_wqe(struct mlx5_ib_dev *dev,
 	umrwr->mkey = key;
 }
 
-static struct ib_umem *mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
-				   int access_flags, int *npages,
-				   int *page_shift, int *ncont, int *order)
+static int mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
+		       int access_flags, struct ib_umem **umem,
+		       int *npages, int *page_shift, int *ncont,
+		       int *order)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-	struct ib_umem *umem = ib_umem_get(pd->uobject->context, start, length,
-					   access_flags, 0);
-	if (IS_ERR(umem)) {
+	int err;
+
+	*umem = ib_umem_get(pd->uobject->context, start, length,
+			    access_flags, 0);
+	err = PTR_ERR_OR_ZERO(*umem);
+	if (err < 0) {
 		mlx5_ib_err(dev, "umem get failed (%ld)\n", PTR_ERR(umem));
-		return (void *)umem;
+		return err;
 	}
 
-	mlx5_ib_cont_pages(umem, start, npages, page_shift, ncont, order);
+	mlx5_ib_cont_pages(*umem, start, npages, page_shift, ncont, order);
 	if (!*npages) {
 		mlx5_ib_warn(dev, "avoid zero region\n");
-		ib_umem_release(umem);
-		return ERR_PTR(-EINVAL);
+		ib_umem_release(*umem);
+		return -EINVAL;
 	}
 
 	mlx5_ib_dbg(dev, "npages %d, ncont %d, order %d, page_shift %d\n",
 		    *npages, *ncont, *order, *page_shift);
 
-	return umem;
+	return 0;
 }
 
 static void mlx5_ib_umr_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -1163,11 +1167,11 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, virt_addr, length, access_flags);
-	umem = mr_umem_get(pd, start, length, access_flags, &npages,
+	err = mr_umem_get(pd, start, length, access_flags, &umem, &npages,
 			   &page_shift, &ncont, &order);
 
-	if (IS_ERR(umem))
-		return (void *)umem;
+        if (err < 0)
+		return ERR_PTR(err);
 
 	if (use_umr(order)) {
 		mr = reg_umr(pd, umem, virt_addr, length, ncont, page_shift,
@@ -1341,10 +1345,9 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		 */
 		flags |= IB_MR_REREG_TRANS;
 		ib_umem_release(mr->umem);
-		mr->umem = mr_umem_get(pd, addr, len, access_flags, &npages,
-				       &page_shift, &ncont, &order);
-		if (IS_ERR(mr->umem)) {
-			err = PTR_ERR(mr->umem);
+		err = mr_umem_get(pd, addr, len, access_flags, &mr->umem,
+				  &npages, &page_shift, &ncont, &order);
+		if (err < 0) {
 			mr->umem = NULL;
 			return err;
 		}
-- 
2.9.0
