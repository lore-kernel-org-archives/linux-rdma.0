From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma 1/1] IB/core: Fix input len in multiple user verbs
Date: Tue, 27 Jun 2017 11:29:14 +0300
Message-ID: <3b0ee6fa-ee35-c64e-9774-a20c381daf04@dev.mellanox.co.il>
References: <1498492429-28051-1-git-send-email-Ram.Amrani@cavium.com>
 <1498492429-28051-2-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498492429-28051-2-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/26/2017 6:53 PM, Ram Amrani wrote:
> Most user verbs pass user data to the kernel with the inclusion of the
> ib_uverbs_cmd_hdr structure. This is problematic because the vendor has
> no ideas if the verb was called by a legacy verb or an extended verb.
> Also, the incosistency between the verbs is confusing.

There are few places that vendor code (e.g. mlx5) already consider the 
inclusion of ib_uverbs_cmd_hdr structure.

See commit Ids a8237b32a3faab155a5dc8f886452147ce73da3e and 
78c0f98cc9dd46824fa66f35f14ea24ba733d145 around alloc_context and create_cq.

Such a change in the uverbs layers which really makes sense should come 
with a matching change in all vendors code where applicable to prevent a 
break.

> Fixes: 565197dd8fb1 ("IB/core: Extend ib_uverbs_create_cq")
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 70 ++++++++++++++++++++----------------
>  1 file changed, 40 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 70b7fb1..c418a0a 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -91,9 +91,10 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
>  		goto err;
>  	}
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd, out_len - sizeof resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len - sizeof(resp));
>
>  	ret = ib_rdmacg_try_charge(&cg_obj, ib_dev, RDMACG_RESOURCE_HCA_HANDLE);
>  	if (ret)
> @@ -313,9 +314,10 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd, out_len - sizeof resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +                   out_len - sizeof(resp));
>
>  	uobj  = uobj_alloc(uobj_get_type(pd), file->ucontext);
>  	if (IS_ERR(uobj))
> @@ -482,9 +484,10 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd, out_len - sizeof  resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +                   out_len - sizeof(resp));
>
>  	mutex_lock(&file->device->xrcd_tree_mutex);
>
> @@ -646,9 +649,10 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd, out_len - sizeof resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +                   out_len - sizeof(resp));
>
>  	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
>  		return -EINVAL;
> @@ -740,7 +744,8 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
>
>  	INIT_UDATA(&udata, buf + sizeof(cmd),
>  		   (unsigned long) cmd.response + sizeof(resp),
> -		   in_len - sizeof(cmd), out_len - sizeof(resp));
> +                   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +                   out_len - sizeof(resp));
>
>  	if (cmd.flags & ~IB_MR_REREG_SUPPORTED || !cmd.flags)
>  		return -EINVAL;
> @@ -1080,7 +1085,8 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
>
>  	INIT_UDATA(&uhw, buf + sizeof(cmd),
>  		   (unsigned long)cmd.response + sizeof(resp),
> -		   in_len - sizeof(cmd), out_len - sizeof(resp));
> +		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len - sizeof(resp));
>
>  	memset(&cmd_ex, 0, sizeof(cmd_ex));
>  	cmd_ex.user_handle = cmd.user_handle;
> @@ -1161,9 +1167,10 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd, out_len - sizeof resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len - sizeof(resp));
>
>  	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
>  	if (!cq)
> @@ -1719,9 +1726,10 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd, out_len - sizeof resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len - sizeof(resp));
>
>  	obj  = (struct ib_uqp_object *)uobj_alloc(uobj_get_type(qp),
>  						  file->ucontext);
> @@ -2038,7 +2046,8 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
>  		return -EOPNOTSUPP;
>
>  	INIT_UDATA(&udata, buf + sizeof(cmd.base), NULL,
> -		   in_len - sizeof(cmd.base), out_len);
> +		   in_len - sizeof(cmd.base) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len);
>
>  	ret = modify_qp(file, &cmd, &udata);
>  	if (ret)
> @@ -2543,7 +2552,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
>
>  	INIT_UDATA(&udata, buf + sizeof(cmd),
>  		   (unsigned long)cmd.response + sizeof(resp),
> -		   in_len - sizeof(cmd), out_len - sizeof(resp));
> +		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len - sizeof(resp));
>
>  	uobj  = uobj_alloc(uobj_get_type(ah), file->ucontext);
>  	if (IS_ERR(uobj))
> @@ -3609,10 +3619,10 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
>  	xcmd.max_sge	 = cmd.max_sge;
>  	xcmd.srq_limit	 = cmd.srq_limit;
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd - sizeof(struct ib_uverbs_cmd_hdr),
> -		   out_len - sizeof resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len - sizeof(resp));
>
>  	ret = __uverbs_create_xsrq(file, ib_dev, &xcmd, &udata);
>  	if (ret)
> @@ -3636,10 +3646,10 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>
> -	INIT_UDATA(&udata, buf + sizeof cmd,
> -		   (unsigned long) cmd.response + sizeof resp,
> -		   in_len - sizeof cmd - sizeof(struct ib_uverbs_cmd_hdr),
> -		   out_len - sizeof resp);
> +	INIT_UDATA(&udata, buf + sizeof(cmd),
> +		   (unsigned long) cmd.response + sizeof(resp),
> +		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
> +		   out_len - sizeof(resp));
>
>  	ret = __uverbs_create_xsrq(file, ib_dev, &cmd, &udata);
>  	if (ret)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
