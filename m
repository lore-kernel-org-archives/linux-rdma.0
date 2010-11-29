From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem Pinning Physical Memory
Date: Mon, 29 Nov 2010 11:13:45 -0600
Message-ID: <4CF3DF49.8000605@opengridcomputing.com>
References: <loom.20101122T192618-795@post.gmane.org> <20101124135507.GA23230@mtldesk30> <20101124174245.GA25325@obsidianresearch.com> <4CF3DE7D.4060105@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF3DE7D.4060105-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Brian <balexander-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/29/10 11:10 AM, Steve Wise wrote:
>
>
> On 11/24/2010 11:42 AM, Jason Gunthorpe wrote:
>>
>> The last time this came up I said that the kernel side of ibv_reg_mr
>> should do the right thing for all types of memory that are mmap'd into
>> a process and I still think that is true. RDMA to device memory could
>> be very useful and with things like GEM managing the allocation of
>> device (video) memory to userspace, so it can be done safely.
>>
>> Jason
>
> Tom posted changes to support this a while back.  Tom, do you have an 
> updated patch series for this support?
>
Yes. I removed the new verb and followed Jason's recommendation of adding 
this support to the core reg_mr support. I used the type bits in the vma 
struct to determine the type of memory being registered and just did the 
"right thing."

I'll repost in the the next day or two.

Tom

> Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
