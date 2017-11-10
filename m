From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/11] Update the usages of some fields
Date: Fri, 10 Nov 2017 12:29:12 -0500
Message-ID: <1510334952.3735.2.camel@redhat.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-toiPr86Lt7Yt2n3WpmpT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-toiPr86Lt7Yt2n3WpmpT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-10 at 16:55 +0800, Lijun Ou wrote:
> This patch series mainly configure some fields of qp context and
> cqe for hardware using as well as fix some bugs for hip08 RoCE.
>=20
> Lijun Ou (11):
>   {topost} RDMA/hns: Update calculation of irrl_ba field for hip08
>   {topost} RDMA/hns: Configure TRRL field in hip08 RoCE device
>   {topost} RDMA/hns: Configure fence attribute in hip08 RoCE
>   {topost} RDMA/hns: Set se attribute of sqwqe in hip08
>   {topost} RDMA/hns: Enable the cqe field of sqwqe of RC
>   {topost} RDMA/hns: Set sq_cur_sge_blk_addr field in QPC in hip08
>   {topost} RDMA/hns: Update the usage of ack timeout in hip08
>   {topost} RDMA/hns: Add sq_invld_flg field in QP context
>   {topost} RDMA/hns: Set the owner field of SQWQE in hip08 RoCE
>   {topost} RDMA/hns: Unify the calculation for hem index in hip08
>   {topost} RDMA/hns: Modify the usage of cmd_sn in hip08
>=20
>  drivers/infiniband/hw/hns/hns_roce_cq.c     |  2 +
>  drivers/infiniband/hw/hns/hns_roce_device.h |  3 ++
>  drivers/infiniband/hw/hns/hns_roce_hem.c    | 13 +++--
>  drivers/infiniband/hw/hns/hns_roce_hem.h    |  1 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 75 +++++++++++++++++++++++=
+-----
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  9 ++--
>  drivers/infiniband/hw/hns/hns_roce_main.c   | 21 +++++++-
>  drivers/infiniband/hw/hns/hns_roce_qp.c     | 19 +++++++-
>  8 files changed, 121 insertions(+), 22 deletions(-)
>=20

I don't know why you left the {topost} on all of the subject lines, but
I removed them.  Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-toiPr86Lt7Yt2n3WpmpT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF4egACgkQuCajMw5X
L93J3Q//WMk4WyANXeXxVYfC3HvPhQq+QEvLiHQU8fWqvT1oINmAH87aM5V3I5jh
FmiTLKnofVqus8UfhSmvB96RBHWxSpt0JKWzemWAj+OLzxMkMX48nyR+y5H2w+pL
SmRHNYyslQPkb1BM5BCKSRa3zqwZ/8QcgPUnAQVP0FOPsSIRwhnFYhK1PzVPjQZi
RQLC38Y3cnvbY5tWIMs8JT1lFII1YEmCThjknaPp12qxF031rzGcn78sQdXurohE
zmplCYAHbelfWdk2rdEgUeZd2Ip2OCErFRXb9/fxZc7yWkq5onRFsPtgCTXG979X
SzaXMZDgRVrJ23o6yyhuTFyucQRGOSF+F6RmABwRtJfyKxwCYFBM12vkdAQ0DNoY
ng/TfQtzMAbFOve0uQQ/yOG3bwsVhDMFwLRwQsR28lZbqZU0CKwtPlpvSG06+v9Z
xaB0HqCeSpr8TQu2ksTj0LHxCuRweuX3FG3J9p814qD31SonwNhvx8rK2kTVi8/j
9isMEViUzPhx1lcnmi9i/bvILluAT0XTXf4fur0J1A1N0cUVSPI5CZClmSvjP5LB
IXXZebOiFTA1zWVnX/9K17oYcgjonmNCS9B5HifgCg2/zSHeg45h1RmaGUoYFAWV
lbzclywUFFQj3OnpD/VsSMs45ZBcBr58l8BmpI1dsOgtUJrFOzI=
=FNkM
-----END PGP SIGNATURE-----

--=-toiPr86Lt7Yt2n3WpmpT--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
