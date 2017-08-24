From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v3 02/24] IB/uverbs: Introduce and use helper
 functions to copy ah attributes
Date: Thu, 24 Aug 2017 16:40:42 -0400
Message-ID: <1503607242.78641.48.camel@redhat.com>
References: <20170817125055.31424-1-leon@kernel.org>
         <20170817125055.31424-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch introduces two helper functions to copy ah attributes
> from uverbs to internal ib_ah_attr structure and the other way
> during modify qp and query qp respectively.
> 
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 124 ++++++++++++++-----------
> ----------
>  1 file changed, 49 insertions(+), 75 deletions(-)

I had to fix this patch up considerably...

> diff --git a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c
> index 670176b670a0..515425a50059 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> 
> @@ -1936,6 +1926,28 @@ static int modify_qp_mask(enum ib_qp_type
> qp_type, int mask)
>  	}
>  }
>  
> +static void copy_ah_attr_from_uverbs(struct ib_device *dev,
> +				     struct rdma_ah_attr *rdma_attr,
> +				     struct ib_uverbs_qp_dest
> *uverb_attr)
> +{
> +	rdma_attr->type = rdma_ah_find_type(dev, uverb_attr-
> >port_num);
> +	if (uverb_attr->is_global) {
> +		rdma_ah_set_grh(rdma_attr, NULL,
> +				uverb_attr->flow_label,
> +				uverb_attr->sgid_index,
> +				uverb_attr->hop_limit,
> +				uverb_attr->traffic_class);
> +		rdma_ah_set_dgid_raw(rdma_attr, uverb_attr->dgid);
> +	} else {
> +		rdma_ah_set_ah_flags(rdma_attr, 0);
> +	}
> +	rdma_ah_set_dlid(rdma_attr, uverb_attr->dlid);
> +	rdma_ah_set_sl(rdma_attr, uverb_attr->sl);
> +	rdma_ah_set_path_bits(rdma_attr, uverb_attr->src_path_bits);
> +	rdma_ah_set_static_rate(rdma_attr, uverb_attr->static_rate);
> +	rdma_ah_set_port_num(rdma_attr, uverb_attr->port_num);
> +}
> +
>  static int modify_qp(struct ib_uverbs_file *file,
>  		     struct ib_uverbs_ex_modify_qp *cmd, struct
> ib_udata *udata)
>  {

My current HEAD of my k.o/for-next (which is merged with my current
head of k.o/for-4.13-rc and so should contain the most up to date code
for the RDMA subsystem) includes this in the areas where it manually
copies the ah attributes:

rdma_ah_set_make_grd(rdma_attr, false);

So I added it to the end of the helper function.

> @@ -1982,47 +1994,9 @@ static int modify_qp(struct ib_uverbs_file
> *file,
>  	attr->alt_timeout	  = cmd->base.alt_timeout;
>  	attr->rate_limit	  = cmd->rate_limit;
>  
> -	attr->ah_attr.type = rdma_ah_find_type(qp->device,
> -					       cmd-
> >base.dest.port_num);

And we had a fix here where we only copy the ah attributes if the user
set the flag for it, so what I ended up with looks like this:

        if (cmd->base.attr_mask & IB_QP_AV)
                copy_ah_attr_from_uverbs(qp->device, &attr->ah_attr,
                                         &cmd->base.dest);

        if (cmd->base.attr_mask & IB_QP_ALT_PATH)
                copy_ah_attr_from_uverbs(qp->device, &attr-
>alt_ah_attr,
                                         &cmd->base.alt_dest);

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
