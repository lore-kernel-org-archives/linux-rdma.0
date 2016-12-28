From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/9] IB/ipoib: Set device connection mode only
 when needed
Date: Wed, 28 Dec 2016 07:43:56 +0200
Message-ID: <20161228054356.GA26885@mtr-leonro.local>
References: <20161227133911.14340-1-leon@kernel.org>
 <20161227133911.14340-3-leon@kernel.org>
 <20161227201500.GA5696@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161227201500.GA5696@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 27, 2016 at 10:15:01PM +0200, Yuval Shaia wrote:
> Extremely minor comment inline, feel free to ignore.
>
> Reviewed-By: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> On Tue, Dec 27, 2016 at 03:39:04PM +0200, Leon Romanovsky wrote:
> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > When changing the connection mode, the ipoib_set_mode function
> > did not check if the previous connection mode equals to the
> > new one. This commit adds the required check and return 0 if the new
> > mode equals to the previous one.
> >
> > Fixes: 839fcaba355a ("IPoIB: Connected mode experimental support")
> > Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > index a550cc6..1787f6b 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -474,6 +474,14 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
> >  {
> >  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> >
> > +	if ((test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
> > +	     !strcmp(buf, "connected\n")) ||
> > +	     (!test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
> > +	     !strcmp(buf, "datagram\n"))) {
> > +		ipoib_dbg(priv, "already in that mode, goes out.\n");
>
> Why not ipoib_warn/warn_once?

We didn't use warn(), because setting the same mode more than once is a valid flow.
However, it makes no sense to continue and this is why we are returning zero (sucesss)
without doing a thing.

>
> > +		return 0;
> > +	}
> > +
> >  	/* flush paths if we switch modes so that connections are restarted */
> >  	if (IPOIB_CM_SUPPORTED(dev->dev_addr) && !strcmp(buf, "connected\n")) {
> >  		set_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
> > --
> > 2.10.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhjURwACgkQ5GN7iDZy
WKcozhAAh9bjtWskBqdo6UONZKiasSON51AVtrWSi4kJGgFNlNpvA6JO0TGJvy9z
yHuhCuynqAUfMFXSUD8ZAqaaiXmrIzdalgJ2nuInbbb1bpC0un3WUCousp1kBSI8
+AWbk4Uw9r8ix17vmqgw6cMsPXGPP99oYjAVUwnoYCXnZB4+NLLUmy/W4whoBIja
SJe37YN0WqJzCSP1fBqB2Bw+DtGL8Kk20d07USr7JLXrXBsCQVHKL6o7p0DXsTQC
dbhD859utUBys8mUHxcXhjJZEZoOLMy8XDjqHxGtZMf9W8q+l8ujm444d3fJ3Lq5
SjPV20IPdvbq4SWCMHJXvebIuiUAO7HcaD3LgtBRJbHwUegThMvHuetQlOXd+JlY
xyCb125xxOnvvyXqnErDuoX4ypDgZNg30DNZlXLPW/0IeQ8/rd9HRl5x1CIJ5z3f
wU/Hy/rHk/P234Cv+LWHEtosOEM3zxehWrtIFBE09jh0gN3jOy2jqcXZsK0fUpIe
wN3YLqSn6Qilh0I0UW5sf6lZ1GqXLDpSyxZKbSFm7W3fQLTvuVsqsNX2l2vUjjcE
niJDxwLRVnI2FGIl067k3KWCA1whycS9Qd1yjiudm/B3OZA+z9GIKiLtx45Ud7DK
GHngS+oBPV5+tBc0gpLA2XqJCzPNiN7NG/KEiRMLXrJSFjXdfbM=
=WIxU
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
