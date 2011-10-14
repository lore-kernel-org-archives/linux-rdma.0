From: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Subject: RE: rdma: 3.1.0-rc9 breaks UD
Date: Fri, 14 Oct 2011 11:31:28 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1110141131150.6411@router.home>
References: <alpine.DEB.2.00.1110140852210.6411@router.home> <1828884A29C6694DAF28B7E6B8A8237316E6AF8E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6AF8E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 14 Oct 2011, Hefty, Sean wrote:

> > Running ibv_ud_pingpong and ibc_uc_pingpong between two hosts. One with
> > OFED 1.5.3.1 (Ubuntu LTS 10.04) and another on linux 3.1.0-rc9 (Same
> > ubuntu version uderlying) with the upstream libraries.
>
> FWIW, I was able to run 3.1-rc9 in loopback and between 3.0 and 3.1-rc9 systems.  I don't have 2 systems configured with 3.1-rc9.  I'm using upstream builds of all libraries.

Our 3.1-rc9 included Rolands for-next branch.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
