From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/IPoIB: Support acceleration options
 callbacks
Date: Wed, 5 Apr 2017 09:45:59 +0300
Message-ID: <20170405064559.GD20443@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <20170404191732.31895-7-leon@kernel.org>
 <20170404194234.GB10780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l21Zc9uzwusa2dXo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404194234.GB10780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--l21Zc9uzwusa2dXo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2017 at 01:42:34PM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 04, 2017 at 10:17:32PM +0300, Leon Romanovsky wrote:
> > -/* Keep the refactoring compile able */
> > -#define ipoib_priv netdev_priv
> > +static inline void *ipoib_priv(const struct net_device *dev)
> > +{
> > +	struct rdma_netdev *rn = netdev_priv(dev);
> > +
> > +	return rn->clnt_priv;
> > +}
>
> This should return struct ipoib_dev_priv *

You are right, this is the whole purpose of ipoib_priv().

>
> >  static ssize_t show_pkey(struct device *dev,
> >  			 struct device_attribute *attr, char *buf)
> >  {
> > -	struct ipoib_dev_priv *priv = netdev_priv(to_net_dev(dev));
> > +	struct ipoib_dev_priv *priv = ipoib_priv(to_net_dev(dev));
>
> Several of these seem to be in the wrong patch
>
> Jason

--l21Zc9uzwusa2dXo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljkkqcACgkQ5GN7iDZy
WKdyvQ/+JJXfehwS8tdRUvwQMoRnPKFusRDSVNBVnB/FoHJZvjr0L1Nb49ZpcMEL
lSsp+hS20BC0psRcWF3+Z1pKpuNcmR28FdSocr8FZAtnvULGk3+BIkJVHq9g1mzo
4pSkw/9D6+uBGDAz13gmdsBaGVvLBpN0f/dvK9/uFLyXqg+E7NYD0OWMJk/9zl/h
iY6VOIl3SFHRNvGaiBBNbOOuAV+PR6F5MOgy9c3nBG9vpAfY8vp8qqbhAgr2IWXJ
/ZktjBiAg5liBfa4A+3TgBC2xQVGH6Ye1s/bE5p/cqWzyoHvQ5DxC1ONUjPWE3yJ
YPgd5Lcqc++/74mmAkb22v+NMK32D2e6oPkZNrRJ3GEocpJFckFpROg7C/jHAdIW
4bW9bYzyrsWxnqpaiku3lR75sVsK/aT/nJb26XzXbyTLPkDaeMaiBbb0yhZ95JpP
6ziUG5T455M/xaLsGHvi7pcKemOk6uVMfxKu/V7jWWEUD9RiXhydjvp3+2WlSA2o
aSrsmn1KDJdNzczMZOT6yRrUuGycrlGdNFUDmktgsNV6iQIah1xpM7N7u1HNb1Xh
wWp3YySD/Nr0fqnxdlmoWqsmpW3R2g92IWVdVb7R7ZSLF0eTqUVFefxQgjsSZAsa
AmWL7sIz3FicrdDqgYRkQ2G1MUHdT624aL7Lxa8whaNyJ6l7oTE=
=/Zhd
-----END PGP SIGNATURE-----

--l21Zc9uzwusa2dXo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
