From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/4] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Wed, 6 Apr 2016 11:56:41 -0700
Message-ID: <57055BE9.1010403@sandisk.com>
References: <57055BC6.7070402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57055BC6.7070402@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

That patch causes the ib_srpt driver to crash as soon as the first
SCSI command is received. This means that that patch was untested.
Hence revert it. The shortcomings of that patch are as follows:
- It makes the ib_srpt driver use I/O contexts allocated by
  transport_alloc_session_tags() but it does not initialize these
  I/O contexts properly. All the initializations performed by
  srpt_alloc_ioctx() are skipped.
- The amount of memory that is needed for I/O contexts is doubled.
- srpt_rdma_ch.free_list is no longer used but is not removed.

Revert commit 0fd10721fe36 and thereby fix the following kernel crash:

kernel BUG at drivers/infiniband/ulp/srpt/ib_srpt.c:1439!
invalid opcode: 0000 [#1] SMP
Workqueue: target_completion target_complete_ok_work [target_core_mod]
RIP: 0010:[<ffffffffa052ef37>]  [<ffffffffa052ef37>] srpt_queue_response+0x437/0x4a0 [ib_srpt]
Call Trace:
 [<ffffffffa052f009>] srpt_queue_data_in+0x9/0x10 [ib_srpt]
 [<ffffffffa04f1ee2>] target_complete_ok_work+0x152/0x2b0 [target_core_mod]
 [<ffffffff81071ea7>] process_one_work+0x197/0x480
 [<ffffffff810721d9>] worker_thread+0x49/0x490
 [<ffffffff8107878a>] kthread+0xea/0x100
 [<ffffffff8159b172>] ret_from_fork+0x22/0x40

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 55 ++++++++++++++++++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 13594db..3b425af 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1264,26 +1264,40 @@ free_mem:
  */
 static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 {
-	struct se_session *se_sess;
 	struct srpt_send_ioctx *ioctx;
-	int tag;
+	unsigned long flags;
 
 	BUG_ON(!ch);
-	se_sess = ch->sess;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
-	if (tag < 0) {
-		pr_err("Unable to obtain tag for srpt_send_ioctx\n");
-		return NULL;
+	ioctx = NULL;
+	spin_lock_irqsave(&ch->spinlock, flags);
+	if (!list_empty(&ch->free_list)) {
+		ioctx = list_first_entry(&ch->free_list,
+					 struct srpt_send_ioctx, free_list);
+		list_del(&ioctx->free_list);
 	}
-	ioctx = &((struct srpt_send_ioctx *)se_sess->sess_cmd_map)[tag];
-	memset(ioctx, 0, sizeof(struct srpt_send_ioctx));
-	ioctx->ch = ch;
+	spin_unlock_irqrestore(&ch->spinlock, flags);
+
+	if (!ioctx)
+		return ioctx;
+
+	BUG_ON(ioctx->ch != ch);
 	spin_lock_init(&ioctx->spinlock);
 	ioctx->state = SRPT_STATE_NEW;
+	ioctx->n_rbuf = 0;
+	ioctx->rbufs = NULL;
+	ioctx->n_rdma = 0;
+	ioctx->n_rdma_wrs = 0;
+	ioctx->rdma_wrs = NULL;
+	ioctx->mapped_sg_count = 0;
 	init_completion(&ioctx->tx_done);
-
-	ioctx->cmd.map_tag = tag;
+	ioctx->queue_status_only = false;
+	/*
+	 * transport_init_se_cmd() does not initialize all fields, so do it
+	 * here.
+	 */
+	memset(&ioctx->cmd, 0, sizeof(ioctx->cmd));
+	memset(&ioctx->sense_data, 0, sizeof(ioctx->sense_data));
 
 	return ioctx;
 }
@@ -2013,7 +2027,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
 	u32 it_iu_len;
-	int ret = 0;
+	int i, ret = 0;
 	unsigned char *p;
 
 	WARN_ON_ONCE(irqs_disabled());
@@ -2135,6 +2149,12 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (!ch->ioctx_ring)
 		goto free_ch;
 
+	INIT_LIST_HEAD(&ch->free_list);
+	for (i = 0; i < ch->rq_size; i++) {
+		ch->ioctx_ring[i]->ch = ch;
+		list_add_tail(&ch->ioctx_ring[i]->free_list, &ch->free_list);
+	}
+
 	ret = srpt_create_ch_ib(ch);
 	if (ret) {
 		rej->reason = cpu_to_be32(
@@ -2165,8 +2185,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	p = &ch->sess_name[0];
 
 try_again:
-	ch->sess = target_alloc_session(&sport->port_tpg_1, ch->rq_size,
-					sizeof(struct srpt_send_ioctx),
+	ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
 					TARGET_PROT_NORMAL, p, ch, NULL);
 	if (IS_ERR(ch->sess)) {
 		pr_info("Rejected login because no ACL has been"
@@ -2873,7 +2892,7 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 	struct srpt_send_ioctx *ioctx = container_of(se_cmd,
 				struct srpt_send_ioctx, cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
-	struct se_session *se_sess = ch->sess;
+	unsigned long flags;
 
 	WARN_ON(ioctx->state != SRPT_STATE_DONE);
 	WARN_ON(ioctx->mapped_sg_count != 0);
@@ -2884,7 +2903,9 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 		ioctx->n_rbuf = 0;
 	}
 
-	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+	spin_lock_irqsave(&ch->spinlock, flags);
+	list_add(&ioctx->free_list, &ch->free_list);
+	spin_unlock_irqrestore(&ch->spinlock, flags);
 }
 
 /**
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index ca288f0..af9b8b5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -179,6 +179,7 @@ struct srpt_recv_ioctx {
  * struct srpt_send_ioctx - SRPT send I/O context.
  * @ioctx:       See above.
  * @ch:          Channel pointer.
+ * @free_list:   Node in srpt_rdma_ch.free_list.
  * @n_rbuf:      Number of data buffers in the received SRP command.
  * @rbufs:       Pointer to SRP data buffer array.
  * @single_rbuf: SRP data buffer if the command has only a single buffer.
@@ -201,6 +202,7 @@ struct srpt_send_ioctx {
 	struct srp_direct_buf	*rbufs;
 	struct srp_direct_buf	single_rbuf;
 	struct scatterlist	*sg;
+	struct list_head	free_list;
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
-- 
2.7.4
