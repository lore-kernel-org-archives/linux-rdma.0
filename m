From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 06/41] IB/hfi1: add char device instantiation code
Date: Mon, 15 Jun 2015 11:34:23 -0600
Message-ID: <20150615173423.GA528@obsidianresearch.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <20150611230901.16479.18231.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 14, 2015 at 11:58:00PM +0300, Or Gerlitz wrote:
> On Fri, Jun 12, 2015 at 2:09 AM, Mike Marciniszyn
> <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > +++ b/drivers/infiniband/hw/hfi1/device.c
> 
> > +int __init dev_init(void)
> > +{
> > +       int ret;
> > +
> > +       ret = alloc_chrdev_region(&hfi1_dev, 0, HFI1_NMINORS, DRIVER_NAME);
> > +       if (ret < 0) {
> > +               pr_err("Could not allocate chrdev region (err %d)\n", -ret);
> > +               goto done;
> > +       }
> > +
> > +       class = class_create(THIS_MODULE, class_name());
> > +       if (IS_ERR(class)) {
> > +               ret = PTR_ERR(class);
> > +               pr_err("Could not create device class (err %d)\n", -ret);
> > +               unregister_chrdev_region(hfi1_dev, HFI1_NMINORS);
> > +       }
> > +
> > +done:
> > +       return ret;
> > +}
> 
> so what's the role of the char-device? why should a low-level driver
> which is part of the upstream RDMA stack contain a char-device?

I for one would like to see a summary of any non-standard UAPI from
this driver.

Was Al Viro's comment on qib addressed here? That would be a
showstopper for me..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
