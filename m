From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/uverbs: Use an unambiguous errno for method not
 supported
Date: Thu, 25 Jan 2018 10:22:55 +0200
Message-ID: <a6d75ed8-4422-f433-4f42-b18e9670904c@mellanox.com>
References: <20180125025834.GA25674@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125025834.GA25674-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 25/01/2018 04:58, Jason Gunthorpe wrote:
> Returning EOPNOTSUPP is problematic because it can also be
> returned by the method function, and we use it in quite a few
> places in drivers these days.
> 
> Instead, dedicate EPROTONOSUPPORT to indicate that the ioctl framework
> is enabled but the requested object and method are not supported by
> the kernel. No other case will return this code, and it lets userspace
> know to fall back to write().
> 
> grep says we do not use it today in drivers/infiniband subsystem.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/uverbs_ioctl.c | 19 +++++++++++++------
>   1 file changed, 13 insertions(+), 6 deletions(-)
> 
> This goes along with the series I am cooking to enable the new ioctl
> interface in rdma-core:
> 
> https://github.com/jgunthorpe/rdma-plumbing/tree/ioctl
> 
> diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
> index 71ff2644e053b8..d96dc1d17be189 100644
> --- a/drivers/infiniband/core/uverbs_ioctl.c
> +++ b/drivers/infiniband/core/uverbs_ioctl.c
> @@ -243,16 +243,13 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   	size_t ctx_size;
>   	uintptr_t data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
>   
> -	if (hdr->reserved)
> -		return -EINVAL;
> -
>   	object_spec = uverbs_get_object(ib_dev, hdr->object_id);
>   	if (!object_spec)
> -		return -EOPNOTSUPP;
> +		return -EPROTONOSUPPORT;
>   
>   	method_spec = uverbs_get_method(object_spec, hdr->method_id);
>   	if (!method_spec)
> -		return -EOPNOTSUPP;
> +		return -EPROTONOSUPPORT;
>   
>   	if ((method_spec->flags & UVERBS_ACTION_FLAG_CREATE_ROOT) ^ !file->ucontext)
>   		return -EINVAL;
> @@ -305,6 +302,16 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   
>   	err = uverbs_handle_method(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
>   				   file, method_spec, ctx->uverbs_attr_bundle);
> +
> +	/*
> +	 * EPROTONOSUPPORT is ONLY to be returned if the ioctl framework can
> +	 * not invoke the method because the request is not supported.  No
> +	 * other cases should return this code.
> +	*/
> +	if (unlikely(err == -EPROTONOSUPPORT)) {
> +		WARN_ON_ONCE(err == -EPROTONOSUPPORT);
> +		err = -EINVAL;
> +	}
>   out:
>   	if (ctx != (void *)data)
>   		kfree(ctx);
> @@ -341,7 +348,7 @@ long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   		}
>   
>   		if (hdr.reserved) {
> -			err = -EOPNOTSUPP;
> +			err = -EPROTONOSUPPORT;
>   			goto out;
>   		}
>   
> 

Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
