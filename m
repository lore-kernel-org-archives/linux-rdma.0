From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 03/11] net/mlx5: Remove not-used lib/eq.h header file
Date: Wed, 28 Nov 2018 20:53:35 +0200
Message-ID: <20181128185343.21669-4-leon@kernel.org>
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

lib/eq.h is needed for EQ manipulation which are not performed in SRQ.

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/srq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index 10036aaa200a..248f1c8dd5d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -11,7 +11,6 @@
 #include <rdma/ib_verbs.h>
 #include <linux/mlx5/transobj.h>
 #include "mlx5_core.h"
-#include "lib/eq.h"
 
 static int srq_event_notifier(struct notifier_block *nb,
 			      unsigned long type, void *data)
-- 
2.19.1
