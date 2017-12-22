From: "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 9/9] i40iw: Fix the connection ORD value for
 loopback
Date: Fri, 22 Dec 2017 20:35:39 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A789E76DD2@fmsmsx116.amr.corp.intel.com>
References: <20171222154702.12632-1-shiraz.saleem@intel.com>
 <20171222154702.12632-10-shiraz.saleem@intel.com>
 <20171222161049.GB30884@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222161049.GB30884-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH rdma-next 9/9] i40iw: Fix the connection ORD value for
> loopback
> 
> > +	u16 private_data_len = conn_param->private_data_len;
> > +	void *private_data = (void *)conn_param->private_data;
> 
> Why casting away const here? That doesn't seem like a good idea..
> 

Agreed. Sent v1 with it fixed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
