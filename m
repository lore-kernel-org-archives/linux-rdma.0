From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/core: Fix race condition in ib_uverbs_open_qp
Date: Thu, 2 Oct 2014 14:34:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DE5662@ORSMSX109.amr.corp.intel.com>
References: <1411465106-3117-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237399DE1811@ORSMSX109.amr.corp.intel.com>
 <20141002132128.095f9ed7@jpm-OptiPlex-GX620>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141002132128.095f9ed7@jpm-OptiPlex-GX620>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > +	/* for XRC target qp's, check that qp is live */
> > > +	if (!event->element.qp->uobject
> > > || !event->element.qp->uobject->live)
> > > +		return;
> >
> > Isn't checking 'live' sufficient?
> 
> Unfortunately, not -- uobject might be NULL, in which case we will get
> a kernel Oops.

I see - thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
