From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Tue, 27 Jul 2010 14:15:27 -0600
Message-ID: <20100727201527.GU7920@obsidianresearch.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com> <AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com> <adamxtejbes.fsf@roland-alpha.cisco.com> <AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com> <adafwz4g98j.fsf@roland-alpha.cisco.com> <AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com> <20100727182046.GT7920@obsidianresearch.com> <AANLkTimAS6znoCCw33ipVV-W-e1BJS93Fxzp-oe0jO4u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimAS6znoCCw33ipVV-W-e1BJS93Fxzp-oe0jO4u-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 27, 2010 at 09:28:54PM +0200, Bart Van Assche wrote:

> I have two more questions: - Some time ago I observed that the
> kernel reported soft lockups because of spin_lock() calls inside a
> completion handler. These spinlocks were not locked in any other
> context than the completion handler itself. And the lockups
> disappeared after having replaced the spin_lock() calls by
> spin_lock_irqsave(). Can it be concluded from this observation that
> completion handlers are not always invoked from interrupt context ?

I don't know.. It wouldn't surprise me if there were some error paths
that called completion handlers outside an IRQ context, but as Roland
pointed out the API guarantee is that this never happens in parallel
with interrupt called cases.

> - The function handle_edge_irq() in kernel/irq/chip.c invokes the
> actual interrupt handler while the spinlock desc->lock is not
> locked.  Does that mean that a completion interrupt can get lost due
> to the

It holds desc->lock while manipulating the flags, so IRQ_PENDING will
be set by CPU 2 and CPU 1 will notice once and re-invoke the handler
once it re-locks desc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
