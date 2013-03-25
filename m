From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Different signatures to ibv_open_xrcd - branch issue?
Date: Mon, 25 Mar 2013 16:35:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F367AB8@ORSMSX101.amr.corp.intel.com>
References: <51502C30.2000806@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51502C30.2000806-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In libibverbs/include/infiniband/verbs.h the API "ibv_open_xrcd" is
> defined with the following signature;
> static inline struct ibv_xrcd *
> ibv_open_xrcd(struct ibv_context *context, struct ibv_xrcd_init_attr
> *xrcd_init_attr)
> And libibverbs/examples/xsrq_pingpong.c the call is O.K. however in
> librdmacm/examples/rdma_xserver.c I see a different call sequence i.e.
> "attr.ext.xrc.xrcd = ibv_open_xrcd(srq_id->verbs, -1, 0);"
> My git branch for libivvers is based on origin/xrc2 and for librdmacm is
> based on origin/xrc.
> 
> Is any of my branches wrong?

The librdmacm changes are against an older version of the changes.  The libibverbs has the correct API, which incorporates the extension mechanism that's been discussed.  Once libibverbs has been accepted, the librdmacm can be updated.  (The librdmacm code is surrounded by a #define, which disables it from the build.)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
