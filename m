From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 04/10] remove default reservation of fexch qps and mpts
Date: Fri, 06 Aug 2010 15:50:31 -0700
Message-ID: <4C5C91B7.2050606@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000605040004070303090205"
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
--------------000605040004070303090205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

mlx4_core: removed reservation of FEXCH QPs and MPTs

mlx4_fc module will reserve them upon loading.
Added mpt reserve_range and release_range functions.

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/net/mlx4/main.c     |    4 +---
 drivers/net/mlx4/mr.c       |   29 +++++++++++++++++++++++------
 include/linux/mlx4/device.h |    7 ++-----
 3 files changed, 26 insertions(+), 14 deletions(-)


--------------000605040004070303090205
Content-Type: text/x-patch;
 name="mlx4_fc_0004_remove_fexch_reservation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mlx4_fc_0004_remove_fexch_reservation.patch"

mlx4_core: removed reservation of FEXCH QPs and MPTs

mlx4_fc module will reserve them upon loading.
Added mpt reserve_range and release_range functions.

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu Pham <vu-jyKWETY2nSZBDgjK7y7TUQ@public.gmane.org>

 drivers/net/mlx4/main.c     |    4 +---
 drivers/net/mlx4/mr.c       |   29 +++++++++++++++++++++++------
 include/linux/mlx4/device.h |    7 ++-----
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 38fbf01..bbf773d 100644
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
index 7185c17..5f07e0c 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -267,6 +267,28 @@ static int mlx4_HW2SW_MPT(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox
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
@@ -486,13 +508,8 @@ int mlx4_init_mr_table(struct mlx4_dev *dev)
 	if (!is_power_of_2(dev->caps.num_mpts))
 		return -EINVAL;
 
-	dev->caps.num_fexch_mpts =
-		2 * dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FC_EXCH];
-	dev->caps.reserved_fexch_mpts_base = dev->caps.num_mpts -
-		dev->caps.num_fexch_mpts;
 	err = mlx4_bitmap_init(&mr_table->mpt_bitmap, dev->caps.num_mpts,
-			       ~0, dev->caps.reserved_mrws,
-			       dev->caps.reserved_fexch_mpts_base);
+			       ~0, dev->caps.reserved_mrws, 0);
 	if (err)
 		return err;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 4664d1d..8afac02 100644
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
 #define MLX4_LEAST_ATTACHED_VECTOR	0xffffffff
 
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
@@ -426,6 +421,8 @@ int mlx4_mtt_init(struct mlx4_dev *dev, int npages, int page_shift,
 void mlx4_mtt_cleanup(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
 u64 mlx4_mtt_addr(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
 
+int mlx4_mr_reserve_range(struct mlx4_dev *dev, int cnt, int align, u32 *base_mridx);
+void mlx4_mr_release_range(struct mlx4_dev *dev, u32 base_mridx, int cnt);
 int mlx4_mr_alloc_reserved(struct mlx4_dev *dev, u32 mridx, u32 pd,
 			   u64 iova, u64 size, u32 access, int npages,
 			   int page_shift, struct mlx4_mr *mr);

--------------000605040004070303090205
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------000605040004070303090205--
