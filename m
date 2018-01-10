From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/8] verbs: Always allocate a verbs_context
Date: Wed, 10 Jan 2018 10:34:27 -0700
Message-ID: <20180110173427.GE4776@mellanox.com>
References: <20180108212632.5183-1-jgg@ziepe.ca>
 <20180108212632.5183-2-jgg@ziepe.ca>
 <CANjDDBjCUtdVcQBze0PVjC5EaXj5BGTQ5tcn6VcuG0P7auuxoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBjCUtdVcQBze0PVjC5EaXj5BGTQ5tcn6VcuG0P7auuxoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>, Alexey Brodkin <abrodkin-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Bar
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 11:16:20AM +0530, Devesh Sharma wrote:

> > +/*
> > + * Allocate and initialize a context structure. This is called to create the
> > + * driver wrapper, and context_offset is the number of bytes into the wrapper
> > + * structure where the verbs_context starts.
> > + */
> > +void *_verbs_init_and_alloc_context(struct ibv_device *device, int cmd_fd,
> > +                                   size_t alloc_size,
> > +                                   struct verbs_context *context_offset)
> > +{
> > +       void *drv_context;
> > +       struct verbs_context *context;
> > +
> > +       drv_context = calloc(1, alloc_size);
> > +       if (!drv_context) {
> > +               errno = ENOMEM;
> > +               close(cmd_fd);
> > +               return NULL;
> > +       }
> > +
> > +       context = (struct verbs_context *)((uint8_t *)drv_context +
> > +                                          (uintptr_t)context_offset);
> 
> A wrapper macro would do better here?

What would we call it? It is kinda of a reverse container of

Thing is, this is the only place that does this calculation and it is
intimately tied to the definition of the
verbs_init_and_alloc_context() macro, so it really is unique and
special to this function.

To elaborate on what is happening here..

The driver calls

        cntx = verbs_init_and_alloc_context(vdev, cmd_fd, cntx, ibvctx);

Where:
        struct bnxt_re_context *cntx;

And the name 'ibvctx' is like container_of, where it refers to the
struct member inside cntx:

struct bnxt_re_context {
        struct verbs_context ibvctx;

This allows the allocation function to both return the 'struct
bnxt_re_context' and find the 'struct verbs_context' where the driver
placed it.

The alternative here is to force the driver to put the verbs_context
at the start of the struct, then eliminate the context_offset entirely
and replace it with a static assert scheme.

Do you think that is nicer?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
