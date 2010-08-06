From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 01/10]  pre-reserve MPTs for FC
Date: Fri, 06 Aug 2010 15:49:42 -0700
Message-ID: <4C5C9186.7030704@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030306050507020605090800"
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
--------------030306050507020605090800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date: Sun, 16 Nov 2008 10:25:59 +0200
Subject: [PATCH] mlx4: Fibre Channel support

As we did with QPs, some of the MPTs are pre-reserved
(the MPTs that are mapped for FEXCHs, 2*64K of them).
So needed to split the operation of allocating an MPT to two:
        The allocation of a bit from the bitmap
        The actual creation of the entry (and it's MTT).
So, mr_alloc_reserved() is the second part, where you know which MPT 
number was allocated.
mr_alloc() is the one that allocates a number from the bitmap.
Normal users keep using the original mr_alloc().
For FEXCH, when we know the pre-reserved MPT entry, we call 
mr_alloc_reserved() directly.

Same with the mr_free() and corresponding mr_free_reserved().
The first will just put back the bit, the later will actually
destroy the entry, but will leave the bit set.

map_phys_fmr_fbo() is very much like the original map_phys_fmr()
 allows setting an FBO (First Byte Offset) for the MPT
 allows setting the data length for the MPT
 does not increase the higher bits of the key after every map.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/net/mlx4/main.c     |    4 +-
 drivers/net/mlx4/mr.c       |  128 
+++++++++++++++++++++++++++++++++++++-----
 include/linux/mlx4/device.h |   21 +++++++-
 include/linux/mlx4/qp.h     |   11 +++-
 4 files changed, 144 insertions(+), 20 deletions(-)



--------------030306050507020605090800
Content-Type: text/x-patch;
 name="mlx4_fc_0001_prereserve_mpt_for_fc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mlx4_fc_0001_prereserve_mpt_for_fc.patch"

From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date: Sun, 16 Nov 2008 10:25:59 +0200
Subject: [PATCH] mlx4: Fibre Channel support

As we did with QPs, some of the MPTs are pre-reserved
(the MPTs that are mapped for FEXCHs, 2*64K of them).
So needed to split the operation of allocating an MPT to two:
        The allocation of a bit from the bitmap
        The actual creation of the entry (and it's MTT).
So, mr_alloc_reserved() is the second part, where you know which MPT number was allocated.
mr_alloc() is the one that allocates a number from the bitmap.
Normal users keep using the original mr_alloc().
For FEXCH, when we know the pre-reserved MPT entry, we call mr_alloc_reserved() directly.

Same with the mr_free() and corresponding mr_free_reserved().
The first will just put back the bit, the later will actually
destroy the entry, but will leave the bit set.

map_phys_fmr_fbo() is very much like the original map_phys_fmr()
 allows setting an FBO (First Byte Offset) for the MPT
 allows setting the data length for the MPT
 does not increase the higher bits of the key after every map.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/net/mlx4/main.c     |    4 +-
 drivers/net/mlx4/mr.c       |  128 +++++++++++++++++++++++++++++++++++++-----
 include/linux/mlx4/device.h |   21 +++++++-
 include/linux/mlx4/qp.h     |   11 +++-
 4 files changed, 144 insertions(+), 20 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index e3e0d54..38fbf01 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -79,12 +79,12 @@ static char mlx4_version[] __devinitdata =
 	DRV_VERSION " (" DRV_RELDATE ")\n";
 
 static struct mlx4_profile default_profile = {
-	.num_qp		= 1 << 17,
+	.num_qp		= 1 << 18,
 	.num_srq	= 1 << 16,
 	.rdmarc_per_qp	= 1 << 4,
 	.num_cq		= 1 << 16,
 	.num_mcg	= 1 << 13,
-	.num_mpt	= 1 << 17,
+	.num_mpt	= 1 << 19,
 	.num_mtt	= 1 << 20,
 };
 
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 3dc69be..7185c17 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -52,7 +52,9 @@ struct mlx4_mpt_entry {
 	__be64 length;
 	__be32 lkey;
 	__be32 win_cnt;
-	u8	reserved1[3];
+	u8	reserved1;
+	u8	flags2;
+	u8	reserved2;
 	u8	mtt_rep;
 	__be64 mtt_seg;
 	__be32 mtt_sz;
@@ -71,6 +73,8 @@ struct mlx4_mpt_entry {
 #define MLX4_MPT_PD_FLAG_RAE	    (1 << 28)
 #define MLX4_MPT_PD_FLAG_EN_INV	    (3 << 24)
 
+#define MLX4_MPT_FLAG2_FBO_EN	     (1 <<  7)
+
 #define MLX4_MPT_STATUS_SW		0xF0
 #define MLX4_MPT_STATUS_HW		0x00
 
@@ -263,6 +267,21 @@ static int mlx4_HW2SW_MPT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
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
@@ -274,14 +293,8 @@ int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
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
 
@@ -289,9 +302,8 @@ int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
 }
 EXPORT_SYMBOL_GPL(mlx4_mr_alloc);
 
-void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr)
+void mlx4_mr_free_reserved(struct mlx4_dev *dev, struct mlx4_mr *mr)
 {
-	struct mlx4_priv *priv = mlx4_priv(dev);
 	int err;
 
 	if (mr->enabled) {
@@ -303,6 +315,13 @@ void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr)
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
@@ -464,8 +483,16 @@ int mlx4_init_mr_table(struct mlx4_dev *dev)
 	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
 	int err;
 
+	if (!is_power_of_2(dev->caps.num_mpts))
+		return -EINVAL;
+
+	dev->caps.num_fexch_mpts =
+		2 * dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_EXCH];
+	dev->caps.reserved_fexch_mpts_base = dev->caps.num_mpts -
+		dev->caps.num_fexch_mpts;
 	err = mlx4_bitmap_init(&mr_table->mpt_bitmap, dev->caps.num_mpts,
-			       ~0, dev->caps.reserved_mrws, 0);
+			       ~0, dev->caps.reserved_mrws,
+			       dev->caps.reserved_fexch_mpts_base);
 	if (err)
 		return err;
 
@@ -529,8 +556,9 @@ static inline int mlx4_check_fmr(struct mlx4_fmr *fmr, u64 *page_list,
 	return 0;
 }
 
-int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list,
-		      int npages, u64 iova, u32 *lkey, u32 *rkey)
+int mlx4_map_phys_fmr_fbo(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
+			  u64 *page_list, int npages, u64 iova, u32 fbo,
+			  u32 len, u32 *lkey, u32 *rkey, int same_key)
 {
 	u32 key;
 	int i, err;
@@ -542,7 +570,8 @@ int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list
 	++fmr->maps;
 
 	key = key_to_hw_index(fmr->mr.key);
-	key += dev->caps.num_mpts;
+	if (!same_key)
+		key += dev->caps.num_mpts;
 	*lkey = *rkey = fmr->mr.key = hw_index_to_key(key);
 
 	*(u8 *) fmr->mpt = MLX4_MPT_STATUS_SW;
@@ -561,8 +590,10 @@ int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list
 
 	fmr->mpt->key    = cpu_to_be32(key);
 	fmr->mpt->lkey   = cpu_to_be32(key);
-	fmr->mpt->length = cpu_to_be64(npages * (1ull << fmr->page_shift));
+	fmr->mpt->length = cpu_to_be64(len);
 	fmr->mpt->start  = cpu_to_be64(iova);
+	fmr->mpt->first_byte_offset = cpu_to_be32(fbo & 0x001fffff);
+	fmr->mpt->flags2 = (fbo ? MLX4_MPT_FLAG2_FBO_EN : 0);
 
 	/* Make MTT entries are visible before setting MPT status */
 	wmb();
@@ -574,6 +605,16 @@ int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mlx4_map_phys_fmr_fbo);
+
+int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list,
+		      int npages, u64 iova, u32 *lkey, u32 *rkey)
+{
+	u32 len = npages * (1ull << fmr->page_shift);
+
+	return mlx4_map_phys_fmr_fbo(dev, fmr, page_list, npages, iova, 0,
+				     len, lkey, rkey, 0);
+}
 EXPORT_SYMBOL_GPL(mlx4_map_phys_fmr);
 
 int mlx4_fmr_alloc(struct mlx4_dev *dev, u32 pd, u32 access, int max_pages,
@@ -618,6 +659,49 @@ err_free:
 }
 EXPORT_SYMBOL_GPL(mlx4_fmr_alloc);
 
