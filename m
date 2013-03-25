From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Different signatures to ibv_open_xrcd - branch issue?
Date: Mon, 25 Mar 2013 12:51:28 +0200
Message-ID: <51502C30.2000806@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

In libibverbs/include/infiniband/verbs.h the API "ibv_open_xrcd" is 
defined with the following signature;
static inline struct ibv_xrcd *
ibv_open_xrcd(struct ibv_context *context, struct ibv_xrcd_init_attr 
*xrcd_init_attr)
And libibverbs/examples/xsrq_pingpong.c the call is O.K. however in 
librdmacm/examples/rdma_xserver.c I see a different call sequence i.e. 
"attr.ext.xrc.xrcd = ibv_open_xrcd(srq_id->verbs, -1, 0);"
My git branch for libivvers is based on origin/xrc2 and for librdmacm is 
based on origin/xrc.

Is any of my branches wrong?

best regards,

S.P.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
