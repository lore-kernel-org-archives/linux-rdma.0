From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 12/12] IB/srpt: Micro-optimize I/O context state manipulation
Date: Mon,  8 Jan 2018 11:00:51 -0800
Message-ID: <20180108190051.32008-13-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since all I/O context state changes are already serialized, it is
not necessary to protect I/O context state changes with the I/O
context spinlock. Hence remove that spinlock.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 16 +---------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 --
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d2835b0c15e8..d78f60dcc2ba 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -764,15 +764,10 @@ static enum srpt_command_state srpt_set_cmd_state(struct srpt_send_ioctx *ioctx,
 						  enum srpt_command_state new)
 {
 	enum srpt_command_state previous;
-	unsigned long flags;
-
-	BUG_ON(!ioctx);
 
-	spin_lock_irqsave(&ioctx->spinlock, flags);
 	previous = ioctx->state;
 	if (previous != SRPT_STATE_DONE)
 		ioctx->state = new;
-	spin_unlock_irqrestore(&ioctx->spinlock, flags);
 
 	return previous;
 }
@@ -790,17 +785,15 @@ static bool srpt_test_and_set_cmd_state(struct srpt_send_ioctx *ioctx,
 					enum srpt_command_state new)
 {
 	enum srpt_command_state previous;
-	unsigned long flags;
 
 	WARN_ON(!ioctx);
 	WARN_ON(old == SRPT_STATE_DONE);
 	WARN_ON(new == SRPT_STATE_NEW);
 
-	spin_lock_irqsave(&ioctx->spinlock, flags);
 	previous = ioctx->state;
 	if (previous == old)
 		ioctx->state = new;
-	spin_unlock_irqrestore(&ioctx->spinlock, flags);
+
 	return previous == old;
 }
 
@@ -1170,7 +1163,6 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 		return ioctx;
 
 	BUG_ON(ioctx->ch != ch);
-	spin_lock_init(&ioctx->spinlock);
 	ioctx->state = SRPT_STATE_NEW;
 	ioctx->n_rdma = 0;
 	ioctx->n_rw_ctx = 0;
@@ -1192,7 +1184,6 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 {
 	enum srpt_command_state state;
-	unsigned long flags;
 
 	BUG_ON(!ioctx);
 
@@ -1201,7 +1192,6 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 	 * the ib_srpt driver, change the state to the next state.
 	 */
 
-	spin_lock_irqsave(&ioctx->spinlock, flags);
 	state = ioctx->state;
 	switch (state) {
 	case SRPT_STATE_NEED_DATA:
@@ -1216,7 +1206,6 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 			  __func__, state);
 		break;
 	}
-	spin_unlock_irqrestore(&ioctx->spinlock, flags);
 
 	pr_debug("Aborting cmd with state %d -> %d and tag %lld\n", state,
 		 ioctx->state, ioctx->cmd.tag);
@@ -2431,13 +2420,11 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	struct ib_send_wr send_wr, *first_wr = &send_wr, *bad_wr;
 	struct ib_sge sge;
 	enum srpt_command_state state;
-	unsigned long flags;
 	int resp_len, ret, i;
 	u8 srp_tm_status;
 
 	BUG_ON(!ch);
 
-	spin_lock_irqsave(&ioctx->spinlock, flags);
 	state = ioctx->state;
 	switch (state) {
 	case SRPT_STATE_NEW:
@@ -2452,7 +2439,6 @@ static void srpt_queue_response(struct se_cmd *cmd)
 			ch, ioctx->ioctx.index, ioctx->state);
 		break;
 	}
-	spin_unlock_irqrestore(&ioctx->spinlock, flags);
 
 	if (unlikely(WARN_ON_ONCE(state == SRPT_STATE_CMD_RSP_SENT)))
 		return;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 8f90a7ca98e6..11ce8c94a051 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -195,7 +195,6 @@ struct srpt_rw_ctx {
  * @rw_ctxs:     RDMA read/write contexts.
  * @rdma_cqe:    RDMA completion queue element.
  * @free_list:   Node in srpt_rdma_ch.free_list.
- * @spinlock:    Protects 'state'.
  * @state:       I/O context state.
  * @cmd:         Target core command data structure.
  * @sense_data:  SCSI sense data.
@@ -213,7 +212,6 @@ struct srpt_send_ioctx {
 
 	struct ib_cqe		rdma_cqe;
 	struct list_head	free_list;
-	spinlock_t		spinlock;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
 	u8			n_rdma;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
