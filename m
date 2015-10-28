From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 1/2] mlx4: Expose correct max_sge_rd limit
Date: Wed, 28 Oct 2015 13:28:15 +0200
Message-ID: <1446031696-19022-2-git-send-email-sagig@mellanox.com>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

mlx4 devices (ConnectX-2, ConnectX-3) has a limitation
where rdma read work queue entries cannot exceed 512 bytes.
A rdma_read wqe needs to fit in 512 bytes:
- wqe control segment (16 bytes)
- rdma segment (16 bytes)
- scatter elements (16 bytes each)

So max_sge_rd should be: (512 - 16 - 16) / 16 = 30.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 include/linux/mlx4/device.h       |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7026580..e0232a2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -499,7 +499,7 @@ static int mlx4_ib_init_device_flags(struct ib_device *ibdev)
 	ibdev->max_qp_wr	   = dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE;
 	ibdev->max_sge		   = min(dev->dev->caps.max_sq_sg,
 					 dev->dev->caps.max_rq_sg);
-	ibdev->max_sge_rd	   = ibdev->max_sge;
+	ibdev->max_sge_rd	   = MLX4_MAX_SGE_RD;
 	ibdev->max_cq		   = dev->dev->quotas.cq;
 	ibdev->max_cqe		   = dev->dev->caps.max_cqes;
 	ibdev->max_mr		   = dev->dev->quotas.mpt;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index dac6872..3dcae41 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -427,6 +427,17 @@ enum {
 };
 
 enum {
+	/*
+	 * Max wqe size for rdma read is 512 bytes, so this
+	 * limits our max_sge_rd as the wqe needs to fit:
+	 * - ctrl segment (16 bytes)
+	 * - rdma segment (16 bytes)
+	 * - scatter elements (16 bytes each)
+	 */
+	MLX4_MAX_SGE_RD	= (512 - 16 - 16) / 16
+};
+
+enum {
 	MLX4_DEV_PMC_SUBTYPE_GUID_INFO	 = 0x14,
 	MLX4_DEV_PMC_SUBTYPE_PORT_INFO	 = 0x15,
 	MLX4_DEV_PMC_SUBTYPE_PKEY_TABLE	 = 0x16,
-- 
1.7.1
