From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: non-const pointer void * addr in rdma_reg_* and
 rdma_post_[send|write]
Date: Wed, 27 Nov 2013 18:07:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D08D9B@ORSMSX109.amr.corp.intel.com>
References: <9A0BFE48-9AED-4C41-80C8-F943D1C64E99@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9A0BFE48-9AED-4C41-80C8-F943D1C64E99-hi6Y0CQ0nG0@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I just started working with librdmacm and I was wondering if there is a
> specific reason why rdma_reg_* functions and rdma_post_send/write functions
> take the local memory address as non-const pointer "void * addr". These
> functions shouldn't and don't change the memory pointed to by addr. I think
> this should be made explicit by using the type const void * for addr.
> In case you agree, I would volunteer to make the necessary changes.

The librdmacm calls simply abstract the libibverbs ibv_post_send() call.  I agree that making them const makes sense, but the inline code would simply cast away the const anyway.  Either way seems fine with me.  If you submitted a patch, I would accept it.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
