From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Sharing MR Between Multiple Connections
Date: Wed, 14 Nov 2012 18:19:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346AD8BC5@ORSMSX101.amr.corp.intel.com>
References: <CAPb9-SHQ=r1MYu=771z2cTi9bAq=ueWMjw2vFDoSHbNByK5awA@mail.gmail.com>
	<CAPb9-SHVmNFm-rCviMLfu7GQhK065fWGTGzJssxLrLMZHDMFpQ@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346AD8B5A@ORSMSX101.amr.corp.intel.com>
 <CAPb9-SEHXKKmVGhsxTrku19H1q3hBE=iejjYMOfMSk+K1W09Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPb9-SEHXKKmVGhsxTrku19H1q3hBE=iejjYMOfMSk+K1W09Zg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Mitchell <kermmartian-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The rdma_cm will automatically allocate one PD per RDMA device.  You can
> share this PD among multiple connections.  To use this PD, pass in NULL into
> rdma_create_qp().  The rdma_cm_id will reference the shared PD.
> 
> That's great to know; thanks Sean (and everyone else who confirmed
> that a shared PD and possibly CQ is the way to go). Is there a way to
> reference this shared PD in ibv_reg_mr() as well? It seems that using
> NULL there too is not the solution, and I'm having difficulty tracing
> back from struct rdma_cm_id to find out where that shared PD is
> stored. I'd prefer to use this solution for simplicity's sake, so any
> additional details would be greatly appreciated. For what it's worth,
> I tried passing NULL to rdma_create_qp() as you suggested, and found
> it to work admirably.

struct rdma_cm_id *id;

ibv_reg_mr(id->pd, ...);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
