From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow steering
Date: Fri, 13 May 2016 16:53:26 -0400
Message-ID: <cf61efc8-e426-dd7c-7065-e46bbfb323b0@redhat.com>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org>
 <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ShvlMBRtPtHhiNprKLvvUAUUnW3jLJTmC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605131051170.27372-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ShvlMBRtPtHhiNprKLvvUAUUnW3jLJTmC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/13/2016 11:52 AM, Christoph Lameter wrote:
> Sorry slight mistake in the original patch. V2 follows
>=20
>=20
>=20
> Subject: [PATCH] IB/core: Do not require CAP_NET_ADMIN for sniffing V2
>=20
> Having to enable CAP_NET_ADMIN for every app that uses sniffer mode is =
kind
> of risky. We do not want people to have the ability to mess around with=
 the
> network configuration and routing. We just want the app to direct strea=
ms and
> deal with inbound data streams in various ways.
>=20
> So lets drop the requirement for CAP_NET_ADMIN and keep just CAP_NET_RA=
W.
>=20
> V1->V2
> - Check for CAP_NET_ADMIN was conditional on IB_FLOW_ATTR_SNIFFER. We n=
eed
> 	to remove this in the correct way.
> - Update description
>=20
>=20
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>=20
> Index: linux/drivers/infiniband/core/uverbs_cmd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/infiniband/core/uverbs_cmd.c	2016-03-24 09:16:27=
=2E782778586 -0500
> +++ linux/drivers/infiniband/core/uverbs_cmd.c	2016-05-13 10:49:28.9530=
00945 -0500
> @@ -3088,8 +3088,7 @@ int ib_uverbs_ex_create_flow(struct ib_u
>  	if (cmd.comp_mask)
>  		return -EINVAL;
>=20
> -	if ((cmd.flow_attr.type =3D=3D IB_FLOW_ATTR_SNIFFER &&
> -	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
> +	if (!capable(CAP_NET_RAW))
>  		return -EPERM;
>=20
>  	if (cmd.flow_attr.flags >=3D IB_FLOW_ATTR_FLAGS_RESERVED)
>=20

I'm not at all convinced this is the right thing to do.  Sniffing of
packets is definitely a privileged operation.  Tcpdump needs to be run
as root to do this on regular devices.  If not CAP_NET_ADMIN, then a
root check seems appropriate.  CAP_NET_RAW does not seem sufficient for
sniffing other people's packets.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ShvlMBRtPtHhiNprKLvvUAUUnW3jLJTmC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNj7GAAoJELgmozMOVy/dM2gP/jWmhbTA1nk1XGb6L5hmMkrF
lJG4iuXVA/GN7cKW+7e3lUVRat3BvhWWOfJCUYJa6cpeckcuWFK7f0GQ5RDwgimc
wWuADeqEuV3G3EjuQ5SEogv7uoSlrpK667i8mJiQpX/XsCRCQGNMpgIHdJvDoSr7
u0GYveoHD6tnGpL82SIkksVfrQ547XBYLRuqGDqn0Mc+wBeD7FlwSnjMFjUw+8bY
N41FlDZL1yEmrKzI/cnW9PHJ9QRIYD+PFsKQpDZrz/onNjdEaylezYInQNJtZ78n
70bqcKg1M2TlCfKi23+jOw8pYCtn/3wTtC5ZaJ7IXKxfXLNOBHCK/CSgeXksF4cr
HziLc+Mz/bJam9BsB48LXSsa5dfc4CJ+vlJcr6xmgWML4WUkIsYhtSj3RRV6RO+z
yoDHevZ+p0wFXEmM1R3CKNKUDzbZKwk2jM8AvzOLQW8e86JUGvpHp5Bak1FhIT0H
poEZ1vHv6FlhMKvV7gOCylpBURY4uKxTgKV4d6nXWYa+ncF6A2PtOt4yppRZN6Yz
DbFebO9qQyBBCTzr8haYtnqZ4DVVZDqwoyS4WPeOO3FL1kjY6CiQxu4oTPZiK07a
WYKuSbLoS+orxfU43MQxrEQeWItsJFBXbzrna/rKsVeWghVqUPxj+rgEmAxVB9fy
qYlcytYaF0vSW4zL2gyn
=OYoX
-----END PGP SIGNATURE-----

--ShvlMBRtPtHhiNprKLvvUAUUnW3jLJTmC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
