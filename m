From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 01/12] iser-target: Fix identification of login rx descriptor type
Date: Wed, 24 Feb 2016 19:23:58 +0200
Message-ID: <1456334649-21437-2-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf@mellanox.com>

Once connection request is accepted, one rx descriptor
is posted to receive login request. This descriptor has rx type,
but is outside the main pool of rx descriptors, and thus
was mistreated as tx type.

Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f121e6129339..09ded3c704e5 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2048,7 +2048,8 @@ is_isert_tx_desc(struct isert_conn *isert_conn, void *wr_id)
 	void *start = isert_conn->rx_descs;
 	int len = ISERT_QP_MAX_RECV_DTOS * sizeof(*isert_conn->rx_descs);
 
-	if (wr_id >= start && wr_id < start + len)
+	if ((wr_id >= start && wr_id < start + len) ||
+	    (wr_id == isert_conn->login_req_buf))
 		return false;
 
 	return true;
-- 
1.8.4.3
