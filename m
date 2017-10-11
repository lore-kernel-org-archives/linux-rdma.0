From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/47] RDMA/uverbs: Make the code in ib_uverbs_cmd_verbs()
 less confusing
Date: Wed, 11 Oct 2017 08:19:28 +0300
Message-ID: <3a6adf24-3e60-7fd1-a119-37586793d374@mellanox.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-6-bart.vanassche@wdc.com>
 <64b5f415-7d56-3f17-0c8c-5d80ba89582c@mellanox.com>
 <1507570048.2674.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507570048.2674.17.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/10/2017 20:27, Bart Van Assche wrote:
> On Mon, 2017-10-09 at 10:40 +0300, Matan Barak (External) wrote:
>> On 07/10/2017 00:32, Bart Van Assche wrote:
>>> This patch reduces the number of #ifdefs and also avoids that
>>> smatch reports the following:
>>>
>>> drivers/infiniband/core/uverbs_ioctl.c:276: ib_uverbs_cmd_verbs() warn: if statement not indented
>>> drivers/infiniband/core/uverbs_ioctl.c:280: ib_uverbs_cmd_verbs() warn: possible memory leak of 'ctx'
>>> drivers/infiniband/core/uverbs_ioctl.c:315: ib_uverbs_cmd_verbs() warn: if statement not indented
>>>
>>> References: commit fac9658cabb9 ("IB/core: Add new ioctl interface")
>>> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
>>> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>    drivers/infiniband/core/uverbs_ioctl.c | 20 +++++++++-----------
>>>    1 file changed, 9 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
>>> index 5286ad57d903..53f780ea49fe 100644
>>> --- a/drivers/infiniband/core/uverbs_ioctl.c
>>> +++ b/drivers/infiniband/core/uverbs_ioctl.c
>>> @@ -234,7 +234,7 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>>>        const struct uverbs_method_spec *method_spec;
>>>        long err = 0;
>>>        unsigned int i;
>>> -    struct {
>>> +    struct attr_and_bundle {
>>>            struct ib_uverbs_attr        *uattrs;
>>>            struct uverbs_attr_bundle    *uverbs_attr_bundle;
>>>        } *ctx = NULL;
>>> @@ -242,7 +242,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>>>        unsigned long *curr_bitmap;
>>>        size_t ctx_size;
>>>    #ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
>>> -    uintptr_t data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
>>> +    uintptr_t __data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
>>> +    struct attr_and_bundle *const data = (void *)__data;
>>> +#else
>>> +    struct attr_and_bundle *const data = NULL;
>>>    #endif
>>>
>>>        if (hdr->reserved)
>>> @@ -269,13 +272,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>>>                (method_spec->num_child_attrs / BITS_PER_LONG +
>>>                 method_spec->num_buckets);
>>>
>>> -#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
>>>        if (ctx_size <= UVERBS_OPTIMIZE_USING_STACK_SZ)
>>
>> If UVERBS_OPTIMIZE_USING_STACK_SZ isn't defined, you'll get an error here.
>> Maybe we could define it as 0 in the else part of the local variables deceleration.
> 
> Hello Matan,
> 
> That's an interesting suggestion but that wouldn't work well with the "#ifdef
> UVERBS_OPTIMIZE_USING_STACK_SZ" code in the declaration section. How about
> changing "if (ctx_size <= UVERBS_OPTIMIZE_USING_STACK_SZ) ctx = data;" into
> "ctx = data;" such that it becomes again safe not to define UVERBS_OPTIMIZE_USING_STACK_SZ?
> With that change this patch looks as follows:
> 
> 
> diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
> index 5286ad57d903..81c05ba2a58b 100644
> --- a/drivers/infiniband/core/uverbs_ioctl.c
> +++ b/drivers/infiniband/core/uverbs_ioctl.c
> @@ -234,7 +234,7 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   	const struct uverbs_method_spec *method_spec;
>   	long err = 0;
>   	unsigned int i;
> -	struct {
> +	struct attr_and_bundle {
>   		struct ib_uverbs_attr		*uattrs;
>   		struct uverbs_attr_bundle	*uverbs_attr_bundle;
>   	} *ctx = NULL;
> @@ -242,7 +242,10 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   	unsigned long *curr_bitmap;
>   	size_t ctx_size;
>   #ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
> -	uintptr_t data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
> +	uintptr_t __data[UVERBS_OPTIMIZE_USING_STACK_SZ / sizeof(uintptr_t)];
> +	struct attr_and_bundle *const data = (void *)__data;
> +#else
> +	struct attr_and_bundle *const data = NULL;

I meant to define that macro here:
#define UVERBS_OPTIMIZE_USING_STACK_SZ 	0

>   #endif
>   
>   	if (hdr->reserved)
> @@ -269,13 +272,9 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   			(method_spec->num_child_attrs / BITS_PER_LONG +
>   			 method_spec->num_buckets);
>   
> -#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
> -	if (ctx_size <= UVERBS_OPTIMIZE_USING_STACK_SZ)
> -		ctx = (void *)data;
> -
> +	ctx = data;
>   	if (!ctx)
> -#endif
> -	ctx = kmalloc(ctx_size, GFP_KERNEL);
> +		ctx = kmalloc(ctx_size, GFP_KERNEL);

But what about cases where UVERBS_OPTIMIZE_USING_STACK_SZ is defined but 
is insufficient in size?

In the suggestion I posted above, I meant:
/* Here UVERBS_OPTIMIZE_USING_STACK_SZ is always defined */
if (ctx_size <= UVERBS_OPTIMIZE_USING_STACK_SZ)
	ctx = data;
if (!ctx)
	ctx = kmalloc(ctx_size, GFP_KERNEL);

The last hunk (free part) stays the same.	

>   	if (!ctx)
>   		return -ENOMEM;
>   
> @@ -311,10 +310,8 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
>   	err = uverbs_handle_method(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
>   				   file, method_spec, ctx->uverbs_attr_bundle);
>   out:
> -#ifdef UVERBS_OPTIMIZE_USING_STACK_SZ
> -	if (ctx_size > UVERBS_OPTIMIZE_USING_STACK_SZ)
> -#endif
> -	kfree(ctx);
> +	if (ctx != data)
> +		kfree(ctx);
>   	return err;
>   }
>   
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
