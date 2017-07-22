From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/13] RDMA/bnxt_re: Misc fixes for bnxt_re
Date: Sat, 22 Jul 2017 13:41:26 -0400
Message-ID: <424c1ab0-e4ff-974a-a5ab-a2cff04553bc@redhat.com>
References: <1498764499-24157-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="orc8242waLejFOCikLEiNxI1USptgtpmo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498764499-24157-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--orc8242waLejFOCikLEiNxI1USptgtpmo
Content-Type: multipart/mixed; boundary="EBmiU259J4gICTVjQc9DXNU0Xbi6iKXpV";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <424c1ab0-e4ff-974a-a5ab-a2cff04553bc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/13] RDMA/bnxt_re: Misc fixes for bnxt_re
References: <1498764499-24157-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1498764499-24157-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

--EBmiU259J4gICTVjQc9DXNU0Xbi6iKXpV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/29/2017 3:28 PM, Selvin Xavier wrote:
> This patch series includes the bug fixes for bnxt_re.
>=20
> Patches 1 - 8 in this series are the backlog from the previously
> submitted series -
> https://www.spinics.net/lists/linux-rdma/msg50984.htm (6 out of the
> the 14 patches from the above series got merged into 4.12-rc).
> Theise patches are already reviewed by the community.
>=20
> Patches 9-13 are new patches posted for review.
>=20
> Doug,
> Please review this and consider applying all 13 patches in the 4.13
> merge cycle.
>=20
> Thanks,
> Selvin Xavier

Hi Selvin,

I dropped patch #1 because it conflicts with other patches already applie=
d.

Then, because I'm only taking -rc candidate fixes this cycle, I took
patches 2, 3, 5, 6, 7, 8, 10, 11, 12, and 13.  I left out 4 because it
is rather large, and because this represents something that is arguably
a feature implementation and not a strict bug fix that has a workaround
(just use vlans with egress mappings and the issue is resolved).  I left
out 9 because of its size and the non-urgent nature of the fix.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--EBmiU259J4gICTVjQc9DXNU0Xbi6iKXpV--

--orc8242waLejFOCikLEiNxI1USptgtpmo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc45GAAoJELgmozMOVy/dwMkQAKAq2GOJkvSsh1aTsLsCUOG5
/sVhPqW92A+auq1lJIrmx30Z/GS9qlbBsfmrY6xKs1OTj7Q6bERcdA9mPFKmeSRr
fHQYgaB1u61kThISKzE74A58p7IZJNYjdAtkQ/X1M9Qh4vlA5yXvk8z8mkc4ccc1
Q1SIfFUkM+4OKVC0EZ6/cAbrLQmoRAvg6eIYsDzXzOu8yILt1CsuEjTxaNnVlqM0
aB9JnOb+fgGeP4rscier9/Nlgcbt6+WiR/g6es6z41BnfF5E0HxC7vpJxSD5XvjA
vVs3NVAXVqVziVhLrqI3ZAAUC+w26Ur5Jyjk7aivAXNg0zN4cThWnrTlijwToQ1l
XCXpZe0vOWuftdE4alJ8auWg4g493f8zu31sX8aZOSfaa/KAns156ocdwLlRJ4Jr
eetxxcKtfmSkWcckfyk5LATksVddmqAFC8EQL/3POUmNDjVs4tj89kQeAgjU5Yeg
1IrWL8u2e8idtmZRalFsII1dAFgso/KvkiAfi0c3Gx5aRswu5jiHpMTPWjjHgEdR
jzlOMNw4czUjSfhrgw4ryNJvv2UANsUXLCE30srohxWyWX+aNBdVgBbtC3s1s8YO
mc7hFgRNjV4SvXcVKhn3HJhLIL7jkCJ4s0snIZ2XggxtdVdjoFJyZR10JoshSpud
rOcAkuGbgYfFzD6Q8Kke
=UZJ4
-----END PGP SIGNATURE-----

--orc8242waLejFOCikLEiNxI1USptgtpmo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
