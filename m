From: Brian <balexander-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Problem Pinning Physical Memory
Date: Fri, 26 Nov 2010 14:08:07 +0000 (UTC)
Message-ID: <loom.20101126T150517-203@post.gmane.org>
References: <loom.20101122T192618-795@post.gmane.org> <20101124135507.GA23230@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen <eli@...> writes:
> You can't regiter IO memory using ibv_reg_mr() - you can only do that
> by registering that memory using physical memory registration which is
> available only for kernel consumers. You can't allow userspace to
> register physical pages as this is a security breach.

So, would ibv_reg_mr work with physical memory if run from a kernel module? (or
would something else have to be used instead). I have no requirement that this
run in userspace.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
