From: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] usnic: corretly check failed allocation
Date: Thu, 15 Oct 2015 15:52:32 -0500
Message-ID: <20151015205232.GA70439@DGOODELL-M-F02A.cisco.com>
References: <1444926460-29333-1-git-send-email-wuninsu@gmail.com>
 <1D90F355-D799-4E9E-9526-836B71355109@cisco.com>
 <CAGoFzNdD+b1co+6zsEo94KP3APLk353fwOQkgdMjh01UOG-9Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGoFzNdD+b1co+6zsEo94KP3APLk353fwOQkgdMjh01UOG-9Ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2015 at 01:41:06PM -0400, Insu Yun wrote:
> On Thu, Oct 15, 2015 at 1:17 PM, Dave Goodell (dgoodell) <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
> > wrote:
> 
> > On Oct 15, 2015, at 11:27 AM, Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > >       us_ibdev->ufdev = usnic_fwd_dev_alloc(dev);
> > > -     if (IS_ERR_OR_NULL(us_ibdev->ufdev)) {
> > > +     if (!us_ibdev->ufdev) {
> > >               usnic_err("Failed to alloc ufdev for %s with err %ld\n",
> > >                               pci_name(dev), PTR_ERR(us_ibdev->ufdev));
> >
> > This PTR_ERR and message make less sense now.
> >
> 
>   Do you think what is better? removing error code? or change
> PTR_ERR(us_ibdev->ufdev)
> to -EFAULT

I would write it as:

        usnic_err("Failed to alloc ufdev for %s\n", pci_name(dev));

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
