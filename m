From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Sat, 7 Aug 2010 19:38:22 -0600
Message-ID: <20100808013822.GA15146@obsidianresearch.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com> <AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com> <adamxtejbes.fsf@roland-alpha.cisco.com> <AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com> <adafwz4g98j.fsf@roland-alpha.cisco.com> <AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com> <20100727182046.GT7920@obsidianresearch.com> <AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 07, 2010 at 09:56:13AM +0200, Bart Van Assche wrote:

> The above implies that one must be careful when applying a common
> Linux practice, that is to defer interrupt handling from IRQ context
> to tasklet context. Since tasklets are executed with interrupts
> enabled, invoking ib_req_notify_cq(cq, IB_CQ_NEXT_COMP) from tasklet
> context may cause concurrent execution of an IB IRQ with an IB
> tasklet. So if ib_poll_cq() is invoked from tasklet context, the
> entire polling loop has to be protected against concurrent execution.
> As far as I know such protection against concurrent execution is not
> necessary inside tasklets that handle other types of hardware.

No, all hardware pretty much works like this. The general flow is:

IRQ happens
 (if level triggered 'ack' the IRQ to the HW, to suppress the level)
SW processes
SW 'does something' to the HW to cause new IRQs to happen
IRQ happens.. repeat..

In the IB case, you get exactly one completion call back and when you
call ib_req_notify_cq/etc then you might get more. There is implicit
locking provided by the HW, in that it does not generate more IRQs
until explicitly told to.

Pretty much every bit of HW works the same way, IRQs stop until the
SW 'does something' to indicate it wants more. If this something is
the very last thing in a tasklet then everything is OK.

A trivial example for ethernet hardware would be someting like this..

IRQ happens whenever packet_buffer_wr != packet_buffer_rd
  When HW sends an IRQ it sets a HW bit to disable further IRQ
  messages
SW processes
SW writes packet_buffer_rd to HW
 HW flips off its disable further IRQ bit
IRQ happens whenever packet_buffer_wr != packet_buffer_rd, which may
 be immediately

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
