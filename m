From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] User-index fixes
Date: Wed, 17 Feb 2016 11:19:24 -0500
Message-ID: <56C49D8C.2000605@redhat.com>
References: <1455467752-3170-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RLwqLrhFWn1aeWMm1iakFDarcNne7unmG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455467752-3170-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RLwqLrhFWn1aeWMm1iakFDarcNne7unmG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/14/2016 11:35 AM, Matan Barak wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hi Doug,
>=20
> This series fixes two issues introduced in 4.5 after applying my
> series "Raw Packet QP user-space support for mlx5".
>=20
> SRQs don't use user-index, therefore the user shouldn't pass it and the=

> kernel shouldn't verify. The first patch fixes this by avoiding
> user-index verification for non-xrc srqs.
>=20
> The mlx5_ib driver fails libraries that support user-index but don't
> pass it. It relies on the input length of the vendor specific part to
> determine whether the user-space supports user-index.
>=20
>=20
> In Legacy verbs, the given vendor specific part input length is given
> including struct ib_uverbs_cmd_hdr. In contrast, extended commands
> pass the same length exluding the header size.
> The vendor driver doesn't know whether the command is a legacy
> command or an extended command. Thus, we need to modify IB/core
> in order to pass a consistent size. The second patch fixes the input
> length in the IB/core and the wrong usage in the mlx5_ib.
>=20
> We verified that other vendors don't use the inlen parameter and thus
> won't break by this change.
>=20
> Thanks,
> Majd and Matan
>=20
>=20
> Majd Dibbiny (2):
>   IB/mlx5: Avoid using user-index for SRQs
>   IB/{core, mlx5}: Fix input len in vendor specific part of
>     create_qp/srq cmd
>=20
>  drivers/infiniband/core/uverbs_cmd.c |  9 +++++---
>  drivers/infiniband/hw/mlx5/srq.c     | 41 +++++++++++++++++++---------=
--------
>  2 files changed, 28 insertions(+), 22 deletions(-)
>=20

These went in already in case you missed it.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--RLwqLrhFWn1aeWMm1iakFDarcNne7unmG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxJ2MAAoJELgmozMOVy/dam0P/iFQ+fU6g+5dTdIvWJRsrWqN
GlVdlHNuaGRgh7nGaFnXi3PUYQU9+iDkVThDmpPIVGhe6oPxq+5ilSW9Glqelofx
zgvOHEl79ezu7pUp4p6dfJ270NbfL7zDYbyjIHB9EnHK5OSFTdV5adYthld09Kkm
4ieXeX/O8sQK4o+IZgSBnGgNZhGDjXE3uZf6qdVsXCmr7gwridzuJsYKVaHq+s2I
EfyxBVgk79tT7Es6LOQ3G+3pbGrBGyjEEbX2VWPgKXhqLoTo8lYzj5jUkJKeVGQl
WoyYEotp+od5Ub8wvJTmEh2eYlnH9CN5quII6uSm9RW/KLVYWkEoLniNCbM5Gt4q
8xvo5PiHLKzfxwotsU1/c14ydTPJ0/lO13gHiYA12SDAgxkSTReG5+5DrOoVC0sq
ubR84RmmJQzAzAVx+IuH/QuEijcsQcoVz7nT4VnyfLIDdSDTu8JEChbXD+W6s4wF
SAl0wiTP1yUukgkt1a/cccTv1Rn2bLsQquh1YxAW0mUSr25P4mr3+2VvtTSxCbi5
CIJe6nn2I/KupQoVit2CBu2mrGAnNdlQutQhaKSr+2vq95eTQLuYVTaz5tvR243Z
XFW49U6pYcWY5GWoSQBJA2tON633erDc/EMlAHLMZSQe5Id/9YAmkpNlvgjaL3MA
ITYgpaF/9UBC3jYj70t4
=SDSA
-----END PGP SIGNATURE-----

--RLwqLrhFWn1aeWMm1iakFDarcNne7unmG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
