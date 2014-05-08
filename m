From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 2/3] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Thu, 8 May 2014 23:05:41 +0300
Message-ID: <CAJZOPZLrLL444ce_hXdnN5_JPfUVAy_Qsj+eVo2-YG3Jqqe01Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 8, 2014 at 10:29 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> On Thu, May 08, 2014 at 09:51:22AM +0300, Or Gerlitz wrote:
>
> > In order to implement RoCE IP based addressing for UD QPs, without
> > introducing uverbs changes, we need a way to resolve the L2 Ethernet
> > addresses from user-space.
>
> Please put anything that changes the public verbs ABI in a seperate
> patch.
>
> Burying the create_ah_ex stuff in this giant thing is not condusive to
> reviewing the ABI portion.
>
> The ABI is *important* do everything you can to bring as many eyes as
> possible to those changes!!
>
> > +struct ibv_ah_attr_ex {
> > +     struct ibv_global_route grh;
> > +     uint16_t                dlid;
> > +     uint8_t                 sl;
> > +     uint8_t                 src_path_bits;
> > +     uint8_t                 static_rate;
> > +     uint8_t                 is_global;
> > +     uint8_t                 port_num;
> > +     uint32_t                comp_mask;
> > +     struct {
> > +             enum ll_address_type type;
> > +             uint32_t        len;
> > +             char            *address;
> > +     } ll_address;
> > +     uint16_t                vid;
> > +};
>
> The above looks sorta reasonable, but:
>
> What is the 'char *address'? Should it be 'const void *' ?????



Hi Jason,

Thanks for looking && commenting, Matan and myself will digest your
feedback and respond/fix what's needed. BTW - note that this is V3
where V0/1/2 were posted three months ago, where the earlier rounds of
reviewers were focused on other portions of the series. So better late
than never, review on the verbs extensions elements now happens :)

>
>
> Who owns that memory? Who allocates it, who frees it? Seems sketchy
> as heck.
>
> What happens if a ibv_ah_attr_ex is returned in some kind of
> ibv_qp_attr_ex structure from a future query_qp?
>
> Can you just put in a 'uint64_t address[8];' or sockaddr_storage, or
> something?
>
> > +
> >  enum ibv_srq_attr_mask {
> >       IBV_SRQ_MAX_WR  = 1 << 0,
> >       IBV_SRQ_LIMIT   = 1 << 1
> > @@ -968,11 +998,14 @@ enum verbs_context_mask {
> >       VERBS_CONTEXT_QP        = 1 << 2,
> >       VERBS_CONTEXT_CREATE_FLOW = 1 << 3,
> >       VERBS_CONTEXT_DESTROY_FLOW = 1 << 4,
> > -     VERBS_CONTEXT_RESERVED  = 1 << 5
> > +     VERBS_CONTEXT_CREATE_AH = 1 << 5,
> > +     VERBS_CONTEXT_RESERVED  = 1 << 6
> >  };
>
> What is going on here??
>
> verbs_context_mask is messed up already!?
>
> It is NOT supposed to be a mask if the function is available - we
> can already test for NULL for that.
>
> It is supposed to indicate if structures *allocated by the provider*
> are extended.
>
> For instance if VERBS_CONTEXT_QP is set, then everyone knows that the
> 'struct ibv_qp' returned by *any* driver function (crate_qp, open_qp,
> create_qp_ex) is convertible to 'verbs_qp'.
>
> VERBS_CONTEXT_CREATE_FLOW/VERBS_CONTEXT_DESTROY_FLOW are screwed
> up. They shouldn't even exist, there is no unextended ibv_flow
> structure to worry about.
>
> Fix this patch to not add VERBS_CONTEXT_CREATE_AH, ibv_ah_attr_ex is
> not a provider allocated structure so it doesn't need an entry.
>
> Please send a patch to remove the screwed up two above and replace
> with RESERVED.
>
> And BE MORE CAREFUL. THIS SHOULD NOT HAVE HAPPENED!
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
