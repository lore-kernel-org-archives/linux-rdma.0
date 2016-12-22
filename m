From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 11:41:24 -0500
Message-ID: <9f5e0225-c53e-43e7-13b5-ae715f74b198@redhat.com>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4psrMIDd9XRv0s9nISCR7RpgAMvcAVd3I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4psrMIDd9XRv0s9nISCR7RpgAMvcAVd3I
Content-Type: multipart/mixed; boundary="wtxSiJT0E5g7Nk4X637435hNrM1GOSvQs";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <9f5e0225-c53e-43e7-13b5-ae715f74b198-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
References: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
In-Reply-To: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>

--wtxSiJT0E5g7Nk4X637435hNrM1GOSvQs
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 8:54 AM, Andrew Boyer wrote:
> This patch series addresses two issues found during heavy traffic
> testing as well as a recently-reported Smatch issue.
>=20
> Andrew Boyer (3):
>   IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
>   IB/rxe: Drop future atomic/read packets rather than retrying
>   IB/rxe: Don't check for null ptr in send()
>=20
>  drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
>  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--wtxSiJT0E5g7Nk4X637435hNrM1GOSvQs--

--4psrMIDd9XRv0s9nISCR7RpgAMvcAVd3I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXAI0AAoJELgmozMOVy/d2BgP/1/C1SXqDpkKlnEyFOsfUihw
A532Ny6i9ytpc6/BVry2ZmQURBzquOfxateL+NJf0lbsjbKKQMe6CQJ5tfmZUqBx
azfkmFIS+8/+ARxmX4J11/VA615oaTANiQDsu+EnLQPfryBlkAZcf/WOZyMM1+Xo
5cGZODNS9x+o631ytuh0/Ldi0+cYVEwyodpRWUqLQAKlWi6H0jpHtX22F41oktO7
xawjGcslNgffPe7p+Rp6fJwzblqgXGugSJ7AYAgY07SrOi+GbvijXPdQWz4mrcXb
34ZqrwkvZ1MtxQ0T+Rt4jYKBI8jlB49qoLf9X8uhZE6Z923rdwz5UGYzH7aj/iQL
8ji0CVZeBrWEAuwPxHFN3ATuWG3tY3IWmSzbmiK0c1g46OB8pDiJCyRR8kTEwx/u
q68TWIEZFw+jZNypttCxh1ob0/LM6eLhfH4+rw44eqk+TnYJYntsmq2wOQy8vLuN
JWuZQAdY+o2NLxjn6UdSjfws/Me0gU1Vn1vCsOrfTJM53GypHikeKDCLRUZ4NlX4
ND52JcLgMlAhkxOvuTyh/kcglVbkafsKCiGY9bgzyzObEP68m8X3guowgVP+Dqqp
+lfF5O1M4LU9F6dJBuOR8YNYcVR9Ncc3b+biTGIE7RqBsatr33pgJ1sXHUYzUIPx
Pa6hXrwr93pQxHJkJRpk
=9Amj
-----END PGP SIGNATURE-----

--4psrMIDd9XRv0s9nISCR7RpgAMvcAVd3I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
