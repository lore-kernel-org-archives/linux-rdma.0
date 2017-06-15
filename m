From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] rdma: copy the saddr if it is already resolved
Date: Wed, 14 Jun 2017 20:12:57 -0400
Message-ID: <1497485577.7171.273.camel@redhat.com>
References: <20170609104925.28927-1-rajur@chelsio.com>
         <1497468245.7171.260.camel@redhat.com>
         <CAANLjFo=VOhUSb494rskZ38fHn=xSUYPi+XL4Vuu0R1Y0czmSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFo=VOhUSb494rskZ38fHn=xSUYPi+XL4Vuu0R1Y0czmSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-06-14 at 16:28 -0600, Robert LeBlanc wrote:
> Doug,
> 
> I've run into this with 4.9.30. The aforementioned patch fixes it in
> the 4.9 series, but also requires 24b43c996 as well. Can we get this
> fix into stable. If needed you can add me as tested-by.
> 
> Tested-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>

While I don't doubt that this fixed the problem, the patch from Roland
Drier looks more correct to me.  As I've already taken Roland's patch,
and it is Cc:ed for stable, it should be resolved already.  I just need
Raju to confirm this for me.

> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> 
> 
> On Wed, Jun 14, 2017 at 1:24 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > 
> > On Fri, 2017-06-09 at 16:19 +0530, Raju Rangoju wrote:
> > > 
> > > The recent changes to addr6_resolve() to call ipv6 route lookup
> > > via
> > > the stub interface broke cxgb4/ipv6. If the source address is
> > > already
> > > resolved by ipv6_dst_lookup() then the check
> > > ipv6_addr_any(&fl6.saddr)
> > > would fail; consequently, copying saddr to the src_in buffer is
> > > omitted.
> > > 
> > > This commit addresses the above issue by moving the copy code out
> > > of
> > > the ipv6_addr_any() block in addr6_resolve().
> > > 
> > > Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/addr.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/infiniband/core/addr.c
> > > b/drivers/infiniband/core/addr.c
> > > index 02971e239a18..c32477907765 100644
> > > --- a/drivers/infiniband/core/addr.c
> > > +++ b/drivers/infiniband/core/addr.c
> > > @@ -454,11 +454,11 @@ static int addr6_resolve(struct
> > > sockaddr_in6
> > > *src_in,
> > >                                        &fl6.daddr, 0,
> > > &fl6.saddr);
> > >               if (ret)
> > >                       goto put;
> > > -
> > > -             src_in->sin6_family = AF_INET6;
> > > -             src_in->sin6_addr = fl6.saddr;
> > >       }
> > > 
> > > +     src_in->sin6_family = AF_INET6;
> > > +     src_in->sin6_addr = fl6.saddr;
> > > +
> > >       /* If there's a gateway and type of device not
> > > ARPHRD_INFINIBAND, we're
> > >        * definitely in RoCE v2 (as RoCE v1 isn't routable) set
> > > the
> > > network
> > >        * type accordingly.
> > 
> > There was a different fix for this submitted by Roland Drier.  It
> > has
> > been taken into my k.o/for-4.12-rc branch.  I need you to check
> > that
> > his patch works for you and renders this patch no longer needed.
> > 
> > --
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >     GPG KeyID: B826A3330E572FDD
> > 
> > Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> > 2FDD
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
