From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 06/18] iser-target: Remove redundant local variable
Date: Sun, 29 Mar 2015 15:52:08 +0300
Message-ID: <1427633540-30352-7-git-send-email-sagig@mellanox.com>
References: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427633540-30352-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

No need for this assignment.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 5b086b3..ae09561 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1385,13 +1385,12 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 {
 	struct iscsi_hdr *hdr = &rx_desc->iscsi_header;
 	struct iscsi_conn *conn = isert_conn->conn;
-	struct iscsi_session *sess = conn->sess;
 	struct iscsi_cmd *cmd;
 	struct isert_cmd *isert_cmd;
 	int ret = -EINVAL;
 	u8 opcode = (hdr->opcode & ISCSI_OPCODE_MASK);
 
-	if (sess->sess_ops->SessionType &&
+	if (conn->sess->sess_ops->SessionType &&
 	   (!(opcode & ISCSI_OP_TEXT) || !(opcode & ISCSI_OP_LOGOUT))) {
 		isert_err("Got illegal opcode: 0x%02x in SessionType=Discovery,"
 			  " ignoring\n", opcode);
-- 
1.7.1
