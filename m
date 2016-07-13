From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Skip napi_schedule if ib_poll_cq fails (v2)
Date: Wed, 13 Jul 2016 18:32:52 +0300
Message-ID: <20160713153252.GG10079@leon.nu>
References: <1468423316-28246-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iAL9S67WQOXgEPD9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468423316-28246-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--iAL9S67WQOXgEPD9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 13, 2016 at 08:21:55AM -0700, Yuval Shaia wrote:
> v0 -> v1:
> 	* Initialize n before use
>=20
> v1 -> v2
> 	* Add reviewers

You don't need to resend patches with tags changes only.
Patchworks handles it and adds automatically when Doug
collects them before apply.

And it will be great if you avoid adding cover letter for one patch.

Thanks

>=20
> [PATCH v2] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--iAL9S67WQOXgEPD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhl8kAAoJEORje4g2clinktgQAJinpcrYgoWgXM9qe7i4tV2j
77a02t9CVgdSRMFrCBsVBjSe2mCBQdXiMo0Uh9QqR1m8y9qZ8YN0rVMocd5qGa5V
XbenSKAzouWBOayzS2nVXPg4foZFv1L3kue5fxylJSV1WY+6lCFbtCo4PE24DtrO
NM7h2RlOSvvqGcJgE70cRibQPfs2iiIcLO+dtMuVt34D8jibrLLnPzUdqNOmDAlC
3W3enj887t6PLPu2NtzDWcaRKIFPWYNY5qzMb+ZKLx2qKRtZ6tl33cR8lvtH9+YA
n3jHKGUg9lZ0uThbLO4ayoZOpF76l7og8zhhBMAOvQVHkADH2MPdIy1u/j1p/tAO
UDNOU760e0I++yqyW9P0ni7grrZgkWRJdqAK5y3R74UDqdP85cz4TqwrPIBPNz5s
Ee9f+t9t23vzfiH8so68gdN90/GWKC6Nx2xzgQZ03RhaLk/G5eoxzlzEZftE5RXG
2DRKXCK9Lsb5IwOQSJabV9RAasIP1PmtSRe2PtxlqQ0aQ5ZUB1nODovqpG6uZM3k
0kGS1CLIZy3V8zurrW6P0vRV02/Ha9wTZbh+VlChy4vyEUhPhRbBdsADYcFrFTwg
q63VppsIO2a8HqrOGHm7C7FDWXj9eaWe/Q+Ri9F8w1CiAN/hJwwgmgOOgkU+28NU
3cig2VPlFvH0O7lvqNuH
=nZbc
-----END PGP SIGNATURE-----

--iAL9S67WQOXgEPD9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
