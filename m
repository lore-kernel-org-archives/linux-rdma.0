From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] MAINTAINERS: Add maintainer section for hfi1
Date: Tue, 18 Aug 2015 16:33:53 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2579977D@fmsmsx120.amr.corp.intel.com>
References: <20150818140609.3571.87830.stgit@phlsvslse11.ph.intel.com>
 <20150818154403.GB3049@kroah.com>
 <32E1700B9017364D9B60AED9960492BC257996DC@fmsmsx120.amr.corp.intel.com>
 <20150818161407.GA4291@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818161407.GA4291-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH] MAINTAINERS: Add maintainer section for hfi1
> 
> On Tue, Aug 18, 2015 at 04:04:15PM +0000, Marciniszyn, Mike wrote:
> > > > +HFI1 DRIVER
> > > > +M:	Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > +L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > +L:	devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
> > > > +S:	Supported
> > > > +F:	drivers/staging/hfi1
> > >
> > > Why do this for a driver that is being deleted?
> > >
> >
> > You are thinking of ipath.   This is a new driver.
> 
> Really?  Why is a new driver not in my tree?  Why is in staging at all?
>

It is in linux-next, I guess by way of a pull request from Doug.

Doug, can you respond to why staging and get this patch into your repo?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
