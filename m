From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/hns: include linux/module.h
Date: Sun, 19 Feb 2017 08:58:33 -0500
Message-ID: <1487512713.86943.115.camel@redhat.com>
References: <20170217143945.2217431-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1ZFsDvgoLSxLkpxxgfP8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170217143945.2217431-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Lijun Ou <oulijun@huawei.com>
Cc: "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Salil <salil.mehta@huawei.com>, Shaobo Xu <xushaobo2@huawei.com>, Wei Yongjun <weiyj.lk@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-1ZFsDvgoLSxLkpxxgfP8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-02-17 at 15:38 +0100, Arnd Bergmann wrote:
> I ran into a build error on arm64 randconfig testing:
>=20
> infiniband/hw/hns/hns_roce_main.c:539:1: error: data definition has
> no type or storage class [-Werror]
> infiniband/hw/hns/hns_roce_main.c:539:1: error: type defaults to
> 'int' in declaration of 'MODULE_DEVICE_TABLE' [-Werror=3Dimplicit-int]
> infiniband/hw/hns/hns_roce_main.c:539:1: error: parameter names
> (without types) in function declaration [-Werror]
> infiniband/hw/hns/hns_roce_main.c:979:226: error: data definition has
> no type or storage class [-Werror]
> infiniband/hw/hns/hns_roce_main.c:979:226: error: type defaults to
> 'int' in declaration of 'module_init' [-Werror=3Dimplicit-int]
> infiniband/hw/hns/hns_roce_main.c:979:1: error: parameter names
> (without types) in function declaration [-Werror]
>=20
> Including the module.h makes it build again.
>=20
> Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-1ZFsDvgoLSxLkpxxgfP8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaSJAAoJELgmozMOVy/dYaEP+wdMP0m52QmhOOcb6pWWA924
315mGF7QjMUwEeGsZfJ2wHg0TOmogPCBjUM/rXHzORXtz2M2Eoxx1YQZuoFA4pJz
pAO7LVk4zUBM7QzbfXIqm1OophW5mM3OXtV5ZooQXxwPDS2pfOmcPlvrvEbNYgjs
baCT+yWeECyPHoWDqg4Xu1a1sjCQwCHkUHDFtEIkTbA943EJuPvxTUpdWialDwd9
rDm8Q+vR7DeF0UF0MqsKKbZI4Fl3J+y8OHghpPo1Bpt+sd1ni2LdEB9lnHC/E7hi
4c8aJsXUicIma7K9U0X6B7xg8k7hdfkm/08lkY9d/J+NSSEIeXSXGfGDZYHnoF8P
DP9zkIMFF1lW67qFM5+k6AZVfUWKkzRJ+xDtLjZCZZ7ab6SgojH71Jv11PX2p/iU
D1NrzR3CPJRBnDw1hniVZL0nEHFlLOjk3xA5KtszGF6WH66kvmt84n44o2J8iyuB
AXdvh1nSkNDRPBlHYRDcfFhdh0XY227pke05ztxoDab/h7BocO2FhXwl0EAEqR+l
VotXyEbuPKVwY3cccl3TxNMqpYdYejnmvyPKcxm57mOuwB/xyj5Sz9vTjLcNUl9Q
N4Ju2TaLTITiHarhFTjMzYOMbniyDP5LIp6scaufCOzmOk+jOTbCe45NVuJm2uPX
JNq/wEJ6MGC1A/xZHXQ0
=jtpc
-----END PGP SIGNATURE-----

--=-1ZFsDvgoLSxLkpxxgfP8--
