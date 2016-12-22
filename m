From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Set 128B as the only supported RQ WQE size
Date: Thu, 22 Dec 2016 11:40:38 -0500
Message-ID: <0737c69e-df80-5375-885a-726a788058eb@redhat.com>
References: <20161221145346.11116-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GN56xKWix6U1mrtODOvaa5Q3cm25ORhlc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161221145346.11116-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GN56xKWix6U1mrtODOvaa5Q3cm25ORhlc
Content-Type: multipart/mixed; boundary="eAijWsR5gnMSjkfiGMbvbi4kRsoFHrHLh";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <0737c69e-df80-5375-885a-726a788058eb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Set 128B as the only supported RQ WQE size
References: <20161221145346.11116-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20161221145346.11116-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--eAijWsR5gnMSjkfiGMbvbi4kRsoFHrHLh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/21/2016 9:53 AM, Henry Orosco wrote:
> From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> RQ WQE size other than 128B is not supported.  Correct
> RQ size calculation to use 128B only.
>=20
> Since this breaks ABI, add additional code to
> provide compatibility with v4 user provider, libi40iw.
>=20
> Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--eAijWsR5gnMSjkfiGMbvbi4kRsoFHrHLh--

--GN56xKWix6U1mrtODOvaa5Q3cm25ORhlc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXAIGAAoJELgmozMOVy/d0DYP/1EmQB3j2cJzobWgfZ/2+htm
mLKlFKA+BH/7I0eBfGoV9Ex1EmuF2s9G1/1f8MmAu42LMXTTRaAe+HAyk/pSnCmT
KYHAaXJ7A3DFecGGwU9C/3FytckGb2JkBOLPMojwFZkAPoA5F/rPqetzGVtB1L1G
QZzOyS0X6nl3+dXi/I9aQx5I1lKh/du2zJEr7t/Dvwl3ViSBCSE4K2UOsO4fkDPx
e0CCkUN6Pm3FiONMqRr1MjmUscEbMTgm7fCsSoauwwheDcNpKw0NbJgrX1zuj24t
a8Zxlw5wuW6Si1J+aXS2o2i+BC/ykNavfcu1s8pwopr5SZLMtAj5IOrREwZiaPkO
w5KZ/BHSEY0XBmF8KuQv7vr+Fp/X8Eh1alAMK6UCse4Ww4RpS385gbEEJS9zAwHE
VPfm5yZZHihxRLphlraMONSZkFRXirz7vPk5HA7oFgFup4zEb0wfAZVLFrBsmB08
OGDHWSLRatW63iOznN4yCW3LEIXcC+B9TUPATddQDQiOMBrZ5nP6kZHuCFW9gqcn
DFVhoYC8uIPxyex26geI6z0wPoE1NhJbmurQmuCAJxGpXD52XlRdUus4WmpP8yJ0
PmllmNOVkFZ2D4sQzJ+BbFb2th2imRBt0EBzRx8oeVokHwAniVc8H3R/mJtexvj3
mi3+Zx7CRA6KtgP2KtBd
=qbbi
-----END PGP SIGNATURE-----

--GN56xKWix6U1mrtODOvaa5Q3cm25ORhlc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
