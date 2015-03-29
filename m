From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 16/18] iser-target: Remove un-needed rdma_listen backlog
Date: Sun, 29 Mar 2015 15:52:18 +0300
Message-ID: <1427633540-30352-17-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

iser target can handle as many connect request as
the fabric sends to it. This backlog should not set as
a back-pressure mechanism (which is not very useful).

isert does need a back-pressure mechanism, but it should
be added in isert by monitoring the number of pending
established connections (will be added in a later stage).

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 357d481..4a2800a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3058,7 +3058,7 @@ isert_setup_id(struct isert_np *isert_np)
 		goto out_id;
 	}
 
-	ret = rdma_listen(id, ISERT_RDMA_LISTEN_BACKLOG);
+	ret = rdma_listen(id, 0);
 	if (ret) {
 		isert_err("rdma_listen() failed: %d\n", ret);
 		goto out_id;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index e386092..651c58e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -31,7 +31,6 @@
 #define isert_err(fmt, arg...) \
 	pr_err(PFX "%s: " fmt, __func__ , ## arg)
 
-#define ISERT_RDMA_LISTEN_BACKLOG	10
 #define ISCSI_ISER_SG_TABLESIZE		256
 #define ISER_FASTREG_LI_WRID		0xffffffffffffffffULL
 #define ISER_BEACON_WRID               0xfffffffffffffffeULL
-- 
1.7.1
