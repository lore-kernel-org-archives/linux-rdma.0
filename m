From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 08/31] RDMA/cma: Fix consider size of
 destination address
Date: Wed, 15 Nov 2017 07:25:03 +0200
Message-ID: <20171115052503.GM18825@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-9-leon@kernel.org>
 <CAJ3xEMiA7G48_boRVJK336n2DNT8voJVJMiT-qhqpfXqz7aNxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="htvT4BrJhvkgK8RF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiA7G48_boRVJK336n2DNT8voJVJMiT-qhqpfXqz7aNxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--htvT4BrJhvkgK8RF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 11:18:41PM +0200, Or Gerlitz wrote:
> On Tue, Nov 14, 2017 at 2:51 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > While copying destination address in statistics, consider size of
> > destination address.
> >
> > Fixes: ce117ffac2e9 ("RDMA/cma: Export AF_IB statistics")
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cma.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index 1fdb473b5df7..9841e7ca5c06 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -4431,7 +4431,7 @@ static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
>
> Leon, isn't that the code you want to remove in your other patch?

Yes, I want, but those two parallel things, I posted RFC to see if
anyone actually is using it and if everything goes smooth, I'll post
proper patch for next cycle (4.16).

Right now, code exists in the tree and Parav has fix to it (he is not
using it too).

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--htvT4BrJhvkgK8RF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLz68ACgkQ5GN7iDZy
WKdXIg/+OLBOD0ciiMJ6RIrlZDYFEe6TGO4hkMf8lK106SiOjSE1aJm3ONHDHpml
TYxNYCJVIbFuO2JaaFWhTFarbD2BzZgjwIhrr5ik4fqjjW6jnLZk4j32NoPP2jsN
4YgExhL53EITG99MwTrgdBaut8kR8OF0+FgQoJa0kpFKAFAij/BCfHh+JkJlA3Ee
qjdud+5DaHEIFSRoj6gly+YNOx+3FHj+b8tBWcGoa9BLxCykG2mk20d2BDKgBN80
OTWRqVzOYAAG4HnZ2Ck1fVtX2Dzgfnz2lVcw2dnGGMrh3U9+7jEahyoyHndjXSOg
Gd7QTn/nfgRJFTUlUMo1DyLQd+gfbce+4/wQlFwKkBdmXmKE2g2bTp30tMj06AGV
hvnudJR/YYvBhF+O7ObEtYmH3jatPZJFlnUl/QqenOXvPpasilOlx9quLE0ri+1E
djplafN2P+HhqPqNbwJnmSsCNaZZHSPk8n6IFmOlBFa3vsSTklAuNdIIgk+m0EF9
IvugjMyt+KSFKqfsDKCSrwKTcb0Ud1hRLutcypij3/swWmOSiiTSHSW6nGj4l/0K
IvRIUfH15NXb9Se4wHmzhaDrTQHhK4yFzw1Mi3K52Ogjg2LBfb4BS6wo/GmU/w3d
a76g4kNsMNJCvpbWJQpqfWxO3oV3jMGswII64zbxQaPVvhJ+cR8=
=fKFh
-----END PGP SIGNATURE-----

--htvT4BrJhvkgK8RF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
