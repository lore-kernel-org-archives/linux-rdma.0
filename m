From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: RFC: CQ pools and implicit CQ resource allocation
Date: Mon, 12 Sep 2016 23:25:29 +0300
Message-ID: <3c30fd68-664c-a15b-021d-0a67544461b1@grimberg.me>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
 <d0c645eb-3674-2841-bdb7-8b9e6fd46473@grimberg.me>
 <BCF7E723-FC50-4497-9E0B-1157CF2D4185@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BCF7E723-FC50-4497-9E0B-1157CF2D4185-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Chuck,

>> One other note that I wanted to raise for the folks interested in this
>> is that with the RDMA core owning the completion queue pools, different
>> ULPs can easily share the same completion queue (given that it uses
>> the same poll context). For example, nvme-rdma host, iser and srp
>> initiators can end up using the same completion queues (if running
>> simultaneously on the same machine).
>
> I've browsed the patches a little. Do you have a sense of how much
> lock / memory contention this sharing scheme introduces on multi-socket
> machines using multiple protocols and multiple QPs?

What we noticed was that usually target/server mode drivers will want
to spread CQs across cores in order to achieve better parallelism when
serving multiple targets. The benefit of this is better completion
aggregation and reduce completion interrupts as we have less CQs in
total and each CQ completes multiple QPs (send and/or recv).

Note that the CQ API uses either irq-poll or a workqueue context, both
guarantee that a single context will poll the completion queue at any
point in time so no lock contention should ever exist regardless of
how many queue-pairs are attached to it.

As for memory, I don't see how the scheme can introduce any inefficient
memory access (its just allocating larger CQs and attach more QPs to
it). But that is a good question. I have noticed recently that
having the RDMA queues (QP, CQ, SRQ) allocated on the "correct" numa
socket makes a real difference (queue lock becomes a lot cheaper and
as well as the work-queue entries fills).

I have a patch set in the works that allows RDMA queues to accept
numa_node (which can accept NUMA_NO_NODE for unaware ULPs).

> Would it make sense for a ULP to indicate that it wants an unshared set
> of resources?

I thought about this before, but it would make sense if there is a good
reason to not share the completion queue. Note that when one allocates
a CQ with the same completion vector assignment as someone else it
practically shares the assigned core anyhow, we'll just see interrupts 
from both CQs so I still can't see how that is better.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
