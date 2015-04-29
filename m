From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix unaligned accesses
Date: Wed, 29 Apr 2015 16:34:25 -0600
Message-ID: <55415C71.8010604@oracle.com>
References: <1430340983-12538-1-git-send-email-david.ahern@oracle.com> <20150429211822.GA25951@obsidianresearch.com> <55414C03.40902@oracle.com> <20150429213042.GA28812@obsidianresearch.com> <55414F4E.5020209@oracle.com> <20150429215123.GA29809@obsidianresearch.com> <55415438.1040205@oracle.com> <20150429221537.GB31415@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150429221537.GB31415-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/29/15 4:15 PM, Jason Gunthorpe wrote:
> Read carefully:
>
>>> > >You'd change the loop stride to by u32 as well.
> which means this:
>
> static void cm_mask_copy(u32 *dst, const u32 *src, const u32 *mask)
> {
> 	int i;
>
> 	for (i = 0; i < IB_CM_COMPARE_SIZE; i++)
> 		dst[i] = src[i] & mask[i];
> }
>
> Divide IB_CM_COMPARE_SIZE by 4, adjust all users.
>
> Make other related type changes the compiler tells you about.
>
> Do not add casts.

got it. that was a lot clearer.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
