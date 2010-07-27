From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Tue, 27 Jul 2010 21:28:54 +0200
Message-ID: <AANLkTimAS6znoCCw33ipVV-W-e1BJS93Fxzp-oe0jO4u@mail.gmail.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	<adafwz4g98j.fsf@roland-alpha.cisco.com>
	<AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
	<20100727182046.GT7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100727182046.GT7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 27, 2010 at 8:20 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> On Tue, Jul 27, 2010 at 08:03:25PM +0200, Bart Van Assche wrote:
>
> > As far as I know it is not possible for a HCA to tell whether or not a
> > CPU has finished executing the interrupt it triggered. So it is not
> > possible for the HCA to implement the above requirement by delaying
> > the generation of a new interrupt -- implementing the above
>
> Linux does not allow interrupts to re-enter.. Read through
> kernel/irq/chip.c handle_edge_irq to get a sense of how that is done
> for MSI. Looked to me like all the CQ call backs flowed from the
> interrupt handler in mlx4?

Thanks for the feedback -- I had tried to look up that information but
hadn't found it yet.

I have two more questions:
- Some time ago I observed that the kernel reported soft lockups
because of spin_lock() calls inside a completion handler. These
spinlocks were not locked in any other context than the completion
handler itself. And the lockups disappeared after having replaced the
spin_lock() calls by spin_lock_irqsave(). Can it be concluded from
this observation that completion handlers are not always invoked from
interrupt context ?
- The function handle_edge_irq() in kernel/irq/chip.c invokes the
actual interrupt handler while the spinlock desc->lock is not locked.
Does that mean that a completion interrupt can get lost due to the
following (unlikely) event order ?
* completion interrupt is triggered on CPU 1.
* handle_edge_irq() sets the IRQ_INPROGRESS flag and invokes the
completion handler on CPU 1.
* The completion handler reenables the completion interrupt via
ib_req_notify_cq().
* Before the IRQ_INPROGRESS flag is cleared by handle_edge_irq(), a
new completion interrupt is triggered on CPU 2.
* handle_edge_irq() is invoked on CPU 2 and exits immediately because
IRQ_INPROGRESS is still set.
* handle_edge_irq() clears IRQ_INPROGRESS on CPU 1.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
