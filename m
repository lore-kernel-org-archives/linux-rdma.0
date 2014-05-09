From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 3/3] Add ibv_query_port_ex support
Date: Fri, 9 May 2014 12:10:43 -0600
Message-ID: <20140509181043.GC18257@obsidianresearch.com>
References: <1399531883-30599-1-git-send-email-ogerlitz@mellanox.com>
 <1399531883-30599-4-git-send-email-ogerlitz@mellanox.com>
 <20140508190951.GB25849@obsidianresearch.com>
 <CAL1RGDUiBtOaYKZVR3ghOZzG6J0p5EV5o4FTTW0E43mHz-BaVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUiBtOaYKZVR3ghOZzG6J0p5EV5o4FTTW0E43mHz-BaVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 09, 2014 at 07:01:36AM -0700, Roland Dreier wrote:
> On Thu, May 8, 2014 at 12:09 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >>  struct verbs_context {
> >>       /*  "grows up" - new fields go here */
> >> +     int (*drv_query_port_ex)(struct ibv_context *context, uint8_t port_num,
> >> +                              struct ibv_port_attr_ex *port_attr);
> >> +     int (*lib_query_port_ex)(struct ibv_context *context, uint8_t port_num,
> >> +                               struct ibv_port_attr_ex *port_attr);
> >>       struct ibv_ah * (*drv_ibv_create_ah_ex)(struct ibv_pd *pd,
> >>                                               struct ibv_ah_attr_ex *attr);
> >>       int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
> >
> > I'm not sure what Roland decided to merge, but I am surprised to see
> > drv_ elements here. That was nix'd in the round of review of the first
> > patch set. eg create_qp_ex/etc don't have them.
> >
> > The flow is such that the verbs code has a chance to capture and
> > override the function pointer after the driver sets it, there is no
> > purpose to the drv_ values.
> >
> > I wouldn't like to see more added, and I think you should make a patch
> > to ensure they are not necessary before it propogates too far.
> 
> Sorry, I was not aware of the feeling on drv_XXX members here and I
> don't think I saw any review comments about them.  (Maybe they got
> lost in the flood of "merge it merge it merge it" emails)

To be honest, I never bothered looking at any patches beyond the core
extension patches. There was no indication from you that they would
ever be merged, so it didn't feel like good use of my time.

> Anyway I'm wondering if there's a way to recover without breaking ABI
> here (or by breaking ABI in a manageable way).  The only library using
> this stuff (that I know of) is libmlx4, maybe we can spin quick
> releases of both and pretend libibverbs 1.1.8 never happened?

I think the best approach is to rescind the last libmlx4 version so it
never gets used then:
  - Rename drv_* to _reserved_X
  - Drop all references to drv_* from libverbs
  - Have libmlx4 set the ib_ pointer only

For the other problem
  - Replace VERBS_CONTEXT_CREATE_FLOW and VERBS_CONTEXT_DESTROY_FLOW
    with _RESERVED_x
  - Drop the references from mlx4

These are not a big deal as long as things are fixed quickly before
the bad libmlx4 gets widely used. Then we could reclaim the reserved_X
entires someday.

The biggest issue I see is that this is creating an anti-pattern, so
we need to stamp that out in the verbs source.

I expect Or will get right on this..

Or, it would be helpful to me if you could go back to libibverbs
commit cbf2a35162afcc9e97870b7b18d6477133a8dfa2 and post the corrected
flow steering patches with the ABI/API change as a distinct patch. I
think I caught everything, but lets also correct that process error
and hopefully Sean/etc can comment too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
