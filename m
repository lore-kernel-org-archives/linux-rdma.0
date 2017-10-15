From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/47] RDMA/uverbs: Make the code in ib_uverbs_cmd_verbs()
 less confusing
Date: Sun, 15 Oct 2017 10:37:34 +0300
Message-ID: <0b6983bb-e219-03ef-5ac1-6952d2c13e20@mellanox.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-6-bart.vanassche@wdc.com>
 <64b5f415-7d56-3f17-0c8c-5d80ba89582c@mellanox.com>
 <1507570048.2674.17.camel@wdc.com>
 <3a6adf24-3e60-7fd1-a119-37586793d374@mellanox.com>
 <1507735840.2477.8.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507735840.2477.8.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/10/2017 18:30, Bart Van Assche wrote:
> On Wed, 2017-10-11 at 08:19 +0300, Matan Barak wrote:
>> But what about cases where UVERBS_OPTIMIZE_USING_STACK_SZ is defined but
>> is insufficient in size?
> 
> Sorry. How about the patch below? The most significant change compared to the
> current code is that UVERBS_OPTIMIZE_USING_STACK_SZ has to be defined as 0
> instead of not defining that macro to disable the optimization. A new change
> is that this version uses gcc's support for zero-length arrays (which is an
> extension of the C standard and is already used elsewhere in the kernel).
> 
> 
> Subject: [PATCH] RDMA/uverbs: Make the code in ib_uverbs_cmd_verbs() less
>   confusing
> 
> This patch reduces the number of #ifdefs and also avoids that
> smatch reports the following:
> 
> drivers/infiniband/core/uverbs_ioctl.c:276: ib_uverbs_cmd_verbs() warn: if statement not indented
> drivers/infiniband/core/uverbs_ioctl.c:280: ib_uverbs_cmd_verbs() warn: possible memory leak of 'ctx'
> drivers/infiniband/core/uverbs_ioctl.c:315: ib_uverbs_cmd_verbs() warn: if statement not indented
> 
> References: commit fac9658cabb9 ("IB/core: Add new ioctl interface")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/uverbs_ioctl.c | 13 +++----------
>   1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
> index 5286ad57d903..71ff2644e053 100644
> --- a/drivers/infiniband/core/uverbs_ioctl.c
> +++ b/drivers/infiniband/core/uverbs_ioctl.c
> @@ -241,9 +241,7 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   	struct uverbs_attr *curr_attr;
>   	unsigned long *curr_bitmap;
>   	size_t ctx_size;
> -#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
>   	uintptr_t data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
> -#endif
>   
>   	if (hdr->reserved)
>   		return -EINVAL;
> @@ -269,13 +267,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   			(method_spec->num_child_attrs / BITS_PER_LONG +
>   			 method_spec->num_buckets);
>   
> -#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
>   	if (ctx_size <= UVERBS_OPTIMIZE_USING_STACK_SZ)
>   		ctx = (void *)data;
> -
>   	if (!ctx)
> -#endif
> -	ctx = kmalloc(ctx_size, GFP_KERNEL);
> +		ctx = kmalloc(ctx_size, GFP_KERNEL);
>   	if (!ctx)
>   		return -ENOMEM;
>   
> @@ -311,10 +306,8 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   	err = uverbs_handle_method(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
>   				   file, method_spec, ctx->uverbs_attr_bundle);
>   out:
> -#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
> -	if (ctx_size > UVERBS_OPTIMIZE_USING_STACK_SZ)
> -#endif
> -	kfree(ctx);
> +	if (ctx != (void *)data)
> +		kfree(ctx);
>   	return err;
>   }
>   
> 

Simple and looks good to me. Thanks.
Acked-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
