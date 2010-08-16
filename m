From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 03/10] mlx4_core: Add mr_reserve_range to
 pre-reserve a range of MPTs
Date: Mon, 16 Aug 2010 15:16:24 -0700
Message-ID: <4C69B8B8.7030800@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050804080408070504000401"
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
--------------050804080408070504000401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------050804080408070504000401
Content-Type: text/x-patch;
 name="0003-mlx4_core-Add-mr_reserve_range-to-pre-reserve-a-rang.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-mlx4_core-Add-mr_reserve_range-to-pre-reserve-a-rang.pa";
 filename*1="tch"

>From b570c5df5006119ac626d96551cc0a9935037e5f Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Tue, 10 Aug 2010 14:10:57 -0700
Subject: [PATCH 03/10] mlx4_core: Add mr_reserve_range to pre-reserve a range of MPTs

Add MPTs mr_reserve/free_range

Remove QPs and MPTs static reservation for FC_EXCH by default.
mlx4_fc driver will reserve them upon loading

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/main.c     |    4 +---
 drivers/net/mlx4/mr.c       |   22 ++++++++++++++++++++++
 include/linux/mlx4/device.h |    7 ++-----
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index fe3be88..fbe646a 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -259,12 +259,10 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		(1 << dev->caps.log_num_vlans) *
 		(1 << dev->caps.log_num_prios) *
 		dev->caps.num_ports;
-	dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_EXCH] = MLX4_NUM_FEXCH;
 
 	dev->caps.reserved_qps = dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW] +
 		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_ETH_ADDR] +
-		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_ADDR] +
-		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_EXCH];
+		dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_ADDR];
 
 	return 0;
 }
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index 35c0af6..ba0514d 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -263,6 +263,28 @@ static int mlx4_HW2SW_MPT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
 			    !mailbox, MLX4_CMD_HW2SW_MPT, MLX4_CMD_TIME_CLASS_B);
 }
 
+int mlx4_mr_reserve_range(struct mlx4_dev *dev, int cnt, int align, u32 *base_mridx)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	u32 mridx;
+
+	mridx = mlx4_bitmap_alloc_range(&priv->mr_table.mpt_bitmap, cnt, align);
+	if (mridx == -1)
+		return -ENOMEM;
+
+	*base_mridx = mridx;
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(mlx4_mr_reserve_range);
+
+void mlx4_mr_release_range(struct mlx4_dev *dev, u32 base_mridx, int cnt)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+	mlx4_bitmap_free_range(&priv->mr_table.mpt_bitmap, base_mridx, cnt);
+}
+EXPORT_SYMBOL_GPL(mlx4_mr_release_range);
+
 int mlx4_mr_alloc_reserved(struct mlx4_dev *dev, u32 mridx, u32 pd,
 			   u64 iova, u64 size, u32 access, int npages,
 			   int page_shift, struct mlx4_mr *mr)
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 66849cf..da8ab85 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -151,7 +151,6 @@ enum mlx4_qp_region {
 	MLX4_QP_REGION_FW = 0,
 	MLX4_QP_REGION_ETH_ADDR,
 	MLX4_QP_REGION_FC_ADDR,
-	MLX4_QP_REGION_FC_EXCH,
 	MLX4_NUM_QP_REGION
 };
 
@@ -167,10 +166,6 @@ enum mlx4_special_vlan_idx {
 	MLX4_VLAN_REGULAR
 };
 
-enum {
-	MLX4_NUM_FEXCH          = 64 * 1024,
-};
-
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 {
 	return (major << 32) | (minor << 16) | subminor;
@@ -424,6 +419,8 @@ int mlx4_mtt_init(struct mlx4_dev *dev, int npages, int page_shift,
 void mlx4_mtt_cleanup(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
 u64 mlx4_mtt_addr(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
 
+int mlx4_mr_reserve_range(struct mlx4_dev *dev, int cnt, int align, u32 *base_mridx);
+void mlx4_mr_release_range(struct mlx4_dev *dev, u32 base_mridx, int cnt);
 int mlx4_mr_alloc_reserved(struct mlx4_dev *dev, u32 mridx, u32 pd,
 			   u64 iova, u64 size, u32 access, int npages,
 			   int page_shift, struct mlx4_mr *mr);
-- 
1.6.3.3


--------------050804080408070504000401
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------050804080408070504000401--
