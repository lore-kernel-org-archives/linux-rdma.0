From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Wed, 6 Sep 2017 08:48:46 +0300
Message-ID: <20170906054845.GB2456@yuvallap>
References: <20170905144625.11768-1-yuval.shaia@oracle.com>
 <20170906040604.GF18084@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170906040604.GF18084-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 06, 2017 at 07:06:04AM +0300, Leon Romanovsky wrote:
> > diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/cxgb3/Kconfig
> > index 2b6352b85485..97046365f1c7 100644
> > --- a/drivers/infiniband/hw/cxgb3/Kconfig
> > +++ b/drivers/infiniband/hw/cxgb3/Kconfig
> > @@ -1,5 +1,6 @@
> >  config INFINIBAND_CXGB3
> >  	tristate "Chelsio RDMA Driver"
> > +	depends on PCI
> >  	depends on CHELSIO_T3 && INET
> 
> I didn't check all other drivers, but this particular is already dependent on PCI.
> 
> It depends on CHELSIO_T3, which depends on "PCI && INET". So instead of
> adding new dependency here, it will be nice to remove INET.

Thanks Leon.
I will post v3 with this fix along with two others but will fix the INET in
a separate patch since i want this one to handle only the PCI dependency.

> 
> Thanks
> 
> >  	select GENERIC_ALLOCATOR

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
