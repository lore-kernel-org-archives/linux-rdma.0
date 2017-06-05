From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/bnxt_re: Check return value from get_link_ksettings
Date: Mon, 5 Jun 2017 17:30:28 +0300
Message-ID: <20170605143028.GB3391@yuvallap>
References: <20170605091429.16232-1-yuval.shaia@oracle.com>
 <CAG9sBKODJaecc2m-GTqU8H=jttPAr+iCcZK0wknEfXerz6TL+A@mail.gmail.com>
 <20170605124213.GA2750@yuvallap>
 <20170605133831.GO6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605133831.GO6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 05, 2017 at 04:38:31PM +0300, Leon Romanovsky wrote:
> On Mon, Jun 05, 2017 at 03:42:14PM +0300, Yuval Shaia wrote:
> > On Mon, Jun 05, 2017 at 01:42:37PM +0300, Moni Shoua wrote:
> > > On Mon, Jun 5, 2017 at 12:14 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > > > The function get_link_ksettings might return bad status indicating a
> > > > failure to retrieve interface atttibutes.
> > > > Check return value to cover this case.
> > > >
> > > > While there, change the zero-initialization to "compiler-helper" instead
> > > > of an expensive call to memcpy.
> > > >
> > > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
> > > >  1 file changed, 9 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > index 7ba9e69..10c7189 100644
> > > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > @@ -183,17 +183,19 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
> > > >
> > > >  static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
> > > >  {
> > > > -       struct ethtool_link_ksettings lksettings;
> > > > -       u32 espeed;
> > > > +       u32 espeed = SPEED_UNKNOWN;
> > > >
> > > >         if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> > > > -               memset(&lksettings, 0, sizeof(lksettings));
> > > > +               struct ethtool_link_ksettings lksettings = {0};
> > > > +               int rc;
> > > > +
> > > >                 rtnl_lock();
> > > > -               netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> > > > +               rc = netdev->ethtool_ops->get_link_ksettings(netdev,
> > > > +                                                            &lksettings);
> > > >                 rtnl_unlock();
> > > > -               espeed = lksettings.base.speed;
> > > > -       } else {
> > > > -               espeed = SPEED_UNKNOWN;
> > > > +
> > > > +               if (!rc)
> > > > +                       espeed = lksettings.base.speed;
> > > >         }
> > > >         switch (espeed) {
> > > >         case SPEED_1000:
> > > > --
> > > > 2.9.4
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > > It looks like that bnxt driver also has similar code (function
> > > __to_ib_speed_width() in drivers/infiniband/hw/bnxt_re/ib_verbs.c)
> >
> > Sorry, i'm not following, this one fixes bnxt_re
> 
> IMHO, he wanted to point your attention that RXE has very similar piece
> of code.

You mean rxe_query_port?

In this case i have two questions.
- rxe_query_port translates speeds to ib_speed by range where
  __to_ib_speed_width translates by fixed speeds. Which one is correct?
- rxe_query_port fallback to get_settings where __to_ib_speed_width just
  take default if get_link_ksettings is not implemented. Which one is correct?

> 
> >
> > > Maybe you can move this function to IB/core and use it in both places (or more)
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
