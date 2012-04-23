From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: How to use IB netlink infrastructure
Date: Mon, 23 Apr 2012 16:26:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D7D42@ORSMSX101.amr.corp.intel.com>
References: <loom.20120418T090823-45@post.gmane.org>
 <loom.20120423T015347-107@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20120423T015347-107-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Ng <daniel.ng1234-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It's been a few days since I posted this question,
> but I've had no responses so far.

Can I use the IB netlink infrastructure to produce actual RDMA data transfers?

no

If this is not possible, what is the actual entry point in the IB kernel code
that results in a call to get_user_pages()?

I believe the memory registration calls will result in this being called.  Look for ib_uverbs_reg_mr.

> If I'm asking on the wrong list, please suggest an alternative one.

This is the correct list.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
