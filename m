From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 12/12] iser-target: Use ib_drain_qp
Date: Wed, 24 Feb 2016 19:24:09 +0200
Message-ID: <1456334649-21437-13-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Now the rdma core offers a QP draining service, use it
instead of our own.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 39 ++++-----------------------------
 drivers/infiniband/ulp/isert/ib_isert.h |  2 --
 2 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 57e4edd661c5..411e4464ca23 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -63,7 +63,6 @@ isert_rdma_accept(struct isert_conn *isert_conn);
 struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
 
 static void isert_release_work(struct work_struct *work);
-static void isert_wait4flush(struct isert_conn *isert_conn);
 static void isert_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc);
@@ -141,7 +140,7 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.qp_context = isert_conn;
 	attr.send_cq = comp->cq;
 	attr.recv_cq = comp->cq;
-	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS;
+	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS + 1;
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
 	attr.cap.max_send_sge = device->ib_device->attrs.max_sge;
 	isert_conn->max_sge = min(device->ib_device->attrs.max_sge,
@@ -887,7 +886,7 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 		break;
 	case ISER_CONN_UP:
 		isert_conn_terminate(isert_conn);
-		isert_wait4flush(isert_conn);
+		ib_drain_qp(isert_conn->qp);
 		isert_handle_unbound_conn(isert_conn);
 		break;
 	case ISER_CONN_BOUND:
@@ -3213,36 +3212,6 @@ isert_wait4cmds(struct iscsi_conn *conn)
 	}
 }
 
-static void
-isert_beacon_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct isert_conn *isert_conn = wc->qp->qp_context;
-
-	isert_print_wc(wc);
-
-	isert_info("conn %p completing wait_comp_err\n", isert_conn);
-	complete(&isert_conn->wait_comp_err);
-}
-
-static void
-isert_wait4flush(struct isert_conn *isert_conn)
-{
-	struct ib_recv_wr *bad_wr;
-	static struct ib_cqe cqe = { .done = isert_beacon_done };
-
-	isert_info("conn %p\n", isert_conn);
-
-	init_completion(&isert_conn->wait_comp_err);
-	isert_conn->beacon.wr_cqe = &cqe;
-	/* post an indication that all flush errors were consumed */
-	if (ib_post_recv(isert_conn->qp, &isert_conn->beacon, &bad_wr)) {
-		isert_err("conn %p failed to post beacon", isert_conn);
-		return;
-	}
-
-	wait_for_completion(&isert_conn->wait_comp_err);
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -3288,7 +3257,7 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 	isert_conn_terminate(isert_conn);
 	mutex_unlock(&isert_conn->mutex);
 
-	isert_wait4flush(isert_conn);
+	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
 	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
@@ -3300,7 +3269,7 @@ static void isert_free_conn(struct iscsi_conn *conn)
 {
 	struct isert_conn *isert_conn = conn->context;
 
-	isert_wait4flush(isert_conn);
+	ib_drain_qp(isert_conn->qp);
 	isert_put_conn(isert_conn);
 }
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 192788a4820c..147900cbb578 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -209,14 +209,12 @@ struct isert_conn {
 	struct ib_qp		*qp;
 	struct isert_device	*device;
 	struct mutex		mutex;
-	struct completion	wait_comp_err;
 	struct kref		kref;
 	struct list_head	fr_pool;
 	int			fr_pool_size;
 	/* lock to protect fastreg pool */
 	spinlock_t		pool_lock;
 	struct work_struct	release_work;
-	struct ib_recv_wr       beacon;
 	bool                    logout_posted;
 	bool                    snd_w_inv;
 };
-- 
1.8.4.3
