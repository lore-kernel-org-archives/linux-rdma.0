From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Handle kzalloc failure in init_pervl_scs
Date: Tue, 02 Aug 2016 22:47:04 -0400
Message-ID: <1470192424.18081.50.camel@redhat.com>
References: <20160728010614.GA3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-VqNDx7kEnrbbUpo3GOai"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160728010614.GA3158-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-VqNDx7kEnrbbUpo3GOai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-07-27 at 21:06 -0400, ira.weiny wrote:
> Checking the return value of the memory allocation call in
> init_pervl_scs() was missed.=C2=A0=C2=A0Recently the kmalloc() was change=
d to
> kzalloc() which identified the problem.
>=20
> While fixing this issue 2 other bugs were noticed.=C2=A0=C2=A0First, the =
array
> being allocated is accessed in the nomem path which can be reached
> before
> it is allocated.=C2=A0=C2=A0Second, kernel_send_context was not released =
on
> error.
> Fix both of these by creating a more common memory unwind label
> structure.
>=20
> Fixes: 35f6befc8441 ("staging/rdma/hfi1: Add qp to send context
> mapping for PIO")
> Reported-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/hw/hfi1/pio.c | 19 ++++++++++++++++---
> =C2=A01 file changed, 16 insertions(+), 3 deletions(-)
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-VqNDx7kEnrbbUpo3GOai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoVsoAAoJELgmozMOVy/d+fIP/ikqrTdbO8eMRHEuAAGv9OiX
RKBomNwWiLOx/7LW4POE4KPNh0cWZffD5ZfzonbsijI5Q1jtrFP5uL6shW52/7tW
mF44qpmspWvkb2BzIAX8jzQco/B1jbNFD2gQFNY3fzmxF63TvCKmv/Tu8j7cbAgi
Egm1xEKPBnruAnPoNpkVofDF6zAp9yQuvoYsQbPwfcvdj84OI6WBaQnWXxyR6P++
Iq1pduyR5B3g/83pEepynfcwsQgqVgsevRR6L+smZ1W+xzJ0yZMFxKUBl+kNLpsD
IhfxBhOsDXnsA1BGtpLYqGT9ZgfUgkL+8FgHpDhwwZEO5N8Z0Rr6F3mPHFGmFSk4
im1XQGHnn5YgExfzlWYWLe6oLIfjD2cjySgr4hZWrD4qnUKUDn/vJmsTB6DFfHKF
uG1ZLpFywZG65jOATOALwYtQwZdkQVQc6fceg5Xi0nUAOK5+12lbk3EyMXLF8hgN
f5ODIlzdZ7wmIcWin+Lrx7yvhHcLKFqzs4sCmoMDkSRmqQs/uaShG+aapddo3T0W
tjfO0TGCgh7I5muOC4WDAbkIHYF5d9Kf+BHO0D2tcRydRRZwsofY0Dhim1HetgXF
VhZB8Sjc3GtOW3iVmHGSYTBzvom1IW9UaR/r7bxCMMBxsYlHbtCXP3UFFdRBfLPZ
bCB9yK5GH7QPRQFfH8m5
=/j6R
-----END PGP SIGNATURE-----

--=-VqNDx7kEnrbbUpo3GOai--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
