From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 08/26] IB/ocrdma: Improve size determinations in
 ocrdma_mbx_rdma_stats()
Date: Wed, 8 Mar 2017 16:20:24 +0200
Message-ID: <20170308142024.GG4828@yuval-lap>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <b72381fc-8ffd-ba40-45d3-2d3f8fb2e224@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b72381fc-8ffd-ba40-45d3-2d3f8fb2e224@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 01:58:49PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 7 Mar 2017 20:16:16 +0100
> 
> Replace the specification of two data structures by pointer dereferences
> as the parameter for the operator "sizeof" to make the corresponding size
> determinations a bit safer according to the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index 1f7d88d7569e..0628600bee56 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -1302,7 +1302,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
>  	mqe->u.nonemb_req.sge[0].len = dev->stats_mem.size;
>  
>  	/* Cache the old stats */
> -	memcpy(old_stats, req, sizeof(struct ocrdma_rdma_stats_resp));
> +	memcpy(old_stats, req, sizeof(*old_stats));

Isn't sizeof(req) smaller than sizeof(*old_stats)?

>  	memset(req, 0, dev->stats_mem.size);
>  
>  	ocrdma_init_mch((struct ocrdma_mbx_hdr *)req,
> @@ -1315,7 +1315,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
>  	status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);
>  	if (status)
>  		/* Copy from cache, if mbox fails */
> -		memcpy(req, old_stats, sizeof(struct ocrdma_rdma_stats_resp));
> +		memcpy(req, old_stats, sizeof(*old_stats));

Fix itself looks fine but original code seems strange and makes me anxious
since resp is (much) bigger than req.

>  	else
>  		ocrdma_le32_to_cpu(req, dev->stats_mem.size);
>  
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
