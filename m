From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: Use dsgl by default
Date: Thu, 2 Mar 2017 17:11:22 +0200
Message-ID: <20170302151122.GC14379@mtr-leonro.local>
References: <1487833303-4779-1-git-send-email-ganeshgr@chelsio.com>
 <20170302144710.GF9525@mtr-leonro.local>
 <039001d29365$fbaf37f0$f30da7d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <039001d29365$fbaf37f0$f30da7d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Ganesh Goudar' <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, 'Bharat Potnuri' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 02, 2017 at 09:02:17AM -0600, Steve Wise wrote:
> >
> > On Thu, Feb 23, 2017 at 12:31:43PM +0530, Ganesh Goudar wrote:
> > > Enable the use of dsgl by default and determine whether dsgl is
> > > supported from lld info.
> > >
> > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/cxgb4/mem.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/cxgb4/mem.c
> > b/drivers/infiniband/hw/cxgb4/mem.c
> > > index 410408f..8db7a11 100644
> > > --- a/drivers/infiniband/hw/cxgb4/mem.c
> > > +++ b/drivers/infiniband/hw/cxgb4/mem.c
> > > @@ -38,9 +38,9 @@
> > >
> > >  #include "iw_cxgb4.h"
> > >
> > > -int use_dsgl = 0;
> > > +int use_dsgl = 1;
> > >  module_param(use_dsgl, int, 0644);
> > > -MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
> > > +MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=1)");
> >
> > Can we get rid of this module parameter completely?
>
> We can, but we would need to deprecate it for a release or two.  I believe
> removing them cold-turkey isn't recommended because it represents a form of user
> interface...

You can rename it to be deprecated_use_dsgl instead of use_dsgl and wait
for a couple of years to see if someone complains.

Thanks

>
>

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli4NhoACgkQ5GN7iDZy
WKeMaw/9HjKNwIz0xXinEPQR28SQl66JiidB8on28iuHzpq+kHxW8r8SHjYfREZq
YELb7b3hJEkRBm/18c/THWO+0g99aLA0Y/V1S/SyPJ6Oia7dAC9DSLA0wFJve4Lg
la5a/ZB5B4uJEV+AwyMd7GrD06IOLqIivlxOhpe+fo3RmbZbNkvcrPeG7zBoZvc0
ePOhEbrFjBRvEeHEROonRm9m37dM+CzjoLFDRM53BhsBdry4LGqH4p1nVU/ouo5K
KTPPATEE8er1sRzx0UvcDNr6eixVLs44cLk2YHI0LdLBZt2hhDYpZ/QaNCX65CwJ
qCyeUtXPXCN9Cc7FSOacADzAhJ+JlidlXBHz1CNRwHyLat6WGoeBQTxUgQFl3f3K
Hd/8teCRozXoj9m6jaJ2VkXdXqEqRfkSgTy2/tHlmRgU+OVZ4Nmkq+FKrakWSluS
ET+ENplapwvyP/9c7JCu8H67QK/C08Ouxi+Sqk5YWHYt4h9jSiCocwnIX7G7kL9F
dHF7EJr9UPcKLaJ72mdsW8bWdryCiKmYXjl6HUiT5uz9XOjyJ2J62t0XdlFasu/6
pcVym7UQlWN++tnqV/nXCTOPXFLEDbJz1dGssfX4zt8UhypJ0TGIwm3XKOrEwVJI
NG5yaflpYedw8HjOUE9OY51hz8P1kpIje4IpabkRWxIcPocoLDU=
=F/7J
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
