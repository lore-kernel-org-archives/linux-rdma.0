From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 21/26] IB/ocrdma: Improve another size determination in
 ocrdma_create_srq()
Date: Thu, 9 Mar 2017 13:46:40 +0200
Message-ID: <20170309114639.GE3307@yuval-lap>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <53b2ab35-8b0c-5cdd-dbc9-d38c7cf9e580@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53b2ab35-8b0c-5cdd-dbc9-d38c7cf9e580@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 02:24:00PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Mar 2017 10:10:50 +0100
> 
> Replace the specification of a data type by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index af8798fd35b1..bedc229be89d 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1915,7 +1915,7 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
>  		if (srq->idx_bit_fields == NULL)
>  			goto arm_err;
>  		memset(srq->idx_bit_fields, 0xff,
> -		       srq->bit_fields_len * sizeof(u32));
> +		       srq->bit_fields_len * sizeof(*srq->idx_bit_fields));
>  	}

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

>  
>  	if (init_attr->attr.srq_limit) {
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
