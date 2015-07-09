From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.2] IB/mlx4: Fix and optimize SRIOV slave init
Date: Thu, 09 Jul 2015 10:27:47 -0400
Message-ID: <559E84E3.9040208@redhat.com>
References: <23f3dca9ff4b71155bd898be1f3cbd8eeb9df27f.1436394658.git.dledford@redhat.com> <559E30C3.5050702@mellanox.com> <559E69AD.9050406@redhat.com> <559E7EFA.3070805@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q61k8VqqU6SfhEiDDmxja866w3gkHMTm7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559E7EFA.3070805-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q61k8VqqU6SfhEiDDmxja866w3gkHMTm7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/09/2015 10:02 AM, Or Gerlitz wrote:
> On 7/9/2015 3:31 PM, Doug Ledford wrote:
>>> i Doug,
>>> >
>>> >I'd like Jack to review this before we ack, not sure if he's in toda=
y,
>>> >so he might get to look on that only on Sunday.
>> Try to get it reviewed before then please.  If it passes my
>> build/functional tests (which I want to get to today), it will go in a=

>> pull request tomorrow.
>=20
> I hope Jack will be able to look on that -- I took a look -- seems fine=
=2E
> However, please (please) break it to two patches: one that fixes the
> leak and one that does the small optimization. Recently I came into a
> conclusion that each time we are violating the kernel practice of
> makingsure a patch has **one** logical change, we either add a bug or
> fix a bug in an unnoticed way, so...again, pull based on what tree/bran=
ch?

It's split.  The tree will be out (probably) later today.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Q61k8VqqU6SfhEiDDmxja866w3gkHMTm7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnoTjAAoJELgmozMOVy/dkOcP/iAFaYvL83qvJ/AT07zIjH3E
1wuCxFb8Dwgk3yOIdvC/yZA9nC9BuuV2iQr7hTClgbn1dQJSH6SlfSt5MqApw8wZ
RpZa/QRXJEHu4HMecqujiullXzFCOJT0er1x6ridAfsAhUfqYQIu5J3yqOqVEpZR
1nhXmPttU58amLVi7FivxsI1T98abBbhLaoOZ+voLdDjT/SGw63efZhm/MzGVcUq
JPehk96ZeOBsdwCLC+5fXc2F33Uci2qh8IwWKyFNgBYNppbVoWqqSHK//699nDcT
JYO0g0+0dyBecadB3ebpXbE0zh21XF1DzsAMfM34VnfjvlLrCKqe2KkCKBX5jx8M
0f7DYrBiMo0noSBrv5Bg2p1HyyyyzhjMsggiWmoeo4ZPkIeJNomWJnjQdeJaKJCN
6j/tmWX2+J6V6RDkB7XDmaKAXpyakJ/GdV26zTqofjvycG98hlLbgm2LRcnSoS19
gBuXYptfxyjze2mk8FbYjClWSjjFzS2XT0ujkfkOe3CYsz0JiwRqGV4/ScKbWlfz
rRS4HEE7YzPqOYuu7BmdC+JRonFrN2PwWy+iwT/VX1L/h/Zpv4Dz40nSWm6F6BXL
yRhbqOzGRw2D3euHM4HU4SOv2Q+lr2f2G8DeJyQIo3uxjfJjxUXpvM3lDYcusv6m
G8gx053Xpy7uW3aXUVwY
=5r4E
-----END PGP SIGNATURE-----

--Q61k8VqqU6SfhEiDDmxja866w3gkHMTm7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
