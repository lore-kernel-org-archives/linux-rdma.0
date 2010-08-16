From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 07/10] mlx4_core: Enable T11 support bit in mlx4
	device
Date: Mon, 16 Aug 2010 15:16:44 -0700
Message-ID: <4C69B8CC.3070505@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070908070605000002040409"
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
--------------070908070605000002040409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------070908070605000002040409
Content-Type: text/x-patch;
 name="0007-mlx4_core-Enable-T11-support-bit-in-mlx4-device.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0007-mlx4_core-Enable-T11-support-bit-in-mlx4-device.patch"

>From 85efcd1d8e1fae3bd5293d923eaf1aa50d54cbce Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Fri, 13 Aug 2010 10:01:31 -0700
Subject: [PATCH 07/10] mlx4_core: Enable T11 support bit in mlx4 device

Enable T11 support bit in mlx4 device
Add bool parameter to enable/disable pre_t11 support
Add inteface to query the mode

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Vu pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/fw.c       |   13 +++++++++++++
 include/linux/mlx4/device.h |    5 ++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 04f42ae..20bee0f 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -51,6 +51,10 @@ static int enable_qos;
 module_param(enable_qos, bool, 0444);
 MODULE_PARM_DESC(enable_qos, "Enable Quality of Service support in the HCA (default: off)");
 
+static int mlx4_pre_t11;
+module_param_named(pre_t11_mode, mlx4_pre_t11, bool, 0644);
+MODULE_PARM_DESC(pre_t11_mode, "For FCoXX, enable pre-t11 mode (default: off)");
+
 #define MLX4_GET(dest, source, offset)				      \
 	do {							      \
 		void *__p = (char *) (source) + (offset);	      \
@@ -792,6 +796,8 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 
 	MLX4_PUT(inbox, (u8) (PAGE_SHIFT - 12), INIT_HCA_UAR_PAGE_SZ_OFFSET);
 	MLX4_PUT(inbox, param->log_uar_sz,      INIT_HCA_LOG_UAR_SZ_OFFSET);
+	if (!mlx4_pre_t11 && dev->caps.flags & (u32) MLX4_DEV_CAP_FLAG_FC_T11)
+		*(inbox + INIT_HCA_FLAGS_OFFSET / 4) |= cpu_to_be32(1 << 10);
 
 	err = mlx4_cmd(dev, mailbox->dma, 0, 0, MLX4_CMD_INIT_HCA, 10000);
 
@@ -890,3 +896,10 @@ int mlx4_NOP(struct mlx4_dev *dev)
 	/* Input modifier of 0x1f means "finish as soon as possible." */
 	return mlx4_cmd(dev, 0, 0x1f, 0, MLX4_CMD_NOP, 100);
 }
+
+void mlx4_get_fc_t11_settings(struct mlx4_dev *dev, int *pre_t11, int *t11)
+{
+	*pre_t11 = mlx4_pre_t11;
+	*t11 = dev->caps.flags & MLX4_DEV_CAP_FLAG_FC_T11;
+}
+EXPORT_SYMBOL_GPL(mlx4_get_fc_t11_settings);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 8afac02..46966bb 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -67,7 +67,8 @@ enum {
 	MLX4_DEV_CAP_FLAG_ATOMIC	= 1 << 18,
 	MLX4_DEV_CAP_FLAG_RAW_MCAST	= 1 << 19,
 	MLX4_DEV_CAP_FLAG_UD_AV_PORT	= 1 << 20,
-	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1 << 21
+	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1 << 21,
+	MLX4_DEV_CAP_FLAG_FC_T11	= 1 << 31
 };
 
 enum {
@@ -491,4 +492,6 @@ int mlx4_fmr_free_reserved(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_SYNC_TPT(struct mlx4_dev *dev);
 
+void mlx4_get_fc_t11_settings(struct mlx4_dev *dev, int *pre_t11, int *t11);
+
 #endif /* MLX4_DEVICE_H */
-- 
1.6.3.3


--------------070908070605000002040409
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------070908070605000002040409--
