From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not block QP attr_masks used by
 older kernels
Date: Sun, 5 Nov 2017 19:28:18 -0700
Message-ID: <20171106022818.GE26011@ziepe.ca>
References: <20171102215031.GY18874@ziepe.ca>
 <20171105071029.GC31774@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171105071029.GC31774-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 05, 2017 at 09:10:29AM +0200, Leon Romanovsky wrote:
> > @@ -909,6 +909,15 @@ enum ibv_qp_attr_mask {
> >  	IBV_QP_PATH_MIG_STATE		= 1 << 18,
> >  	IBV_QP_CAP			= 1 << 19,
> >  	IBV_QP_DEST_QPN			= 1 << 20,
> > +#if 0
> > +	/* These bits were supported on older kernels, but never exposed to
> > +	 * user space:
> > +	 */
> > +	_IBV_QP_COMPAT1			= 1 << 21,
> > +	_IBV_QP_COMPAT2			= 1 << 22,
> > +	_IBV_QP_COMPAT3			= 1 << 23,
> > +	_IBV_QP_COMPAT3			= 1 << 24,
> > +#endif
> 
> Why do we need "if 0" in production code (global header file)?

It is really a comment. I don't want to introduce new global symbols
just for this, or loose the obvious formatting structure of the enum.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
