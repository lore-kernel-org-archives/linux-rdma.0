From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
Date: Wed, 24 Aug 2016 11:27:03 -0400
Message-ID: <c20dbb49-cf77-ca53-31fd-1a6d7451a0b1@redhat.com>
References: <1471910507-83104-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="80XC2fwJQ4EV3O7F9FXEgXSMAlH7tdcc3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471910507-83104-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--80XC2fwJQ4EV3O7F9FXEgXSMAlH7tdcc3
Content-Type: multipart/mixed; boundary="tTxbv1WAfEeSarGSbKHadDBIxEhSEwqea"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <c20dbb49-cf77-ca53-31fd-1a6d7451a0b1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
References: <1471910507-83104-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1471910507-83104-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--tTxbv1WAfEeSarGSbKHadDBIxEhSEwqea
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/22/2016 8:01 PM, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> In i40iw_free_virt_mem(), do not set mem->va to NULL
> after freeing it as mem->va is a self-referencing pointer
> to mem.
>=20
> Fixes: 4e9042e647ff ("i40iw: add hw and utils files")
>=20
> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>=20
> V2: Fix typo in subject line.

Applied with a minor comment added to the file.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--tTxbv1WAfEeSarGSbKHadDBIxEhSEwqea--

--80XC2fwJQ4EV3O7F9FXEgXSMAlH7tdcc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvbzHAAoJELgmozMOVy/d4b0P+wffJ8R/shmafVtKoKnc6Tea
slgpX8ENhpfgD/Hd+RAw767ybn84DSh5ENTYdzMSGr9HIuJPmUsxFjb5dvKCWT1O
Nwdo7qK+EeoZ65cApaD/i73gL83JyCGY9oaBsas1fyBJ6bi3TZ6ty26JVNRZwDhP
sWfqR4QFvggSOKcY/4x9CSZa+dvb0eMWibUBfa83ruHPSYztjk6R6h/1K0wm0nIc
BvQT4P9XYpvTc6/iyP0F7DjppOjFBZXspYAP1du0R/xUz6SMRb4RhrsiqLNmnYSf
LA6Q4+Px+Onh5FbWICH6WsIJ4LM7qgDROwZwoHBrBdPBGQXBRdW9r0ZKigK+25xI
FPGYKhWnh0FKbYnlEfugf9S3kGidoweAkwwDysJmDKJoVTl8MmggvoHikMaMYNut
UmglTwMjh5gglakGkx4EMhd0HVq07HRiQ1u2LRyWxNz6sswnEU1MYYznjCK/+LH+
HS7h6EOf+iXO2ESl3MbR4w+rj/QhQtQA6Bzh9fataSlkLodnHRj0Ga8HC6lR+bbv
UGhT9SK9iSx6OSFhIMmeyxPRkv3Dy39vY6Pnw6CQZ8hrsMRtCGkFse7aBAQqFaKL
OWgHZfIrdY9sEKq/qUqrLKkIAsQPU8z+bUa6HEffOiAjMRiS7+xIbZ2LmVgX26Un
nwtCPBSE6fmDaQVv6hLh
=OMIf
-----END PGP SIGNATURE-----

--80XC2fwJQ4EV3O7F9FXEgXSMAlH7tdcc3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
