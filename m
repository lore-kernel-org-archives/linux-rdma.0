From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: An IB SRP target
Date: Mon, 21 Feb 2011 02:48:51 -0800
Message-ID: <1298285331.26616.100.camel@haakon2.linux-iscsi.org>
References: <201102142109.19150.bvanassche@acm.org>
	 <AANLkTinQJCfGZxbCkS_rxp=viee2T935ObUCFdoBazSH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinQJCfGZxbCkS_rxp=viee2T935ObUCFdoBazSH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-02-16 at 21:49 +0100, Bart Van Assche wrote:
> On Mon, Feb 14, 2011 at 9:09 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> >
> > This patch adds the kernel module ib_srpt, which is a SCSI RDMA Protocol
> > (SRP) target implementation conforming to the SRP r16a specification.
> 
> Since no documentation is available for the target core, the unavoidable
> happened: I had misinterpret the meaning of one target core function. I just
> found out that queue_data_in must operate synchronously. So this follow-up
> patch is necessary in order to make this IB SRP target implementation work
> correctly:
> 

Greetings Bart,

Using a completion queue here with possibility of the extra context
switch is IMHO an unnecessary overhead.  The main issue here is that
target core needs to be able to clear the struct se_cmd descriptor after
invoking the struct target_core_fabric_ops->send_data_in() callback, but
before the call to srpt_handle_send_comp() -> release of the fabric
dependent descriptor containing our struct se_cmd can happen.

I prefer something along the lines of the patch below for
lio-core-2.6.git/tcm_ib_srpt to follow what other TCM v4 HW fabric
modules are currently doing wrt to TFO->check_stop_free() usage.  This
patch has been compile tested only at this point, but I will be testing
this on IB hardware in the upcoming week.  Please review.

Thanks,

--nab

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index cfcb1bc..cf42db8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1326,6 +1326,8 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
         */
        memset(&ioctx->cmd, 0, sizeof(ioctx->cmd));
        memset(&ioctx->sense_data, 0, sizeof(ioctx->sense_data));
+       atomic_set(&ioctx->cmd_done, 0);
+       atomic_set(&ioctx->cmd_stop_free, 0);
 
        return ioctx;
 }
@@ -1486,6 +1488,15 @@ static void srpt_handle_send_comp(struct srpt_rdma_ch *ch,
        atomic_inc(&ch->sq_wr_avail);
 
        state = srpt_set_cmd_state(ioctx, SRPT_STATE_DONE);
+       /*
+        * If srpt_check_stop_free() has already been called, we
+        * are safe to go ahead and call transport_generic_free_cmd()
+        * to release the descriptor.
+        */
+       atomic_set(&ioctx->cmd_done, 1);
+
+       if (atomic_read(&ioctx->cmd_stop_free) != 0)
+               transport_generic_free_cmd(&ioctx->cmd, 0, 1, 0);
 
        if (WARN_ON(state != SRPT_STATE_CMD_RSP_SENT
                    && state != SRPT_STATE_MGMT_RSP_SENT
@@ -1737,13 +1748,26 @@ out_err:
 
 static void srpt_check_stop_free(struct se_cmd *cmd)
 {
-       struct srpt_send_ioctx *ioctx;
+       struct srpt_send_ioctx *ioctx = container_of(cmd,
+                               struct srpt_send_ioctx, cmd);
+
+       if (cmd->se_tmr_req)
+               return;
 
-       ioctx = container_of(cmd, struct srpt_send_ioctx, cmd);
-       transport_generic_free_cmd(cmd, 0, 1, 0);
        if (srpt_get_cmd_state(ioctx) != SRPT_STATE_MGMT_RSP_SENT)
                srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
-       kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
+
+       /*
+        * If srpt_handle_send_comp() has already been called from the LLD,
+        * it's safe to call transport_generic_free_cmd() to release the
+        * descriptor.  Otherwise set cmd->cmd_stop_free=1 and let
+        * srpt_handle_send_comp() call transport_generic_free_cmd().
+        */
+       if (atomic_read(&ioctx->cmd_done) != 0) {
+               transport_generic_free_cmd(&ioctx->cmd, 0, 1, 0);
+               kref_put(&ioctx->kref, srpt_put_send_ioctx_kref);
+       } else
+               atomic_set(&ioctx->cmd_stop_free, 1);
 }
 
 /**
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 321b097..02be818 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -218,6 +218,8 @@ struct srpt_send_ioctx {
        spinlock_t              spinlock;
        enum srpt_command_state state;
        struct se_cmd           cmd;
+       atomic_t                cmd_done;
+       atomic_t                cmd_stop_free;
        u64                     tag;
        int                     sg_cnt;
        int                     mapped_sg_count;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
