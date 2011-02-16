From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: An IB SRP target
Date: Wed, 16 Feb 2011 21:49:45 +0100
Message-ID: <AANLkTinQJCfGZxbCkS_rxp=viee2T935ObUCFdoBazSH@mail.gmail.com>
References: <201102142109.19150.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201102142109.19150.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 14, 2011 at 9:09 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>
> This patch adds the kernel module ib_srpt, which is a SCSI RDMA Protocol
> (SRP) target implementation conforming to the SRP r16a specification.

Since no documentation is available for the target core, the unavoidable
happened: I had misinterpret the meaning of one target core function. I just
found out that queue_data_in must operate synchronously. So this follow-up
patch is necessary in order to make this IB SRP target implementation work
correctly:

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7fe9d3b..b92c0e3 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1320,6 +1320,7 @@ static struct srpt_send_ioctx
*srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	ioctx->n_rdma_ius = 0;
 	ioctx->rdma_ius = NULL;
 	ioctx->mapped_sg_count = 0;
+	init_completion(&ioctx->tx_done);
 	/*
 	 * transport_init_se_cmd() does not initialize all fields, so do it
 	 * here.
@@ -1429,6 +1430,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 		 * not been received in time.
 		 */
 		srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
+		complete(&ioctx->tx_done);
 		atomic_set(&ioctx->cmd.t_task->transport_lun_stop, 1);
 		kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
 		break;
@@ -1492,6 +1494,9 @@ static void srpt_handle_send_comp(struct srpt_rdma_ch *ch,
 		    && state != SRPT_STATE_DONE))
 		pr_debug("state = %d\n", state);

+	if (state == SRPT_STATE_CMD_RSP_SENT)
+		complete(&ioctx->tx_done);
+
 	if (state != SRPT_STATE_DONE)
 		kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
 	else
@@ -3097,7 +3102,9 @@ static int srpt_queue_data_in(struct se_cmd *cmd)

 	resp_len = srpt_build_cmd_rsp(ch, ioctx, ioctx->tag, cmd->scsi_status);
 	ret = srpt_post_send(ch, ioctx, resp_len);
-	if (ret) {
+	if (ret == 0)
+		wait_for_completion(&ioctx->tx_done);
+	else {
 		printk(KERN_ERR "sending cmd response failed for tag %llu\n",
 		       ioctx->tag);
 		srpt_unmap_sg_to_ib_sge(ch, ioctx);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h
b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 321b097..54d2382 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -218,6 +218,7 @@ struct srpt_send_ioctx {
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
+	struct completion	tx_done;
 	u64			tag;
 	int			sg_cnt;
 	int			mapped_sg_count;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
