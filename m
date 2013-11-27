From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Subject: non-const pointer void * addr in rdma_reg_* and rdma_post_[send|write]
Date: Wed, 27 Nov 2013 19:00:02 +0100
Message-ID: <9A0BFE48-9AED-4C41-80C8-F943D1C64E99@gmx.net>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I just started working with librdmacm and I was wondering if there is a specific reason why rdma_reg_* functions and rdma_post_send/write functions take the local memory address as non-const pointer "void * addr". These functions shouldn't and don't change the memory pointed to by addr. I think this should be made explicit by using the type const void * for addr.
In case you agree, I would volunteer to make the necessary changes.

Best regards,
Hannes Weisbach--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
