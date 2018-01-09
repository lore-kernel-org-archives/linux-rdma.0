From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core v2] debian: Add udev dependency to rdma-core
 and srptools
Date: Tue, 9 Jan 2018 13:20:45 +0200
Message-ID: <20180109112045.GE6823@mtr-leonro.local>
References: <20171228210124.GI25436@ziepe.ca>
 <20180103102211.28307-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103102211.28307-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 03, 2018 at 11:22:11AM +0100, Benjamin Drung wrote:
> When udevadm is not available (e.g. in a minimal chroot environment),
> the rdma-core package installation will print these warnings:
>
> /var/lib/dpkg/info/rdma-core.postinst: 33:
> /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> /var/lib/dpkg/info/rdma-core.postinst: 34:
> /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> /var/lib/dpkg/info/rdma-core.postinst: 35:
> /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
>
> Add udev dependency to rdma-core and srptools (which provides udevadm),
> because these packages rely on udev to load the kernel modules.
>
> Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  debian/control            | 2 ++
>  debian/rdma-core.postinst | 6 +++---
>  debian/srptools.postinst  | 2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)
>

Thanks, applied.

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpUpY0ACgkQ5GN7iDZy
WKcCyg//faZs9LKsTCOfShf3nUTrOVkXhxD8/FIyuNQwi/YIvysq8YcoV0yZ6jyG
WihKQOJ6f8g/GiERGbwVAVBBLdu8co/LCcoTAlZopk4eyctmUru8EJECoi4j1iq6
BYAcKO4DEeQyy9jc1Qch+DhzkZkgzn4eRr+K8qWypIgXRgUgwBrmfCyZOynSI4je
RscZ8XXROwAUqZsDjPnGEdrcr8iFODDUOjOC/0G74MPS0fb6v2nYz/bQDhCFnnlB
uo0hUDEHFyhdfPwUfN3sdGE3VffK+FQY34BN5mgxJYhXPpJkLIOjSKWyBEqqoo/+
KJiSrvuLXgmlw4JRiY2lhEq5TcDUPJppcrm3ZDRCFjIqADjJbrqQw02h+att1o4l
OZyaSiObLtzdkLJA1XNjutXDiAFVEwIdL5JPVxYEZqcD3afvGePHRADZQRTuOMJD
viqe2G8OoOis7JM8Z14j8U5lUoMYi476Ca6UzU0xZ3QezIJI2KLb9CET7DC4bhNA
pTMkqS218oqX0OGL8xK3+bQ4gYvbNawVFHpbZECWlcOkEGQqqkeDzjOhMLrLXgtB
hxxWEFfEOkz0MeM/HWucv3o8w6sSjggPyYg6x+ZBILDtdq25G4ry9yhJKn/aJidS
62t1R6tp4GHlKV/9x6V8XmA24sc8sFY3jeh6veduDxy1vdH7yTs=
=nSXU
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
