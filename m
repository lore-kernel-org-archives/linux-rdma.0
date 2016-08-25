From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 0/3] Add support for TCP segmentation
 offload (TSO)
Date: Thu, 25 Aug 2016 10:42:59 -0400
Message-ID: <4bedb772-ff66-a60e-66a4-128e4d061e3a@redhat.com>
References: <1471798081-19088-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QRNOvAgkQehmLOJAIu2SEfNPluLXb26Lv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471798081-19088-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QRNOvAgkQehmLOJAIu2SEfNPluLXb26Lv
Content-Type: multipart/mixed; boundary="sc2rOecMODFxSTQ0rtRGMh8vQ6EfSdtsk"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Message-ID: <4bedb772-ff66-a60e-66a4-128e4d061e3a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 0/3] Add support for TCP segmentation
 offload (TSO)
References: <1471798081-19088-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1471798081-19088-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--sc2rOecMODFxSTQ0rtRGMh8vQ6EfSdtsk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/21/2016 12:47 PM, Yishai Hadas wrote:
> Hi Doug,
>=20
> This V1 series addresses a note coming from the list to replace a macro=

> by a static inline function, details below.
>=20
> The relevant kernel patches regarding capabilities were already taken i=
nto your
> tree for coming kernel of 4.8.
>=20
> The series was tested successfully with mlx5 driver (lib, kernel) and c=
an be
> accessed also from my openfabrics GIT at:
> git://openfabrics.org/~yishaih/libibverbs.git branch: tso_v1
>=20
> Yishai
>=20
> In general,
> TSO enables an application to pass a packet with large chunk of data th=
an the
> MTU to the NIC and let it breaks into small packets as part of its send=
 flow.
> The TSO engine will split the packet into separate packets and insert t=
he
> relevant user specified L2/L3/L4 headers automatically.
> This is a technique for increasing outbound throughput of high-bandwidt=
h
> network connections by reducing CPU overhead.
>=20
> For some extra information about TSO, below link can be helpful:
> https://en.wikipedia.org/wiki/Large_segment_offload
>=20
> Verbs usage,
> TSO traffic is performed by ibv_post_send with opcode IBV_WR_TSO.
> The following information should be supplied within the associated send=
 WR:
> - A pointer to the packet header.
> - Header size.
> - The maximum segment size (mss) that hardware should generate in
>   its TSO engine.
>=20
> The above information required to send a TSO packet is similar to the I=
B kernel
> API.  http://lxr.free-electrons.com/source/include/rdma/ib_verbs.h#L123=
7
>=20
> The TSO capabilities as of the supported QP types, max TSO payload can =
be
> achieved upon query device.
> =20
> When creating a TSO eligible QP, user should supply the maximum TSO hea=
der size
> in order to let providers preparing their SQ buffer accordingly. This n=
eed is
> similar to other capabilities that are given as part of QP creation for=
 that
> purpose.
>=20
> Changes from V0:
> patch #2: Change 'ibv_is_qpt_supported' to be a static inline function =
instead
>           of a macro.
>=20
> Bodong Wang (3):
>   Fix ibv_cmd_query_device_ex to return valid output
>   Add support for TCP segmentation offload (TSO)
>   Update man pages for TSO support
>=20
>  examples/devinfo.c         | 20 ++++++++++++++++++++
>  include/infiniband/verbs.h | 37 +++++++++++++++++++++++++++++--------
>  man/ibv_create_qp_ex.3     |  1 +
>  man/ibv_post_send.3        | 36 ++++++++++++++++++++++++------------
>  man/ibv_query_device_ex.3  | 22 ++++++++++++++--------
>  src/cmd.c                  |  9 +--------
>  6 files changed, 89 insertions(+), 36 deletions(-)
>=20

The third patch, to the man pages, only added raw eth to the supported
type matrix for TSO.  However, the actual support clearly was intended
to work with UD as well.  I modified the man page patch to correct that.
 Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--sc2rOecMODFxSTQ0rtRGMh8vQ6EfSdtsk--

--QRNOvAgkQehmLOJAIu2SEfNPluLXb26Lv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvwPzAAoJELgmozMOVy/d9J0P/2R3T6qj6esL6oGLxZkyvq5h
VU1P17nthWTocrWr9k5XFO6yrYeHPE1eF3ckYLAI6X9fNJc+ShQtl2pRVVhD0Bpf
pu4PwkOmLxHHGRZQkRGlw6ItDv40U37nUae0Go//3yqmyIxyCNgcZaCXJkFxf0Qi
mSWc8ONj5oZPU6qZEZmghBlAzrqJubFi+q+4iIV0YoxneBas9XQOqyH53FY4a/MU
spEe4foMtRDQyw0lVgDR7sBHjEZMtaX1cacFCnT7thzs+LalwJv/pPY33qwaAJRN
VXOY4L4BMGwQLn2pMJsnN5sujnGDQ6mhSFwA6pO4VaTq8e7bT5A4uI+vWFL4/rC8
+dxOlD4SS81xHUbJijdYjBJF4TarhsNW28HHzo+zhtMMyNpcvK+PrbPr7BqQ6vc2
F3Ue7r9ESB4BAVmhmmGGwZjMDSqU5mLiha1GMVmmme6qQ1mmtGIGyR51X/VvpFbO
1iMwLpjOli6RWHrA1gFmVVVEH9jTLVxi2ZjgVBnBkbw62S2O9LQPFglNSdmvieIW
UjHZvGTaMDgKtQW3BwtWx7YxuDwHqrh3AvTcjnQ/inxWs+PTvqLZ22Ct6Rl5c4Ij
NeDVW6Reslfy3cZhVFfr8fCeiP4KGxCIBjZdo4OCYqAi2Q2+8XSLxDxG8bdH9uL/
Ol8qAJaWdFbb4QS6Pcia
=R2i1
-----END PGP SIGNATURE-----

--QRNOvAgkQehmLOJAIu2SEfNPluLXb26Lv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