+int mlx4_fmr_alloc_reserved(struct mlx4_dev *dev, u32 mridx,
+			    u32 pd, u32 access, int max_pages,
+			    int max_maps, u8 page_shift, struct mlx4_fmr *fmr)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	u64 mtt_seg;
+	int err = -ENOMEM;
+
+	if (page_shift < (ffs(dev->caps.page_size_cap) - 1) || page_shift >= 32)
+		return -EINVAL;
+
+	/* All MTTs must fit in the same page */
+	if (max_pages * sizeof *fmr->mtts > PAGE_SIZE)
+		return -EINVAL;
+
+	fmr->page_shift = page_shift;
+	fmr->max_pages  = max_pages;
+	fmr->max_maps   = max_maps;
+	fmr->maps = 0;
+
+	err = mlx4_mr_alloc_reserved(dev, mridx, pd, 0, 0, access, max_pages,
+				     page_shift, &fmr->mr);
+	if (err)
+		return err;
+
+	mtt_seg = fmr->mr.mtt.first_seg * dev->caps.mtt_entry_sz;
+
+	fmr->mtts = mlx4_table_find(&priv->mr_table.mtt_table,
+				    fmr->mr.mtt.first_seg,
+				    &fmr->dma_handle);
+	if (!fmr->mtts) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	return 0;
+
+err_free:
+	mlx4_mr_free_reserved(dev, &fmr->mr);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_fmr_alloc_reserved);
+
 int mlx4_fmr_enable(struct mlx4_dev *dev, struct mlx4_fmr *fmr)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -660,6 +744,18 @@ int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr)
 }
 EXPORT_SYMBOL_GPL(mlx4_fmr_free);
 
