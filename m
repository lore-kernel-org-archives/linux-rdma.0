From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/8] verbs: Always allocate a verbs_context
Date: Thu, 11 Jan 2018 10:54:22 -0700
Message-ID: <20180111175422.GG30208@mellanox.com>
References: <20180108212632.5183-1-jgg@ziepe.ca>
 <20180108212632.5183-2-jgg@ziepe.ca>
 <CANjDDBjCUtdVcQBze0PVjC5EaXj5BGTQ5tcn6VcuG0P7auuxoA@mail.gmail.com>
 <20180110173427.GE4776@mellanox.com>
 <CANjDDBgmueZ3fiRJsHEb+p5+H5gX8-7z0NbJShc2bk8yXrh+pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBgmueZ3fiRJsHEb+p5+H5gX8-7z0NbJShc2bk8yXrh+pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>, Alexey Brodkin <abrodkin-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Bar
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 11:14:33PM +0530, Devesh Sharma wrote:
> On Wed, Jan 10, 2018 at 11:04 PM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > On Wed, Jan 10, 2018 at 11:16:20AM +0530, Devesh Sharma wrote:
> >
> >> > +/*
> >> > + * Allocate and initialize a context structure. This is called to create the
> >> > + * driver wrapper, and context_offset is the number of bytes into the wrapper
> >> > + * structure where the verbs_context starts.
> >> > + */
> >> > +void *_verbs_init_and_alloc_context(struct ibv_device *device, int cmd_fd,
> >> > +                                   size_t alloc_size,
> >> > +                                   struct verbs_context *context_offset)
> >> > +{
> >> > +       void *drv_context;
> >> > +       struct verbs_context *context;
> >> > +
> >> > +       drv_context = calloc(1, alloc_size);
> >> > +       if (!drv_context) {
> >> > +               errno = ENOMEM;
> >> > +               close(cmd_fd);
> >> > +               return NULL;
> >> > +       }
> >> > +
> >> > +       context = (struct verbs_context *)((uint8_t *)drv_context +
> >> > +                                          (uintptr_t)context_offset);
> >>
> >> A wrapper macro would do better here?

> > Thing is, this is the only place that does this calculation and it is
> > intimately tied to the definition of the
> > verbs_init_and_alloc_context() macro, so it really is unique and
> > special to this function.
> 
> If that is the case I don't mind leaving this as it is, may be it
> would look better from code readability point of view if we wrap it.

Maybe I should just embrace the Pointer-Arith gcc extension:

  context = drv_context + (uintptr_t)context_offset;

Have to check first how prevalent it is already in the code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
