From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 04/12] Target/sbc: don't return from sbc_check for non prot_sg
Date: Wed, 19 Feb 2014 17:50:17 +0200
Message-ID: <1392825025-29943-5-git-send-email-sagig@mellanox.com>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com, martin.petersen@oracle.com
List-Id: linux-rdma@vger.kernel.org

For transports which use generic new command these
buffers have yet to be allocated. Instead check afterwards
if command required prot buffers but none are provided, In
this case send CHECK_CONDITION response.

Also this way, target may support protection information
against legacy initiators (writes are inserted and reads
are stripped).

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_sbc.c       |    3 ---
 drivers/target/target_core_transport.c |   21 ++++++++++++++++++---
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 6939947..312f522 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -633,9 +633,6 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 {
 	u8 protect = cdb[1] >> 5;
 
-	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
-		return true;
-
 	switch (dev->dev_attrib.pi_prot_type) {
 	case TARGET_DIF_TYPE3_PROT:
 		cmd->reftag_seed = 0xffffffff;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0f9e1ea..a45d628 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1365,6 +1365,13 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		target_put_sess_cmd(se_sess, se_cmd);
 		return 0;
 	}
+
+	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
+	if (rc != 0) {
+		transport_generic_request_failure(se_cmd, rc);
+		return 0;
+	}
+
 	/*
 	 * Save pointers for SGLs containing protection information,
 	 * if present.
@@ -1374,11 +1381,19 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		se_cmd->t_prot_nents = sgl_prot_count;
 	}
 
-	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
-	if (rc != 0) {
-		transport_generic_request_failure(se_cmd, rc);
+	/*
+	 * Fail if protection operation requiers protection
+	 * information buffers but None are provided!
+	 */
+	if ((!se_cmd->t_prot_sg || !se_cmd->t_prot_nents) &&
+	    (se_cmd->prot_op != TARGET_PROT_NORMAL)) {
+		pr_err("ERROR: protection information was requested but "
+		       "protection buffers weren't provided.\n");
+		transport_generic_request_failure(se_cmd,
+						  TCM_INVALID_CDB_FIELD);
 		return 0;
 	}
+
 	/*
 	 * When a non zero sgl_count has been passed perform SGL passthrough
 	 * mapping for pre-allocated fabric memory instead of having target
-- 
1.7.1
