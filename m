From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/cxgb4: Remove unnecessary conversion from
 __be32 to cpu format
Date: Wed, 25 Oct 2017 22:00:49 -0700
Message-ID: <46faaaf4-c719-e9cf-c7eb-e6f688e62be7@talpey.com>
References: <20171024182848.7945-1-leon@kernel.org>
 <067301d34cf7$d0872ff0$71958fd0$@opengridcomputing.com>
 <20171024185956.GL16127@mtr-leonro.local>
 <020c01d34da0$04115ff0$0c341fd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <020c01d34da0$04115ff0$0c341fd0$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/25/2017 7:46 AM, Steve Wise wrote:
>>>> @@ -234,7 +234,7 @@ struct t4_cqe {
>>>>
>>>>   /* used for SQ completion processing */
>>>>   #define CQE_WRID_SQ_IDX(x)	((x)->u.scqe.cidx)
>>>> -#define CQE_WRID_FR_STAG(x)     (be32_to_cpu((x)->u.scqe.stag))
>>>> +#define CQE_WRID_FR_STAG(x)     ((x)->u.scqe.stag)
>>>
>>> This is incorrect.  The stag is filled in by HW which is BE.  The
> declaration of
>>> scqe.stag needs to be __be32.
>>
>> So why do you declare stag as u32?
> 
> I'm saying it is a bug that stag is declared as u32.  t4_cqe.u.scqe.stag should
> be declared as __be32.
> 
> So the fix for the sparse warning should be something like this:
> 
> diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
> index e765c00..bcb80ca6 100644
> --- a/drivers/infiniband/hw/cxgb4/t4.h
> +++ b/drivers/infiniband/hw/cxgb4/t4.h
> @@ -171,7 +171,7 @@ struct t4_cqe {
>                          __be32 msn;
>                  } rcqe;
>                  struct {
> -                       u32 stag;
> +                       __be32 stag;

Technically speaking, the stag is opaque to software and should be
declared as a non-integer type, e.g. u8 stag[4]. However, most
code treats it as a native 32-bit type, and performs integer
stores to pass it in the WR. If declaring as __be32 achieves
that without manipulating byte order, well, ok, but it's not
perfectly accurate, type-wise.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
