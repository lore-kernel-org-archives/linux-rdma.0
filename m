From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] RDMA/cxgb3: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 15:54:11 -0700
Message-ID: <20171016225411.GA98979@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Steve Wise <swise@chelsio.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. Also removes an unused timer.

Cc: Steve Wise <swise@chelsio.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/hw/cxgb3/iwch_cm.c       | 12 +++++-------
 drivers/infiniband/hw/cxgb3/iwch_provider.c |  1 -
 drivers/infiniband/hw/cxgb3/iwch_provider.h |  1 -
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 86975370a4c0..638ac9a06053 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -107,7 +107,7 @@ static struct workqueue_struct *workq;
 static struct sk_buff_head rxq;
 
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp);
-static void ep_timeout(unsigned long arg);
+static void ep_timeout(struct timer_list *t);
 static void connect_reply_upcall(struct iwch_ep *ep, int status);
 
 static void start_ep_timer(struct iwch_ep *ep)
@@ -119,8 +119,6 @@ static void start_ep_timer(struct iwch_ep *ep)
 	} else
 		get_ep(&ep->com);
 	ep->timer.expires = jiffies + ep_timeout_secs * HZ;
-	ep->timer.data = (unsigned long)ep;
-	ep->timer.function = ep_timeout;
 	add_timer(&ep->timer);
 }
 
@@ -1399,7 +1397,7 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	child_ep->l2t = l2t;
 	child_ep->dst = dst;
 	child_ep->hwtid = hwtid;
-	init_timer(&child_ep->timer);
+	timer_setup(&child_ep->timer, ep_timeout, 0);
 	cxgb3_insert_tid(tdev, &t3c_client, child_ep, hwtid);
 	accept_cr(child_ep, req->peer_ip, skb);
 	goto out;
@@ -1719,9 +1717,9 @@ static int ec_status(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	return CPL_RET_BUF_DONE;
 }
 
-static void ep_timeout(unsigned long arg)
+static void ep_timeout(struct timer_list *t)
 {
-	struct iwch_ep *ep = (struct iwch_ep *)arg;
+	struct iwch_ep *ep = from_timer(ep, t, timer);
 	struct iwch_qp_attributes attrs;
 	unsigned long flags;
 	int abort = 1;
@@ -1899,7 +1897,7 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		err = -ENOMEM;
 		goto out;
 	}
-	init_timer(&ep->timer);
+	timer_setup(&ep->timer, ep_timeout, 0);
 	ep->plen = conn_param->private_data_len;
 	if (ep->plen)
 		memcpy(ep->mpa_pkt + sizeof(struct mpa_message),
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 099e76f3758a..a578ca559e11 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -969,7 +969,6 @@ static struct ib_qp *iwch_create_qp(struct ib_pd *pd,
 		insert_mmap(ucontext, mm2);
 	}
 	qhp->ibqp.qp_num = qhp->wq.qpid;
-	init_timer(&(qhp->timer));
 	pr_debug("%s sq_num_entries %d, rq_num_entries %d qpid 0x%0x qhp %p dma_addr 0x%llx size %d rq_addr 0x%x\n",
 		 __func__, qhp->attr.sq_num_entries, qhp->attr.rq_num_entries,
 		 qhp->wq.qpid, qhp, (unsigned long long)qhp->wq.dma_addr,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index 9e216edec4c0..2e38ddefea8a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -168,7 +168,6 @@ struct iwch_qp {
 	atomic_t refcnt;
 	wait_queue_head_t wait;
 	enum IWCH_QP_FLAGS flags;
-	struct timer_list timer;
 };
 
 static inline int qp_quiesced(struct iwch_qp *qhp)
-- 
2.7.4


-- 
Kees Cook
Pixel Security
