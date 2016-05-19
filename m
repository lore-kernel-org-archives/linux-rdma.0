From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Thu, 19 May 2016 13:14:59 -0700
Message-ID: <573E1EC3.5000907@sandisk.com>
References: <20160518220302.81260E09E9@smtp.ogc.us>
 <20160518222857.GB23835@obsidianresearch.com>
 <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
 <20160519180552.GA26130@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519180552.GA26130-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/19/2016 11:05 AM, Jason Gunthorpe wrote:
> This is the mapping that matches the definitions of the barriers:
>
>   wmb can be memory_order_release
>   rmb can be memory_order_acquire
>   mb can be memory_order_seq_cst

This is not correct. Acquire and release, at least as defined by 
Gharachorloo in 1991, have another meaning than the mentioned barrier 
instructions. Acquire and release are labels that can be applied to load 
and store instructions respectively. Acquire semantics prevent 
reordering of a load-acquire instruction with any read or write 
operation which follows it in program order. Release semantics prevent 
reordering of a store-release with any read or write operation which 
precedes it in program order. Figure 2 in 
https://courses.engr.illinois.edu/cs533/sp2012/reading_list/2b.pdf 
illustrates this clearly.

I have not yet analyzed the meaning of acquire and release labels in the 
Itanium instruction set nor in the C11 memory consistency model closely 
but I think that acquire and release have the same meaning in these 
contexts as what has been explained above.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
