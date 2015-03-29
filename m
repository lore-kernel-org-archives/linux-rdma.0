From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 04/18] iser-target: Remove redundant check on recv completion
Date: Sun, 29 Mar 2015 15:52:06 +0300
Message-ID: <1427633540-30352-5-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

We have a switch default for this.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 506c2eb..9b40b37 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1946,10 +1946,6 @@ isert_send_completion(struct iser_tx_desc *tx_desc,
 	isert_dbg("Cmd %p iser_ib_op %d\n", isert_cmd, wr->iser_ib_op);
 
 	switch (wr->iser_ib_op) {
-	case ISER_IB_RECV:
-		isert_err("Got ISER_IB_RECV\n");
-		dump_stack();
-		break;
 	case ISER_IB_SEND:
 		isert_response_completion(tx_desc, isert_cmd,
 					  isert_conn, ib_dev);
-- 
1.7.1
