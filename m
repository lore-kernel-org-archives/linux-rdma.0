From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Fix error code in ipoib_add_port()
Date: Sat, 22 Jul 2017 13:27:15 -0400
Message-ID: <29ab2fbd-0164-870e-8720-dd2056570a6d@redhat.com>
References: <20170713074548.i6cgpjhmmcnvtd5c@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="je4S7UDOs0Jqle3uB9sSXQMDgvuS6Ejf6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713074548.i6cgpjhmmcnvtd5c@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--je4S7UDOs0Jqle3uB9sSXQMDgvuS6Ejf6
Content-Type: multipart/mixed; boundary="omGrOq3gFtRMkXBton6NukeweifHaiRlj";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <29ab2fbd-0164-870e-8720-dd2056570a6d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Fix error code in ipoib_add_port()
References: <20170713074548.i6cgpjhmmcnvtd5c@mwanda>
In-Reply-To: <20170713074548.i6cgpjhmmcnvtd5c@mwanda>

--omGrOq3gFtRMkXBton6NukeweifHaiRlj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/2017 3:45 AM, Dan Carpenter wrote:
> We accidentally don't see the error code on some of these error paths.
> It means we return ERR_PTR(0) which is NULL and it results in a NULL
> dereference in the caller.
>=20
> This bug dates to pre-git days.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--omGrOq3gFtRMkXBton6NukeweifHaiRlj--

--je4S7UDOs0Jqle3uB9sSXQMDgvuS6Ejf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4rzAAoJELgmozMOVy/dsB8QAJWTPi58gFkOCj3Vysr3Hy58
9SPBj42m4S8BagFpx+VNrDh/UVNXIapc9RLgMPjiOsJpBW4Pm+RDY+xcd4jN8JwS
6MR6+RzmKW5zd6oJQ5uWhWUP8eDpjBbpzaiVIjZ7ku+PgcgO8uGwdd5F7R0gR4DL
mH4eJzG3w74dZaZX+NCXN/SUa0Sb3IGMLO44bVQuhEZSOlaJ4t5SkkyD+iwx3SL+
V7Lk187eLMDXGPaax0znDWcreqf5wKivdVnA2shqY0Ovl5sE5oI2Jq9RDwaNJGKb
ocFBt3FWZ3t9Pvyb+vLNCpTX7q2bkzHtRJMjPzFio9Dyi2sXEk42L9IKl4C3bSzV
wasO3r+rwtAlnvYy7qgv4bwW5J6Q8eoVazHjPVxl+NL5/F4yHsHQvtJLT82EpEnV
hCiNVYXnxjONifHKbuwqqMY5Wb2SO/b855TygnJRnwASNmyWYfGcMRybso917e6X
5vN3pR5dDDic4cHIi4tdmIv38opHsIQmT+WrvLnukCjivISR1NqnozQ8aqSY5xpk
kdcyW5cDQ1ciRF97qe1n6qDpMGGgbwafyOgrju4kUDYyIvtSNakFiB23inA+Ecif
6ZrTatI8t/PBeF1trFokKDDbPYgdojmzcavddnpRSNHFha6N/Jgcx5zkfQn6c16O
tlZmxZYv5x3rbXIoyUZC
=oyZG
-----END PGP SIGNATURE-----

--je4S7UDOs0Jqle3uB9sSXQMDgvuS6Ejf6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
