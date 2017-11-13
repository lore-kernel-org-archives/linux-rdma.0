From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Mon, 13 Nov 2017 22:47:30 +0200
Message-ID: <a79c3899-5599-aa7e-5c5b-75ec98cdc490@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <F7FAF7FD-AE2C-4428-A779-06C9768E0C73@oracle.com>
 <b502f211-c477-3acd-be01-eaf645edc117@grimberg.me>
 <4B49C591-8671-4683-A437-215BAA6B56CD@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B49C591-8671-4683-A437-215BAA6B56CD-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Chuck,

> This works for me. It seems like an appropriate design.
> 
> On targets, the CPUs are typically shared with other ULPs,
> so there is little more to do.
> 
> On initiators, CPUs are shared with user applications.
> In fact, applications will use the majority of CPU and
> scheduler resources.
> 
> Using BOUND workqueues seems to be very typical in file
> systems, and we may be stuck with that design. What we
> can't have is RDMA completions forcing user processes to
> pile up on the CPU core that handles Receives.

I'm not sure I understand what you mean by:
"RDMA completions forcing user processes to pile up on the CPU core that
handles Receives"

My baseline assumption is that other cpu cores have their own tasks
that they are handling, and making RDMA completions be processed
on a different cpu is blocking something, maybe not the submitter,
but something else. So under the assumption that completion processing
always comes on the expense of something, choosing anything else other
than the cpu core that the I/O was submitted on is an inferior choice.

Is my understanding correct that you are trying to emphasize that
unbound workqueues make sense on some use-cases for initiator drivers
(like xprtrdma)?

> Quite probably, initiator ULP implementations will need
> to ensure explicitly that their transactions complete on
> the same CPU core where the application started them.

Just to be clear, you mean the CPU core where the I/O was
submitted correct?

> The downside is this frequently adds the latency cost of
> a context switch.

That is true, if the interrupt was directed to another cpu core
then a context-switch will need to be involved, and that adds latency.

I'm stating the obvious here, but this issue historically existed in
various devices ranging from network to storage and more. The solution
is using multiple queues (ideally per-cpu) and try to have minimal
synchronization in the submission path (like XPS for networking) and
keep completions as local as possible to the submission cores (like flow
steering).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
