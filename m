From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Tue, 08 Jul 2014 23:22:00 -0700
Message-ID: <1404886920.11176.13.camel@haswell.thedillows.org>
References: <53B55E55.5040907@acm.org> <53B55F1F.6000704@acm.org>
		 <1404407103.32754.3.camel@haswell.thedillows.org>
		 <53B6868A.3070705@acm.org>
	 <1404501176.16296.18.camel@haswell.thedillows.org>
	 <53BBF6E3.3040403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BBF6E3.3040403-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2014-07-08 at 15:49 +0200, Bart Van Assche wrote:
> Thanks for digging up this information and also for sharing it.

Sure thing; it's a bummer that something in the email must have tickled
vger's taboo filters...

>  This is interesting. What I noticed is that the in the SRP target
> driver attached to the previous e-mail ("srptest.c") one command at a
> time is processed. However, in the SRP target driver I ran my own
> tests with (based on SCST) multiple SCSI commands are processed
> simultaneously by a single thread. A finite state machine is
> associated with each SCSI command and events like IB work completions
> trigger transitions of that state machine. So that might be a possible
> explanation why my measurement results were different.

True, I expect to see a difference between those models, and I suspect
we were also measuring different values. I was looking at IOPS, and that
I saw a drop when adding the batching (as well as blk-iopoll) tells me
that the test driver was not the limiting factor -- it did not change
between them.

I'll readily agree that it is not a "real" load -- it purposefully does
not do any RDMA reads or writes; it just responds to the request as fast
as possible. The fact that it is single threaded shouldn't matter in
this context -- the IB streaming benchmarks are also single threaded and
can do many more operations per second.

I'll also admit that perhaps your threaded target bunches up responses a
bit, so perhaps the initiator sees enough work to make the batching
worth it for your tests. It'd be a bit surprising, but not overly so.

Regardless, it'd be nice to see your numbers for this change, and if you
have time to run it against my test target and post those for
comparison, that'd be swell. I no longer have much in the way of access
to relevant IB hardware -- just some SDR and perhaps a few DDR mthca
cards at home, and none are currently in machines.

> However, before I repost (a variant of) this patch I will try to find
> a way to combine the advantages of interrupt-based processing (low
> latency) and the blk-iopoll approach (minimal time spent in interrupt
> context).

Have you run an idle-soaking process like zc (by Andrew Morton, back in
the days of sendfile) to measure the CPU usage of the different
approaches? Those would be some interesting numbers in conjunction with
the latency and IOPs numbers -- it would give everyone a picture of the
trade-offs involved.

Thanks, and I may have plenty of questions, I'm glad you're looking at
this.
Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
