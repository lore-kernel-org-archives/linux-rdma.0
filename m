From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V3 1/4] mlx4, mlx5, mthca: Expose max_sge_rd correctly
Date: Wed, 01 Jul 2015 11:30:42 -0500
Message-ID: <20150701163042.6501.86759.stgit@build.ogc.int>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150701162936.6501.45512.stgit@build.ogc.int>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: roid@mellanox.com, linux-rdma@vger.kernel.org, sagig@mellanox.com, infinipath@intel.com, target-devel@vger.kernel.org, eli@mellanox.com, ogerlitz@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

Applications must not assume that max_sge and max_sge_rd are the same,
Hence expose max_sge_rd correctly as well.

Reported-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx4/main.c            |    1 +
 drivers/infiniband/hw/mlx5/main.c            |    1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 166da78..81c342f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -229,6 +229,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_qp_wr	   = dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE;
 	props->max_sge		   = min(dev->dev->caps.max_sq_sg,
 					 dev->dev->caps.max_rq_sg);
+	props->max_sge_rd = props->max_sge;
 	props->max_cq		   = dev->dev->quotas.cq;
 	props->max_cqe		   = dev->dev->caps.max_cqes;
 	props->max_mr		   = dev->dev->quotas.mpt;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c6cb26e..a2bcd96 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -137,6 +137,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	max_sq_sg = (gen->max_sq_desc_sz - sizeof(struct mlx5_wqe_ctrl_seg)) /
 		sizeof(struct mlx5_wqe_data_seg);
 	props->max_sge = min(max_rq_sg, max_sq_sg);
+	props->max_sge_rd = props->max_sge;
 	props->max_cq		   = 1 << gen->log_max_cq;
 	props->max_cqe		   = gen->max_cqes - 1;
 	props->max_mr		   = 1 << gen->log_max_mkey;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 93ae51d..dc2d48c 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -97,6 +97,7 @@ static int mthca_query_device(struct ib_device *ibdev, struct ib_device_attr *pr
 	props->max_qp              = mdev->limits.num_qps - mdev->limits.reserved_qps;
 	props->max_qp_wr           = mdev->limits.max_wqes;
 	props->max_sge             = mdev->limits.max_sg;
+	props->max_sge_rd          = props->max_sge;
 	props->max_cq              = mdev->limits.num_cqs - mdev->limits.reserved_cqs;
 	props->max_cqe             = mdev->limits.max_cqes;
 	props->max_mr              = mdev->limits.num_mpts - mdev->limits.reserved_mrws;
