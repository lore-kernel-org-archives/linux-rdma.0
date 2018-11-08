From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 07/10] net/mlx5: Use multi threaded workqueue for page fault handling
Date: Thu,  8 Nov 2018 21:10:14 +0200
Message-ID: <20181108191017.21891-8-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Page fault events are processed in a workqueue context. Since each QP
can have up to two concurrent unrelated page-faults, one for requester
and one for responder, page-fault handling can be done in parallel.
Achieve this by changing the workqueue to be multi-threaded.
The number of threads is the same as the number of command interface
channels to avoid command interface bottlenecks.

In addition to multi-threads, change the workqueue flags to give it high
priority.

Stress benchmark shows that before this change 85% of page faults were
waiting in queue 8 seconds or more while after the change 98% of page
faults were waiting in queue 64 milliseconds or less. The number of threads
was chosen as the number of channels to the command interface.

Fixes: d9aaed838765 ("{net,IB}/mlx5: Refactor page fault handling")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index c1e1a16a9b07..aeab0c4f60f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -356,8 +356,9 @@ static int init_pf_ctx(struct mlx5_eq_pagefault *pf_ctx, const char *name)
 	spin_lock_init(&pf_ctx->lock);
 	INIT_WORK(&pf_ctx->work, eq_pf_action);
 
-	pf_ctx->wq = alloc_ordered_workqueue(name,
-					     WQ_MEM_RECLAIM);
+	pf_ctx->wq = alloc_workqueue(name,
+				     WQ_HIGHPRI | WQ_UNBOUND | WQ_MEM_RECLAIM,
+				     MLX5_NUM_CMD_EQE);
 	if (!pf_ctx->wq)
 		return -ENOMEM;
 
-- 
2.19.1
