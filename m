From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 0/2] RoCE V2 support for UD traffic
Date: Thu, 15 Sep 2016 14:40:28 -0400
Message-ID: <d5aa97ce-369f-ed3f-3171-b88947c0af83@redhat.com>
References: <1473943877-6049-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="67erxLlwmwDCDsbHQRxvoxbDD2teXG8FA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473943877-6049-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--67erxLlwmwDCDsbHQRxvoxbDD2teXG8FA
Content-Type: multipart/mixed; boundary="x86avLiUP3MdJSn9EJPQKvwjVjl7HjAVT";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <d5aa97ce-369f-ed3f-3171-b88947c0af83-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 0/2] RoCE V2 support for UD traffic
References: <1473943877-6049-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1473943877-6049-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--x86avLiUP3MdJSn9EJPQKvwjVjl7HjAVT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/15/2016 8:51 AM, Yishai Hadas wrote:
> Hi Doug,
>=20
> Sending V2 to align the map file with the GCC syntax, details below.
> No other changes from V1.
>=20
> This patch-set from Noa enables user application to work
> properly with RoCE V2 when UD traffic is used.
> The series was tested successfully with mlx5 driver (lib, kernel)
> and can be accessed also from my openfabrics GIT at:
> git://openfabrics.org/~yishaih/libibverbs.git branch: rocev2_v2
>=20
> It's sent over your master branch, to take it on top of RSS series
> you can take it from the 'for-upstream' branch in above GIT.
> (solves a conflict in src/libibverbs.map)
>=20
> No change is required in the application side, all is done transparentl=
y
> to the application.
>=20
> Yishai
>=20
> In General:
> Currently, UD traffic is not supported over RoCE V2 in libibverbs,
> since libibverbs can't differ between V1 and V2 GIDs and can't
> select GID index properly.
>=20
> This series contains two patches targeted to solve this:
> - The first one introduces an internal helper function,
>   ibv_query_gid_type, to be used by libibverbs and its vendors libs
>   in order to select the correct GID index.
> =20
> - The second patch changes init_ah_from_wc to use the first patch and
>   set the GID index according to the RoCE version used.
>=20
> Changes from V1:
> patch #1: Align the map file around IBVERBS_1.3 to match the GCC syntax=
 as described in below wiki:
>           https://gcc.gnu.org/wiki/SymbolVersioning.
>=20
> Changes from V0:
> patch #1: Use IBVERBS_1.3 as the symbol label.
>=20
> Noa Osherovich (2):
>   Add ibv_query_gid_type to support RoCE v2 UD traffic
>   Add support for UD traffic on RoCE v2
>=20
>  include/infiniband/driver.h |   7 ++
>  src/libibverbs.map          |   5 +
>  src/verbs.c                 | 243 ++++++++++++++++++++++++++++++++++++=
++++----
>  3 files changed, 236 insertions(+), 19 deletions(-)
>=20

Series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--x86avLiUP3MdJSn9EJPQKvwjVjl7HjAVT--

--67erxLlwmwDCDsbHQRxvoxbDD2teXG8FA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX2uscAAoJELgmozMOVy/dosUP/R6gItZSvqkqdhtJJ01Fw35k
7W0UWBHFg1ccj4gYLtZI+ZlYfFXLtQVx83pBYrJsNbkg3hDUETQu/Q5ba6Nhn2BF
0MeK8FeR/DWUHzn5ViMgxwDImz81NQOkKcGC2QVUNBS/IcPBzVcI5M9xhN2LBOA2
f7BC4z4G5Bzmwbr7gWhRKC/F3OfmDzw4gXvMejubz2dC/g8mkEq8sQDg8k+qX2rX
u9CK/AUvsk7YdABHODnofwH6q7IYX4GgUGLCWJkKWitZ7HONHjqlWGsHwzHttGy9
mwSfRvwucViM5H89tjHFCGe9Tp6FTo3F4ZHAfSBX0lvyJGsIAWCng3Fut7k6A4xw
WgCP8YQTAljIlUVz/0h62oEF5Xb5HrvDGXs9QMZClXT9pMlp2QAFTx43xPsLxx9M
RTUKzLHhoQjr3p7I46ZzX0su2GaZInzcAnPzM/ininYL7XVx3025He+TxD8nIprp
1U+RagQKYPpfs6nio/o1hhTbdjEy6khB3PhcVw1l6IZnUWmjHbpOfrMRB65Wmnzj
6VnbxrXdZeoMwbf3ugzQJysvvVKWrvs1VEBj4ybFIzNh8u6cTgf+Z4Z/UaBvaS09
UIeoI1rPRL763VEHL0dLN592m57SR02CMN3HGrgApNt+ghcy+m8n7MyVvBFW/JDr
xf7vsIrBvUd6SEues7i9
=Yttp
-----END PGP SIGNATURE-----

--67erxLlwmwDCDsbHQRxvoxbDD2teXG8FA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
