From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Thu, 23 Jul 2015 06:47:26 -0700
Message-ID: <55B0F06E.8000603@sandisk.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Andy Grover <andy.grover@oracle.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, Zach Brown <zach.brown@oracle.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On 07/22/15 16:34, Jason Gunthorpe wrote:
> The remaining users of ib_get_dma_mr are all unsafe:
 >   [ ... ]
>   drivers/infiniband/ulp/srp/ib_srp.c:
> 	srp_dev->mr = ib_get_dma_mr(srp_dev->pd,
> 				    IB_ACCESS_LOCAL_WRITE |
> 				    IB_ACCESS_REMOTE_READ |
> 				    IB_ACCESS_REMOTE_WRITE);

Hello Jason,

This statement might need some clarification. Are you aware that this 
memory region is only used if the kernel module parameter 
register_always is zero ?

I will try to find some time to test the SRP changes in this series but 
I'm not sure yet when I will be able to do that.

Bart.
