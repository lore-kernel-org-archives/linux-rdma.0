From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Fri, 10 Nov 2017 14:27:59 -0500
Message-ID: <4B49C591-8671-4683-A437-215BAA6B56CD@oracle.com>
References: <20171108095742.25365-1-sagi@grimberg.me> <F7FAF7FD-AE2C-4428-A779-06C9768E0C73@oracle.com> <b502f211-c477-3acd-be01-eaf645edc117@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b502f211-c477-3acd-be01-eaf645edc117-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 9, 2017, at 12:06 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
>> Hi Sagi, glad to see progress on this!
> 
> Hi Chuck,
> 
>> When running on the same CPU, Send and Receive completions compete
>> for the same finite CPU resource. In addition, they compete with
>> soft IRQ tasks that are also pinned to that CPU, and any other
>> BOUND workqueue tasks that are running there.
> 
> Thats true.
> 
>> Send and Receive completions often have significant work to do
>> (for example, DMA syncing or unmapping followed by some parsing
>> of the completion results) and are all serialized on ib_poll_wq or
>> by soft IRQ.
> 
> Yes, that's correct.
> 
>> This limits IOPS, and restricts other users of that shared CQ.
> 
> I agree that's true for a single queue aspect. When multiple queues
> are used, usually centralizing context to their cpu core is probably
> the best approach to achieve linear scalability, otherwise we pay
> more for context switches, cacheline bounces, resource contention, etc.
> 
>> I recognize that handling interrupts on the same core where they
>> fired is best, but some of this work has to be allowed to migrate
>> when this CPU core is already fully utilized. A lot of the RDMA
>> core and ULP workqueues are BOUND, which prevents task migration,
>> even in the upper layers.
> 
> So for the ib_comp_wq, started as an UNBOUND workqueue, but the fact
> that unbound worqueue workers are not cpu bound did not fit well
> with cpu/numa locality used with high-end storage devices and was a source of latency
> 
> See:
> --
> commit b7363e67b23e04c23c2a99437feefac7292a88bc
> Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Date:   Wed Mar 8 22:03:17 2017 +0200
> 
>    IB/device: Convert ib-comp-wq to be CPU-bound
> 
>    This workqueue is used by our storage target mode ULPs
>    via the new CQ API. Recent observations when working
>    with very high-end flash storage devices reveal that
>    UNBOUND workqueue threads can migrate between cpu cores
>    and even numa nodes (although some numa locality is accounted
>    for).
> 
>    While this attribute can be useful in some workloads,
>    it does not fit in very nicely with the normal
>    run-to-completion model we usually use in our target-mode
>    ULPs and the block-mq irq<->cpu affinity facilities.
> 
>    The whole block-mq concept is that the completion will
>    land on the same cpu where the submission was performed.
>    The fact that our submitter thread is migrating cpus
>    can break this locality.
> 
>    We assume that as a target mode ULP, we will serve multiple
>    initiators/clients and we can spread the load enough without
>    having to use unbound kworkers.
> 
>    Also, while we're at it, expose this workqueue via sysfs which
>    is harmless and can be useful for debug.
> --
> 
> The rational is that storage targets (or file servers) usually serve
> multiple clients and the spreading across cpu cores for more efficient
> utilization would come from spreading the completion vectors.

This works for me. It seems like an appropriate design.

On targets, the CPUs are typically shared with other ULPs,
so there is little more to do.

On initiators, CPUs are shared with user applications.
In fact, applications will use the majority of CPU and
scheduler resources.

Using BOUND workqueues seems to be very typical in file
systems, and we may be stuck with that design. What we
can't have is RDMA completions forcing user processes to
pile up on the CPU core that handles Receives.

Quite probably, initiator ULP implementations will need
to ensure explicitly that their transactions complete on
the same CPU core where the application started them.
The downside is this frequently adds the latency cost of
a context switch.


> However if this is not the case, then by all means we need a knob for
> it (maybe have two ib completion workqueues and ULP will choose).
> 
>> I would like to see a capability of intelligently spreading the
>> CQ workload for a single QP onto more CPU cores.
> 
> That is a different use case than what I was trying to achieve. In
> ulp consumers such as nvme-rdma (or srp and alike) will use multiple
> qp-cq pairs (usually even per-core) and for that use-case, probably
> cpu locality is a better approach to take imo.
> 
> How likely that multiple NFS mount-points will be used on a single
> server? Is that something you are looking for to optimize? or is
> the single (or few) mount-points per server the common use-case?
> If its the latter, then I perfectly agree with you, and we should
> come up with a core api for it (probably rds or smc will want it
> too).
> 
>> As an example, I've found that ensuring that NFS/RDMA's Receive
>> and Send completions are handled on separate CPU cores results in
>> slightly higher IOPS (~5%) and lower latency jitter on one mount
>> point.
> 
> That is valuable information. I do agree that what you are proposing
> is useful. I'll need some time to think on that.
> 
>> This is more critical now that our ULPs are handling more Send
>> completions.
> 
> We still need to fix some more...
> 
>>> In addition, we introduce a configfs knob to our nvme-target to
>>> bound I/O threads to a given cpulist (can be a subset). This is
>>> useful for numa configurations where the backend device access is
>>> configured with care to numa affinity, and we want to restrict rdma
>>> device and I/O threads affinity accordingly.
>>> 
>>> The patch set convert iser, isert, srpt, svcrdma, nvme-rdma and
>>> nvmet-rdma to use the new API.
>> Is there a straightforward way to assess whether this work
>> improves scalability and performance when multiple ULPs share a
>> device?
> 
> I guess the only way is running multiple ULPs in parallel? I tried
> running iser+nvme-rdma in parallel but my poor 2 VMs are not the best
> performance platform I can evaluate this...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
