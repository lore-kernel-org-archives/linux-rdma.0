From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 12/14] IB/mlx5: Route MADs for dual port RoCE
Date: Thu,  4 Jan 2018 17:25:42 +0200
Message-ID: <20180104152544.28919-13-leon@kernel.org>
References: <20180104152544.28919-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104152544.28919-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Route performance query MADs to the correct mlx5_core_dev when using
dual port RoCE mode.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mad.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 0559e0a9e398..32a9e9228b13 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -197,10 +197,9 @@ static void pma_cnt_assign(struct ib_pma_portcounters *pma_cnt,
 			     vl_15_dropped);
 }
 
-static int process_pma_cmd(struct ib_device *ibdev, u8 port_num,
+static int process_pma_cmd(struct mlx5_core_dev *mdev, u8 port_num,
 			   const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	int err;
 	void *out_cnt;
 
@@ -222,7 +221,7 @@ static int process_pma_cmd(struct ib_device *ibdev, u8 port_num,
 		if (!out_cnt)
 			return IB_MAD_RESULT_FAILURE;
 
-		err = mlx5_core_query_vport_counter(dev->mdev, 0, 0,
+		err = mlx5_core_query_vport_counter(mdev, 0, 0,
 						    port_num, out_cnt, sz);
 		if (!err)
 			pma_cnt_ext_assign(pma_cnt_ext, out_cnt);
@@ -235,7 +234,7 @@ static int process_pma_cmd(struct ib_device *ibdev, u8 port_num,
 		if (!out_cnt)
 			return IB_MAD_RESULT_FAILURE;
 
-		err = mlx5_core_query_ib_ppcnt(dev->mdev, port_num,
+		err = mlx5_core_query_ib_ppcnt(mdev, port_num,
 					       out_cnt, sz);
 		if (!err)
 			pma_cnt_assign(pma_cnt, out_cnt);
@@ -255,9 +254,11 @@ int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			u16 *out_mad_pkey_index)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
+	struct mlx5_core_dev *mdev;
+	u8 mdev_port_num;
+	int ret;
 
 	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
 			 *out_mad_size != sizeof(*out_mad)))
@@ -265,14 +266,20 @@ int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 
 	memset(out_mad->data, 0, sizeof(out_mad->data));
 
+	mdev = mlx5_ib_get_native_port_mdev(dev, port_num, &mdev_port_num);
+	if (!mdev)
+		return IB_MAD_RESULT_FAILURE;
+
 	if (MLX5_CAP_GEN(mdev, vport_counters) &&
 	    in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT &&
 	    in_mad->mad_hdr.method == IB_MGMT_METHOD_GET) {
-		return process_pma_cmd(ibdev, port_num, in_mad, out_mad);
+		ret = process_pma_cmd(mdev, mdev_port_num, in_mad, out_mad);
 	} else {
-		return process_mad(ibdev, mad_flags, port_num, in_wc, in_grh,
+		ret =  process_mad(ibdev, mad_flags, port_num, in_wc, in_grh,
 				   in_mad, out_mad);
 	}
+	mlx5_ib_put_native_port_mdev(dev, port_num);
+	return ret;
 }
 
 int mlx5_query_ext_port_caps(struct mlx5_ib_dev *dev, u8 port)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
