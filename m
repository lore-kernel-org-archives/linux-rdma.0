From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Wed, 8 Nov 2017 11:42:12 -0500
Message-ID: <F7FAF7FD-AE2C-4428-A779-06C9768E0C73@oracle.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 8, 2017, at 4:57 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> This is the third re-incarnation of the CQ pool patches proposed
> by Christoph and I.
> 
> Our ULPs often want to make smart decisions on completion vector
> affinitization when using multiple completion queues spread on
> multiple cpu cores. We can see examples for this in iser, srp, nvme-rdma.
> 
> This patch set attempts to move this smartness to the rdma core by
> introducing per-device CQ pools that by definition spread
> across cpu cores. In addition, we completely make the completion
> queue allocation transparent to the ULP by adding affinity hints
> to create_qp which tells the rdma core to select (or allocate)
> a completion queue that has the needed affinity for it.
> 
> This API gives us a similar approach to whats used in the networking
> stack where the device completion queues are hidden from the application.
> With the affinitization hints, we also do not compromise performance
> as the completion queue will be affinitized correctly.
> 
> One thing that should be noticed is that now different ULPs using this
> API may share completion queues (given that they use the same polling context).
> However, even without this API they share interrupt vectors (and CPUs
> that are assigned to them). Thus aggregating consumers on less completion
> queues will result in better overall completion processing efficiency per
> completion event (or interrupt).

Hi Sagi, glad to see progress on this!

When running on the same CPU, Send and Receive completions compete
for the same finite CPU resource. In addition, they compete with
soft IRQ tasks that are also pinned to that CPU, and any other
BOUND workqueue tasks that are running there.

Send and Receive completions often have significant work to do
(for example, DMA syncing or unmapping followed by some parsing
of the completion results) and are all serialized on ib_poll_wq or
by soft IRQ.

This limits IOPS, and restricts other users of that shared CQ.

I recognize that handling interrupts on the same core where they
fired is best, but some of this work has to be allowed to migrate
when this CPU core is already fully utilized. A lot of the RDMA
core and ULP workqueues are BOUND, which prevents task migration,
even in the upper layers.

I would like to see a capability of intelligently spreading the
CQ workload for a single QP onto more CPU cores.

As an example, I've found that ensuring that NFS/RDMA's Receive
and Send completions are handled on separate CPU cores results in
slightly higher IOPS (~5%) and lower latency jitter on one mount
point.

This is more critical now that our ULPs are handling more Send
completions.


> In addition, we introduce a configfs knob to our nvme-target to
> bound I/O threads to a given cpulist (can be a subset). This is
> useful for numa configurations where the backend device access is
> configured with care to numa affinity, and we want to restrict rdma
> device and I/O threads affinity accordingly.
> 
> The patch set convert iser, isert, srpt, svcrdma, nvme-rdma and
> nvmet-rdma to use the new API.

Is there a straightforward way to assess whether this work
improves scalability and performance when multiple ULPs share a
device?


> Comments and feedback is welcome.
> 
> Christoph Hellwig (1):
>  nvme-rdma: use implicit CQ allocation
> 
> Sagi Grimberg (8):
>  RDMA/core: Add implicit per-device completion queue pools
>  IB/isert: use implicit CQ allocation
>  IB/iser: use implicit CQ allocation
>  IB/srpt: use implicit CQ allocation
>  svcrdma: Use RDMA core implicit CQ allocation
>  nvmet-rdma: use implicit CQ allocation
>  nvmet: allow assignment of a cpulist for each nvmet port
>  nvmet-rdma: assign cq completion vector based on the port allowed cpus
> 
> drivers/infiniband/core/core_priv.h      |   6 +
> drivers/infiniband/core/cq.c             | 193 +++++++++++++++++++++++++++++++
> drivers/infiniband/core/device.c         |   4 +
> drivers/infiniband/core/verbs.c          |  69 ++++++++++-
> drivers/infiniband/ulp/iser/iscsi_iser.h |  19 ---
> drivers/infiniband/ulp/iser/iser_verbs.c |  82 ++-----------
> drivers/infiniband/ulp/isert/ib_isert.c  | 165 ++++----------------------
> drivers/infiniband/ulp/isert/ib_isert.h  |  16 ---
> drivers/infiniband/ulp/srpt/ib_srpt.c    |  46 +++-----
> drivers/infiniband/ulp/srpt/ib_srpt.h    |   1 -
> drivers/nvme/host/rdma.c                 |  62 +++++-----
> drivers/nvme/target/configfs.c           |  75 ++++++++++++
> drivers/nvme/target/nvmet.h              |   4 +
> drivers/nvme/target/rdma.c               |  71 +++++-------
> include/linux/sunrpc/svc_rdma.h          |   2 -
> include/rdma/ib_verbs.h                  |  31 ++++-
> net/sunrpc/xprtrdma/svc_rdma_transport.c |  22 +---
> 17 files changed, 468 insertions(+), 400 deletions(-)
> 
> -- 
> 2.14.1
> 
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
