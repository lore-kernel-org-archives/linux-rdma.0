From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Fri, 24 Jul 2015 23:27:19 -0700
Message-ID: <20150725062719.GB26437@infradead.org>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55B0F06E.8000603@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55B0F06E.8000603@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On Thu, Jul 23, 2015 at 06:47:26AM -0700, Bart Van Assche wrote:
> This statement might need some clarification. Are you aware that this memory
> region is only used if the kernel module parameter register_always is zero ?

The way I read the driver it's also used if the driver doesn't support
either FMR or FR (although no current in-tree IB driver falls into that
category), or as fallback if memory registration fails for some reason.

But given that rkeys are just 32-bit integers there also seems to be
some risk that a peer could simply brute force it even if it's never
sent out on the wire.
