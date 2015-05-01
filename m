From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: Fix unaligned accesses
Date: Fri, 1 May 2015 11:50:26 +0200
Message-ID: <55434C62.6050604@sandisk.com>
References: <1430448168-38479-1-git-send-email-david.ahern@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430448168-38479-1-git-send-email-david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In addition to Yann's comments:

On 05/01/15 04:42, David Ahern wrote:
> -static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
> +static void cm_mask_copy(u32 *dst, u32 *src, u32 *mask)

Please consider to constify the src and mask arguments.

> -	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++)
> -		((unsigned long *) dst)[i] = ((unsigned long *) src)[i] &
> -					     ((unsigned long *) mask)[i];
> +	for (i = 0; i < IB_CM_COMPARE_SIZE / sizeof(u32); i++)
> +		dst[i] =  src[i] & mask[i];

A single space after the equals sign is sufficient.

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
