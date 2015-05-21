From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 11/11] IB/mlx4: Return hca core clock's offset in query_device vendor's data
Date: Thu, 21 May 2015 17:56:42 +0300
Message-ID: <1432220202-9834-12-git-send-email-ogerlitz@mellanox.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to read the HCA's core clock, the user-space needs to query
the correct offset in the mapped page. This offset is passed
through query_device's vendor specific data.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |   36 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   15 ++++++++++++++
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a5a90c4..84001cf 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -140,10 +140,27 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
 	int have_ib_ports;
+	struct mlx4_uverbs_ex_query_device cmd;
+	struct mlx4_uverbs_ex_query_device_resp resp = {.comp_mask = 0};
+	struct mlx4_clock_params clock_params;
 
-	if (uhw->inlen || uhw->outlen)
-		return -EINVAL;
+	if (uhw->inlen) {
+		if (uhw->inlen < sizeof(cmd))
+			return -EINVAL;
+
+		err = ib_copy_from_udata(&cmd, uhw, sizeof(cmd));
+		if (err)
+			return err;
+
+		if (cmd.comp_mask)
+			return -EINVAL;
+
+		if (cmd.reserved)
+			return -EINVAL;
+	}
 
+	resp.response_length = offsetof(typeof(resp), response_length) +
+		sizeof(resp.response_length);
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
 	if (!in_mad || !out_mad)
@@ -236,6 +253,21 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->hca_core_clock = dev->dev->caps.hca_core_clock;
 	props->timestamp_mask = 0xFFFFFFFFFFFFULL;
 
+	err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
+	if (err)
+		goto out;
+
+	if (uhw->outlen >= resp.response_length + sizeof(resp.hca_core_clock_offset)) {
+		resp.hca_core_clock_offset = clock_params.offset % PAGE_SIZE;
+		resp.response_length += sizeof(resp.hca_core_clock_offset);
+		resp.comp_mask |= QUERY_DEVICE_RESP_MASK_TIMESTAMP;
+	}
+
+	if (uhw->outlen) {
+		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
+		if (err)
+			goto out;
+	}
 out:
 	kfree(in_mad);
 	kfree(out_mad);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index ae04dad..8421e15 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -556,6 +556,21 @@ struct mlx4_ib_qp_tunnel_init_attr {
 	u8 port;
 };
 
+struct mlx4_uverbs_ex_query_device {
+	__u32 comp_mask;
+	__u32 reserved;
+};
+
+enum query_device_resp_mask {
+	QUERY_DEVICE_RESP_MASK_TIMESTAMP = 1UL << 0,
+};
+
+struct mlx4_uverbs_ex_query_device_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u64 hca_core_clock_offset;
+};
+
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
 {
 	return container_of(ibdev, struct mlx4_ib_dev, ib_dev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
