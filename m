From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Mon, 18 Apr 2016 23:14:27 -0400
Message-ID: <20160419031425.GB27515@rhel.amr.corp.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460410360-13104-3-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dledford@redhat.com, bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 02:32:30PM -0700, Christoph Hellwig wrote:
> The new RW API will need this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Tested-by: Steve Wise <swise@opengridcomputing.com>

I'm not opposed to this change but traditionally QPs are bound to a device not
to a single port.

How does this change that semantic?

Ira

> ---
>  drivers/infiniband/core/cma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 93ab0ae..6ebaf20 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -800,6 +800,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ib_pd *pd,
>  	if (id->device != pd->device)
>  		return -EINVAL;
>  
> +	qp_init_attr->port_num = id->port_num;
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
