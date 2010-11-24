From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Problem Pinning Physical Memory
Date: Wed, 24 Nov 2010 15:55:07 +0200
Message-ID: <20101124135507.GA23230@mtldesk30>
References: <loom.20101122T192618-795@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20101122T192618-795-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian <balexander-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 22, 2010 at 06:28:47PM +0000, Brian wrote:
> ibv_reg_mr works fine as long as the shared region is in RAM. However, if I
> change the memory region to the physical memory on a PCI device the call to
> ibv_reg_mr fails. What should I be doing to register a physical memory region?
> 
> In searching through this forum I've seen some patches relating to
> reg_io_mr/dereg_io_mr. However, I don't see those changes in the 1.5.2 ofed
> sources. I had hoped to try applying the patches myself but the structure of the
> unchanged code in the patches appears to be different than the 1.5.2 ofed
> sources. Is there another, more recent, code base that I should be using?
> 

You can't regiter IO memory using ibv_reg_mr() - you can only do that
by registering that memory using physical memory registration which is
available only for kernel consumers. You can't allow userspace to
register physical pages as this is a security breach.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
