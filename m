From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 16:29:50 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
 <20150818161102.GA4040@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818161102.GA4040-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
> 
> On Tue, Aug 18, 2015 at 10:15:42AM -0400, Mike Marciniszyn wrote:
> > The move from infiniband to staging requires a temporary PCI
> > dependency to fix 0-day build issues.  The
> > drivers/infiniband/hw/Kconfig gratuitously added it for all drivers.
> >
> > Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/staging/hfi1/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Why are these drivers not in drivers/staging/infiniband/ ?  Why do they all
> need their own drivers/staging/ directory?
> 

Greg, what is the path name convention for adding a driver to staging when its eventual destination is part of a subsystem?  Perhaps it should be drivers/staging/hw/hfi1?

Doug, can you get this patch so that linux-next is fixed?

Mike 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
