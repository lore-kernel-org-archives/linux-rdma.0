From: Dominique Martinet <dominique.martinet@cea.fr>
Subject: Re: [PATCH 10/10] net/9p: Remove ib_get_dma_mr calls
Date: Thu, 23 Jul 2015 09:46:45 +0200
Message-ID: <20150723074645.GA10415@u-michard>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1437608083-22898-11-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437608083-22898-11-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote on Wed, Jul 22, 2015 at 05:34:43PM -0600:
> The pd now has a local_dma_lkey member which completely replaces
> ib_get_dma_mr, use it instead.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

9P part looks good and tested OK (only applied 01 and 10 of the serie),
thanks for the Cc.

-- 
Dominique
