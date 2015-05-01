From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: Fix unaligned accesses
Date: Fri, 01 May 2015 10:33:19 -0600
Message-ID: <5543AACF.7060502@oracle.com>
References: <1430448168-38479-1-git-send-email-david.ahern@oracle.com> <20150501162413.GC8531@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150501162413.GC8531-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/1/15 10:24 AM, Jason Gunthorpe wrote:
>> -static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
>> +static void cm_mask_copy(u32 *dst, u32 *src, u32 *mask)
>
> masy as well add the const while here

noted by Bart.

>
>> -	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++)
>> -		((unsigned long *) dst)[i] = ((unsigned long *) src)[i] &
>> -					     ((unsigned long *) mask)[i];
>> +	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(u32); i++)
>> +		dst[i] =  src[i] & mask[i];
>
> for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(*dst); i++)
>
> Is a little more idiomatic

Sizing of the array using some macro / enum that accounts for u32 
walking versus u8 walking means the sizeof goes away.

>
>> -		data_cmp = cm_compare_private_data(private_data,
>> +		data_cmp = cm_compare_private_data((u32 *) private_data,
>>   						   cm_id_priv->compare_data);
>
> I'd be happier without this cast, at the worst move it up one more
> layer, at the best, fix the two impacted structures as well.

I tried to fix private_data and it blows the patch up.

>
>> I feel like I stepped into a tar pit... It's a bit odd that
>> IB_CM_COMPARE_SIZE is part of an enum rather than a #define.
>
> This is, again, idiomatic. '#define CONSTANT' is often frowned upon,
> the semantics of enum are much cleaner/safer,

'#define NAME VALUE' is used throughout the kernel. Why does ib_rdma 
need to be different?

>>> Anyway, you might want to compile this part of the kernel with
>>> -Wcast-align and ignore the false positive (in particular
>>> every other use of container_of()).
>
>> Why?
>
> To look for more sketchy things that might impact SPARC, ARM, etc.

Seems like a topic for another patch.

David

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
