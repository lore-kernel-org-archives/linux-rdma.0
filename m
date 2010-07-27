From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: About a shortcoming of the verbs API
Date: Tue, 27 Jul 2010 09:50:04 -0700
Message-ID: <adafwz4g98j.fsf@roland-alpha.cisco.com>
References: <AANLkTi=zowawGDjyh+uKve_NiRNMXcrqjAk0hRxGSMOv@mail.gmail.com>
	<AANLkTinHRnt-jvy0xBOAPUDGcfx6=V6rkRT3t0Ja52FP@mail.gmail.com>
	<adamxtejbes.fsf@roland-alpha.cisco.com>
	<AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinYuyCqJ6_wq6GH0vQGAY-mwC=7ZLicBnXO+efB-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Tue, 27 Jul 2010 10:33:42 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > In the applications I'm familiar with InfiniBand is being used not
 > only because of its low latency but also because of its high
 > throughput.

Yes, I seem to recall hearing that people care about throughput as well.

 > In order to handle such loads efficiently, interrupts have to be
 > spread over multiple CPUs.

Let's look at what you say you want here:

 - strict in-order processing of completions
 - work spread across multiple CPUs

Do you see that the two goals are contradictory?  If you are running
work on multiple CPUs in parallel, then there can't be an order assumed
between CPUs -- otherwise you serialize the processing and lose all the
benefit of parallelism.

 > Switching from a single receive queue to multiple receive queues is an
 > interesting alternative, but is not possible without changing the
 > communication protocol between client and server. Changing the
 > communication protocol is not always possible, especially when the
 > communication protocol has been defined by a standards organization.

If you only have a single client talking to a single server over a
single connection, then yes the opportunities for parallelism are
limited.

By the way, looking at VipCQNotify further, I'm not sure I follow
exactly the race you're worried about.  If you're willing to do your
processing from the completion notification callback (which seems to be
the approach that VipCQNotify forces), then doesn't the following (from
Documentation/infiniband/core_locking.txt):

  The low-level driver is responsible for ensuring that multiple
  completion event handlers for the same CQ are not called
  simultaneously.  The driver must guarantee that only one CQ event
  handler for a given CQ is running at a time.  In other words, the
  following situation is not allowed:

        CPU1                                    CPU2

  low-level driver ->
    consumer CQ event callback:
      /* ... */
      ib_req_notify_cq(cq, ...);
                                        low-level driver ->
      /* ... */                           consumer CQ event callback:
                                            /* ... */
      return from CQ event handler

mean that the problem you are complaining about doesn't actually exist?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
