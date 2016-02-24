From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 03/12] iser-target: Separate flows for np listeners and connections cma events
Date: Wed, 24 Feb 2016 19:24:00 +0200
Message-ID: <1456334649-21437-4-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf@mellanox.com>

No need to restrict this check to specific events.

Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 320d3a55249c..73b2233edcff 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -889,14 +889,9 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 			   enum rdma_cm_event_type event)
 {
 	struct isert_np *isert_np = cma_id->context;
-	struct isert_conn *isert_conn;
+	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	bool terminating = false;
 
-	if (isert_np->cm_id == cma_id)
-		return isert_np_cma_handler(cma_id->context, event);
-
-	isert_conn = cma_id->qp->qp_context;
-
 	mutex_lock(&isert_conn->mutex);
 	terminating = (isert_conn->state == ISER_CONN_TERMINATING);
 	isert_conn_terminate(isert_conn);
@@ -935,12 +930,16 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 static int
 isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
+	struct isert_np *isert_np = cma_id->context;
 	int ret = 0;
 
 	isert_info("%s (%d): status %d id %p np %p\n",
 		   rdma_event_msg(event->event), event->event,
 		   event->status, cma_id, cma_id->context);
 
+	if (isert_np->cm_id == cma_id)
+		return isert_np_cma_handler(cma_id->context, event->event);
+
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		ret = isert_connect_request(cma_id, event);
-- 
1.8.4.3
