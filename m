From: Daniel Ng <daniel.ng1234-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How to use IB netlink infrastructure
Date: Wed, 18 Apr 2012 07:18:45 +0000 (UTC)
Message-ID: <loom.20120418T090823-45@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, I'm new to IB and RDMA.

Can I use the IB netlink infrastructure to produce actual RDMA data transfers?

If so, can you please give an example showing the path of function calls? I
would like to see how get_user_pages() ultimately gets called as a result of a
netlink operation.

If this is not possible, what is the actual entry point in the IB kernel code
that results in a call to get_user_pages()?  

Cheers,
Daniel

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
