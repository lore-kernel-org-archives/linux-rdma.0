From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Substitute ib to rdma in file names
Date: Mon, 18 Jul 2016 14:09:54 -0400
Message-ID: <960f2db5-1ba0-c070-fdae-a12328fedffd@redhat.com>
References: <1468487320-19797-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tgGp5oMlaCFQCsAVA0B63NGwXkK002muS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468487320-19797-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tgGp5oMlaCFQCsAVA0B63NGwXkK002muS
Content-Type: multipart/mixed; boundary="ovgwcQiBdTkeIRE4beOVQSOtU54Em8lrJ"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <960f2db5-1ba0-c070-fdae-a12328fedffd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Substitute ib to rdma in file names
References: <1468487320-19797-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1468487320-19797-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ovgwcQiBdTkeIRE4beOVQSOtU54Em8lrJ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 7/14/2016 5:08 AM, Moni Shoua wrote:
> Change prefix of module name and public inclue file name from ib to
> rdma.
>=20
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  MAINTAINERS                           |   2 +-
>  drivers/infiniband/hw/Makefile        |   2 +-
>  drivers/infiniband/hw/rxe/Kconfig     |   2 +-
>  drivers/infiniband/hw/rxe/Makefile    |   4 +-
>  drivers/infiniband/hw/rxe/rxe_verbs.h |   4 +-
>  include/uapi/rdma/Kbuild              |   2 +-
>  include/uapi/rdma/ib_user_rxe.h       | 144 --------------------------=
--------
>  include/uapi/rdma/rdma_user_rxe.h     | 144 ++++++++++++++++++++++++++=
++++++++
>  8 files changed, 152 insertions(+), 152 deletions(-)
>  delete mode 100644 include/uapi/rdma/ib_user_rxe.h
>  create mode 100644 include/uapi/rdma/rdma_user_rxe.h

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--ovgwcQiBdTkeIRE4beOVQSOtU54Em8lrJ--

--tgGp5oMlaCFQCsAVA0B63NGwXkK002muS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXjRtyAAoJELgmozMOVy/dRssP/0teBWy65UrDAxRVDLMd1ikn
LjJ6FDyC5gKcDPLu4wS8krecY3KWzhdVmXN1MaogOkKEs403Icv+QPS8xLv8VMjX
5ZBJLJ6TdG4j0AwDO++kn5gryVaYcDN6Qf60PU+6rQ6XKjl+VUQ4d3p+9JYRLqOY
lloEx9pt+1lLNMlZ0S9WDfkTGDe+5HNB/F6uK3+/XXZGxrPHBH6KmzZwnh/87UFh
gRcZ048eIf2B6JvR6Sn/ndoDLzW7I6TpER7N38ghfm+4hWRb73KcmTbSjg+C0fb4
vzHkMEEwHKROLYd2/cI0z7Tuo8CToynSHVmWXG/DB9V1FgX2C+g7sd1YIepNSycW
CNN7N1xNY3BAgO2JIlHsOqNhbTs2I97Fi7rSqTxRh0FYMZA66xk4g2o8d0ObhKIk
se2K9jTAJ26FvLlKI7s4DadDfBd2BsyE9LEvp+Bc9susdgyxgyeBHwcz5a9oBcGM
QVy1POXrr2llMceYID3t3psbiZQNdGX5OTEuvNmeWcsczUUwNK+Ub0PPFRqHGySA
/Ydbahh5GJYuysch5b9lei9YcIwFkM9ArePkUIbLvbN+AeXvQkUZS021yNHpoCQQ
nckogr6XTJNHQT69fdoIWP2fNVCn/aF3XsfbizTMRdmc8uPIHNWeEnxjp6vMBdHq
mPyouHtrzrcfa/obw+lF
=Vrej
-----END PGP SIGNATURE-----

--tgGp5oMlaCFQCsAVA0B63NGwXkK002muS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
