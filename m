From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Sat, 07 Aug 2010 09:32:30 -0700
Message-ID: <adavd7mz8m9.fsf@roland-alpha.cisco.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
	<adafwz4g98j.fsf@roland-alpha.cisco.com>
	<AANLkTimAk0k-q1EKjaXOadoXvKXbEN9nAky0w1rjixxB@mail.gmail.com>
	<20100727182046.GT7920@obsidianresearch.com>
	<AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimc3iS8=8ZQ9u8tOLP4-q_e+o0=AncZj-Mbre2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sat, 7 Aug 2010 09:56:13 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The above implies that one must be careful when applying a common
 > Linux practice, that is to defer interrupt handling from IRQ context
 > to tasklet context. Since tasklets are executed with interrupts
 > enabled, invoking ib_req_notify_cq(cq, IB_CQ_NEXT_COMP) from tasklet
 > context may cause concurrent execution of an IB IRQ with an IB
 > tasklet. So if ib_poll_cq() is invoked from tasklet context, the
 > entire polling loop has to be protected against concurrent execution.
 > As far as I know such protection against concurrent execution is not
 > necessary inside tasklets that handle other types of hardware.

Not sure that I follow the problem you're worried about.  A given
tasklet can only be running on one CPU at any one time -- if an
interrupt occurs and reschedules the tasklet then it just runs again
when it exits.

Also I'm not sure I understand why this is special for IB hardware --
standard practice is for interrupt handlers to clear the interrupt
source and reenable interrupts, so I don't see why the same thing you
describe can't happen with any interrupt-generating device that defers
work to a tasklet.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
