From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Wed, 28 Jul 2010 12:05:53 -0700
Message-ID: <1280343953.31421.296.camel@chromite.mv.qlogic.com>
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
	 <adaocdreal0.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaocdreal0.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-07-28 at 11:16 -0700, Roland Dreier wrote:
> >  > Actually, I tried to implement the completion callback
>  >  > in a workqueue thread but ipoib_cm_handle_tx_wc() calls
>  >  > netif_tx_lock() which isn't safe unless it is called
>  >  > from an IRQ handler or netif_tx_lock_bh() is called first.
> 
>  > Oh, sounds like a bug in IPoIB.  I guess we could fix it by just
>  > changing it to netif_tx_lock_bh()?  (Or is that not safe from an IRQ handler?)
> 
> Wait, is this still a problem with IPoIB?  As far as I can tell, the
> IPoIB completion handlers don't do anything except enable the NAPI poll
> routine or the transmit ring timer (ie they just do napi_schedule() or
> mod_timer()), so the context that the CQ callback is called in doesn't
> matter.  In particular I don't see any way ipoib_cm_handle_tx_wc() could
> be reached except from the NAPI polling loop.
> 
>  - R.

I don't remember now whether I hit the problem in a backported IPoIB
or in a recent kernel but I did need to single thread and call
local_bh_disable() for completion callbacks or I would get deadlocks.
I just assumed that ULPs were being written with that as a requirement.

This is what makes understanding the "locking conventions" for
IPoIB really complex. Sometimes you need a lock and sometimes
you don't depending on the state of the network stack.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
