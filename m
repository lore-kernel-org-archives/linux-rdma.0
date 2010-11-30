From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Problem Pinning Physical Memory
Date: Tue, 30 Nov 2010 15:24:47 +0000 (UTC)
Message-ID: <loom.20101130T160950-109@post.gmane.org>
References: <loom.20101122T192618-795@post.gmane.org> <20101124135507.GA23230@mtldesk30> <20101124174245.GA25325@obsidianresearch.com> <4CF3DE7D.4060105@opengridcomputing.com> <4CF3DF49.8000605@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Tom Tucker <tom@...> writes:
> 
> Yes. I removed the new verb and followed Jason's recommendation of adding 
> this support to the core reg_mr support. I used the type bits in the vma 
> struct to determine the type of memory being registered and just did the 
> "right thing."
> 
> I'll repost in the the next day or two.
> 
> Tom
> 

Tom,

Couple of questions:

I noticed that OFED 1.5.3 was released last week.  Are the changes you speak of
part of that release? If not, is there an alternate branch/project that I should
be looking at or into to for the mentioned changes?

Also, I am inferring that the changes allowing the registering of physical
memory will only happen if my application is running in kernel space.  Is this
correct? or will I be able to register the physical memory from user space now
as well?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
