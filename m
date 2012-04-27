From: Daniel Ng <daniel.ng1234-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to use IB netlink infrastructure
Date: Fri, 27 Apr 2012 05:25:46 +0000 (UTC)
Message-ID: <loom.20120427T065509-752@post.gmane.org>
References: <loom.20120418T090823-45@post.gmane.org> <loom.20120423T015347-107@post.gmane.org> <1828884A29C6694DAF28B7E6B8A82373469D7D42@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean <sean.hefty@...> writes:
>> What is the actual entry point in the IB kernel code
>> that results in a call to get_user_pages()?
> 
> I believe the memory registration calls will result in this being called.  
>Look for ib_uverbs_reg_mr.

Thanks for your helpful suggestions Sean.

I've noticed this article on LWN.net:

http://lwn.net/Articles/133649/

It was written in 2005 and points out some shortcomings with using
get_user_pages() for RDMA. Do you know if these shortcomings have been addressed
since 2005?

If not, is there perhaps another way RDMA has been implemented in the kernel?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
