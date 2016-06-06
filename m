From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Mon, 6 Jun 2016 19:53:43 -0400
Message-ID: <85e56121-5911-37f4-2ac3-a1af561d5a7a@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-7-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7HAUnsgKGHk3bCP6Pw8Mn3LDWN3gjv46W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7HAUnsgKGHk3bCP6Pw8Mn3LDWN3gjv46W
Content-Type: multipart/mixed; boundary="CkqlgnRVkLch6rr3fsj2V8bcDep1r241d"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <85e56121-5911-37f4-2ac3-a1af561d5a7a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1465042524-25852-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1465042524-25852-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--CkqlgnRVkLch6rr3fsj2V8bcDep1r241d
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/4/2016 8:15 AM, Leon Romanovsky wrote:
> From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> In a attribute group struct, attrs should point to a NULL
> terminated list. Which means we need to allocate one more
> slot in the array.

This patch is both right and wrong.  You're right with the intent (that
there should be a total of 2 extra entries in the array size, one for
the NULL termination and one for the lifespan entry), but wrong with the
mechanics (unless I've missed something).  We already have two extra
entries because sizeof(*hsag) includes our first counter, so just
num_counters is actually enough to NULL terminate the list, and + 1
gives us lifespan plus a NULL terminate spot.  The comment could be
cleaned up to make this more clear though, so I'll do that.

> Fixes: b40f4757daa1 ("IB/core: Make device counter infrastructure dynam=
ic")
> Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/=
sysfs.c
> index 5e573bb..c68f132 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -902,8 +902,11 @@ static void setup_hw_stats(struct ib_device *devic=
e, struct ib_port *port,
>  		goto err;
> =20
>  	hsag =3D kzalloc(sizeof(*hsag) +
> -		       // 1 extra for the lifespan config entry
> -		       sizeof(void *) * (stats->num_counters + 1),
> +		       /* 1 extra for the lifespan config entry,
> +			* and 1 more because attrs should be
> +			* NULL terminated.
> +			*/
> +		       sizeof(void *) * (stats->num_counters + 2),
>  		       GFP_KERNEL);
>  	if (!hsag)
>  		return;
>=20



--CkqlgnRVkLch6rr3fsj2V8bcDep1r241d--

--7HAUnsgKGHk3bCP6Pw8Mn3LDWN3gjv46W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVg0HAAoJELgmozMOVy/dGeQQAL81ghWnb0ouAyC+OsAg9K4A
XkMaIVWCxmAVNisA/EzWDKbWtGW5QY0Mi+0bOCG6nzHG60KAdS7Mp7YmqyeGXGhW
ZdE2568NboVT/tBBr96AbPngKDeZF1EaRpO2XTAWibqEHf6YI1BLptvtIMID3TUh
RI1YH2EEJ9mn91MXSfYaYuUtjudRPriojqe82K2L+coz0ctxGFACr754JCloEOo9
36l8Q7ZTVcSOm5Z8fCSsF9fpuNNrfSy7cEVOY8nqCaSxgb3HFG+ghsgcy25sJdjR
X1fe7J9KBJwnEV7CHrNpbVcfIftpwpPOTvuhQpjyI5hbDcoRU2m0DKC1nBxkhmgW
WsciGMEKOEUtD91S0BiTs7MszFa0f+rlFvWZk6E+I85RFCK1lzZDEyEazpE897IA
zsF4QGhAWhRrxp9pzJc+ghbqBAEjorO0OCflyll9VDxvsbnBnXp0GwQonNpblMvT
UdLu2nTCSUNIQSaPFJEkiEdJBAEOQP2s14AUpQjDm+6mCrm50cuQPE5dfl5KAhg1
6pLQ35glfHNcWG2PMKiePjTwAQ5fscDyRUf7BYrr1oFruZlQnal7yk+k4dSJHgh4
GkEP/zvz8HW/3wSAwuUSA8o3q37gACV3SgZQRs06pKwdbnKQhVfG5grqe+lMNIOQ
QfqwMOzfbRvM8VkdMI6H
=QcQ9
-----END PGP SIGNATURE-----

--7HAUnsgKGHk3bCP6Pw8Mn3LDWN3gjv46W--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
