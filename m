From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] RDMA/mlx4: Spread completion vectors for proxy CQs
Date: Mon, 25 Feb 2019 13:46:30 -0800
Message-ID: <602b7707-37d1-5e36-13e3-0911d5f35021@grimberg.me>
References: <20190218183302.1242676-1-haakon.bugge@oracle.com>
 <38187795-4082-42C2-AF56-E6C89EE7DE39@oracle.com>
 <66C92ED1-EE5E-4136-A7D7-DBF8A0816800@oracle.com>
 <20190220171441.GH8429@ziepe.ca>
 <A7FA2738-ACD2-42C7-A0AF-4343583CF87E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A7FA2738-ACD2-42C7-A0AF-4343583CF87E@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Chuck Lever <chuck.lever@oracle.com>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, jackm@dev.mellanox.co.il, majd@mellanox.com, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>> I was thinking of the stuff in core/cq.c - but it also doesn't have
>> automatic comp_vector balancing. It is the logical place to put
>> something like that though..
>>
>> An API to manage a bundle of CPU affine CQ's is probably what most
>> ULPs really need.. (it makes little sense to create a unique CQ for
>> every QP)
> 
> ULPs behave way differently. E.g. RDS creates one tx and one rx CQ per QP.
> 
> As I wrote earlier, we do not have any modify_cq() that changes the comp_vector (EQ association). We can balance #CQ associated with the EQs, but we do not know their behaviour.
> 
> So, assume 2 completion EQs, and four CQs. CQa and CQb are associated with the first EQ, the two others with the second EQ. That's the "best" we can do. But, if CQa and CQb are the only ones generating events, we will have all interrupt processing on a single CPU. But if we now could modify CQa.comp_vector to be that of the second EQ, we could achieve balance. But not sure if the drivers are able to do this at all.
> 
>> alloc_bundle()
> 
> You mean alloc a bunch of CQs? How do you know their #cqes and cq_context?
> 
> 
> Håkon
> 
> 
>> get_cqn_for_flow(bundle)
>> alloc_qp()
>> destroy_qp()
>> put_cqn_for_flow(bundle)
>> destroy_bundle();
>>
>> Let the core code balance the cqn's and allocate (shared) CQ
>> resources.
>>
>> Jason
> 

I sent a simple patchset back in the day for it [1], IIRC there was
some resistance of having multiple ULPs implicitly share the same
completion queues:

[1]:
--
RDMA/core: Add implicit per-device completion queue
  pools

Allow a ULP to ask the core to implicitly assign a completion
queue to a queue-pair based on a least-used search on a per-device
cq pools. The device CQ pools grow in a lazy fashion with every
QP creation.

In addition, expose an affinity hint for a queue pair creation.
If passed, the core will attempt to attach a CQ with a completion
vector that is directed to the cpu core as the affinity hint
provided.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
--

That one added implicit QP create flags:
--
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bdb1279a415b..56d42e753eb4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1098,11 +1098,22 @@ enum ib_qp_create_flags {
         IB_QP_CREATE_SCATTER_FCS                = 1 << 8,
         IB_QP_CREATE_CVLAN_STRIPPING            = 1 << 9,
         IB_QP_CREATE_SOURCE_QPN                 = 1 << 10,
+
+       /* only used by the core, not passed to low-level drivers */
+       IB_QP_CREATE_ASSIGN_CQS                 = 1 << 24,
+       IB_QP_CREATE_AFFINITY_HINT              = 1 << 25,
+
--

Then I modified it to add a ib_cq_pool that a ULP can allocate
privately and then get/put CQs from/to.

[2]:
--
IB/core: Add a simple CQ pool API

Using CQ pools is useful especially for target/server modes.
The server/target implementation will usually serve multiple clients
and will usually have an array of completion queues allocated for that.

In addition, usually the server/target implementation will use a least-used
scheme to select a completion vector to each completion queue in order
to acheive better parallelism.

Having the server/target rdma queue-pairs share completion queues as
much as possible is desirable as it allows for better completion 
aggragation.
One downside of this approach is that some entries of the completion queues
might never be used in case the queue-pairs sizes are not fixed.

This simple CQ pool API allows for both optimizations and exposes a simple
API to alloc/free a completion queue pool and get/put from the pool.

The pool starts by allocating a caller-defined batch of CQs, and grows
in batches in a lazy fashion.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
--

That one had the CQ pool API:
--
+struct ib_cq_pool *ib_alloc_cq_pool(struct ib_device *device, int nr_cqe,
+                       int nr_cqs, enum ib_poll_context poll_ctx);
+void ib_free_cq_pool(struct ib_cq_pool *pool);
+void ib_cq_pool_put(struct ib_cq *cq, unsigned int nents);
+struct ib_cq *ib_cq_pool_get(struct ib_cq_pool *pool, unsigned int nents);
--

I can try to revive this if this becomes interesting again to anyone..

Thoughts?