+int mlx4_fmr_free_reserved(struct mlx4_dev *dev, struct mlx4_fmr *fmr)
+{
+	if (fmr->maps)
+		return -EBUSY;
+
+	fmr->mr.enabled = 0;
+	mlx4_mr_free_reserved(dev, &fmr->mr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_fmr_free_reserved);
+
 int mlx4_SYNC_TPT(struct mlx4_dev *dev)
 {
 	return mlx4_cmd(dev, 0, 0, 0, MLX4_CMD_SYNC_TPT, 1000);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 7a7f9c1..aa8fa93 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -424,8 +432,12 @@ int mlx4_mtt_init(struct mlx4_dev *dev, int npages, int page_shift,
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
@@ -471,13 +483,20 @@ void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int index);
 int mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan, int *index);
 void mlx4_unregister_vlan(struct mlx4_dev *dev, u8 port, int index);
 
+int mlx4_map_phys_fmr_fbo(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
+			  u64 *page_list, int npages, u64 iova, u32 fbo,
+			  u32 len, u32 *lkey, u32 *rkey, int same_key);
 int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list,
 		      int npages, u64 iova, u32 *lkey, u32 *rkey);
+int mlx4_fmr_alloc_reserved(struct mlx4_dev *dev, u32 mridx, u32 pd,
+			    u32 access, int max_pages, int max_maps,
+			    u8 page_shift, struct mlx4_fmr *fmr);
 int mlx4_fmr_alloc(struct mlx4_dev *dev, u32 pd, u32 access, int max_pages,
 		   int max_maps, u8 page_shift, struct mlx4_fmr *fmr);
 int mlx4_fmr_enable(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 void mlx4_fmr_unmap(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
 		    u32 *lkey, u32 *rkey);
+int mlx4_fmr_free_reserved(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_SYNC_TPT(struct mlx4_dev *dev);
 
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 7abe643..1b98814 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -151,7 +151,16 @@ struct mlx4_qp_context {
 	u8			reserved4[2];
 	u8			mtt_base_addr_h;
 	__be32			mtt_base_addr_l;
-	u32			reserved5[10];
+	u8			VE;
+	u8			reserved5;
+	__be16			VFT_id_prio;
+	u8			reserved6;
+	u8			exch_size;
+	__be16			exch_base;
+	u8			VFT_hop_cnt;
+	u8			my_fc_id_idx;
+	__be16			reserved7;
+	u32			reserved8[7];
 };
 
 /* Which firmware version adds support for NEC (NoErrorCompletion) bit */

--------------030306050507020605090800
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------030306050507020605090800--
