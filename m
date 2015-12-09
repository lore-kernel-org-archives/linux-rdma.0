From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 07/10] iser-target: Declare correct flags when accepting a connection
Date: Wed,  9 Dec 2015 14:12:05 +0200
Message-ID: <1449663128-368-8-git-send-email-sagig@mellanox.com>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1449663128-368-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf@mellanox.com>

iser target does not support zero based virtual addresses and
send with invalidate, so it should declare that it doesn't.

Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 63217e382140..8a90475ed2f2 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3098,12 +3098,18 @@ isert_rdma_accept(struct isert_conn *isert_conn)
 	struct rdma_cm_id *cm_id = isert_conn->cm_id;
 	struct rdma_conn_param cp;
 	int ret;
+	struct iser_cm_hdr rsp_hdr;
 
 	memset(&cp, 0, sizeof(struct rdma_conn_param));
 	cp.initiator_depth = isert_conn->initiator_depth;
 	cp.retry_count = 7;
 	cp.rnr_retry_count = 7;
 
+	memset(&rsp_hdr, 0, sizeof(rsp_hdr));
+	rsp_hdr.flags = (ISERT_ZBVA_NOT_USED | ISERT_SEND_W_INV_NOT_USED);
+	cp.private_data = (void *)&rsp_hdr;
+	cp.private_data_len = sizeof(rsp_hdr);
+
 	ret = rdma_accept(cm_id, &cp);
 	if (ret) {
 		isert_err("rdma_accept() failed with: %d\n", ret);
-- 
1.8.4.3
