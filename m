From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] rxe: fix broken receive queue draining
Date: Sat, 22 Jul 2017 14:14:47 -0400
Message-ID: <a6f87fad-fa16-0a10-5d1e-b2704b83e654@redhat.com>
References: <1498555178-12106-1-git-send-email-sagi@grimberg.me>
 <1499812957.2586.47.camel@wdc.com> <D594F7C4.1AF34%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UkWipBOViN1DuUxbxbMbJkWOGuE7doFC3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D594F7C4.1AF34%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org" <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UkWipBOViN1DuUxbxbMbJkWOGuE7doFC3
Content-Type: multipart/mixed; boundary="wJ57wTBk6GPSsIcC9hnK3fi75BxDlNgGm";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>,
 Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org" <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
Message-ID: <a6f87fad-fa16-0a10-5d1e-b2704b83e654-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] rxe: fix broken receive queue draining
References: <1498555178-12106-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
 <1499812957.2586.47.camel-Sjgp3cTcYWE@public.gmane.org> <D594F7C4.1AF34%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
In-Reply-To: <D594F7C4.1AF34%Andrew.Boyer-mb1K0bWo544@public.gmane.org>

--wJ57wTBk6GPSsIcC9hnK3fi75BxDlNgGm
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/19/2017 11:56 AM, Boyer, Andrew wrote:
> To make this work, it also needs to handle the case where a pkt is on t=
he
> req_pkts list but the QP is no longer valid.
>=20
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -594,8 +594,10 @@ int rxe_requester(void *arg)
>  	rxe_add_ref(qp);
> =20
>  next_wqe:
> -	if (unlikely(!qp->valid))
> +	if (unlikely(!qp->valid)) {
> +		rxe_drain_req_pkts(qp, true);
>  		goto exit;
> +	}
> =20
>  	if (unlikely(qp->req.state =3D=3D QP_STATE_ERROR)) {
>  		rxe_drain_req_pkts(qp, true);
>=20
>=20
> You could also combine the two checks into one conditional.
>=20
> For that matter, what is the =8Cnotify=B9 argument supposed to do? I wo=
uld
> think =8Cnotify =3D=3D true=B9 would mean advancing the consumer pointe=
r, not the
> other way around.

This will have to be done in a follow up patch.  I had already accepted
the original patch before you made this review comment.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--wJ57wTBk6GPSsIcC9hnK3fi75BxDlNgGm--

--UkWipBOViN1DuUxbxbMbJkWOGuE7doFC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc5YXAAoJELgmozMOVy/dv9QQAKy5Y9l1tNjkotPA1w6NJ/Xs
NVSFXp6GyNimbziOhqUiabhulLDhjFCchFKhAVh6DfmWL8QoIv5zjUMnv6L1zle6
O2IWH7swM9qadl/HQB1hJAbNYV640zhvYIPk9p5buJ50GBHjqsblhh17+83+qnZq
LzIdN5NlPz5B/MdRG0UkyCun+tfhTLIEbaCBAm1Bx3fLjOoV9AKsAq1Qz7+G4OCi
68geLgbq4du6xRu91yNzEX0H3pY8GgLIiOSAcX/6P3KIh6jPFJwTlUcer1sRxnnD
e0WQncymeP8dCatlFu9RblIfAlnds/SxwZ2vHb6x/x5lLvQo/tEs5nVZH0Qk3HDS
bT53Ur0r+LoNraSRFaFNgsUYFAsSh40QsUiT9xr2Bq8Rt2LeCg87t2TeMJvmMYfE
QVebtg58zmT+6mhXAy56DMKqHdlpJKnnMdNQ/tMameK0pAEdbO48oADw8Eid/kfL
vt3UqqPoMW/HvjyZEEOlqvhcveJY3qj960yTIL6BHBoRuHmyviYmC1uNEm+Wf9ql
eThDMeOpujVrQIGKm6/ysTpmhavEBRjNVPJBMG9ifZhAWx1T5cYw/AMm/b+LICIW
fgzBC6DlOI2OvtRFj2674yYAx4nRmngY+gnNZwgSjnt8M2OA5fRLePdK5Fb89hjR
IoJdpohiW+bnbhvp3lxS
=TVsj
-----END PGP SIGNATURE-----

--UkWipBOViN1DuUxbxbMbJkWOGuE7doFC3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
