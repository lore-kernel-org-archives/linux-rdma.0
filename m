From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Thu, 9 Feb 2017 07:31:35 +0200
Message-ID: <20170209053135.GL6005@mtr-leonro.local>
References: <20170207184206.GA14102@obsidianresearch.com>
 <20170207194759.GU6005@mtr-leonro.local>
 <20170207201428.GV6005@mtr-leonro.local>
 <20170207205930.GA28922@obsidianresearch.com>
 <20170208063758.GZ6005@mtr-leonro.local>
 <20170208173335.GB30720@obsidianresearch.com>
 <20170208180104.GG6005@mtr-leonro.local>
 <20170208181820.GA31664@obsidianresearch.com>
 <20170208185446.GH6005@mtr-leonro.local>
 <20170208205622.GA32427@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rFczCnPKoBLyy+QQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208205622.GA32427-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rFczCnPKoBLyy+QQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 01:56:22PM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 08, 2017 at 08:54:46PM +0200, Leon Romanovsky wrote:
>
> > > Hmm. Can you update your github? I'll look for you.
> >
> > I pushed latest code to m/dv-1 branch, it is not for inclusion yet.
> > https://github.com/rleon/rdma-core/commits/m/dv-v1
> > Updated cover letter with changelog:
> > https://github.com/rleon/rdma-core/commit/a332669511d5bbbd3dcdd977fbf95aa7ee47a69e
> > And all cmake/packages stuff in the patch:
> > https://github.com/rleon/rdma-core/commit/fcc4996c7fa5169fe599c2d568476314c1f65ddc
>
> This should take care of most things
>
> https://github.com/jgunthorpe/rdma-plumbing/commit/490b7fb184c414ab16b7056f1effa9136e8afe46

Thanks a lot, we will add into our v1.

>
> The debian packaging still needs some adjusting.
>
> I suspect it is against Debian policy to include libmlx.so in the
> providers package, it probably needs to have its own package and its
> own -dev package.

I don't know, at the end, it is provider.

>
> Jason

--rFczCnPKoBLyy+QQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlib/rYACgkQ5GN7iDZy
WKe+vQ//T8XQ6GWiY2F84hmhVNqB8HLuMcob+rX06lU2I9GT8Z8EeLPsY8qdL/Xj
D6soyI5x9xLOHd92TuxBd8sECIhYU5RyL3pJ9aFD0kjt4U9x+ReG6wDObMPf2UVY
ONHrqMv+kNeHbJ+kIG9WZu7ZxEg7Mu6+Unx0AGahVjaipHRVcTEETK6zWGEbehkf
O1E2EdfoQAsAzwLT879cYqowQMd0eMo7NNRRhnq+z43vreUSGuw/qVfFi79BHsqQ
l7RMyUyg8c35u630X5f/NSSYe1PNNHDWTPZBUUWmbbujYrUAO0X6Ey1hDHQXKqfr
PZl59R2FuUiRYFbXR+L6H4Hj0PVtNhyjsuXglmBtDwD0nSXvKL+m7dbtIELsH3Pk
eaP+Eojkx1cENFH4+mp4/zRvtfYMPYMgnNugjmN7xt41V2mBq8IYieUxX2YUIhzw
Xvguz5rfHHwPdaoIQ66KSp2LhMOIRlmeH3Rnv3i3lwDCfGpB+ME94zbduQJsFhim
tvRKLdbul0moJMve8PLDy6anF49ph8hitNBezBDjZD2Ybeej/ZQ8Prbjax594RJD
dgIPgRTo3FMxfUUFj1CuXKMnPN+BB1R+C2B0fN+/WgX476TyiQIgeu7pM8R2dlpD
+s6nqYcLp3opTNXBWhrv0ixDUkvFKTk6F5cAFlf4MdhnBnI9i5k=
=v8u4
-----END PGP SIGNATURE-----

--rFczCnPKoBLyy+QQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
