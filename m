From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 05/10] mlx4_core: Map phys_fmr with first byte
	offset enabled
Date: Mon, 16 Aug 2010 15:16:31 -0700
Message-ID: <4C69B8BF.8020400@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040807060303080503080403"
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
--------------040807060303080503080403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------040807060303080503080403
Content-Type: text/x-patch;
 name="0005-mlx4_core-Map-phys_fmr-with-first-byte-offset-enable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0005-mlx4_core-Map-phys_fmr-with-first-byte-offset-enable.pa";
 filename*1="tch"

>From 1afc1f9cfe33444c26dc027556035c7c85a9a565 Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Tue, 10 Aug 2010 14:27:23 -0700
Subject: [PATCH 05/10] mlx4_core: Map phys_fmr with first byte offset enabled

map_phys_fmr_fbo() is very much like the original map_phys_fmr():
    . allows setting an FBO (First Byte Offset) for the MPT
    . allows setting the data length for the MPT
    . does not increase the higher bits of the key after every map.

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/mr.c       |   28 +++++++++++++++++++++++-----
 include/linux/mlx4/device.h |    3 +++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 67d858f..42527b5 100644
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
 
@@ -566,8 +570,9 @@ static inline int mlx4_check_fmr(struct mlx4_fmr *fmr, u64 *page_list,
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
@@ -579,7 +584,8 @@ int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list
 	++fmr->maps;
 
 	key = key_to_hw_index(fmr->mr.key);
-	key += dev->caps.num_mpts;
+	if (!same_key)
+		key += dev->caps.num_mpts;
 	*lkey = *rkey = fmr->mr.key = hw_index_to_key(key);
 
 	*(u8 *) fmr->mpt = MLX4_MPT_STATUS_SW;
@@ -598,8 +604,10 @@ int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list
 
 	fmr->mpt->key    = cpu_to_be32(key);
 	fmr->mpt->lkey   = cpu_to_be32(key);
-	fmr->mpt->length = cpu_to_be64(npages * (1ull << fmr->page_shift));
+	fmr->mpt->length = cpu_to_be64(len);
 	fmr->mpt->start  = cpu_to_be64(iova);
+	fmr->mpt->first_byte_offset = cpu_to_be32(fbo & 0x001fffff);
+	fmr->mpt->flags2 = (fbo ? MLX4_MPT_FLAG2_FBO_EN : 0);
 
 	/* Make MTT entries are visible before setting MPT status */
 	wmb();
@@ -611,6 +619,16 @@ int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list
 
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
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 3960033..ae09787 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -472,6 +472,9 @@ void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int index);
 int mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan, int *index);
 void mlx4_unregister_vlan(struct mlx4_dev *dev, u8 port, int index);
 
+int mlx4_map_phys_fmr_fbo(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
+			  u64 *page_list, int npages, u64 iova, u32 fbo,
+			  u32 len, u32 *lkey, u32 *rkey, int same_key);
 int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list,
 		      int npages, u64 iova, u32 *lkey, u32 *rkey);
 int mlx4_fmr_alloc_reserved(struct mlx4_dev *dev, u32 mridx, u32 pd,
-- 
1.6.3.3


--------------040807060303080503080403
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------040807060303080503080403--
