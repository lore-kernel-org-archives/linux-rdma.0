From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: An IB SRP target
Date: Mon, 21 Feb 2011 15:10:08 -0800
Message-ID: <1298329808.26616.174.camel@haakon2.linux-iscsi.org>
References: <201102142109.19150.bvanassche@acm.org>
	 <AANLkTinQJCfGZxbCkS_rxp=viee2T935ObUCFdoBazSH@mail.gmail.com>
	 <1298285331.26616.100.camel@haakon2.linux-iscsi.org>
	 <AANLkTikL-5Az6tQuPxg77T5H5xNKYvL4r9kBjyt87QBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikL-5Az6tQuPxg77T5H5xNKYvL4r9kBjyt87QBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-02-21 at 19:08 +0100, Bart Van Assche wrote:
> On Mon, Feb 21, 2011 at 11:48 AM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > Using a completion queue here with possibility of the extra context
> > switch is IMHO an unnecessary overhead.  The main issue here is that
> > target core needs to be able to clear the struct se_cmd descriptor after
> > invoking the struct target_core_fabric_ops->send_data_in() callback, but
> > before the call to srpt_handle_send_comp() -> release of the fabric
> > dependent descriptor containing our struct se_cmd can happen.
> >
> > I prefer something along the lines of the patch below for
> > lio-core-2.6.git/tcm_ib_srpt to follow what other TCM v4 HW fabric
> > modules are currently doing wrt to TFO->check_stop_free() usage.  This
> > patch has been compile tested only at this point, but I will be testing
> > this on IB hardware in the upcoming week.  Please review.
> 
> Hello Nicholas,
> 
> Thanks for the review. Regarding the two issues you mentioned:
> - As far as I understood it is safe to send back data to the initiator
> concurrently with the target core processing new commands ?

Yes, > 1 TCQ depth is not the issue.  This issue at hand is how to clear
the struct se_cmd in transport_cmd_check_stop() when using the optional
TFO->check_stop_free() call after TFO->queue_data_in() has been invoked.

> In that
> case no new counters are necessary - the existing kref in
> srpt_send_ioctx is sufficient. The patch that re-enables concurrent
> SCSI READs can be found here:
> https://github.com/bvanassche/srpt/commit/cd8d5e9a6501f5b3a4315c261e945c201c4ce0ae.
> Please let me know if anyone wants to see that patch posted on the
> list. Also, please note that your patch contained the same race as my
> original patch: directly invoking srpt_unmap_sg_to_ib_sge() from the
> check_stop_free() callback makes that call race with the ongoing RDMA
> write. To Roland: I haven't found a way to invoke
> srpt_put_send_ioctx() without using an atomic counter.

Ok, so this sounds like srpt_unmap_sg_to_ib_sge() should be getting
called from the IB completion queue context then..

>  If you see an
> approach to avoid that atomic counter, suggestions are welcome.
> - Regarding making the check_stop_free() callback a NOOP for task
> management commands: are you sure that that's a good idea ? I have
> tried to do that, and the following appeared in the kernel log during
> module unload:
> 
> CORE_HBA[0] - Detached HBA from Generic Target Core
> =============================================================================
> BUG se_tmr_cache: Objects remaining on kmem_cache_close()
> -----------------------------------------------------------------------------
> 
> INFO: Slab 0xffffea0000119c00 objects=16 used=1 fp=0xffff880005080100
> flags=0x1000000000000080
> Pid: 18117, comm: rmmod Not tainted 2.6.38-rc5-dbg+ #4
> Call Trace:
>  [<ffffffff81123f76>] ? slab_err+0x96/0xb0
>  [<ffffffff81126da4>] ? __slab_alloc+0x124/0x540
>  [<ffffffff811277c8>] ? __kmalloc+0xf8/0x1b0
>  [<ffffffff81081a0d>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff811277e8>] ? __kmalloc+0x118/0x1b0
>  [<ffffffff81128cf7>] ? kmem_cache_destroy+0x177/0x3f0
>  [<ffffffffa02e53c6>] ? release_se_global+0x36/0xb0 [target_core_mod]
>  [<ffffffffa02d10ab>] ? target_core_exit_configfs+0x17b/0x190 [target_core_mod]
>  [<ffffffff8109340f>] ? sys_delete_module+0x16f/0x260
>  [<ffffffff81002fdc>] ? sysret_check+0x27/0x62
>  [<ffffffff81087a8d>] ? trace_hardirqs_on_caller+0x14d/0x190
>  [<ffffffff81002fab>] ? system_call_fastpath+0x16/0x1b
> INFO: Object 0xffff880005080000 @offset=0
> INFO: Allocated in core_tmr_alloc_req+0x33/0x80 [target_core_mod]
> age=2442 cpu=1 pid=18088
> SLUB se_tmr_cache: kmem_cache_destroy called for cache that still has objects.
> Pid: 18117, comm: rmmod Not tainted 2.6.38-rc5-dbg+ #4
> Call Trace:
>  [<ffffffff81128ee4>] ? kmem_cache_destroy+0x364/0x3f0
>  [<ffffffffa02e53c6>] ? release_se_global+0x36/0xb0 [target_core_mod]
>  [<ffffffffa02d10ab>] ? target_core_exit_configfs+0x17b/0x190 [target_core_mod]
>  [<ffffffff8109340f>] ? sys_delete_module+0x16f/0x260
>  [<ffffffff81002fdc>] ? sysret_check+0x27/0x62
>  [<ffffffff81087a8d>] ? trace_hardirqs_on_caller+0x14d/0x190
>  [<ffffffff81002fab>] ? system_call_fastpath+0x16/0x1b
> 

Hmmm, I don't recall seeing this with TCM_Loop with sg_reset, but I will
double check with the lastest for-39 WIP fabric module code using
TFO->check_stop_free().

Thanks!

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
