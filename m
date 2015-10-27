From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 1/2] mlx4: Expose correct max_sge_rd limit
Date: Tue, 27 Oct 2015 11:40:45 +0200
Message-ID: <1445938846-9240-2-git-send-email-sagig@mellanox.com>
References: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

mlx4 devices (ConnectX-2, ConnectX-3) can not issue
max_sge in a single RDMA_READ request (resulting in
a completion error). Thus, expose lower max_sge_rd
to avoid this issue.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx4/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 3889723..46305dc 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -499,7 +499,8 @@ static int mlx4_ib_init_device_flags(struct ib_device *ibdev)
 	ibdev->max_qp_wr	   = dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE;
 	ibdev->max_sge		   = min(dev->dev->caps.max_sq_sg,
 					 dev->dev->caps.max_rq_sg);
-	ibdev->max_sge_rd	   = ibdev->max_sge;
+	/* reserve 2 sge slots for rdma reads */
+	ibdev->max_sge_rd	   = ibdev->max_sge - 2;
 	ibdev->max_cq		   = dev->dev->quotas.cq;
 	ibdev->max_cqe		   = dev->dev->caps.max_cqes;
 	ibdev->max_mr		   = dev->dev->quotas.mpt;
-- 
1.7.1
