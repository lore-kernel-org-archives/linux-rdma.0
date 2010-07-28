From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Wed, 28 Jul 2010 20:01:24 +0200
Message-ID: <AANLkTikmv+5moGVsJSB6UC+_mv7x84E4rSg6w==jYxNq@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	<adafwz4g98j.fsf@roland-alpha.cisco.com>
	<AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
	<20100727182046.GT7920@obsidianresearch.com>
	<AANLkTimAS6znoCCw33ipVV-W-e1BJS93Fxzp-oe0jO4u@mail.gmail.com>
	<ada62zzfqpj.fsf@roland-alpha.cisco.com>
	<1280339513.31421.264.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280339513.31421.264.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 28, 2010 at 7:51 PM, Ralph Campbell
<ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2010-07-28 at 10:42 -0700, Roland Dreier wrote:
>> > - Some time ago I observed that the kernel reported soft lockups
>> =A0> because of spin_lock() calls inside a completion handler. These
>> =A0> spinlocks were not locked in any other context than the complet=
ion
>> =A0> handler itself. And the lockups disappeared after having replac=
ed the
>> =A0> spin_lock() calls by spin_lock_irqsave(). Can it be concluded f=
rom
>> =A0> this observation that completion handlers are not always invoke=
d from
>> =A0> interrupt context ?
>>
>> Did you get a soft lockup report or a lockdep report? =A0Anyway, the=
 very
>> next paragraph of the documentation I quoted says:
>>
>> =A0 The context in which completion event and asynchronous event
>> =A0 callbacks run is not defined. =A0Depending on the low-level driv=
er, it
>> =A0 may be process context, softirq context, or interrupt context.
>> =A0 Upper level protocol consumers may not sleep in a callback.
>>
>> So yes, it is possible that a completion callback gets called in
>> non-interrupt context.
>>
>> However as far as I know, at least mthca and mlx4 only call completi=
on
>> callbacks from the interrupt handler. =A0But without the actual code=
 in
>> question it's hard to know what the real problem was.
>
> Actually, I tried to implement the completion callback
> in a workqueue thread but ipoib_cm_handle_tx_wc() calls
> netif_tx_lock() which isn't safe unless it is called
> from an IRQ handler or netif_tx_lock_bh() is called first.

Has anyone already tried to enable threaded IRQ mode for IB completion
interrupts ? Threaded IRQs are one of the cornerstones of the
real-time Linux patch for reducing interrupt latency.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
