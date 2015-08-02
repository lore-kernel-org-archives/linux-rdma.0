From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH v2 01/12] IB/core: Guarantee that a local_dma_lkey is
 available
Date: Sun, 2 Aug 2015 16:09:01 +0300
Message-ID: <55BE166D.5000700@mellanox.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1438298547-21404-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-2-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On 31/07/2015 02:22, Jason Gunthorpe wrote:
>  int ib_dealloc_pd(struct ib_pd *pd)
>  {
> +	if (pd->local_mr) {
> +		if (ib_dereg_mr(pd->local_mr))
> +			return -EBUSY;
> +		pd->local_mr = NULL;
> +	}
> +

It looks like ib_uverbs_alloc_pd calls ib_device.alloc_pd() directly,
and some drivers don't use kzalloc for allocating the pd, so the
ib_dereg_mr call above results in a general protection fault.

Haggai
