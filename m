From: Michal Nazarewicz <mpn@google.com>
Subject: [PATCH] drivers: infiniband: remove unused argument and minor dead code
Date: Sun, 10 Nov 2013 19:58:35 +0100
Message-ID: <1384109915-24095-1-git-send-email-mpn@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
List-Id: linux-rdma@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The dev variable is never assigned after being initialised.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/infiniband/core/cma.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index da9611d..33f114f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1452,7 +1452,6 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 {
 	struct rdma_cm_id *new_cm_id;
 	struct rdma_id_private *listen_id, *conn_id;
-	struct net_device *dev = NULL;
 	struct rdma_cm_event event;
 	int ret;
 	struct ib_device_attr attr;
@@ -1530,8 +1529,6 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	cma_deref_id(conn_id);
 
 out:
-	if (dev)
-		dev_put(dev);
 	mutex_unlock(&listen_id->handler_mutex);
 	return ret;
 }
-- 
1.8.3.2
