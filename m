From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: display ocrdma tech preview status
Date: Tue, 23 Aug 2016 16:58:17 +0530
Message-ID: <CANjDDBjq0ueOD3yxYMCaUrYwX6CQu2Sy1tuenw7Yu8hj-W21Xw@mail.gmail.com>
References: <1471521740-28353-1-git-send-email-devesh.sharma@broadcom.com> <a96c1f64-7911-1f96-3a99-2ccedff238a9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a96c1f64-7911-1f96-3a99-2ccedff238a9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 23, 2016 at 12:24 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 8/18/2016 8:02 AM, Devesh Sharma wrote:
> > This patch adds a code to display ocrdma driver technology
> > preview status on ocrdma module load.
> >
> > Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>
> This patch isn't really appropriate for the upstream kernel.  The
> upstream kernel has no specific state of "tech preview".  I know we use
> that term at Red Hat, others like Oracle and SuSE might too, and it has
> specific connotations in terms of the provided support SLA for the given
> technology, but those things are not relevant to upstream kernels.  For
> upstream, only a few things are appropriate:
>
> 1) Your driver is in drivers/staging
> 2) Your driver is fully supported (from a kernel community point of view)

Understood, we will take-up this with Redhat.
Thanks
>
>
> > ---
> >  drivers/infiniband/hw/ocrdma/ocrdma_main.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> > index 07d0c6c..9b8774c 100644
> > --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> > +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> > @@ -444,6 +444,16 @@ void ocrdma_update_link_state(struct ocrdma_dev *dev, u8 lstate)
> >               ocrdma_dispatch_port_active(dev);
> >  }
> >
> > +void ocrdma_print_tech_preview_status(void)
> > +{
> > +     printk(KERN_INFO
> > +            "*************************************************************\n");
> > +     printk(KERN_INFO
> > +            "RoCE supported at Tech Preview level in all OCE141XX Adapters\n");
> > +     printk(KERN_INFO
> > +            "*************************************************************\n");
> > +}
> > +
> >  static struct ocrdma_driver ocrdma_drv = {
> >       .name                   = "ocrdma_driver",
> >       .add                    = ocrdma_add,
> > @@ -456,6 +466,7 @@ static int __init ocrdma_init_module(void)
> >  {
> >       int status;
> >
> > +     ocrdma_print_tech_preview_status();
> >       ocrdma_init_debugfs();
> >
> >       status = be_roce_register_driver(&ocrdma_drv);
> >
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
