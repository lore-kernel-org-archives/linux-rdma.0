From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 20 Aug 2015 13:04:13 -0600
Message-ID: <20150820190413.GB29567@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55D46EE8.4060701@dev.mellanox.co.il>
 <20150819173751.GB22646@obsidianresearch.com>
 <55D5A687.90102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55D5A687.90102-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 20, 2015 at 01:05:59PM +0300, Sagi Grimberg wrote:
> >>1. if register - call ib_map_mr_sg (which calls dma_map_sg)
> >>    else do dma_map_sg
> >>2. if registered - call ib_dma_unmap_sg (which calles dma_unmap_sg)
> >>    else do dma_unmap_sg
> >
> > From what I've seen in the ULPs the flow control is generally such
> >that the MR is 'consumed' even if it isn't used by a send.
> 
> Not really. if registration is not needed, an MR is not consumed. In
> fact, in svcrdma the IB code path never uses those, and the iWARP code
> path always use those for RDMA_READs and not RDMA_WRITEs. Also, isert
> use those only when signature is enabled and registration is required.

The MR is not *used* but it should be 'consumed' - in the sense that
every RPC slot is associated (implicitly) with a MR, leaving the unused MR
in some kind of pool doesn't really help anything. Honestly, the MR
pool idea doesn't really help anything, it just makes confusion.

What should be pooled is the 'request slot' itself, in the sense that
if a request slot is in the 'ready to go' pool it is guarenteed to be
able to complete *any* request without blocking. That means the
MR/SQE/CQE resources are all ready to go. Any ancillary memory is
ready to use, etc.

The ULP should design its slot with the idea that it doesn't have to
allocate memory, or IB resources, or block, once the slot becomes
'ready to go'.

Review the discussion Chuck and I had on SQE flow control for a sense
on what that means. Understand why the lifetime of the MR and the SQE
and the slot are all convoluted together if RDMA is used correctly.

Trying to decouple the sub resources, ie by separately pooling the
MR/SQE/etc, is just unnecessary complexity, IMHO.. NFS client already
had serioues bugs in this area.

So, I turn to the idea that every ULP should work as the above, which
means when it gets to working on a 'slot' that implies there is an
actual struct ib_mr resource guaranteed available. This is why I
suggested using the 'struct ib_mr' to guide the SG construction even if
the actual HW MR isn't going to be used. The struct ib_mr is tied to
the slot, so using it has no cost.

-------

But, maybe that is too much of a shortcut, and thinking about it more
and all the other things I've written about.. Lets just directly
address this issue and add something called 'struct ib_op_slot'.

Data transfer would look like this:

 struct *ib_send_wr cur;

 cur = ib_slot_make_send(&req->op_slot,scatter_list);
 cur->next = ib_slot_make_rdma_read(&next_req->op,scatter_list,
 	          rkey,length);
 ib_post_send(qp,cur);

 [.. at CQE time ..]
 if (ib_slot_complete(qp,req->op_slot))
    [.. slot is now 'ready to go' ..]
 else
    [.. otherwise more stuff was posted, have to wait ...]

This forces the ULP to deal with many of the issues. Having a slot
means guarenteed minimum avaiable MR,SQE,CQE resources. That
guarenteed minimum avoids the messy API struggle in my prior writings.

.. and maybe the above is even thinking too small, to Christoph's
earlier musings, I wonder if a slot based middle API could hijack the
entire SCQ processing and have a per-slot callback scheme
instead. That kind of intervention is exactly what we'd need to
trivially hide the FMR difference.

... and now this provides enough context to start talking about common
helper APIs for common ULP things, like the rdma_read switch. The slot
has pre-allocated everything needed to handle the variations.

... which suddenly starts to be really viable because the slot
guarentees SQE availability too.

... and we start having the idea of a slot able to do certain tasks,
and codify that with API help at creation:

  struct nfs_rpc_slot
  {
     strict ib_op_slot slot;
  };

  struct ib_op_slot_attributes attrs;
  ib_init_slot_attrs(&attrs,ib_pd);

  ib_request_action(&attrs, "args describing RDMA read with N SGEs");
  if (ib_request_action("args describing a requirement for signature"))
      signature_supported = true;
  if (ib_request_action("args describing a requirement for non-page-aligned"))
      byte_sgl_supported = true;
  ib_request_action("args describing SEND with N SGEs");
  ib_request_action("args describing N RDMA reads each with N SGEs");

  for (required slot concurrency)
    ib_alloc_slot(&rpc.slot,&attrs);

Then the alloc just grabs everything required. ..mumble mumble.. some
way to flow into the QP/CQ allocation attributes too ..

Essentially, the ULP says 'here is what I want to do with this slot'
and the core code *guarentees* that if the slot is 'ready to go' then
'any single work of any requested type' can be queued without blocking
or memory allocation. Covers SQEs, CQEs, MRs, etc.

ib_request_action is a basic pattern that does various tests and ends
up doing:
  attrs->num_mrs = max(attrs->num_mrs, needed_for_this_action);
  attrs->num_mrs_sge = max(attrs->num_mrs_sge, needed_for_this_action);
  attrs->num_wr_sge = max(attrs->num_qp_sqe, needed_for_this_action);
  attrs->num_sqe = max(attrs->num_sqe, needed_for_this_action);
  attrs->num_cqe = max(attrs->num_cqe, needed_for_this_action);
[ie we compute the maximum allocation needed to satisfy the
 requested requirement]

Each request could fail, eg if signature is not supported then the
request_action will fail, so we have a more uniform way to talk about
send queue features.

... and the ULP could have a 'heavy' and 'light' slot pool if that
made some kind of sense for its work load.

So, that is a long road, but maybe there are reasonable interm stages?

Anyhow, conceptually, an idea. Eliminates the hated fmr pool concept,
cleans up bad thinking around queue flow control. Provides at least a
structure to abstract transport differences.

---------

It could look something like this:

 struct ib_op_slot
 {
    struct ib_mr **mr_list; // null terminated
    void *wr_memory;
    void *sg_memory;
    unsigned int num_sgs;
 };

 struct ib_send_wr *ib_slot_make_send(struct ib_op_slot *slot,
               const struct scatter_list *sgl)
 {
     dma_map(sgl);
     if (num_sges(sgl) < slot->num_sgs) {
        // send fits in the sg list
        struct ib_send_wr *wr = slot->wr_memory;
	wr->sg0list = slot->sg_memory;
	.. pack it in ..
	return wr;
     } else {
        // Need to spin up a MR..
	struct {
	   struct ib_send_wr frwr_wr;
	   struct ib_send_wr send_wr;
	} *wrs = slot->wr_memory;
	wrs->frwr_wr.next = &wrs->send_wr
	... pack it in ...
	return &wrs->frwr_wr;
    }
    // similar for FMR
 }

.. similar concept for rdma read, etc.
.. ib_request_action makes sure the wr_memory/sg_memory are pre-sized
   to accommodate the action. Add optional #ifdef'd debugging to check
   for bad ULP usage
.. function pointers could be used to provide special optimal versions
   if necessary
.. Complex things like signature just vanish from the API. ULP sees
   something like:

    if (ib_request_action("args describing a requirement for signature"))
       signature_supported = true;
    wr = ib_slot_make_rdma_write_signature(slot,....);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
