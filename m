From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v05 61/72] include/uapi/rdma/rdma_user_rxe.h: include in.h
 and in6.h
Date: Tue, 23 Aug 2016 11:03:35 -0400
Message-ID: <99dc34ea-696d-8a07-8353-bc51f39855b6@redhat.com>
References: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
 <1471890809-4383-62-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="APBgOEaJXjv08dlxsNakp8DooQCxNvrQk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471890809-4383-62-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--APBgOEaJXjv08dlxsNakp8DooQCxNvrQk
Content-Type: multipart/mixed; boundary="jKLuOM3KheeO5fHLicfokPw31dbMimAvt"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <99dc34ea-696d-8a07-8353-bc51f39855b6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v05 61/72] include/uapi/rdma/rdma_user_rxe.h: include in.h
 and in6.h
References: <1471890809-4383-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
 <1471890809-4383-62-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
In-Reply-To: <1471890809-4383-62-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>

--jKLuOM3KheeO5fHLicfokPw31dbMimAvt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/22/2016 2:33 PM, Mikko Rapeli wrote:
> Fixes these userspace compilation errors when rdma_user_rxe.h is compil=
ed
> alone:
>=20
> rdma/rdma_user_rxe.h:59:20: error: field =E2=80=98_sockaddr=E2=80=99 ha=
s incomplete type
>    struct sockaddr  _sockaddr;
>                     ^~~~~~~~~
> rdma/rdma_user_rxe.h:60:22: error: field =E2=80=98_sockaddr_in=E2=80=99=
 has incomplete type
>    struct sockaddr_in _sockaddr_in;
>                       ^~~~~~~~~~~~
> rdma/rdma_user_rxe.h:61:23: error: field =E2=80=98_sockaddr_in6=E2=80=99=
 has incomplete type
>    struct sockaddr_in6 _sockaddr_in6;
>                        ^~~~~~~~~~~~~
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/rdma/rdma_user_rxe.h | 2 ++
>  1 file changed, 2 insertions(+)

for the rxe portion of this much larger patchset:

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jKLuOM3KheeO5fHLicfokPw31dbMimAvt--

--APBgOEaJXjv08dlxsNakp8DooQCxNvrQk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvGXHAAoJELgmozMOVy/dSKwP/1hEJZF/FA/3QgV3jRG7LRzA
1BbW2C3EYv6Bo3Bo9UHyHhqEqhvIbtoDGt4DCCQJrJ28F6C32CMJ4faO2dss5xsY
H3gPsQa6NQS0hoTd1d9rVtlEJt+euXQdX5W2Zv/Ha3qaIZBxHYV2XuVF7FZlKA2S
/dyrDngFr5bPX5L3WBxlsckcVLlFiKk0K5VAKnawe+mEcv013NmHXf49zBqukzl1
ELCWGbrhLAvCvr0HGyw4NlRlqnF3H9n4apgyT3Tx/rV2b4nDUDDipWeI0nQUFuYU
8ig5hmsnWf69SrviL4vcH1G53l0GyCYknp0JU6Xg63FyTfSUDZvIbM30tFrKT7xF
LPT4oeaXxl9RoU5bqO4ROwm6GF/CJBjhMeSMGkKl7kWjnMl9nyia6lKZniwPC/AJ
26eH5Qo0867skjwzo5rAeA3pYS3uwhHKzsOXozIsspXJOtnSZj7aIxjVgc0cXjHs
WdLyq+HqRgNfjgoZZrlY8E4Ch54JSw3YXS9/JSRThD64urczS/hKwQU+ngVcFWX5
4Xj03iQodLB9swufFr3mW9TmP1g1dIH7r28+nlmAWisRoh4hSlKtdwl87O6u+mst
z6bB3v64K+cROQxFvoxpuNXJefVkC0hTnLNOZn3y6JrxtiFCPBzOngeqCdBZgU99
aoTzGbr1kSvreY7r/O7Y
=SzL3
-----END PGP SIGNATURE-----

--APBgOEaJXjv08dlxsNakp8DooQCxNvrQk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
