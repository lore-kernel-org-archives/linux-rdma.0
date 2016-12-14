From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Address three Coverity complaints about RDMA code
Date: Wed, 14 Dec 2016 13:27:47 -0500
Message-ID: <3a91270b-bce5-f426-e85e-a81d98f1e9d5@redhat.com>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ieAJAitsnhnPO1PPr589O7V8DnuPo8sRn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94eb11fc-b558-b994-c933-da784caefc53-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ieAJAitsnhnPO1PPr589O7V8DnuPo8sRn
Content-Type: multipart/mixed; boundary="SlEemsOG3P5mkIMgXbd6tUhWVg90wODUK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <3a91270b-bce5-f426-e85e-a81d98f1e9d5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Address three Coverity complaints about RDMA code
References: <94eb11fc-b558-b994-c933-da784caefc53-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <94eb11fc-b558-b994-c933-da784caefc53-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

--SlEemsOG3P5mkIMgXbd6tUhWVg90wODUK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/21/2016 1:20 PM, Bart Van Assche wrote:
> Hello Doug,
>=20
> The three patches in this series address warnings reported by Coverity
> on the RDMA code. Please consider these patches for kernel version v4.1=
0.
>=20
> Thanks,
>=20
> Bart.

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--SlEemsOG3P5mkIMgXbd6tUhWVg90wODUK--

--ieAJAitsnhnPO1PPr589O7V8DnuPo8sRn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUY8kAAoJELgmozMOVy/dMmMP/3l9eT6AMHlrHPLTkoNueb9v
wMiEGdNy5GU4e5ZJCBdAbu7TjF2IgkUwjwNLAUg/RzoJ+8AHw7i48n1eglIsR3VI
ri+xu2tIDXvCzVX4YYjQ3ieNUN8cCsPwsnsu16ebFH/CiOFPlOY1jqb+Dqb8ZBdw
iNMYyELgqT1DmVaCJqzk1izPpHP/gdtgCzkTl+CEQ+2AOZ3bwg5A19b6qiX38GQx
9tu/UQ6kDwGKlouADUIkBqTjQ1lc1vust2ppolAafW3sEZraJmuS4lF++qL6Jtim
P85HXZWtLsEGpObdeOMnyZn3KM9CjvOqk+zzMGWt6YajHWoXKfw87DQZOOGhH/3I
FRLxcamgU3j81BVHZ/6Pzy+drp2zJmKPXonVOkgGfsVu/pHExuolb8T8AOioqeoU
2HKc4CvrN+aqcsOM67+nHSockFkML6wcfUlcDGO64sPvDBlxeoI3e5+ZeYZ6ppeT
bjh7kphC4LKCQaXpFkk+r7n7mVRdvl+/Yspy4Mnh75hJMy5HkGPQ0ZY0Ob1f4fql
uV8Y/3L5MyRM0oh9VYuk3zRpS/VaJ78hoEcQ+bN1hy9aTp//m+g/XXc6yALtbJYl
RMgUf6gvTXQh003sxFAdHEgWTrxqZUJ7M8vQP5wq6BGJdzdtBPG8tmNa5uzRgloo
PdmZM7MK8xQdL04AhxYA
=a9TG
-----END PGP SIGNATURE-----

--ieAJAitsnhnPO1PPr589O7V8DnuPo8sRn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
