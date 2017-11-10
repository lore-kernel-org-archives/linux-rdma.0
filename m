From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/hns: Add rereg mr & RoCEv2 support for hip08
Date: Fri, 10 Nov 2017 12:15:48 -0500
Message-ID: <1510334148.3735.1.camel@redhat.com>
References: <1509009025-101743-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6scbcVDqFstEoC1qul5T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509009025-101743-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org, shaoboxu-WVlzvzqoTvw@public.gmane.org, shaobo.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-6scbcVDqFstEoC1qul5T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-10-26 at 17:10 +0800, Wei Hu (Xavier) wrote:
> This patch-set introduce rereg mr support, RoCEv2 support for hip08.
>=20
> Wei Hu (Xavier) (3):
>   RDMA/hns: Add rereg mr support for hip08
>   RDMA/hns: Generate gid type of RoCEv2
>   RDMA/hns: Configure sgid type for hip08 RoCE
>=20
>  drivers/infiniband/hw/hns/hns_roce_cmd.h    |   3 +
>  drivers/infiniband/hw/hns/hns_roce_device.h |  17 +++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   7 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  79 +++++++++++++++++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   7 ++
>  drivers/infiniband/hw/hns/hns_roce_main.c   |  20 +++--
>  drivers/infiniband/hw/hns/hns_roce_mr.c     | 123 ++++++++++++++++++++++=
++++++
>  7 files changed, 242 insertions(+), 14 deletions(-)
>=20

Thanks, series applied.
--=-6scbcVDqFstEoC1qul5T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF3sQACgkQuCajMw5X
L90uVw/+LZ0F+iNo0F6lyLnXJ0gFywCb4cTLNFta/wNaxxxo8tidZHiFfuwu7K7v
xv+x+iiWJID45TIDqX0xVzbHUyAy/RNfBlfaHzXctDR3V+tae4VTQW2l+DCWn4Ha
DJ3NB8RdmvA6+34HWvdgQc6AU7FIuayfNSkqgAYWJY+EZMmkaqhGv5+ePqCT64Bk
L348jp/XztEnhgNTDAolulJFtvH+YbWFY4Ho6oybpAaO4D8w7/HYzQ08lkVekijP
cS57wm4E55D3C5Zrj/bCmRSwqALUnDNHI0pK8VwGbbiKTVn8m9+HHOdInLxdeCKq
aJ0U00oqkCLcStCZZpUF69yjLHJwGbUuRABEoyFg7rxmTZmHkKAzK+tIshwWwRu0
1QrPuK3Z6Hk4ogkjDJXivIGve8ST706E0dWoF+8m0URrzreNH1UOjpl83HdEsx7v
ILS5rs8RKrgXbViid6Ar8lZxmxR7pFepdffRG+K4ziIGMssMsmCSBrAIIyBxQFkI
6JzAhiMfEVBsznQuIeckhu+BJvPm3n6/M7uOIc7dYZBGWE9y7JhCLDw+8jb8rtj0
iRrJcqRnXgTGTOxCadPh9IGaIqrT2aCjvsYCNfIwXxlpbwWOJBzzv0MZOvh5qL7N
+Q7hd+ul7E6TMfCnWbO+WF+PYTanj2m7IA++uH6TJ0/mis+1F4o=
=0vyg
-----END PGP SIGNATURE-----

--=-6scbcVDqFstEoC1qul5T--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
