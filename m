From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] RDMA/netlink: Advertise IB subnet prefix
Date: Wed, 28 Jun 2017 19:10:20 +0300
Message-ID: <20170628161020.GI1248@mtr-leonro.local>
References: <20170628133445.16550-1-leon@kernel.org>
 <20170628133445.16550-3-leon@kernel.org>
 <20170628160251.GB14375@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5yI2NvEZ36o0Huwo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628160251.GB14375-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5yI2NvEZ36o0Huwo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 10:02:51AM -0600, Jason Gunthorpe wrote:
> On Wed, Jun 28, 2017 at 04:34:43PM +0300, Leon Romanovsky wrote:
>
> > +	/*
> > +	 * Subnet prefix (in host byte order)
> > +	 */
> > +	RDMA_NLDEV_ATTR_SUBNET_PREFIX,		/* u64 */
>
> I've always hated how random the be / host choices are in our API.

Agree

>
> Since the GUID is in host order I recommend making the subnet_prefix
> in host order too.
>
> At the very least, the comments beside anything not in host order
> should be 'be64' not u64

Those comments represent netlink types. It doesn't have be64.

>
> Jason

--5yI2NvEZ36o0Huwo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllT1OwACgkQ5GN7iDZy
WKd3hg/9HDEvqqpbT3MIhpADLeWEE0r5yR8faJDiiI90ZPp8+EG9YOFNwR+2vLiW
2PzFYwH7l3xeDwpeTjzVwk2VC4Y8eFgqck64UKhoY2xLon//S0gKI5P0ybokkv2Z
qpYu0PppfNw/Lvg5E++t3Yy+PV14P7r0eQXqeoVbwTN0+5JWCoUtx7u637TrS0/3
i6z6SofrY92WCma7ixj3hmJDV20JiVceSq5GLhkd5ng0FhNJ1IOzlgeuMoylSQ8B
crm0hy5eoQ3L06zrQjT1pB2a6tM9o1P+DiV7HnyCcoHCi57KiVv1ss2nUrdcDs7N
jPC0ud1yp1UVIZon7jvubjPiw7gL6Cfm3Z0Z4NRQEGeWVoXj2HzTWgD+x/c2XgjS
pVVcWxmi5j5EwkyNAkN38b8pSRVRxgx6mjKd51fA6t0UncjQJXBm0xHb6Ac1AAFA
vHbmofnc1xhU9ObYJbx+WVbxevNa85TvsnUwjZKyjcixWMB+PS1ntjYssAtR2O5s
7kMbE0FDKS4TZaZq5Nkm5s45XNzbZzXgdJbhQWe7eA8dDU4bQ86brE6Ut7jtPspG
7sClBm7eDGIr3r2eE1WpGrNt6PbiKcH+kWdLRpCHgLlz2FXzSQTyue/mZDrmsBiL
5XhopGnh9QC3DMkZGNbZN+aZ3UvnGX4a477KF2eiNzRLFKEcwfQ=
=ICgC
-----END PGP SIGNATURE-----

--5yI2NvEZ36o0Huwo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
