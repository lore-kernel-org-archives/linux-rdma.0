From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 28/87] infiniband: ulp: remove memset after vzalloc in ipoib_cm.c
Date: Fri, 28 Jun 2019 01:38:04 +0800
Message-ID: <20190627173806.3307-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Kamal Heib <kamalheib1@gmail.com>, Feras Daoud <ferasda@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, Aaron Knister <aaron.s.knister@nasa.gov>, Denis Drozdov <denisd@mellanox.com>, Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

vzalloc has already zeroed the memory.
So memset is unneeded.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index aa9dcfc36cd3..c59e00a0881f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1153,7 +1153,6 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 		ret = -ENOMEM;
 		goto err_tx;
 	}
-	memset(p->tx_ring, 0, ipoib_sendq_size * sizeof(*p->tx_ring));
 
 	p->qp = ipoib_cm_create_tx_qp(p->dev, p);
 	memalloc_noio_restore(noio_flag);
-- 
2.11.0
