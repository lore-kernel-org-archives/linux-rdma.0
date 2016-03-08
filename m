From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH v4 1/9] IB/cma: pass the port number to ib_create_qp
Date: Tue, 8 Mar 2016 21:27:09 +0200
Message-ID: <20160308192709.GJ13396@leon.nu>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-2-git-send-email-hch@lst.de>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457461000-24088-2-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dledford@redhat.com, bart.vanassche@sandisk.com, sagig@mellanox.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 07:16:32PM +0100, Christoph Hellwig wrote:
> The new RW API will need this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  drivers/infiniband/core/cma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 9729639..a791522 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -800,6 +800,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ib_pd *pd,
>  	if (id->device != pd->device)
>  		return -EINVAL;
>  
> +	qp_init_attr->port_num = id->port_num;

I doubt whether this is the right place to update qp_init_attr structure.
Maybe the better solution will be to update the callers of rdma_create_qp?
It will place all qp_init_attr assignments in one place.

>  	qp = ib_create_qp(pd, qp_init_attr);
>  	if (IS_ERR(qp))
>  		return PTR_ERR(qp);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
