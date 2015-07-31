From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 08/12] IB/srp: Use pd->local_dma_lkey
Date: Fri, 31 Jul 2015 16:05:30 -0700
Message-ID: <55BBFF3A.6020802@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1438298547-21404-9-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438298547-21404-9-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
Cc: Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

On 07/30/2015 04:22 PM, Jason Gunthorpe wrote:
> Replace all leys with  pd->local_dma_lkey. This driver does not support
> iWarp, so this is safe.
>
> The insecure use of ib_get_dma_mr is thus isolated to an rkey, and will
> have to be fixed separately.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 31a20b462266..19a1356f8b2a 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3146,7 +3146,7 @@ static ssize_t srp_create_target(struct device *dev,
>   	target->io_class	= SRP_REV16A_IB_IO_CLASS;
>   	target->scsi_host	= target_host;
>   	target->srp_host	= host;
> -	target->lkey		= host->srp_dev->mr->lkey;
> +	target->lkey		= host->srp_dev->pd->local_dma_lkey;
>   	target->rkey		= host->srp_dev->mr->rkey;
>   	target->cmd_sg_cnt	= cmd_sg_entries;
>   	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
