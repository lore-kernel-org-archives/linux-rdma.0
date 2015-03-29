From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 15/18] iser-target: Remove redundant check on the device
Date: Sun, 29 Mar 2015 15:52:17 +0300
Message-ID: <1427633540-30352-16-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

In iser_connect_release there is no chance that
the iser device is set to NULL, if this happens
we have a BUG. So use BUG_ON.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 97cee96..357d481 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -797,7 +797,9 @@ isert_connect_release(struct isert_conn *isert_conn)
 
 	isert_dbg("conn %p\n", isert_conn);
 
-	if (device && device->use_fastreg)
+	BUG_ON(!device);
+
+	if (device->use_fastreg)
 		isert_conn_free_fastreg_pool(isert_conn);
 
 	isert_free_rx_descriptors(isert_conn);
@@ -814,10 +816,9 @@ isert_connect_release(struct isert_conn *isert_conn)
 	if (isert_conn->login_buf)
 		isert_free_login_buf(isert_conn);
 
-	kfree(isert_conn);
+	isert_device_put(device);
 
-	if (device)
-		isert_device_put(device);
+	kfree(isert_conn);
 }
 
 static void
-- 
1.7.1
