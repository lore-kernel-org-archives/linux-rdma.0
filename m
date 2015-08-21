From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Fri, 21 Aug 2015 12:08:09 -0600
Message-ID: <20150821180809.GA3762@obsidianresearch.com>
References: <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55D46EE8.4060701@dev.mellanox.co.il>
 <20150819173751.GB22646@obsidianresearch.com>
 <55D5A687.90102@dev.mellanox.co.il>
 <20150820190413.GB29567@obsidianresearch.com>
 <20150821063458.GA875@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150821063458.GA875-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 20, 2015 at 11:34:58PM -0700, Christoph Hellwig wrote:

> How is this going to work for drivers that might consumer multiple
> MRs per request like SRP or similar upcoming block drivers?  Unless
> you want to allocate a potentially large number of MRs for each
> request that scheme doesn't work.

There are at least two approaches, and it depends on how flow control
to the driving layer works out. Look at what the ULP does when the
existing MR pool exhausts:
- Exhaustion is not allowed. In this model every slot must truely handle
  every required action without blocking. The ULP somehow wrangles
  things so pool exhaustion is not possible. NFS client is a
  good example.

  Where NFS client went wrong is that the MR alone is not enough,
  issuing a request requires SQE/CQE resources, failing to track that
  caused hard to find bugs.
- Exhaustion is allowed, and somehow the ULP is able to stop
  processing. In this case you'd just swap MRs for slots in the pool,
  probably having pools of different kinds of slots to optimize
  resource use.

  Pool draw down includes SQE/CQE/etc resources as well. A multiple
  rkey MR case would just draw down the required slots from the pool.

I suspect client side tends to lean toward the first option and target
side the second - targets can always do back pressure flow control by
simply halting RQE processing, and it makes alot of sense on a target
to globally pool slots across all client QPs.

This idea of a slot is just a higher level structure we can hang other
stuff off - like the sg/mr decision, the iwarp rdma read change, sqe
accounting.

We don't need to start with everything, but I'm looking at Sagi's
notes on trying to factor the lkey side code paths and thinking a
broader abstraction than raw MR is needed to solve that.

> FYI, I have working early patches to do per-WR completion callback,
> I'll post them after I get them into a slightly better shape.

Interesting..

> As for your grand schemes:  I like some of the idea there, but we
> need to get there gradually.  I'd much prefer to finish Sagi's simple
> scheme, get my completion work in, add abstractions for RDMA READ and
> WRITE scatterlist mapping and build things up slowly.

Yes, absolutely, we have to go slowly - but exploring how we can fit
this together in some other way can help guide some of the smaller
choices.

Sagi could drop the lkey side, getting the rkey side in order would be
nice enough. Something like this is a direction to address the
lkey side.

Ie we could 1:1 replace MR with 'slot' and use that to factor the lkey
code paths. Over time slot can grow organically to factor more code.

Slot would be a new object for the core, one that is guarenteed to
last from post->completion, that seems like exactly the sort of object
a completion callback scheme would benefit from. Guarenteed memory to
hang callback pointers/etc off.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
