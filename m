From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/12] IB/mlx5: Expose correct max_sge_rd limit
Date: Mon, 18 Apr 2016 16:14:12 -0400
Message-ID: <1461010463-6603-2-git-send-email-hch@lst.de>
References: <1461010463-6603-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461010463-6603-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

mlx5 devices (Connect-IB, ConnectX-4, ConnectX-4-LX) has a limitation
where rdma read work queue entries cannot exceed 512 bytes.
A rdma_read wqe needs to fit in 512 bytes:
- wqe control segment (16 bytes)
- rdma segment (16 bytes)
- scatter elements (16 bytes each)

So max_sge_rd should be: (512 - 16 - 16) / 16 = 30.

Reported-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Tested-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |  2 +-
 include/linux/mlx5/device.h       | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5acf346..049754f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -530,7 +530,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		     sizeof(struct mlx5_wqe_ctrl_seg)) /
 		     sizeof(struct mlx5_wqe_data_seg);
 	props->max_sge = min(max_rq_sg, max_sq_sg);
-	props->max_sge_rd = props->max_sge;
+	props->max_sge_rd	   = MLX5_MAX_SGE_RD;
 	props->max_cq		   = 1 << MLX5_CAP_GEN(mdev, log_max_cq);
 	props->max_cqe = (1 << MLX5_CAP_GEN(mdev, log_max_cq_sz)) - 1;
 	props->max_mr		   = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 8156e3c..b3575f3 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -392,6 +392,17 @@ enum {
 	MLX5_CAP_OFF_CMDIF_CSUM		= 46,
 };
 
+enum {
+	/*
+	 * Max wqe size for rdma read is 512 bytes, so this
+	 * limits our max_sge_rd as the wqe needs to fit:
+	 * - ctrl segment (16 bytes)
+	 * - rdma segment (16 bytes)
+	 * - scatter elements (16 bytes each)
+	 */
+	MLX5_MAX_SGE_RD	= (512 - 16 - 16) / 16
+};
+
 struct mlx5_inbox_hdr {
 	__be16		opcode;
 	u8		rsvd[4];
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
