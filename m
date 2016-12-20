From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
Date: Tue, 20 Dec 2016 12:44:04 +0000
Message-ID: <748B799B6A00724488C603FD7E5E7EB94CBAEEA0@FMSMSX114.amr.corp.intel.com>
References: <20161219203227.86392-1-henry.orosco@intel.com>
 <20161220112417.GV1074@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161220112417.GV1074-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Orosco, Henry" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Tuesday, December 20, 2016 5:24 AM
> To: Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Tung, Chien Tin <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH] i40iw: Set 128B as the only supported RQ WQE size
> 
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > index 12acd68..57d3f1d 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_ucontext.h
> > @@ -39,8 +39,8 @@
> >
> >  #include <linux/types.h>
> >
> > -#define I40IW_ABI_USERSPACE_VER 4
> > -#define I40IW_ABI_KERNEL_VER    4
> > +#define I40IW_ABI_VER 5
> > +
> 
> Why did you remove defines and move to use constants "4" and "5" instead?
[Chien Tin Tung] This is the ABI version change, did you read the commit message?  Two defines were not necessary.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
