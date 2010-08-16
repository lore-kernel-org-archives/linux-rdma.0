From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 02/10] mlx4_core: Add mr_alloc_reserved to able
 create MPTs with pre-reserve range
Date: Mon, 16 Aug 2010 15:16:18 -0700
Message-ID: <4C69B8B2.40805@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070404090907050200000104"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070404090907050200000104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------070404090907050200000104
Content-Type: text/x-patch;
 name="0002-mlx4_core-Add-mr_alloc_reserved-to-able-create-MPTs-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-mlx4_core-Add-mr_alloc_reserved-to-able-create-MPTs-.pa";
 filename*1="tch"

>From 7c943349148dcbcb173814a9b6800ac2a2b12626 Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Tue, 10 Aug 2010 14:03:53 -0700
Subject: [PATCH 02/10] mlx4_core: Add mr_alloc_reserved to able create MPTs with pre-reserve range

As we did with QPs, range of the MPTs are pre-reserved
(the MPTs that are mapped for FEXCHs, 2*64K of them).

We need to split the operation of allocating an MPT to two:
    . The allocation of a bit from the bitmap
    . The actual creation of the entry (and it's MTT).

So, mr_alloc_reserved() is the second part, where you know which MPT
number was allocated. mr_alloc() is the one that allocates a number
from the bitmap.

Normal users keep using the original mr_alloc().
For FEXCH, when we know the pre-reserved MPT entry, we call
mr_alloc_reserved() directly.

Same with the mr_free() and corresponding mr_free_reserved().
The first will just put back the bit, the later will actually
destroy the entry, but will leave the bit set.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/mr.c       |   35 +++++++++++++++++++++++++----------
 include/linux/mlx4/device.h |    4 ++++
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 9c188bd..35c0af6 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -263,6 +263,21 @@ static int mlx4_HW2SW_MPT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
 			    !mailbox, MLX4_CMD_HW2SW_MPT, MLX4_CMD_TIME_CLASS_B);
 }
 
+int mlx4_mr_alloc_reserved(struct mlx4_dev *dev, u32 mridx, u32 pd,
+			   u64 iova, u64 size, u32 access, int npages,
+			   int page_shift, struct mlx4_mr *mr)
+{
+	mr->iova       = iova;
+	mr->size       = size;
+	mr->pd	       = pd;
+	mr->access     = access;
+	mr->enabled    = 0;
+	mr->key	       = hw_index_to_key(mridx);
+
+	return mlx4_mtt_init(dev, npages, page_shift, &mr->mtt);
+}
+EXPORT_SYMBOL_GPL(mlx4_mr_alloc_reserved);
+
 int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
 		  int npages, int page_shift, struct mlx4_mr *mr)
 {
@@ -274,14 +289,8 @@ int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
 	if (index == -1)
 		return -ENOMEM;
 
-	mr->iova       = iova;
-	mr->size       = size;
-	mr->pd	       = pd;
-	mr->access     = access;
-	mr->enabled    = 0;
-	mr->key	       = hw_index_to_key(index);
-
-	err = mlx4_mtt_init(dev, npages, page_shift, &mr->mtt);
+	err = mlx4_mr_alloc_reserved(dev, index, pd, iova, size,
+				     access, npages, page_shift, mr);
 	if (err)
 		mlx4_bitmap_free(&priv->mr_table.mpt_bitmap, index);
 
@@ -289,9 +298,8 @@ int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
 }
 EXPORT_SYMBOL_GPL(mlx4_mr_alloc);
 
-void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr)
+void mlx4_mr_free_reserved(struct mlx4_dev *dev, struct mlx4_mr *mr)
 {
-	struct mlx4_priv *priv = mlx4_priv(dev);
 	int err;
 
 	if (mr->enabled) {
@@ -303,6 +311,13 @@ void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr)
 	}
 
 	mlx4_mtt_cleanup(dev, &mr->mtt);
+}
+EXPORT_SYMBOL_GPL(mlx4_mr_free_reserved);
+
+void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	mlx4_mr_free_reserved(dev, mr);
 	mlx4_bitmap_free(&priv->mr_table.mpt_bitmap, key_to_hw_index(mr->key));
 }
 EXPORT_SYMBOL_GPL(mlx4_mr_free);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 7a7f9c1..66849cf 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -424,8 +424,12 @@ int mlx4_mtt_init(struct mlx4_dev *dev, int npages, int page_shift,
 void mlx4_mtt_cleanup(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
 u64 mlx4_mtt_addr(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
 
+int mlx4_mr_alloc_reserved(struct mlx4_dev *dev, u32 mridx, u32 pd,
+			   u64 iova, u64 size, u32 access, int npages,
+			   int page_shift, struct mlx4_mr *mr);
 int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
 		  int npages, int page_shift, struct mlx4_mr *mr);
+void mlx4_mr_free_reserved(struct mlx4_dev *dev, struct mlx4_mr *mr);
 void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr);
 int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr);
 int mlx4_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
-- 
1.6.3.3


--------------070404090907050200000104
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------070404090907050200000104--
