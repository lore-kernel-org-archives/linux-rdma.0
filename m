From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] MAINTAINERS: Update Intel RDMA RNIC driver maintainers
Date: Thu, 6 Oct 2016 17:52:47 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB10A8C79D@fmsmsx104.amr.corp.intel.com>
References: <20161005143054.4844-1-henry.orosco@intel.com>
 <20161005153530.GA11148@flatif-MOBL1>
 <20161005191229.GI18636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161005191229.GI18636-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Orosco, Henry" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

I will continue to maintain libnes, libi40iw and libiwpm in rdma-core.  Steve Wise has significantly contributed to libiwpm which is iWarp related service and he may be interested in co-maintaining it.

Thank you,
Tatyana

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
Sent: Wednesday, October 05, 2016 2:12 PM
To: Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: Re: [PATCH] MAINTAINERS: Update Intel RDMA RNIC driver maintainers

On Wed, Oct 05, 2016 at 10:35:30AM -0500, Faisal Latif wrote:
> On Wed, Oct 05, 2016 at 07:30:54AM -0700, Henry Orosco wrote:
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS index cc77b9a..32f535e 100644
> > +++ b/MAINTAINERS
> > @@ -6188,6 +6188,7 @@ R:     Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >  R:     Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >  R:     Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >  R:     Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > +R:     Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >  L:     linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >  S:     Supported
> >  F:     drivers/infiniband/hw/i40iw/
> 
> Acked-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Are any of you going to continue supporting the user space component that now lives in rdma-core?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
