From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 20 Aug 2015 23:34:58 -0700
Message-ID: <20150821063458.GA875@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55D46EE8.4060701@dev.mellanox.co.il>
 <20150819173751.GB22646@obsidianresearch.com>
 <55D5A687.90102@dev.mellanox.co.il>
 <20150820190413.GB29567@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150820190413.GB29567-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 20, 2015 at 01:04:13PM -0600, Jason Gunthorpe wrote:
> Trying to decouple the sub resources, ie by separately pooling the
> MR/SQE/etc, is just unnecessary complexity, IMHO.. NFS client already
> had serioues bugs in this area.
> 
> So, I turn to the idea that every ULP should work as the above, which
> means when it gets to working on a 'slot' that implies there is an
> actual struct ib_mr resource guaranteed available. This is why I
> suggested using the 'struct ib_mr' to guide the SG construction even if
> the actual HW MR isn't going to be used. The struct ib_mr is tied to
> the slot, so using it has no cost.

How is this going to work for drivers that might consumer multiple
MRs per request like SRP or similar upcoming block drivers?  Unless
you want to allocate a potentially large number of MRs for each
request that scheme doesn't work.

> This forces the ULP to deal with many of the issues. Having a slot
> means guarenteed minimum avaiable MR,SQE,CQE resources. That
> guarenteed minimum avoids the messy API struggle in my prior writings.
> 
> .. and maybe the above is even thinking too small, to Christoph's
> earlier musings, I wonder if a slot based middle API could hijack the
> entire SCQ processing and have a per-slot callback scheme
> instead. That kind of intervention is exactly what we'd need to
> trivially hide the FMR difference.

FYI, I have working early patches to do per-WR completion callback,
I'll post them after I get them into a slightly better shape.

As for your grand schemes:  I like some of the idea there, but we
need to get there gradually.  I'd much prefer to finish Sagi's simple
scheme, get my completion work in, add abstractions for RDMA READ and
WRITE scatterlist mapping and build things up slowly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
