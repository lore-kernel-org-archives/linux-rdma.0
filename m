From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: Fix unaligned accesses
Date: Fri, 1 May 2015 10:24:13 -0600
Message-ID: <20150501162413.GC8531@obsidianresearch.com>
References: <1430448168-38479-1-git-send-email-david.ahern@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430448168-38479-1-git-send-email-david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 30, 2015 at 10:42:48PM -0400, David Ahern wrote:
> Addresses the following kernel logs seen during boot of sparc systems:
> 
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib_cm]
> 
> Changed signature of cm_mask_copy from u8 to u32 as suggested by Jason
> Gunthorpe.

+1 to everyone elses comments..

> -static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
> +static void cm_mask_copy(u32 *dst, u32 *src, u32 *mask)

masy as well add the const while here

> -	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++)
> -		((unsigned long *) dst)[i] = ((unsigned long *) src)[i] &
> -					     ((unsigned long *) mask)[i];
> +	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(u32); i++)
> +		dst[i] =  src[i] & mask[i];

for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(*dst); i++)

Is a little more idiomatic

> -		data_cmp = cm_compare_private_data(private_data,
> +		data_cmp = cm_compare_private_data((u32 *) private_data,
>  						   cm_id_priv->compare_data);

I'd be happier without this cast, at the worst move it up one more
layer, at the best, fix the two impacted structures as well.

> I feel like I stepped into a tar pit... It's a bit odd that
> IB_CM_COMPARE_SIZE is part of an enum rather than a #define.

This is, again, idiomatic. '#define CONSTANT' is often frowned upon,
the semantics of enum are much cleaner/safer, eg what you trivially
posted:

> #define IB_CM_COMPARE_SIZE 64/sizeof(u32)

Is wrong, missing brackets.

>> Anyway, you might want to compile this part of the kernel with
>> -Wcast-align and ignore the false positive (in particular
>> every other use of container_of()).

> Why?

To look for more sketchy things that might impact SPARC, ARM, etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
