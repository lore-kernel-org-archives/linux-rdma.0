From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 0/2] Advertise atomic operations support in
 mlx5
Date: Wed, 23 Dec 2015 11:06:26 -0500
Message-ID: <567AC682.1020601@redhat.com>
References: <1450103650-16857-1-git-send-email-eranbe@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L7bKxPhHsnfWT0fcPKG8HgB4KbMJ4ADJq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450103650-16857-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L7bKxPhHsnfWT0fcPKG8HgB4KbMJ4ADJq
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/14/2015 09:34 AM, Eran Ben Elisha wrote:
> Hi Doug,
>=20
> This patch set adds the functionality to advertise standard atomic oper=
ations
> capabilities for mlx5 driver.  The Hardware can be configured to work i=
n two
> modes according to the device capabilities: 1. Big Endian requestor res=
pond 2.
> Host Endian requestor respond
>=20
> If the firmware supports host endianness, try to configure the hardware=
 to work
> this way, and on success propagate this capability to the upper layers,=

> otherwise advertise that atomic operations aren't supported.

If you are not going to allow any support except for host endian, then
why bother with all of the BE stuff, can't you just list it as supported
or not?

> Thanks, Eran
>=20
> Changes from v0:
> 	- Rewrite the commit message of the second patch in the series
>=20
>=20
> Eran Ben Elisha (2):
>   net/mlx5_core: Configure HW to support atomic request in host
>     endianness

I can fix this up, but generally try to keep your subject of patches
short enough to fit in the generally accepted length.

>   IB/mlx5: Advertise atomic capabilities in query device
>=20
>  drivers/infiniband/hw/mlx5/main.c              | 28 ++++++++++++-
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 57 ++++++++++++++++++=
+++++++-
>  include/linux/mlx5/driver.h                    |  5 +++
>  include/linux/mlx5/mlx5_ifc.h                  | 22 ++++++----
>  4 files changed, 102 insertions(+), 10 deletions(-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--L7bKxPhHsnfWT0fcPKG8HgB4KbMJ4ADJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesaCAAoJELgmozMOVy/dfQQQALzZlxFeJo6QyHxatcp9EboZ
Zff8W8lwde00/XB36joZXyK+jIIaz3x6XseSY8uNl6+Q7rY+DQfNMcjH5HW1csBJ
QIYk1udr5oLlZcA3cnuoQo0wUw0gkQL/ckKY/0uQ6elFOpvITZNpgsgczWmGWMkY
TJ3xV51QZvbrQYKjSiFuPJYWy3kaDuMN81bxJh9dvfgUmKg499/rEOgfFkIYnZDt
H2kx85DAePtKglUgaQbjmWSVmk+51rDPu66nejn+ayNpTQ4CJ/6oa9o3PcpKS8i6
ThY1be1gyzKy9Kx1uEejSneZRGnGRo9zfY30y3rFKV+3VFhx3M1Zw45I8yLJw270
FqC9AVzirQOJUQNFyxXGQYFzDJ5tMdkVSXcmmH79/lWh5D+maok5juGaOzj0iRWC
BvxYKDLPHZ8m9VhZqLedD4yhcXPPbsmW0aZxaS4ePABPoiWGatWyC36OIQKSUg76
vkjrHQP0D6+zuYMSy0NSAcxpNyEnaIKwcc1sWJsbWUo22iIQ4tvjbT3o1Zpwffx4
l70G1Idd57oYunfISSMMcVy4tFFdOLz9AecJgz9L6Oktn8MEWWdCwAL91Ev7lDU5
FqPZs+1UCLc5JfP3SXleQfUYIvXHIyjnhCbWuH8s76k2G1M33TP7qfp9mhNgDpz0
zBTMYkUyAbiSHu8qGRQ/
=lR3W
-----END PGP SIGNATURE-----

--L7bKxPhHsnfWT0fcPKG8HgB4KbMJ4ADJq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
