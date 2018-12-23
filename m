From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 19/20] net/mlx4_core: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:57:14 +0100
Message-ID: <1545555435-24576-20-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Drop LIST_HEAD where the variable it declares has never
been used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: c82e9aa0a8bc ("mlx4_core: resource tracking for HCA resources used by guests")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 31bd56727022..eb13d3618162 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -4729,7 +4729,6 @@ static void rem_slave_srqs(struct mlx4_dev *dev, int slave)
 	struct res_srq *tmp;
 	int state;
 	u64 in_param;
-	LIST_HEAD(tlist);
 	int srqn;
 	int err;
 
@@ -4795,7 +4794,6 @@ static void rem_slave_cqs(struct mlx4_dev *dev, int slave)
 	struct res_cq *tmp;
 	int state;
 	u64 in_param;
-	LIST_HEAD(tlist);
 	int cqn;
 	int err;
 
@@ -4858,7 +4856,6 @@ static void rem_slave_mrs(struct mlx4_dev *dev, int slave)
 	struct res_mpt *tmp;
 	int state;
 	u64 in_param;
-	LIST_HEAD(tlist);
 	int mptn;
 	int err;
 
@@ -4926,7 +4923,6 @@ static void rem_slave_mtts(struct mlx4_dev *dev, int slave)
 	struct res_mtt *mtt;
 	struct res_mtt *tmp;
 	int state;
-	LIST_HEAD(tlist);
 	int base;
 	int err;
 
@@ -5115,7 +5111,6 @@ static void rem_slave_eqs(struct mlx4_dev *dev, int slave)
 	struct res_eq *tmp;
 	int err;
 	int state;
-	LIST_HEAD(tlist);
 	int eqn;
 
 	err = move_all_busy(dev, slave, RES_EQ);
