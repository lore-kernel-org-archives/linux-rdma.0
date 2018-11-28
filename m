From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 04/11] net/mlx5: Remove references to local mlx5_core functions
Date: Wed, 28 Nov 2018 20:53:36 +0200
Message-ID: <20181128185343.21669-5-leon@kernel.org>
References: <20181128185343.21669-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128185343.21669-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

As a preparation to move SRQ functionality to RDMA, drop all references
to mlx5_core logic and make SRQ be dependent on shared code only.

Most of the time, we are interested to know if events are working/not
working and it is possible with previous commit ("net/mlx5: Debug print
for forwarded async events").

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/srq.c | 22 +++----------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index 248f1c8dd5d3..690815234838 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -10,15 +10,12 @@
 #include <linux/mlx5/srq.h>
 #include <rdma/ib_verbs.h>
 #include <linux/mlx5/transobj.h>
-#include "mlx5_core.h"
 
 static int srq_event_notifier(struct notifier_block *nb,
 			      unsigned long type, void *data)
 {
 	struct mlx5_srq_table *table;
-	struct mlx5_core_dev *dev;
 	struct mlx5_core_srq *srq;
-	struct mlx5_priv *priv;
 	struct mlx5_eqe *eqe;
 	u32 srqn;
 
@@ -27,12 +24,9 @@ static int srq_event_notifier(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	table = container_of(nb, struct mlx5_srq_table, nb);
-	priv  = container_of(table, struct mlx5_priv, srq_table);
-	dev   = container_of(priv, struct mlx5_core_dev, priv);
 
 	eqe = data;
 	srqn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
-	mlx5_core_dbg(dev, "SRQ event (%d): srqn 0x%x\n", eqe->type, srqn);
 
 	spin_lock(&table->lock);
 
@@ -42,10 +36,8 @@ static int srq_event_notifier(struct notifier_block *nb,
 
 	spin_unlock(&table->lock);
 
-	if (!srq) {
-		mlx5_core_warn(dev, "Async event for bogus SRQ 0x%08x\n", srqn);
+	if (!srq)
 		return NOTIFY_OK;
-	}
 
 	srq->event(srq, eqe->type);
 
@@ -617,10 +609,8 @@ int mlx5_core_create_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree, srq->srqn, srq);
 	spin_unlock_irq(&table->lock);
-	if (err) {
-		mlx5_core_warn(dev, "err %d, srqn 0x%x\n", err, srq->srqn);
+	if (err)
 		goto err_destroy_srq_split;
-	}
 
 	return 0;
 
@@ -640,14 +630,8 @@ int mlx5_core_destroy_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq)
 	spin_lock_irq(&table->lock);
 	tmp = radix_tree_delete(&table->tree, srq->srqn);
 	spin_unlock_irq(&table->lock);
-	if (!tmp) {
-		mlx5_core_warn(dev, "srq 0x%x not found in tree\n", srq->srqn);
+	if (!tmp || tmp != srq)
 		return -EINVAL;
-	}
-	if (tmp != srq) {
-		mlx5_core_warn(dev, "corruption on srqn 0x%x\n", srq->srqn);
-		return -EINVAL;
-	}
 
 	err = destroy_srq_split(dev, srq);
 	if (err)
-- 
2.19.1
