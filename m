From: Andi Shyti <andi@etezian.org>
Subject: [PATCH] mlx5: qp: variable may be used uninitialized
Date: Tue, 16 Jul 2013 15:35:01 +0200
Message-ID: <1373981701-15276-1-git-send-email-andi@etezian.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eli@mellanox.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, andi@etezian.org
List-Id: linux-rdma@vger.kernel.org

in the sq_overhead() function, if qp_typ is equal to IB_QPT_RC,
size will be used uninitialized.

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 16ac54c..045f8cd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -199,7 +199,7 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 
 static int sq_overhead(enum ib_qp_type qp_type)
 {
-	int size;
+	int size = 0;
 
 	switch (qp_type) {
 	case IB_QPT_XRC_INI:
-- 
1.8.3.2
