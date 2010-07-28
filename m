From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Wed, 28 Jul 2010 10:51:53 -0700
Message-ID: <1280339513.31421.264.camel@chromite.mv.qlogic.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	 <AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	 <adamxtejbes.fsf@roland-alpha.cisco.com>
	 <AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	 <adafwz4g98j.fsf@roland-alpha.cisco.com>
	 <AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
	 <20100727182046.GT7920@obsidianresearch.com>
	 <AANLkTimAS6znoCCw33ipVV-W-e1BJS93Fxzp-oe0jO4u@mail.gmail.com>
	 <ada62zzfqpj.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada62zzfqpj.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Actually, I tried to implement the completion callback
in a workqueue thread but ipoib_cm_handle_tx_wc() calls
netif_tx_lock() which isn't safe unless it is called
from an IRQ handler or netif_tx_lock_bh() is called first.

On Wed, 2010-07-28 at 10:42 -0700, Roland Dreier wrote:
> > - Some time ago I observed that the kernel reported soft lockups
>  > because of spin_lock() calls inside a completion handler. These
>  > spinlocks were not locked in any other context than the completion
>  > handler itself. And the lockups disappeared after having replaced the
>  > spin_lock() calls by spin_lock_irqsave(). Can it be concluded from
>  > this observation that completion handlers are not always invoked from
>  > interrupt context ?
> 
> Did you get a soft lockup report or a lockdep report?  Anyway, the very
> next paragraph of the documentation I quoted says:
> 
>   The context in which completion event and asynchronous event
>   callbacks run is not defined.  Depending on the low-level driver, it
>   may be process context, softirq context, or interrupt context.
>   Upper level protocol consumers may not sleep in a callback.
> 
> So yes, it is possible that a completion callback gets called in
> non-interrupt context.
> 
> However as far as I know, at least mthca and mlx4 only call completion
> callbacks from the interrupt handler.  But without the actual code in
> question it's hard to know what the real problem was.
> 
>  - R.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
