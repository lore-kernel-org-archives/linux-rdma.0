From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 2/9] IB/core: Change ib_create_cq to use
 struct ib_cq_init_attr
Date: Tue, 2 Jun 2015 11:27:11 -0600
Message-ID: <20150602172711.GB17776@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433074457-26437-3-git-send-email-ogerlitz@mellanox.com>
 <20150601165335.GB14391@obsidianresearch.com>
 <CAAKD3BAyNpEKwM7xu=LzFo2F=qP=EN9ZteL2yyAgBVuPNmvtqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BAyNpEKwM7xu=LzFo2F=qP=EN9ZteL2yyAgBVuPNmvtqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 02, 2015 at 10:29:14AM +0300, Matan Barak wrote:
> On Mon, Jun 1, 2015 at 7:53 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Sun, May 31, 2015 at 03:14:10PM +0300, Or Gerlitz wrote:
> >
> >> +     struct ib_cq_init_attr cq_attr;
> >>
> >>       /* Create new device info */
> >>       port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
> >> @@ -2943,9 +2944,11 @@ static int ib_mad_port_open(struct ib_device *device,
> >>       if (has_smi)
> >>               cq_size *= 2;
> >>
> >> +     memset(&cq_attr, 0, sizeof(cq_attr));
> >> +     cq_attr.cqe = cq_size;
> >
> > Why does this patch switch to using memset when the prior patch used
> > = {} ?
> >
> 
> Why does it matter? Both are valid approaches, aren't they?

Sure, but why mix and match techniques in the same code base? Is there
a reason?

> >> @@ -1075,12 +1075,11 @@ EXPORT_SYMBOL(ib_destroy_qp);
> >>  struct ib_cq *ib_create_cq(struct ib_device *device,
> >>                          ib_comp_handler comp_handler,
> >>                          void (*event_handler)(struct ib_event *, void *),
> >> -                        void *cq_context, int cqe, int comp_vector)
> >> +                        void *cq_context, struct ib_cq_init_attr *cq_attr)
> >>  {
> >>       struct ib_cq *cq;
> >> -     struct ib_cq_init_attr attr = {.cqe = cqe, .comp_vector = comp_vector};
> >>
> >> -     cq = device->create_cq(device, &attr, NULL, NULL);
> >> +     cq = device->create_cq(device, cq_attr, NULL, NULL);
> >
> > How does this compile without warnings?
> >
> 
> Do you mean that there's a missing const here? It doesn't (and shouldn't)
> cause warnings.

Warnings will be emitted when you compile with -Wcast-qual (make W=3).

Some of the static tools may warn/error on implicitly casting away
const, I'm not sure.

It is broadly undesirable to implicitly cast away const, even if the
Kernel warning defaults don't produce the message.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
