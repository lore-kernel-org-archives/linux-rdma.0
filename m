From: simo.ghannam@gmail.com
Subject: [PATCH] RDS: null pointer dereference in rds_atomic_free_op
Date: Wed,  3 Jan 2018 21:06:06 +0000
Message-ID: <5a4d45ce.8b8a1c0a.1d072.e5e1@mx.google.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, santosh.shilimkar@oracle.com, davem@davemloft.net, rds-devel@oss.oracle.com
Cc: Mohamed Ghannam <simo.ghannam@gmail.com>
List-Id: linux-rdma@vger.kernel.org

From: Mohamed Ghannam <simo.ghannam@gmail.com>

set rm->atomic.op_active to 0 when rds_pin_pages() fails
or the user supplied address is invalid,
this prevents a NULL pointer usage in rds_atomic_free_op()

Signed-off-by: Mohamed Ghannam <simo.ghannam@gmail.com>
---
 net/rds/rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index bc2f1e0977d6..398932fbaf27 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -874,6 +874,7 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 err:
 	if (page)
 		put_page(page);
+	rm->atomic.op_active = 0;
 	kfree(rm->atomic.op_notifier);
 
 	return ret;
-- 
2.14.1
