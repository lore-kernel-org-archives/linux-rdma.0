From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Mon, 20 Nov 2017 14:08:20 +0200
Message-ID: <b4493cd9-62d6-c855-2b55-9749df7fa90d@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <F7FAF7FD-AE2C-4428-A779-06C9768E0C73@oracle.com>
 <b502f211-c477-3acd-be01-eaf645edc117@grimberg.me>
 <4B49C591-8671-4683-A437-215BAA6B56CD@oracle.com>
 <a79c3899-5599-aa7e-5c5b-75ec98cdc490@grimberg.me>
 <A6E320D9-63F4-4FFE-A5E2-EB3ED19D0CB3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A6E320D9-63F4-4FFE-A5E2-EB3ED19D0CB3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Recall that NFS is limited to a single QP per client-server
> pair.
> 
> ib_alloc_cq(compvec) determines which CPU will handle Receive
> completions for a QP. Let's call this CPU R.
> 
> I assume any CPU can initiate an RPC Call. For example, let's
> say an application is running on CPU C != R.
> 
> The Receive completion occurs on CPU R. Suppose the Receive
> matches to an incoming RPC that had no registered MRs. The
> Receive completion can invoke xprt_complete_rqst in the
> Receive completion handler to complete the RPC on CPU R
> without another context switch.
> 
> The problem is that the RPC completes on CPU R because the
> RPC stack uses a BOUND workqueue, and so does NFS. Thus at
> least the RPC and NFS completion processing are competing
> for CPU R, instead of being handled on other CPUs, and
> maybe the requesting application is also likely to migrate
> onto CPU R.
> 
> I observed this behavior experimentally.
> 
> Today, the xprtrdma Receive completion handler processes
> simple RPCs (ie, RPCs with no MRs) immediately, but finishes
> completion processing for RPCs with MRs by re-scheduling
> them on an UNBOUND secondary workqueue.
> 
> I thought it would save me a context switch if the Receive
> completion handler dealt with an RPC with only one MR that
> had been remotely invalidated as a simple RPC, and allowed
> it to complete immediately (all it needs to do is DMA unmap
> that already-invalidated MR) rather than re-scheduling.
> 
> Assuming NFS READs and WRITEs are less than 1MB and the
> payload can be registered in a single MR, I can avoid
> that context switch for every I/O (and this assumption
> is valid for my test system, using CX-3 Pro).
> 
> Except when I tried this, the IOPS throughput dropped
> considerably, even while the measured per-RPC latency was
> lower by the expected 5-15 microseconds. CPU R was running
> flat out handling Receives, RPC completions, and NFS I/O
> completions. In one case I recall seeing a 12 thread fio
> run not using CPU on any other core on the client.

I see your point Chuck. The design choice here assumes that
other CPUs are equally occupied (even with NFS-RPC context) hence the
choice on which cpu to run would almost always want to run the local
cpu.

If this is not the case, then this design does not apply.

>> My baseline assumption is that other cpu cores have their own tasks
>> that they are handling, and making RDMA completions be processed
>> on a different cpu is blocking something, maybe not the submitter,
>> but something else. So under the assumption that completion processing
>> always comes on the expense of something, choosing anything else other
>> than the cpu core that the I/O was submitted on is an inferior choice.
>>
>> Is my understanding correct that you are trying to emphasize that
>> unbound workqueues make sense on some use-cases for initiator drivers
>> (like xprtrdma)?
> 
> No, I'm just searching for the right tool for the job.
> 
> I think what you are saying is that when a file system
> like XFS resides on an RDMA-enabled block device, you
> have multiple QPs and CQs to route the completion
> workload back to the CPUs that dispatched the work. There
> shouldn't be an issue there similar to NFS, even though
> XFS might also use BOUND workqueues. Fair enough.

The issue I've seen with unbound workqueues is that the
worker thread can migrate between cpus which messes up
the locality we are trying to achieve. However, we could
easily add IB_POLL_UNBOUND_WORKQUEUE polling context if
that helps your use case.

> Latency is also introduced when ib_comp_wq cannot get
> scheduled for some time because of competing work on
> the same CPU. Soft IRQ, Send completions, or other
> HIGHPRI work can delay the dispatch of RPC and NFS work
> on a particular CPU.

True, but again, the design assumes that other cores can (and
will) run similar tasks. The overhead of trying to select an
"optimal" cpu at exactly that moment is something we would want
to avoid for fast storage devices. Moreover, in high stress these
decisions are not guaranteed to be optimal and might be counter
productive (as estimations often can be).

>> I'm stating the obvious here, but this issue historically existed in
>> various devices ranging from network to storage and more. The solution
>> is using multiple queues (ideally per-cpu) and try to have minimal
>> synchronization in the submission path (like XPS for networking) and
>> keep completions as local as possible to the submission cores (like flow
>> steering).
> 
> For the time being, the Linux NFS client does not support
> multiple connections to a single NFS server. There is some
> protocol standards work to be done to help clients discover
> all distinct network paths to a server. We're also looking
> at safe ways to schedule NFS RPCs over multiple connections.
> 
> To get multiple connections today you can use pNFS with
> block devices, but that doesn't help the metadata workload
> (GETATTRs, LOOKUPs, and the like), and not everyone wants
> to use pNFS.
> 
> Also, there are some deployment scenarios where "creating
> another connection" has an undesirable scalability impact:

I can understand that.

> - The NFS client has dozens or hundreds of CPUs. Typical
> for a single large host running containers, where the
> host's kernel NFS client manages the mounts, which are
> shared among containers.
> 
> - The NFS client has mounted dozens or hundreds of NFS
> servers, and thus wants to conserve its connection count
> to avoid managing MxN connections.

So in this use-case, do you really see that non-local cpu
selection for completion processing is performing better?

 From my experience, linear scaling is much harder to achieve
with bouncing cpus with all the context-switching overhead involved.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
