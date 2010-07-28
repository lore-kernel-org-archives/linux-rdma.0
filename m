From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Wed, 28 Jul 2010 11:11:41 -0700
Message-ID: <1280340701.31421.267.camel@chromite.mv.qlogic.com>
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
	 <adask33eb36.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask33eb36.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-07-28 at 11:05 -0700, Roland Dreier wrote:
> > Actually, I tried to implement the completion callback
>  > in a workqueue thread but ipoib_cm_handle_tx_wc() calls
>  > netif_tx_lock() which isn't safe unless it is called
>  > from an IRQ handler or netif_tx_lock_bh() is called first.
> 
> Oh, sounds like a bug in IPoIB.  I guess we could fix it by just
> changing it to netif_tx_lock_bh()?  (Or is that not safe from an IRQ handler?)

netif_tx_lock_bh() is an inline function for
	local_bh_disable();
        netif_tx_lock();

so I meant to say local_bh_disable(), not netif_tx_lock_bh().

Basically, we would need a "irqsave" version of netif_tx_lock()
so that it could be called from either IRQ or non-IRQ context
and save/restore the prior state.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
