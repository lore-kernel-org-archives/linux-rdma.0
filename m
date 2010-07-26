From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: fix race condition on srp_target_port.req_lim
Date: Mon, 26 Jul 2010 09:55:01 +0200
Message-ID: <AANLkTikF=KAmS+e4AKE1tx+XLqedJm6q1KcDuhptneXY@mail.gmail.com>
References: <201007251812.42757.bvanassche@acm.org>
	<1280082992.10629.44.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280082992.10629.44.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 25, 2010 at 8:36 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
>
> On Sun, 2010-07-25 at 18:12 +0200, Bart Van Assche wrote:
> > In the current implementation of ib_srp the req_lim field of
> > struct srp_target_port can be manipulated in a non-atomic way by
> > more than one CPU at a time: one CPU can be modifying req_lim in
> > function srp_process_rsp() while another CPU can concurrently be
> > decrementing req_lim in function __srp_get_tx_iu(). This is a
> > race condition which can result in incorrect manipulation of the
> > req_lim field. The patch below fixes this race condition by
> > converting all manipulations of req_lim into atomic operations.
>
> This is not needed -- all modifications of target->req_lim are protected
> by scsi_dev->host_lock. It is held implicitly in srp_queuecommand() by
> the SCSI mid-layer, and we take that lock before modifying req_lim
> elsewhere -- or we're initializing and there won't be concurrent access.

It would be helpful for anyone who is reviewing or modifying the SRP
initiator source code if the locking policy was documented. As an
example, in kernels 2.6.33 and before there was a single notification
processing function srp_completion() that incremented target->tx_tail
non-atomically and without protection of scsi_host->host_lock. It was
not possible to tell from the source code comments whether or not this
access pattern was intentional.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
