From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Problem Pinning Physical Memory
Date: Wed, 1 Dec 2010 15:30:45 +0000 (UTC)
Message-ID: <loom.20101201T162410-279@post.gmane.org>
References: <loom.20101122T192618-795@post.gmane.org> <20101124135507.GA23230@mtldesk30> <20101124174245.GA25325@obsidianresearch.com> <4CF3DE7D.4060105@opengridcomputing.com> <4CF3DF49.8000605@opengridcomputing.com> <loom.20101130T160950-109@post.gmane.org> <4CF55DF2.1030507@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tom Tucker <tom@...> writes:

> What I implemented was support for mmap'd memory. In practical terms for 
> your application you would write a driver that supported the mmap file op. 
> The driver's mmap routine would ioremap the pci memory of interest and 
> stuff it in the provided vma. The user-mode app then ibv_reg_mr the 
> address and length returned by mmap.
> 
> Make sense?

I believe so.  Something along these lines has already been implemented for the
device with which I am working, but was failing due to lacking your patch.

I am not able to find the patch that you submitted (bad search terms?).  I also
am having a difficult time tracking down (with any certainty) the sources that
your patch would be made against.

If you could provide lines to both I would greatly appreciate it.

Thanks.

-- Alan


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
