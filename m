From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 03/12] Clean status reporting frmom mthca_main
Date: Thu, 7 Jul 2011 12:21:12 -0500
Message-ID: <20110707172112.GD10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_main.c |  188 ++++++++++--------------------
 1 files changed, 61 insertions(+), 127 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index f24b79b..e25e8cb 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -165,19 +165,14 @@ static int mthca_tune_pci(struct mthca_dev *mdev)
 static int mthca_dev_lim(struct mthca_dev *mdev, struct mthca_dev_lim *dev_lim)
 {
 	int err;
-	u8 status;
 
 	mdev->limits.mtt_seg_size = (1 << log_mtts_per_seg) * 8;
-	err = mthca_QUERY_DEV_LIM(mdev, dev_lim, &status);
+	err = mthca_QUERY_DEV_LIM(mdev, dev_lim);
 	if (err) {
-		mthca_err(mdev, "QUERY_DEV_LIM command failed, aborting.\n");
+		mthca_err(mdev, "QUERY_DEV_LIM command returned %d"
+				", aborting.\n", err);
 		return err;
 	}
-	if (status) {
-		mthca_err(mdev, "QUERY_DEV_LIM returned status 0x%02x, "
-			  "aborting.\n", status);
-		return -EINVAL;
-	}
 	if (dev_lim->min_page_sz > PAGE_SIZE) {
 		mthca_err(mdev, "HCA minimum page size of %d bigger than "
 			  "kernel PAGE_SIZE of %ld, aborting.\n",
@@ -293,49 +288,35 @@ static int mthca_dev_lim(struct mthca_dev *mdev, struct mthca_dev_lim *dev_lim)
 static int mthca_init_tavor(struct mthca_dev *mdev)
 {
 	s64 size;
-	u8 status;
 	int err;
 	struct mthca_dev_lim        dev_lim;
 	struct mthca_profile        profile;
 	struct mthca_init_hca_param init_hca;
 
-	err = mthca_SYS_EN(mdev, &status);
+	err = mthca_SYS_EN(mdev);
 	if (err) {
-		mthca_err(mdev, "SYS_EN command failed, aborting.\n");
+		mthca_err(mdev, "SYS_EN command returned %d"
+				", aborting.\n", err);
 		return err;
 	}
-	if (status) {
-		mthca_err(mdev, "SYS_EN returned status 0x%02x, "
-			  "aborting.\n", status);
-		return -EINVAL;
-	}
 
-	err = mthca_QUERY_FW(mdev, &status);
+	err = mthca_QUERY_FW(mdev);
 	if (err) {
-		mthca_err(mdev, "QUERY_FW command failed, aborting.\n");
-		goto err_disable;
-	}
-	if (status) {
-		mthca_err(mdev, "QUERY_FW returned status 0x%02x, "
-			  "aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "QUERY_FW command returned %d,"
+				" aborting.\n", err);
 		goto err_disable;
 	}
-	err = mthca_QUERY_DDR(mdev, &status);
+	err = mthca_QUERY_DDR(mdev);
 	if (err) {
-		mthca_err(mdev, "QUERY_DDR command failed, aborting.\n");
-		goto err_disable;
-	}
-	if (status) {
-		mthca_err(mdev, "QUERY_DDR returned status 0x%02x, "
-			  "aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "QUERY_DDR command returned %d,"
+				" aborting.\n", err);
 		goto err_disable;
 	}
 
 	err = mthca_dev_lim(mdev, &dev_lim);
 	if (err) {
-		mthca_err(mdev, "QUERY_DEV_LIM command failed, aborting.\n");
+		mthca_err(mdev, "QUERY_DEV_LIM command returned %d,"
+				" aborting.\n", err);
 		goto err_disable;
 	}
 
@@ -351,29 +332,23 @@ static int mthca_init_tavor(struct mthca_dev *mdev)
 		goto err_disable;
 	}
 
-	err = mthca_INIT_HCA(mdev, &init_hca, &status);
+	err = mthca_INIT_HCA(mdev, &init_hca);
 	if (err) {
-		mthca_err(mdev, "INIT_HCA command failed, aborting.\n");
-		goto err_disable;
-	}
-	if (status) {
-		mthca_err(mdev, "INIT_HCA returned status 0x%02x, "
-			  "aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "INIT_HCA command returned %d,"
+				" aborting.\n", err);
 		goto err_disable;
 	}
 
 	return 0;
 
 err_disable:
-	mthca_SYS_DIS(mdev, &status);
+	mthca_SYS_DIS(mdev);
 
 	return err;
 }
 
 static int mthca_load_fw(struct mthca_dev *mdev)
 {
-	u8 status;
 	int err;
 
 	/* FIXME: use HCA-attached memory for FW if present */
@@ -386,31 +361,23 @@ static int mthca_load_fw(struct mthca_dev *mdev)
 		return -ENOMEM;
 	}
 
-	err = mthca_MAP_FA(mdev, mdev->fw.arbel.fw_icm, &status);
+	err = mthca_MAP_FA(mdev, mdev->fw.arbel.fw_icm);
 	if (err) {
-		mthca_err(mdev, "MAP_FA command failed, aborting.\n");
-		goto err_free;
-	}
-	if (status) {
-		mthca_err(mdev, "MAP_FA returned status 0x%02x, aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "MAP_FA command returned %d,"
+				" aborting.\n", err);
 		goto err_free;
 	}
-	err = mthca_RUN_FW(mdev, &status);
+	err = mthca_RUN_FW(mdev);
 	if (err) {
-		mthca_err(mdev, "RUN_FW command failed, aborting.\n");
-		goto err_unmap_fa;
-	}
-	if (status) {
-		mthca_err(mdev, "RUN_FW returned status 0x%02x, aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "RUN_FW command returned %d,"
+				" aborting.\n", err);
 		goto err_unmap_fa;
 	}
 
 	return 0;
 
 err_unmap_fa:
-	mthca_UNMAP_FA(mdev, &status);
+	mthca_UNMAP_FA(mdev);
 
 err_free:
 	mthca_free_icm(mdev, mdev->fw.arbel.fw_icm, 0);
@@ -423,19 +390,14 @@ static int mthca_init_icm(struct mthca_dev *mdev,
 			  u64 icm_size)
 {
 	u64 aux_pages;
-	u8 status;
 	int err;
 
-	err = mthca_SET_ICM_SIZE(mdev, icm_size, &aux_pages, &status);
+	err = mthca_SET_ICM_SIZE(mdev, icm_size, &aux_pages);
 	if (err) {
-		mthca_err(mdev, "SET_ICM_SIZE command failed, aborting.\n");
+		mthca_err(mdev, "SET_ICM_SIZE command returned %d"
+				", aborting.\n", err);
 		return err;
 	}
-	if (status) {
-		mthca_err(mdev, "SET_ICM_SIZE returned status 0x%02x, "
-			  "aborting.\n", status);
-		return -EINVAL;
-	}
 
 	mthca_dbg(mdev, "%lld KB of HCA context requires %lld KB aux memory.\n",
 		  (unsigned long long) icm_size >> 10,
@@ -448,14 +410,10 @@ static int mthca_init_icm(struct mthca_dev *mdev,
 		return -ENOMEM;
 	}
 
-	err = mthca_MAP_ICM_AUX(mdev, mdev->fw.arbel.aux_icm, &status);
+	err = mthca_MAP_ICM_AUX(mdev, mdev->fw.arbel.aux_icm);
 	if (err) {
-		mthca_err(mdev, "MAP_ICM_AUX command failed, aborting.\n");
-		goto err_free_aux;
-	}
-	if (status) {
-		mthca_err(mdev, "MAP_ICM_AUX returned status 0x%02x, aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "MAP_ICM_AUX returned %d,"
+				" aborting.\n", err);
 		goto err_free_aux;
 	}
 
@@ -596,7 +554,7 @@ err_unmap_eq:
 	mthca_unmap_eq_icm(mdev);
 
 err_unmap_aux:
-	mthca_UNMAP_ICM_AUX(mdev, &status);
+	mthca_UNMAP_ICM_AUX(mdev);
 
 err_free_aux:
 	mthca_free_icm(mdev, mdev->fw.arbel.aux_icm, 0);
@@ -606,7 +564,6 @@ err_free_aux:
 
 static void mthca_free_icms(struct mthca_dev *mdev)
 {
-	u8 status;
 
 	mthca_free_icm_table(mdev, mdev->mcg_table.table);
 	if (mdev->mthca_flags & MTHCA_FLAG_SRQ)
@@ -619,7 +576,7 @@ static void mthca_free_icms(struct mthca_dev *mdev)
 	mthca_free_icm_table(mdev, mdev->mr_table.mtt_table);
 	mthca_unmap_eq_icm(mdev);
 
-	mthca_UNMAP_ICM_AUX(mdev, &status);
+	mthca_UNMAP_ICM_AUX(mdev);
 	mthca_free_icm(mdev, mdev->fw.arbel.aux_icm, 0);
 }
 
@@ -629,43 +586,35 @@ static int mthca_init_arbel(struct mthca_dev *mdev)
 	struct mthca_profile        profile;
 	struct mthca_init_hca_param init_hca;
 	s64 icm_size;
-	u8 status;
 	int err;
 
-	err = mthca_QUERY_FW(mdev, &status);
+	err = mthca_QUERY_FW(mdev);
 	if (err) {
-		mthca_err(mdev, "QUERY_FW command failed, aborting.\n");
+		mthca_err(mdev, "QUERY_FW command failed %d,"
+				" aborting.\n", err);
 		return err;
 	}
-	if (status) {
-		mthca_err(mdev, "QUERY_FW returned status 0x%02x, "
-			  "aborting.\n", status);
-		return -EINVAL;
-	}
 
-	err = mthca_ENABLE_LAM(mdev, &status);
-	if (err) {
-		mthca_err(mdev, "ENABLE_LAM command failed, aborting.\n");
-		return err;
-	}
-	if (status == MTHCA_CMD_STAT_LAM_NOT_PRE) {
-		mthca_dbg(mdev, "No HCA-attached memory (running in MemFree mode)\n");
+	err = mthca_ENABLE_LAM(mdev);
+	if (err == -EAGAIN) {
+		mthca_dbg(mdev, "No HCA-attached memory "
+				"(running in MemFree mode)\n");
 		mdev->mthca_flags |= MTHCA_FLAG_NO_LAM;
-	} else if (status) {
-		mthca_err(mdev, "ENABLE_LAM returned status 0x%02x, "
-			  "aborting.\n", status);
-		return -EINVAL;
+	} else if (err) {
+		mthca_err(mdev, "ENABLE_LAM returned %d, "
+			  "aborting.\n", err);
+		return err;
 	}
 
 	err = mthca_load_fw(mdev);
 	if (err) {
-		mthca_err(mdev, "Failed to start FW, aborting.\n");
+		mthca_err(mdev, "Loading FW returned %d, aborting.\n", err);
 		goto err_disable;
 	}
 
 	err = mthca_dev_lim(mdev, &dev_lim);
 	if (err) {
-		mthca_err(mdev, "QUERY_DEV_LIM command failed, aborting.\n");
+		mthca_err(mdev, "QUERY_DEV_LIM returned %d, aborting.\n", err);
 		goto err_stop_fw;
 	}
 
@@ -685,15 +634,10 @@ static int mthca_init_arbel(struct mthca_dev *mdev)
 	if (err)
 		goto err_stop_fw;
 
-	err = mthca_INIT_HCA(mdev, &init_hca, &status);
+	err = mthca_INIT_HCA(mdev, &init_hca);
 	if (err) {
-		mthca_err(mdev, "INIT_HCA command failed, aborting.\n");
-		goto err_free_icm;
-	}
-	if (status) {
-		mthca_err(mdev, "INIT_HCA returned status 0x%02x, "
-			  "aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "INIT_HCA command returned %d,"
+				" aborting.\n", err);
 		goto err_free_icm;
 	}
 
@@ -703,37 +647,34 @@ err_free_icm:
 	mthca_free_icms(mdev);
 
 err_stop_fw:
-	mthca_UNMAP_FA(mdev, &status);
+	mthca_UNMAP_FA(mdev);
 	mthca_free_icm(mdev, mdev->fw.arbel.fw_icm, 0);
 
 err_disable:
 	if (!(mdev->mthca_flags & MTHCA_FLAG_NO_LAM))
-		mthca_DISABLE_LAM(mdev, &status);
+		mthca_DISABLE_LAM(mdev);
 
 	return err;
 }
 
 static void mthca_close_hca(struct mthca_dev *mdev)
 {
-	u8 status;
-
-	mthca_CLOSE_HCA(mdev, 0, &status);
+	mthca_CLOSE_HCA(mdev, 0);
 
 	if (mthca_is_memfree(mdev)) {
 		mthca_free_icms(mdev);
 
-		mthca_UNMAP_FA(mdev, &status);
+		mthca_UNMAP_FA(mdev);
 		mthca_free_icm(mdev, mdev->fw.arbel.fw_icm, 0);
 
 		if (!(mdev->mthca_flags & MTHCA_FLAG_NO_LAM))
-			mthca_DISABLE_LAM(mdev, &status);
+			mthca_DISABLE_LAM(mdev);
 	} else
-		mthca_SYS_DIS(mdev, &status);
+		mthca_SYS_DIS(mdev);
 }
 
 static int mthca_init_hca(struct mthca_dev *mdev)
 {
-	u8 status;
 	int err;
 	struct mthca_adapter adapter;
 
@@ -745,15 +686,10 @@ static int mthca_init_hca(struct mthca_dev *mdev)
 	if (err)
 		return err;
 
-	err = mthca_QUERY_ADAPTER(mdev, &adapter, &status);
+	err = mthca_QUERY_ADAPTER(mdev, &adapter);
 	if (err) {
-		mthca_err(mdev, "QUERY_ADAPTER command failed, aborting.\n");
-		goto err_close;
-	}
-	if (status) {
-		mthca_err(mdev, "QUERY_ADAPTER returned status 0x%02x, "
-			  "aborting.\n", status);
-		err = -EINVAL;
+		mthca_err(mdev, "QUERY_ADAPTER command returned %d,"
+				" aborting.\n", err);
 		goto err_close;
 	}
 
@@ -772,7 +708,6 @@ err_close:
 static int mthca_setup_hca(struct mthca_dev *dev)
 {
 	int err;
-	u8 status;
 
 	MTHCA_INIT_DOORBELL_LOCK(&dev->doorbell_lock);
 
@@ -833,8 +768,8 @@ static int mthca_setup_hca(struct mthca_dev *dev)
 		goto err_eq_table_free;
 	}
 
-	err = mthca_NOP(dev, &status);
-	if (err || status) {
+	err = mthca_NOP(dev);
+	if (err) {
 		if (dev->mthca_flags & MTHCA_FLAG_MSI_X) {
 			mthca_warn(dev, "NOP command failed to generate interrupt "
 				   "(IRQ %d).\n",
@@ -1166,7 +1101,6 @@ err_disable_pdev:
 static void __mthca_remove_one(struct pci_dev *pdev)
 {
 	struct mthca_dev *mdev = pci_get_drvdata(pdev);
-	u8 status;
 	int p;
 
 	if (mdev) {
@@ -1174,7 +1108,7 @@ static void __mthca_remove_one(struct pci_dev *pdev)
 		mthca_unregister_device(mdev);
 
 		for (p = 1; p <= mdev->limits.num_ports; ++p)
-			mthca_CLOSE_IB(mdev, p, &status);
+			mthca_CLOSE_IB(mdev, p);
 
 		mthca_cleanup_mcg_table(mdev);
 		mthca_cleanup_av_table(mdev);
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
