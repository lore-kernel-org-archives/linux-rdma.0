From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: RFC: CQ pools and implicit CQ resource allocation
Date: Tue, 13 Sep 2016 00:12:59 +0300
Message-ID: <65940603-4226-c0c1-697d-deea27d067a7@grimberg.me>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
 <d0c645eb-3674-2841-bdb7-8b9e6fd46473@grimberg.me>
 <00e001d20d03$ea891100$bf9b3300$@opengridcomputing.com>
 <6dd3ecbd-7109-95ff-9c86-dfea9e515538@grimberg.me>
 <022901d20d33$5eebf1a0$1cc3d4e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <022901d20d33$5eebf1a0$1cc3d4e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>>> One other note that I wanted to raise for the folks interested in this
>>>> is that with the RDMA core owning the completion queue pools, different
>>>> ULPs can easily share the same completion queue (given that it uses
>>>> the same poll context). For example, nvme-rdma host, iser and srp
>>>> initiators can end up using the same completion queues (if running
>>>> simultaneously on the same machine).
>>>>
>>>> Up until now, I couldn't think of anything that can introduce a problem
>>>> with that but maybe someone else will...
>>>
>>> It would be useful to provide details on how many CQs get created and of
> what
>>> size for an uber iSER/NVMF/SRP initiator/host and target.
>>
>> Are you talking about some debugfs layout?
>>
>
> No, just a matrix showing how the CQs scale out when shared among these three
> ULPs on a machine with X cores, for example.   Just to visualize if the number
> of CQs and their sizes are reduced by this new series or increased...

Umm, it sort of depends on the workload.

But the rule of thumb is that less CQs would be allocated in the system
(because they are shared) but would probably be larger.

One downside is that we might have some unused cqes for each CQ.
Say we create a CQ with 1024 cqes, and the we have 7 QPs of size
128 attached to it. Now 896 cqes occupied to serve the 7 qps. Now
a QP of size 129 comes along, it cannot be attached to this CQ as we
might overrun it, so another CQ of size 1024 will be created and the QP
will be attached to it. The old CQ will have 128 free cqes until some
QP comes along that can fill it.

The current algorithm takes the least-used CQ that accommodates the
caller needs (poll_ctx and completion vector if exists).

> If this series causes, say, 2X the amount of memory needed for CQs vs the
> existing private CQ approach, then that impacts how many CQs can be allocated,
> due to limits on the amount of memory that can be allocated system-wide via
> dma_alloc_coherent(), which is what cxgb4 uses to allocate queue memory.
>
> So I'm just voicing the concern this design can possibly reduce the overall
> number of CQs available on a given system.  It is probably not a big deal
> though, but I don't have a good visualization of how much more memory this
> proposed series would incur...

I see. So I don't think this would allocate way more completion queues
than say iser/srp/nvmf alone (note that today iser alone uses crazy
over-allocations for CQs to aggressively aggregate them).

The main motivation for this is to aggregate completions as much
as possible (and reasonable). It is possible that we will sacrifice
some memory for that...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
