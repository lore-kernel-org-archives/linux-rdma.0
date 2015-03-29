From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 05/18] iser-target: Remove dead code
Date: Sun, 29 Mar 2015 15:52:07 +0300
Message-ID: <1427633540-30352-6-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

unmap_list is unused.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9b40b37..5b086b3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1640,7 +1640,6 @@ static void
 isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-	LIST_HEAD(unmap_list);
 
 	isert_dbg("Cmd %p\n", isert_cmd);
 
-- 
1.7.1
