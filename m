From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix race condition in ib_uverbs_open_qp
Date: Thu, 2 Oct 2014 13:21:28 +0300
Message-ID: <20141002132128.095f9ed7@jpm-OptiPlex-GX620>
References: <1411465106-3117-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237399DE1811@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DE1811-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 23 Sep 2014 15:55:14 +0000
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > --- a/drivers/infiniband/core/uverbs_main.c
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -502,6 +502,10 @@ void ib_uverbs_qp_event_handler(struct ib_event
> > *event, void *context_ptr)
> >  {
> >  	struct ib_uevent_object *uobj;
> > 
> > +	/* for XRC target qp's, check that qp is live */
> > +	if (!event->element.qp->uobject
> > || !event->element.qp->uobject->live)
> > +		return;
> 
> Isn't checking 'live' sufficient?

Unfortunately, not -- uobject might be NULL, in which case we will get
a kernel Oops.

However, checking that uobject is NULL alone is not sufficient -- it
might not yet be live.

-Jack


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
