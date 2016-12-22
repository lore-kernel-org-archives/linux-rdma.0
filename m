From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
Date: Thu, 22 Dec 2016 11:53:02 -0500
Message-ID: <fe84ce7a-dd7f-1b63-ac84-5a0ed5f3bcea@redhat.com>
References: <20161221220840.36268-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sBpc7KNMcbUcokMJRv7XkJwJogkQ4te2Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sBpc7KNMcbUcokMJRv7XkJwJogkQ4te2Q
Content-Type: multipart/mixed; boundary="rOw6prd0i3iV6Aj3G3dsclRdwAEwRfCn1";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <fe84ce7a-dd7f-1b63-ac84-5a0ed5f3bcea-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] redhat/spec: various fixes and cleanups
References: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20161221220840.36268-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--rOw6prd0i3iV6Aj3G3dsclRdwAEwRfCn1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/21/2016 5:08 PM, Jarod Wilson wrote:
> This is a set of patches to fix up a few things in the Red Hat (Fedora)=

> rdma-core spec file that came up as part of the Fedora new package revi=
ew
> process, where we're working on getting rdma-core into Fedora in place =
of
> the old split packages.
>=20
> Fedora package review bug:
>   https://bugzilla.redhat.com/show_bug.cgi?id=3D1404043
>=20
> Jarod Wilson (6):
>   redhat/spec: call it srp_daemon in desc, not srptools
>   redhat/spec: improve base package description
>   redhat/spec: use fully versioned Requires on base package
>   redhat/spec: fix up %post scriptlets
>   redhat/spec: clean up rsocket packaging
>   redhat/spec: make sure docdir is owned
>=20
>  redhat/rdma-core.spec | 65 +++++++++++++++++++++++++++++++++++++------=
--------
>  1 file changed, 47 insertions(+), 18 deletions(-)
>=20

Thanks, series applied and -rc3 generated, so future fixes will need to
be incremental.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--rOw6prd0i3iV6Aj3G3dsclRdwAEwRfCn1--

--sBpc7KNMcbUcokMJRv7XkJwJogkQ4te2Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXATvAAoJELgmozMOVy/dpYEP/3CWbrjyxT50XcmQtpcREbwY
TdAyIRuIC8DsCWbBxmyMeua5W5Z/z/2P8hIZfKmzv85ajgud1FWb67dtIvs5ep65
8rrhvkKatUrchwVAQHHNY7Pvldb5StSNWIifx9ex4eVsMfvHLf9MsohrlJspN2Ru
ai468B0JSmLfl3N7VWarP3xIPS+mhN9PXkdgSUODe34rDU+O8j432jTbb3PXJrU3
J9UwQA/TeLMM8Okg4XfVrPES1HFyB3ZxuYqtUUYaFuaKjCTIsHXeKufdYAXY16Yi
Elz7HoWzb0Swy6f7GXeYaMES8BJDdVRI34tEA/nG/1xzd7ygIrrYTHA0qn3hnT7S
7vuaufXOLQQtZa/0UK1tZtVpv59sdow/TjVdFMIpZFRbtRDGpIM3berZji8T3A4w
vC53Kl8e4BY2E12Lj/Q/X7B2X+3xJi/QfB9AxWTQDQrGbO2by0OlyM5a1SU0eDBJ
r8KJxnjkTFQ7dwjlBVCVKr1oKLocjomC2TDIJ/DgCtzfR7Xsdnm+SzDrd3bc+toS
iWf72/75bQQhEEcCKYPm+SJtiybaw3k+92Wr/0QbhlHo9E2RgAENKAVZoLg/bhOh
BJj3IpCUiebMT/p8oQkm+FHUKsktOAvf1+lwIdtMQRtwsB+IGH1IAlDdlSCzMBik
WG/N6YMzNRfAlLcXTYht
=rYZ9
-----END PGP SIGNATURE-----

--sBpc7KNMcbUcokMJRv7XkJwJogkQ4te2Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
