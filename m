From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: An IB SRP target
Date: Mon, 21 Feb 2011 14:59:22 -0800
Message-ID: <1298329162.26616.162.camel@haakon2.linux-iscsi.org>
References: <201102142109.19150.bvanassche@acm.org>
	 <AANLkTinQJCfGZxbCkS_rxp=viee2T935ObUCFdoBazSH@mail.gmail.com>
	 <1298285331.26616.100.camel@haakon2.linux-iscsi.org>
	 <AANLkTiksjO7vO7t4MNkr77AWSmbKUSLC_J9CN3y0qVGn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiksjO7vO7t4MNkr77AWSmbKUSLC_J9CN3y0qVGn-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-02-21 at 08:21 -0800, Roland Dreier wrote:
> On Mon, Feb 21, 2011 at 2:48 AM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > +       atomic_t                cmd_done;
> > +       atomic_t                cmd_stop_free;
> 
> What's the point of using atomic_t here?  AFAICT, you only use
> atomic_set and atomic_read with them, which have no special
> ordering powers (look at what those macros expand to).
> 

Ugh, thanks for pointing this out.  For atomic_t inc/dec I always use
smp_mb__after_atomic_[inc,dec](), but I forgot that atomic_set() is a
simple/dumb assignment wrapper that also expects an explict barrier() to
enforce CONFIG_SMP ordering..

So adding the extra explict barrier here is currently required to
address the potential race between TFO->check_stop_free() usage after
TFO->queue_data_in(), and the explict ioctx and ioctl->cmd (struct
se_cmd) release from IB completion queue context.  However, I am
starting to wonder if using TFO->check_stop_free() here with HW target
perhaps does not make the most sense..

The ->check_stop_free() target fabric callback was originally used for
the TCM_Loop SCSI LLD module in order to immmediate complete and release
a struct scsi_cmnd after TFO->queue_data_in() has been called.  In the
case of using IB completion queues, I think checking for a zero of
T_TASK(cmd)->t_transport_active before release the ioctx->cmd might may
more sense..  To give more of an idea of how this currently works, the
following in target_core_transport.c:transport_cmd_check_stop() is
called from TCM backend struct se_device thread context after
TFO->queue_data_in() has been called:

   spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
   .....
        if (transport_off) {
                atomic_set(&T_TASK(cmd)->t_transport_active, 0);
                if (transport_off == 2) {
                        transport_all_task_dev_remove_state(cmd);
                        /*
                         * Clear struct se_cmd->se_lun before the transport_off == 2
                         * handoff to fabric module.
                         */
                        cmd->se_lun = NULL;
                        /*
                         * Some fabric modules like tcm_loop can release
                         * their internally allocated I/O refrence now and
                         * struct se_cmd now.
                         */
                        if (CMD_TFO(cmd)->check_stop_free != NULL) {
                                spin_unlock_irqrestore(
                                        &T_TASK(cmd)->t_state_lock, flags);

                                CMD_TFO(cmd)->check_stop_free(cmd);
                                return 1;
                        }
                }
                spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
		return 0;
        }
   .....
   spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
   
So given this logic, I think waiting for T_TASK(cmd)->t_transport_active
to return to zero before releasing ioctx->cmd in the IB completion path
might be a better way handle this..  However, to do this properly w/o
holding T_TASK(cmd)->t_state_lock in the completion path is going to
require a small re-org of the above from transport_cmd_check_stop() for
the transport_off == 2 case that TFO->queue_data_in() is invoking..

Thoughts Roland..?

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
