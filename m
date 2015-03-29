From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 18/18] iser-target: Bump version to 1.0
Date: Sun, 29 Mar 2015 15:52:20 +0300
Message-ID: <1427633540-30352-19-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8f452f6..327529e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3439,7 +3439,7 @@ static void __exit isert_exit(void)
 }
 
 MODULE_DESCRIPTION("iSER-Target for mainline target infrastructure");
-MODULE_VERSION("0.1");
+MODULE_VERSION("1.0");
 MODULE_AUTHOR("nab@Linux-iSCSI.org");
 MODULE_LICENSE("GPL");
 
-- 
1.7.1
