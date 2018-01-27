From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] IB/iser: Delete an unnecessary variable initialisation in
 iser_send_data_out()
Date: Sat, 27 Jan 2018 19:20:05 +0100
Message-ID: <f9277c5a-50f3-2f7e-ee6f-e4dee15e4eea@users.sourceforge.net>
References: <00e8b16f-c856-8999-fe93-2724a2f6a56e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00e8b16f-c856-8999-fe93-2724a2f6a56e@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 27 Jan 2018 17:55:13 +0100

The variable "tx_desc" will be set to an appropriate pointer a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 3ae2571ba5b4..1425c4957a04 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -436,7 +436,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 {
 	struct iser_conn *iser_conn = conn->dd_data;
 	struct iscsi_iser_task *iser_task = task->dd_data;
-	struct iser_tx_desc *tx_desc = NULL;
+	struct iser_tx_desc *tx_desc;
 	struct iser_mem_reg *mem_reg;
 	unsigned long buf_offset;
 	unsigned long data_seg_len;
-- 
2.16.1
