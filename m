From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 04/10] mlx4_core: Add interface to allocate fmr
 with pre-reserved MPTs
Date: Mon, 16 Aug 2010 15:16:27 -0700
Message-ID: <4C69B8BB.4000407@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060608050207040003050107"
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
--------------060608050207040003050107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------060608050207040003050107
Content-Type: text/x-patch;
 name="0004-mlx4_core-Add-interface-to-allocate-fmr-with-pre-res.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0004-mlx4_core-Add-interface-to-allocate-fmr-with-pre-res.pa";
 filename*1="tch"

>From 9652f29170c7daabf2e9a62acb848a05dc71db9a Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Tue, 10 Aug 2010 14:16:50 -0700
Subject: [PATCH 04/10] mlx4_core: Add interface to allocate fmr with pre-reserved MPTs

As we did with MRs, the fmr_alloc() will call mr_alloc() to allocate
bitmap and create MPTs entry. fmr_alloc_reserver will call mr_alloc_reserve()
to create MPTs entry with pre-reserved range

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/mr.c       |   55 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mlx4/device.h |    4 +++
 2 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index ba0514d..67d858f 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -655,6 +655,49 @@ err_free:
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
@@ -697,6 +740,18 @@ int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr)
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
index da8ab85..3960033 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -474,11 +474,15 @@ void mlx4_unregister_vlan(struct mlx4_dev *dev, u8 port, int index);
 
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
 
-- 
1.6.3.3


--------------060608050207040003050107
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------060608050207040003050107--
