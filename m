From: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix unaligned accesses
Date: Wed, 29 Apr 2015 15:59:20 -0600
Message-ID: <55415438.1040205@oracle.com>
References: <1430340983-12538-1-git-send-email-david.ahern@oracle.com> <20150429211822.GA25951@obsidianresearch.com> <55414C03.40902@oracle.com> <20150429213042.GA28812@obsidianresearch.com> <55414F4E.5020209@oracle.com> <20150429215123.GA29809@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150429215123.GA29809-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/29/15 3:51 PM, Jason Gunthorpe wrote:
> On Wed, Apr 29, 2015 at 03:38:22PM -0600, David Ahern wrote:
>
>>> And dealing with the fairly few resulting changes..
>>
>> Confused. That does not deal with the alignment problem. Internal to
>> cm_mask_copy unsigned longs are used (8-bytes), so why change the
>> signature to u32?
>
> You'd change the loop stride to by u32 as well.
>
> This whole thing is just an attempted optimization, but doing copy and
> mask 8 bytes at a time on unaligned data is not very efficient, even
> on x86.
>
> So either drop the optimization and use u8 as the stride.
>
> Or keep the optimization and guarentee alignment, the best we can do
> is u32.
>
> Since this is an optimization, get_unaligned should be avoided,
> looping over u8 would be faster.

Sorry, to be dense on this but I still don't see how your proposal 
addresses the underlying problem -- guarantee of 8 byte alignment. Be it 
a u8 or u32 for the input arguments the cast to unsigned long says that 
an extended load operation can be used for access. For that to work the 
address (src, dst, mask) must all be 8-byte aligned.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
