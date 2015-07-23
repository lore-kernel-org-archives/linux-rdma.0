From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 01/10] IB/core: Guarantee that a local_dma_lkey is
 available
Date: Thu, 23 Jul 2015 12:36:24 -0600
Message-ID: <20150723183624.GB1868@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1437608083-22898-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <55B0C626.4070707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B0C626.4070707@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 01:47:02PM +0300, Sagi Grimberg wrote:
> >+/* Return a pd for in-kernel use that has a local_dma_lkey which provides
> >+   local access to all physical memory. */
> 
> Why not kdoc style? we need to move the ib_verbs.h kdocs here anyway.
> Might be a good chance to do that for ib_alloc_pd().

Right, took care of these.

> >diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> >index 986fddb08579..cfda95d7b067 100644
> >+++ b/include/rdma/ib_verbs.h
> >@@ -1255,6 +1255,8 @@ struct ib_pd {
> >  	struct ib_device       *device;
> >  	struct ib_uobject      *uobject;
> >  	atomic_t          	usecnt; /* count all resources */
> >+	struct ib_mr	       *local_mr;
> >+	u32			local_dma_lkey;
> 
> Maybe its better to place the local_dma_lkey in the first cacheline as
> it is normally accessed in the hot path?

Sure, but it doesn't matter too much as it is probably the only hot
item in the pd... At the very least is avoids computing an EA...

I've posted an updated series on my github, none of this is a
functional change, so I'm going to continue to wait for
testing/reviewing of the various pieces before reposting such a big
series.

https://github.com/jgunthorpe/linux/commits/remove-ib_get_dma_mr

Thanks,
Jason
