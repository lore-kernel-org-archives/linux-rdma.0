From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/core: Add might_sleep() annotation to
 ib_init_ah_from_wc()
Date: Wed, 30 Aug 2017 10:24:03 -0400
Message-ID: <571534e2-878c-b169-e65c-d4dd2d05694f@redhat.com>
References: <20170829173444.4289-1-roland@kernel.org>
 <20170829173444.4289-2-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V00hGEoUsW9lQmIDaEPOKEwVltrHaaleJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829173444.4289-2-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V00hGEoUsW9lQmIDaEPOKEwVltrHaaleJ
Content-Type: multipart/mixed; boundary="p3PQfMJp276gq62mQQ8LHaWvbAXvTBIF2";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <571534e2-878c-b169-e65c-d4dd2d05694f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/core: Add might_sleep() annotation to
 ib_init_ah_from_wc()
References: <20170829173444.4289-1-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20170829173444.4289-2-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170829173444.4289-2-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--p3PQfMJp276gq62mQQ8LHaWvbAXvTBIF2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/29/2017 1:34 PM, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>=20
> For RoCE, ib_init_ah_from_wc() can follow the path
>=20
>     ib_init_ah_from_wc() ->
>       rdma_addr_find_l2_eth_by_grh() ->
>         rdma_resolve_ip()
>=20
> and rdma_resolve_ip() will sleep in kzalloc() and wait_for_completion()=
=2E
>=20
> However, developers will not see any warnings if they use ib_init_ah_fr=
om_wc()
> in an atomic context and test only on IB, because the function doesn't
> sleep in that case.
>=20
> Add a might_sleep() so that lockdep will catch bugs no matter what hard=
ware is
> used to test.
>=20
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Thanks, will pick this up today too.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--p3PQfMJp276gq62mQQ8LHaWvbAXvTBIF2--

--V00hGEoUsW9lQmIDaEPOKEwVltrHaaleJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZpsqEAAoJELgmozMOVy/drn8P/ievXlJSAFEN/Xfz9hCXhfHf
+QiuEBYR0/DOv29YeWXZucERJdadFDlqdFLupN5mvWiDeqyA7y2qqeTfZvah149G
PEYWHUI98PAF1Ehug+Z2GLgi9PnuHqlAf4+lDetJDBxagpHGrfUHm58s3xZyY6Vd
a1zziZw0sXdK+UCGWH/WgyRgCiObUqA1AV8Z7ZHd4igSu9szCF7k6JUVgHaVLbxq
cx5c8BAmg3Vyu1AvT+3bxMmFzJtJxHUXdl3BJpQ+gCeiGf/oLx6kq6uKjdmgF78h
3mjf0lM2KnoUoThRs+rCQgI6y/pnvg4O2mFrNC0SElTnbHqkWGOG98bIggVGyrbc
NMU/+Ylhe+28j7R8IzRdL7q0SPXZ5+ku7Z2TV/aHqduTxAE9HxbWmxIjHrJPysYT
GquyeRR7EbGfvjmrjJ5pxrjsjuF6bB0cX1QWB+/CacPeZUT4Nc4J2iiaINgEG3fl
yyv1dngqU1O7yjwFrCuVwcBFed+6qxXwPCuKks/LsmsGC3tjgHrXogTY14gjHQRA
jBSD/MSfDPUME8CXEdVXScE1Of+fk63OUBuKfAEkrtU8xj+UV8T4SiSUGj88Z9At
udbd0L/kbxqcfEDyQLOQnLERu6s1cnwYvrolqEEGVrurdjxPudt+Il+3W6404dm7
yvufn93V28Le8kMUnsBg
=LfZm
-----END PGP SIGNATURE-----

--V00hGEoUsW9lQmIDaEPOKEwVltrHaaleJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
