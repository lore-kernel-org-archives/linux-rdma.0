From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Mon, 9 Aug 2010 09:57:56 +0200
Message-ID: <AANLkTimfouLhLCcbxx84d94iztT7PJza+2ZaK50XczT=@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	<adafwz4g98j.fsf@roland-alpha.cisco.com>
	<AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
	<20100727182046.GT7920@obsidianresearch.com>
	<AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g@mail.gmail.com>
	<20100808013822.GA15146@obsidianresearch.com>
	<AANLkTi=My1aK3VsYejeVeRSqo+7RNMX2x6osGNbBERvx@mail.gmail.com>
	<20100808235104.GA32488@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100808235104.GA32488-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 9, 2010 at 1:51 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> [ ... ]
>
> Further, the approach you outline in your follow on message for
> blkio, has problems.. Look at how IPOIB does NAPI to see how
> this must look.
>
> 1) ib_req_notify_cq must only be called if you are processing less
> =A0 the budget
> 2) blk_iopoll_complete must be called prior to ib_req_notify_cq, sinc=
e
> =A0 call ib_req_notify_cq can immediately generate an interrupt, and
> =A0 that interrupt must see the sched bit as cleared. If
> =A0 ib_req_notify_cq races then you have to blkiopoll_reschedual.
> =A0 (and maybe continue looping depending on your strategy for
> =A0 =A0call blkio_poll_disable elsewhere)
> 3) The idea you can hand off to normal processing if
> =A0 blk_iopoll_sched_prep fails in the ISR does not work for anything
> =A0 relying on the non-rentrancy of the blkio_poll call back for
> =A0 locking. This seems to describe the SRP driver.

Good catches.

> There is no easy way you can switch from processing in a non-ISR
> context to processing in an interrupt on the fly.. Each relies on
> different implicit locking and switching between those two domains is
> ugly. Something like this pseudo-code:
>
> srp_supress_ib_req_notify_cq =3D 1;
> blkio_poll_disable();
>
> // now there will be no more blkio calls, and no more interrupts!
>
> // Neuter the ISR while we are piddling:
> set_bit(IOPOLL_F_DISABLE, &iop->state);
>
> // Drain the CQ
> poll_again:
> while (srp_recv_poll_once())
> =A0 ;
>
> // Try to swith back to interrupts!
> disable_interrupts();
> ret =3D ib_req_notify_cq(priv->recv_cq,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IB_CQ_NEXT_COMP |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IB_CQ_REPORT_MISSED_EVENT=
S));
> if (ret) {
> =A0 enable_interrupts();
> =A0 goto poll_agian;
> }
>
> // OK! We will *definately* get an interrupt now!
> srp_do_not_use_blkio_poll =3D 1;
> enable_interrupts();

Regarding the above pseudo-code: I do not know of any Linux kernel
version that defines the functions disable_interrupts() and
enable_interrupts(). There exist functions however that allow to
disable and re-enable interrupts on the local CPU. But for the above
pseudo-code, disabling interrupts on the local CPU only would make the
above code behave incorrectly on multiprocessor systems. And as far as
I know there are no functions available to disable all interrupts on
all CPUs - which would be a very expensive operation anyway. Invoking
disable_irq() and enable_irq() could help, but this requires knowledge
of the interrupt number, which is not available in the context of a
completion handler. So I'm not sure whether it is possible to
translate the above approach from pseudo-code to real code.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
