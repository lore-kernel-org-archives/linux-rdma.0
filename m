From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/qedr: Notify user application if DPM
 is supported
Date: Tue, 20 Jun 2017 09:39:28 -0600
Message-ID: <20170620153928.GB29283@obsidianresearch.com>
References: <1497790871-23945-1-git-send-email-Ram.Amrani@cavium.com>
 <1497790871-23945-2-git-send-email-Ram.Amrani@cavium.com>
 <20170619155553.GB10188@obsidianresearch.com>
 <BN3PR07MB2578EC6DD9C3DF920388418AF8C50@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170620104104.GS17846@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170620104104.GS17846-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 20, 2017 at 01:41:04PM +0300, Leon Romanovsky wrote:
> On Tue, Jun 20, 2017 at 08:34:24AM +0000, Amrani, Ram wrote:
> > > Um, how is uapi compatibility achieved here? I don't see any size
> > > tests related to qedr_alloc_ucontext_resp:
> > >
> > > struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
> > >                                         struct ib_udata *udata)
> > > {
> > >         struct qedr_alloc_ucontext_resp uresp;
> > >         rc = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> > >
> > > Seems bad.
> > >
> > > Same with the other patch.
> > >
> > > Jason
> >
> > It does seem bad. Did you had in mind something like this:
> >          struct qedr_alloc_ucontext_resp uresp;
> >          size_t copy_size = min_t(size_t, sizeof(uresp), udata->outlen);
> >
> >          rc = ib_copy_to_udata(udata, &uresp, copy_size);
> >
> > If so, it makes sense to me to protect everybody's transactions.
> > I.e.:
> > 	static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len)
> > 	{
> > 		size_t copy_size = min_t(size_t, sizeof(uresp), udata->outlen);
> > 		return copy_to_user(udata->outbuf, src, copy_size) ? -EFAULT : 0;
> > 	}
> >
> > Likewise, a protection can be added for ib_copy_from_udata() too.
> 
> mlx4 and mlx5 don't need such protection, because they calculates the
> response length and ensure that no extra data is copied.

so you need to to whatever mlx4/5 do, and if we have some code
duplication then maybe a new ib_copy_to_udate_ex function is sensible.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
