From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC 1/9] IB/core: Introduce indirect and protected
 memory regions
Date: Thu, 17 Oct 2013 22:43:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CE2BE0@ORSMSX109.amr.corp.intel.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com>
 <1381851510-17290-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381851510-17290-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This commit introduces verbs for creating memory regions
> which will allow new types of memory key operations such
> as indirect memory registration and protected memory
> registration.
> 
> Indirect memory registration is registering several (one
> of more) pre-registered memory regions in a specific layout.
> The Indirect region may potentialy describe several regions
> and some repitition format between them.

I didn't follow this direct versus indirect difference.  See below.
 
> +struct ib_mr *ib_create_mr(struct ib_pd *pd,
> +			   struct ib_mr_init_attr *mr_init_attr)
> +{
> +	struct ib_mr *mr;
> +
> +	if (!pd->device->create_mr)
> +		return ERR_PTR(-ENOSYS);
> +
> +	mr = pd->device->create_mr(pd, mr_init_attr);
> +
> +	if (!IS_ERR(mr)) {
> +		mr->device  = pd->device;
> +		mr->pd      = pd;
> +		mr->uobject = NULL;
> +		atomic_inc(&pd->usecnt);
> +		atomic_set(&mr->usecnt, 0);
> +	}
> +
> +	return mr;
> +}
> +EXPORT_SYMBOL(ib_create_mr);
> +
> +int ib_destroy_mr(struct ib_mr *mr)
> +{
> +	struct ib_pd *pd;
> +	int ret;
> +
> +	if (atomic_read(&mr->usecnt))
> +		return -EBUSY;
> +
> +	pd = mr->pd;
> +	ret = mr->device->destroy_mr(mr);
> +	if (!ret)
> +		atomic_dec(&pd->usecnt);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ib_destroy_mr);
> +
>  struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int
> max_page_list_len)
>  {
>  	struct ib_mr *mr;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 645c3ce..65b7e79 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -925,6 +925,30 @@ enum ib_mr_rereg_flags {
>  	IB_MR_REREG_ACCESS	= (1<<2)
>  };
> 
> +enum ib_mr_create_flags {
> +		IB_MR_SIGNATURE_EN = 1,
> +};
> +
> +enum ib_mr_reg_type {
> +	IB_MR_REG_DIRECT,
> +	IB_MR_REG_INDIRECT,
> +};
> +
> +/**
> + * ib_mr_init_attr - Memory region init attributes passed to routine
> + *	ib_create_mr.
> + * @reg_type: requested mapping type, this can be direct/indirect
> + *   registration or repetitive structure registration.
> + * @max_reg_descriptors: max number of registration units that
> + *   may be used with UMR work requests.
> + * @flags: MR creation flags bit mask.
> + */
> +struct ib_mr_init_attr {
> +	enum ib_mr_reg_type	reg_type;
> +	int			max_reg_descriptors;
> +	enum ib_mr_create_flags	flags;
> +};
> +
>  /**
>   * struct ib_mw_bind - Parameters for a type 1 memory window bind
> operation.
>   * @wr_id:      Work request id.
> @@ -1257,6 +1281,9 @@ struct ib_device {
>  	int                        (*query_mr)(struct ib_mr *mr,
>  					       struct ib_mr_attr *mr_attr);
>  	int                        (*dereg_mr)(struct ib_mr *mr);
> +	int                        (*destroy_mr)(struct ib_mr *mr);
> +	struct ib_mr *		   (*create_mr)(struct ib_pd *pd,
> +						struct ib_mr_init_attr *mr_init_attr);

These create and destroy something called an 'MR', but are not actually associated with any memory buffers.  Is this some sort of conceptual sub-protection domain?  Why is this needed, versus defining new ib_mr_attr fields?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
