From: "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/5] i40iw: Do not generate CQE for RTR on QP flush
Date: Mon, 2 Oct 2017 15:12:33 +0000
Message-ID: <5C5647B5F4794941BAAC07CF28785CBC33F61674@fmsmsx101.amr.corp.intel.com>
References: <20170930012942.9128-1-shiraz.saleem@intel.com>
 <20170930012942.9128-3-shiraz.saleem@intel.com>
 <20171001061928.GD2031@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171001061928.GD2031-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH 2/5] i40iw: Do not generate CQE for RTR on QP flush
> 
> On Fri, Sep 29, 2017 at 08:29:39PM -0500, Shiraz Saleem wrote:
> > From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > If RTR WQE is posted and QP is flushed, a CQE is incorrectly generated
> > for the RTR WQE. Add code to look for the RTR and not generate a CQE
> > when QP is flushed.
> >
> > +	u8 first_sq_wq;
> 
> Isn't this supposed to be "bool" and not "u8"?
Agreed. We will send a V2.

Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
