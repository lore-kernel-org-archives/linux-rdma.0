From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Using XRC between kernel and user space.
Date: Thu, 4 Apr 2013 20:44:48 +0300
Message-ID: <515DBC10.1080009@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I wonder how a kernel "program" and a user space one can communicate 
using XRC.
A example for such an application is iSER kernel initiator connected to 
tgtd target that runs in user space.
The XRC domain in the kernel is created with "struct ib_xrcd 
*ib_alloc_xrcd(struct ib_device *device)" while in the user space it is 
created with "static inline struct ibv_xrcd * ibv_open_xrcd(struct 
ibv_context *context, struct ibv_xrcd_init_attr *xrcd_init_attr)".
When looking in "xrc_pingpong.c" example we can see that the attribute 
has some file descriptor of some file ("/tmp/xrc_domain").
So how a kernel "program" on one machine can communicate with a user 
space program on another one?
The XRC annex (page 9) sates that all QP should belong to the same XRC 
domain.

S.P.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
