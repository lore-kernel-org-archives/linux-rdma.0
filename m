From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Expand ODP MR to support implicit
 registration
Date: Tue, 14 Feb 2017 11:45:02 -0500
Message-ID: <1487090702.86943.79.camel@redhat.com>
References: <20170118145811.9136-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HDex1bsK5VwoKtFIZdSA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118145811.9136-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-HDex1bsK5VwoKtFIZdSA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 16:58 +0200, Leon Romanovsky wrote:
> Hi Doug,
>=20
> This patchset comes from Artemy Kovalyov who proposed to expand
> current ODP feature to register memory with simplified and enhanced
> semantics.
>=20
> In existing ODP implementation applications still register memory
> buffers for communication, though registered memory regions
> need not have valid mappings at registration time.
>=20
> This patchset adds implicit ODP sematics, where applications are
> provided
> with a special memory key that represents their complete address
> space.
>=20
> Thus all IO accesses referencing this key (subject to the access
> rights
> associated with the key) won't need register any virtual address
> range.
>=20
> Thanks,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Artemy, Ilya and Leon

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-HDex1bsK5VwoKtFIZdSA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYozQOAAoJELgmozMOVy/dLqcQALaoVcoqiUC5CDJpfDq+vTbf
RFbbwanKV6ztDVNoPasRnxu81DdLmtgY75IxX25CzcSjLCDaZ+i96V+ocIyf7dpW
QoTK/PAPQ8vWq8eFfhg52qx8DXBvf4yR2Mp12lCdbSxQCEN/HUzpzeI/D6Kxw+pv
eeh0XOZ6AnsNfSvpIDVykQQjuxJCg+bwScWf7HcREe3OhSlvlxkEuQKJXH8ygWaU
MiDkZGm2mpEC0xAdDcpKLreLgvA4IEGH6tHhd2j8yw0A/leq1EYTFH0PMxJ0NmiG
QpljKmiXf4wFQ+8I46o04vONO+C75NrwJbFUdKBayaxt5Bj4GgGyxxsg9GldXNzY
/Iw2B9oQED83JzS5hjXcFDnMIC+KuBO5QgaqZsR8mTycPVEprDAvl+t3UIa15Tqg
IIS7FhTZ6GjYmJXnDRQivMfzzSr68gKfi5v/d0i1e5BezoasSkUZ1FQW9lFmviro
g4S4Gf+XlRCZu59END2Nru2TT7Px3rk2BW9h3fJfClnpSSWVG0RwK/r7T4/TfHLk
BdtqmK5DeJziVthUjD+kwjAAt3vsPG8MFx6MHyEspcA7gsGw02tWkHRCnB2hMWpG
hlD8d7+6/9GiUxV1/nDgjO0fhSgOGy5FH/OC5SxIKpLOWYK8hXjA8tjG8Ck3Gj4O
Y+HcWEvHqN2TbHcseET3
=Cc+x
-----END PGP SIGNATURE-----

--=-HDex1bsK5VwoKtFIZdSA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
