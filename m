From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next,V3] IB/IPoIB: Allow setting the device address
Date: Wed, 25 May 2016 13:59:43 -0400
Message-ID: <dca48241-291a-e13c-4e26-ed332c26c612@redhat.com>
References: <1463578963-14956-1-git-send-email-markb@mellanox.com>
 <VI1PR05MB139136EF3C46570069764F35D2400@VI1PR05MB1391.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HIDBWkWV6qnruXXDkudFiEuBPU0Dl22jo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB139136EF3C46570069764F35D2400-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HIDBWkWV6qnruXXDkudFiEuBPU0Dl22jo
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/25/2016 09:15 AM, Mark Bloch wrote:
> Hi Doug,
>=20
> Are you planning to take this one? Do you have issues I need to address=
?
>=20
> I've fixed Jason's comments, but no further input
> was given besides that.

I was just waiting on the final version of the SendOnly mcast join
series as that's IPoIB related too and I was going to pull them together
into an IPoIB topic branch.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--HIDBWkWV6qnruXXDkudFiEuBPU0Dl22jo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRegPAAoJELgmozMOVy/dXP8P/0iUgImQPIX7XSavUIZGfbQ2
NKlY0fK1ghv6lU6/3QEYuaGU+hJS4BKPwE51gD+EaBnMj+/RVmfe/YeXD8EeBaJS
4e4wRAyJk0Mubbs2FFxO0W4JaZ9fqYnoXKucp22Swg0WMA/eIt9nrxQ4dc0yKNPJ
8yYAdM9BNTaKw5mbidF8A1RvWjYi6OA6gKDPR45DHaurdx2xXEjEBDgmrAjxEcVE
avxeaovfNqipxKV7Pd0RL421Q1OK0WE6S9ZK84KYbqKwplyRP3wYV4srghANtR7G
WlZLvrrPoXYY4SO+QgFlCdlTmIwAJKIrvNA9gxc4GM6Ek3nsrGfrO8y4xwU+vPE4
kFFvqzDbil9mvBatrK3USls1WM6fNCApMbSEmV1tVqorIcwlZHV3hFlOaLOZbiAd
XM9hkriHTbn02T//SYG2qZKiOOqSJWKcwZzfdRrc1Zq2vaTIBulhBrJDPcKrADK/
haHS8N26RINgf0uN6X68BhOTrihvfmPgMazpbyFUI5QOKOPEGGcTdDY2IPeBXowe
dB2JcEYAW532wzSSsrck5ogZILxRqD6yAcLyxKJ4HiikxnK6kkK4R7UAMA3JPrad
wolnKVVIAXyVrs218MU8IjaAYASR/RSyfbSZacjXfjynFKchBbbPre7ngCEeHKgW
XbWzlbWBWlob4nFMXz3c
=kpCL
-----END PGP SIGNATURE-----

--HIDBWkWV6qnruXXDkudFiEuBPU0Dl22jo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
