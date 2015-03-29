From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 01/18] iser-target: Fix session hang in case of an rdma read DIF error
Date: Sun, 29 Mar 2015 15:52:03 +0300
Message-ID: <1427633540-30352-2-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This hang was a result of a missing command put when
a DIF error occurred during a rdma read (and we sent
an CHECK_CONDITION error without passing it to the
backend).

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 075b19c..4b8d518 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1861,11 +1861,13 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
 	spin_unlock_bh(&cmd->istate_lock);
 
-	if (ret)
+	if (ret) {
+		target_put_sess_cmd(se_cmd->se_sess, se_cmd);
 		transport_send_check_condition_and_sense(se_cmd,
 							 se_cmd->pi_err, 0);
-	else
+	} else {
 		target_execute_cmd(se_cmd);
+	}
 }
 
 static void
-- 
1.7.1
