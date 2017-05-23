From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/IPoIB: Forward MTU change to driver below
Date: Tue, 23 May 2017 12:24:28 +0300
Message-ID: <20170523092428.GK17751@mtr-leonro.local>
References: <20170523084252.16018-1-leon@kernel.org>
 <20170523085645.GA5877@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J+eNKFoVC4T1DV3f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170523085645.GA5877@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--J+eNKFoVC4T1DV3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 23, 2017 at 11:56:45AM +0300, Yuval Shaia wrote:
> On Tue, May 23, 2017 at 11:42:52AM +0300, Leon Romanovsky wrote:
> > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch checks if there is a driver below that
>
> Is it "below" or "upper" in the driver hierarchy?

The part which  close to the HW. I called it "below".

>
> > needs to be updated on the new MTU and calls it
> > accordingly.
> >
> > Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > index 2869d1adb1de..28068140800c 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > @@ -233,6 +233,7 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
> >  static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
> >  {
> >  	struct ipoib_dev_priv *priv = ipoib_priv(dev);
> > +	int ret = 0;
> >
> >  	/* dev->mtu > 2K ==> connected mode */
> >  	if (ipoib_cm_admin_enabled(dev)) {
> > @@ -256,9 +257,23 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
> >  		ipoib_dbg(priv, "MTU must be smaller than the underlying "
> >  				"link layer MTU - 4 (%u)\n", priv->mcast_mtu);
> >
> > -	dev->mtu = min(priv->mcast_mtu, priv->admin_mtu);
> > +	new_mtu = min(priv->mcast_mtu, priv->admin_mtu);
> >
> > -	return 0;
> > +	if (priv->rn_ops->ndo_change_mtu) {
> > +		bool carrier_status = netif_carrier_ok(dev);
> > +
> > +		netif_carrier_off(dev);
> > +
> > +		/* notify lower level on the real mtu */
> > +		ret = priv->rn_ops->ndo_change_mtu(dev, new_mtu);
> > +
> > +		if (carrier_status)
> > +			netif_carrier_on(dev);
> > +	} else {
> > +		dev->mtu = new_mtu;
> > +	}
>
> So we don't want dev->mtu to be updated if driver was registered?

It is updated in ndo_change_mtu call. See nes. cxgb3/4 and mlx4/5 as an
example.

>
> > +
> > +	return ret;
> >  }
> >
> >  /* Called with an RCU read lock taken */
> > --
> > 2.12.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--J+eNKFoVC4T1DV3f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkj/8sACgkQ5GN7iDZy
WKcYKQ/+JMyA9oht7SCspJwZZ1C8H877xPe2IxiuJTrAVtnTx9Wa4ZrNfEWVFtgZ
jNCKvlTwQVAibQ/xTQvoDBa9GPpWdYbBgpGE4wZBI3LlmFLSJNt7IZpiWaFpQiBx
q/9jKJANO2e/W42wsa3aTYo4MzUJV8JTVbXLBEkQ6Tke8xcq9B7bEzXTdTOf1n8r
BGMgOfC3wHw+I0oshAEwCWYhGGU2WhHJWXbyqjhB+wQD0xC7Dx5jgfqF21jeDFMT
cMZPR38RmJt/nHdFHNRP6MY6tq5wD0zQgVGD+gv+ZLZQhogZ8kGJ2P91FwR2p/42
ASoFUOiPuZ/kJ2tjGAiepOSNWFyAANPA+Xm0uVipbk4pZU9iUjvH/wyPttvhiwyy
HcNIbELfoUeVYZt7S9P6xI+0HX2pqRSuBQXroc4YozVMMFqu2vXbYdraW5REg0+E
GKRMjzZPRD5exNl1q4uvhT5gyVN/PUOW2OEq/pGu0JuztMBNdIo4LiYRcsNdHM4s
AL474wQpPZ+EZdGqTmZZwyhARMTkKmPrxLtM04Qjx14SzOb/LRDMq4GVwCriQ3xS
9r700RWHA3mNxRJsWwalARpkryScKQP1LV/qclgnAXxTpntS7W831ypHcmy69POE
ivvOjMrK9C7Bwur4WzMgempDatGbeiK1Qn1I1KihZ3sIsbOxj/4=
=RhDY
-----END PGP SIGNATURE-----

--J+eNKFoVC4T1DV3f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
