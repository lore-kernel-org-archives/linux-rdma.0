From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: amso1100: c2_provider: Use netdev_dbg()
Date: Thu, 11 Feb 2016 11:27:27 -0500
Message-ID: <56BCB66F.4070305@redhat.com>
References: <20160206151114.GA18959@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jCTNt4u7apn41l8Pu6c05gMh0qhiKnfKR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160206151114.GA18959@amitoj-Inspiron-3542>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: julia.lawall-L2FTfq7BK8M@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jCTNt4u7apn41l8Pu6c05gMh0qhiKnfKR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/06/2016 10:11 AM, Amitoj Kaur Chawla wrote:
> Replace generic pr_debug() with netdev_dbg() for net devices.
>=20
> Found using Coccinelle. The semantic patch used to find this is as
> follows:
>=20
> //<smpl>
> @@
> expression e;
> identifier f,i;
> position p;
> @@
>=20
> f(...,struct net_device *i,...) {
>   ...
> -  pr_debug@p(e);
> +  netdev_dbg(i, e);
>   ...
> }
> //</smpl>
>=20
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This driver has been removed entire as of 4.5-rc2, so this patch can no
longer be applied.

> ---
>  drivers/staging/rdma/amso1100/c2_provider.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/rdma/amso1100/c2_provider.c b/drivers/stag=
ing/rdma/amso1100/c2_provider.c
> index e44ad22..75a7de5 100644
> --- a/drivers/staging/rdma/amso1100/c2_provider.c
> +++ b/drivers/staging/rdma/amso1100/c2_provider.c
> @@ -659,7 +659,7 @@ static int c2_pseudo_up(struct net_device *netdev)
>  	if (!ind)
>  		return 0;
> =20
> -	pr_debug("adding...\n");
> +	netdev_dbg(netdev, "adding...\n");
>  	for_ifa(ind) {
>  #ifdef DEBUG
>  		u8 *ip =3D (u8 *) & ifa->ifa_address;
> @@ -684,7 +684,7 @@ static int c2_pseudo_down(struct net_device *netdev=
)
>  	if (!ind)
>  		return 0;
> =20
> -	pr_debug("deleting...\n");
> +	netdev_dbg(netdev, "deleting...\n");
>  	for_ifa(ind) {
>  #ifdef DEBUG
>  		u8 *ip =3D (u8 *) & ifa->ifa_address;
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jCTNt4u7apn41l8Pu6c05gMh0qhiKnfKR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvLZvAAoJELgmozMOVy/d7qgP/jOvG4kKEqOBKhZing+qfqVA
9HxboGUmAJHjSyjw5fPXNwBcT4RlE6VQQpVo3ChcO1nbV38MW/umhnT1TLKp7vzR
r/Rgo86fQt35OLfH+fUTykBxHsnPvKad+xKPYBu5HPE4YngFpwzPnje8e7Iblfzi
bcwgpMxrBgc/zdzYZzIQgCYmyOoMV1VMUxfW/RHcF3t6OL7qmAfJOU/kBm8+DBRL
mTW+jJN4MuUD9CBxI7CPIRxYWCVFB58oUqYQWPT/BGCp9bXmIaG5tSyr3p4uFH/x
JkffRJlOFGU4ezz5OlNkNA8n1R0uzd1L5K8RiFLAJJLQctqF43nyVG0ETJGVZRHl
onP8RuZqHCPulMYAoApRYa4D4kt8lNZOfm7C0jRMqT9EV4KltzZpv0aCyUF8q4lD
yuAfJ7EOItHmqOXS6wwv1XCxaZeRO22DIs1axqZOn8tCiIEmolpSHyrfu5SLhzt5
+7Ym+DCohtZmf0NTNV0I5RPEOvJQuiliKNeXutszF+9S/0oOo9m/uh5UligkC7jD
OyfCt4Kdtgr7hg2V3uWaErAJAgadNRIhEE4sRVoM70oGfXxgtgP6j+JHh1HSweeT
UHZZgK0a8aRcaE3PDMkZMwfkyZ+hhBq+pa0P+qyyai4z4VLzArWcKjxD6CRSBbif
/N86B5pkew9IaPwWy6a7
=s9V8
-----END PGP SIGNATURE-----

--jCTNt4u7apn41l8Pu6c05gMh0qhiKnfKR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
