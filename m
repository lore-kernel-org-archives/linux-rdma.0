From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 01/12] IB/core: Guarantee that a local_dma_lkey is
 available
Date: Mon, 3 Aug 2015 21:21:24 -0600
Message-ID: <20150804032124.GA29125@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1438298547-21404-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BE166D.5000700@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55BE166D.5000700@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 02, 2015 at 04:09:01PM +0300, Haggai Eran wrote:
> On 31/07/2015 02:22, Jason Gunthorpe wrote:
> >  int ib_dealloc_pd(struct ib_pd *pd)
> >  {
> > +	if (pd->local_mr) {
> > +		if (ib_dereg_mr(pd->local_mr))
> > +			return -EBUSY;
> > +		pd->local_mr = NULL;
> > +	}
> > +
> 
> It looks like ib_uverbs_alloc_pd calls ib_device.alloc_pd() directly,
> and some drivers don't use kzalloc for allocating the pd, so the
> ib_dereg_mr call above results in a general protection fault.

Indeed it does..

I'll clean up the dealloc_pd mess too.

Jason
