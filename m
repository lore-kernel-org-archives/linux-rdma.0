From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] RDMA/cma: Make IPoIB port space multicast joins
 consistent with IPoIB
Date: Thu, 23 Aug 2012 19:00:17 +0300
Message-ID: <CAJZOPZK4qeCeyZ8D4_Dk=-p1Sk6SwujvRrFSSipnzr6hxJnrNg@mail.gmail.com>
References: <1345732127-7765-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8A8DA@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8A8DA-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 23, 2012 at 6:45 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index 7172559..f7e4cb9 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -3056,9 +3056,16 @@ static int cma_join_ib_multicast(struct rdma_id_private
> > *id_priv,
> >                   IB_SA_MCMEMBER_REC_FLOW_LABEL |
> >                   IB_SA_MCMEMBER_REC_TRAFFIC_CLASS;
> >
> > -     if (id_priv->id.ps == RDMA_PS_IPOIB)
> > +     if (id_priv->id.ps == RDMA_PS_IPOIB) {
> >               comp_mask |= IB_SA_MCMEMBER_REC_RATE |
> > -                          IB_SA_MCMEMBER_REC_RATE_SELECTOR;
> > +                          IB_SA_MCMEMBER_REC_RATE_SELECTOR |
> > +                          IB_SA_MCMEMBER_REC_MTU_SELECTOR |
> > +                          IB_SA_MCMEMBER_REC_MTU |
> > +                          IB_SA_MCMEMBER_REC_HOP_LIMIT;
> > +
> > +             rec.rate_selector = IB_SA_EQ;
> > +             rec.mtu_selector  = IB_SA_EQ;
> > +     }
>
> So, the rdma cm joins a group without these set.  The SA picks some values, which differ from those used by ipoib.  IPoIB then joins a group, which fails because of the mismatch.  Is this the problem?


YES
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
