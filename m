From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 10/18] iser-target: Remove redundant assignment to local variable
Date: Sun, 29 Mar 2015 15:52:12 +0300
Message-ID: <1427633540-30352-11-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

No need to keep a local ib_dev as a device pointer.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index db5460a..0bab74b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -346,12 +346,11 @@ out_cq:
 static int
 isert_create_device_ib_res(struct isert_device *device)
 {
-	struct ib_device *ib_dev = device->ib_device;
 	struct ib_device_attr *dev_attr;
-	int ret = 0;
+	int ret;
 
 	dev_attr = &device->dev_attr;
-	ret = isert_query_device(ib_dev, dev_attr);
+	ret = isert_query_device(device->ib_device, dev_attr);
 	if (ret)
 		return ret;
 
-- 
1.7.1
