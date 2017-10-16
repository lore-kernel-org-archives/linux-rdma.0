From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] RDMA/cxgb4: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 15:52:31 -0700
Message-ID: <20171016225231.GA98935@beast>
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
to pass the timer pointer explicitly. Also removes an unused timer and
drops a redundant initialization.

Cc: Steve Wise <swise@chelsio.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/hw/cxgb4/cm.c       | 13 +++++--------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  1 -
 drivers/infiniband/hw/cxgb4/qp.c       |  1 -
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e395afcd7d33..919b68422a5e 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -144,7 +144,7 @@ static struct workqueue_struct *workq;
 static struct sk_buff_head rxq;
 
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp);
-static void ep_timeout(unsigned long arg);
+static void ep_timeout(struct timer_list *t);
 static void connect_reply_upcall(struct c4iw_ep *ep, int status);
 static int sched(struct c4iw_dev *dev, struct sk_buff *skb);
 
@@ -189,8 +189,6 @@ static void start_ep_timer(struct c4iw_ep *ep)
 	clear_bit(TIMEOUT, &ep->com.flags);
 	c4iw_get_ep(&ep->com);
 	ep->timer.expires = jiffies + ep_timeout_secs * HZ;
-	ep->timer.data = (unsigned long)ep;
-	ep->timer.function = ep_timeout;
 	add_timer(&ep->timer);
 }
 
@@ -2107,7 +2105,6 @@ static int c4iw_reconnect(struct c4iw_ep *ep)
 	__u8 *ra;
 
 	pr_debug("qp %p cm_id %p\n", ep->com.qp, ep->com.cm_id);
-	init_timer(&ep->timer);
 	c4iw_init_wr_wait(ep->com.wr_waitp);
 
 	/* When MPA revision is different on nodes, the node with MPA_rev=2
@@ -2585,7 +2582,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
 	pr_debug("tx_chan %u smac_idx %u rss_qid %u\n",
 		 child_ep->tx_chan, child_ep->smac_idx, child_ep->rss_qid);
 
-	init_timer(&child_ep->timer);
+	timer_setup(&child_ep->timer, ep_timeout, 0);
 	cxgb4_insert_tid(t, child_ep, hwtid,
 			 child_ep->com.local_addr.ss_family);
 	insert_ep_tid(child_ep);
@@ -3210,7 +3207,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		goto fail1;
 	}
 
-	init_timer(&ep->timer);
+	timer_setup(&ep->timer, ep_timeout, 0);
 	ep->plen = conn_param->private_data_len;
 	if (ep->plen)
 		memcpy(ep->mpa_pkt + sizeof(struct mpa_message),
@@ -4122,9 +4119,9 @@ static void process_work(struct work_struct *work)
 
 static DECLARE_WORK(skb_work, process_work);
 
-static void ep_timeout(unsigned long arg)
+static void ep_timeout(struct timer_list *t)
 {
-	struct c4iw_ep *ep = (struct c4iw_ep *)arg;
+	struct c4iw_ep *ep = from_timer(ep, t, timer);
 	int kickit = 0;
 
 	spin_lock(&timeout_lock);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index d730bb735d74..788ddb6aa57b 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -537,7 +537,6 @@ struct c4iw_qp {
 	struct mutex mutex;
 	struct kref kref;
 	wait_queue_head_t wait;
-	struct timer_list timer;
 	int sq_sig_all;
 	struct work_struct free_work;
 	struct c4iw_ucontext *ucontext;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 56655a000121..57b23e33eb8b 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1929,7 +1929,6 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 		qhp->ucontext = ucontext;
 	}
 	qhp->ibqp.qp_num = qhp->wq.sq.qid;
-	init_timer(&(qhp->timer));
 	INIT_LIST_HEAD(&qhp->db_fc_entry);
 	pr_debug("sq id %u size %u memsize %zu num_entries %u rq id %u size %u memsize %zu num_entries %u\n",
 		 qhp->wq.sq.qid, qhp->wq.sq.size, qhp->wq.sq.memsize,
-- 
2.7.4


-- 
Kees Cook
Pixel Security
