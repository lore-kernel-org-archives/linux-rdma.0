From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for
 datagram mode
Date: Tue, 12 Jun 2012 20:44:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A30177@ORSMSX101.amr.corp.intel.com>
References: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A25BFF@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZ+WX6gXAXESWge4ZsQVBun+bhWoui+f5DeKkqB3uEB2Hg@mail.gmail.com>
 <CAJZOPZJL+qhk4CcUpmXffrTsS85fMJtxvuQePzpjN902Eg5h5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJL+qhk4CcUpmXffrTsS85fMJtxvuQePzpjN902Eg5h5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Do you have something more specific re how to actually align (say) the
> RSS QP group into the framework used by XRC?

Not really.  That was more of a conceptual statement regarding the design.  The operation, particularly on the receive side, just seems similar.

I don't think we should force a fit if it doesn't, but what's missing from the XRC framework to support RSS?

I guess more specifically, if I look at the changes to ib_verbs.h, can we avoid the changes to ib_qp_init_attr and ib_qp?  I.e. why can't the qp_type indicate the type of group, or why couldn't ib_open_qp() be used?  Should the associated QPs share some sort of common protection domain, like an XRCD, to provide some security on sharing the underlying QP across processes?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
