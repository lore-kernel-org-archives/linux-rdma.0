From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Sun, 8 Aug 2010 17:51:04 -0600
Message-ID: <20100808235104.GA32488@obsidianresearch.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com> <AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com> <adamxtejbes.fsf@roland-alpha.cisco.com> <AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com> <adafwz4g98j.fsf@roland-alpha.cisco.com> <AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com> <20100727182046.GT7920@obsidianresearch.com> <AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g@mail.gmail.com> <20100808013822.GA15146@obsidianresearch.com> <AANLkTi=My1aK3VsYejeVeRSqo+7RNMX2x6osGNbBERvx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=My1aK3VsYejeVeRSqo+7RNMX2x6osGNbBERvx-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 08, 2010 at 08:16:55PM +0200, Bart Van Assche wrote:
> On Sun, Aug 8, 2010 at 3:38 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > [ ... ]
> >
> > No, all hardware pretty much works like this. The general flow is:
> >
> > IRQ happens
> > ?(if level triggered 'ack' the IRQ to the HW, to suppress the level)
> > SW processes
> > SW 'does something' to the HW to cause new IRQs to happen
> > IRQ happens.. repeat..
> >
> > [ ... ]
> 
> You might have missed or forgotten the point that was made in the
> first message of this thread.

Erm, Roland asserted the problem you were thinking about did not exist
in Linux, and I thought you agreed?

http://www.spinics.net/lists/linux-rdma/msg05031.html

Was there something else in that message?

I agree there is some variation in what HW is sensitive to for
generating IRQs, and I do agree that making ib_req_notify_cq an event
sensitive condition (ie a new CQ was added) rather than a state
sensitive call back (ie the CQ is not empty) often requires more
code. But it does not fundamentally make IB any different than every
thing else - and it fits within the general flow I outline above.

Further, the approach you outline in your follow on message for
blkio, has problems.. Look at how IPOIB does NAPI to see how
this must look.

1) ib_req_notify_cq must only be called if you are processing less
   the budget
2) blk_iopoll_complete must be called prior to ib_req_notify_cq, since
   call ib_req_notify_cq can immediately generate an interrupt, and
   that interrupt must see the sched bit as cleared. If
   ib_req_notify_cq races then you have to blkiopoll_reschedual.
   (and maybe continue looping depending on your strategy for
    call blkio_poll_disable elsewhere)
3) The idea you can hand off to normal processing if
   blk_iopoll_sched_prep fails in the ISR does not work for anything
   relying on the non-rentrancy of the blkio_poll call back for
   locking. This seems to describe the SRP driver.

There is no easy way you can switch from processing in a non-ISR
context to processing in an interrupt on the fly.. Each relies on
different implicit locking and switching between those two domains is
ugly. Something like this pseudo-code:

srp_supress_ib_req_notify_cq = 1;
blkio_poll_disable();

// now there will be no more blkio calls, and no more interrupts!

// Neuter the ISR while we are piddling:
set_bit(IOPOLL_F_DISABLE, &iop->state);

// Drain the CQ
poll_again:
while (srp_recv_poll_once())
   ;

// Try to swith back to interrupts!
disable_interrupts();
ret = ib_req_notify_cq(priv->recv_cq,
	               IB_CQ_NEXT_COMP |
                       IB_CQ_REPORT_MISSED_EVENTS));
if (ret) {
   enable_interrupts();
   goto poll_agian;
}

// OK! We will *definately* get an interrupt now!
srp_do_not_use_blkio_poll = 1;
enable_interrupts();

Hope this helps,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
