From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 02 Apr 2015 12:04:45 +0200
Message-ID: <1427969085.17020.5.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Shachar Raindel <raindel@mellanox.com>
Cc: "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 18 mars 2015 =C3=A0 17:39 +0000, Shachar Raindel a =C3=A9cr=
it :
> Hi,
>=20
> It was found that the Linux kernel's InfiniBand/RDMA subsystem did no=
t
> properly sanitize input parameters while registering memory regions
> from user space via the (u)verbs API. A local user with access to
> a /dev/infiniband/uverbsX device could use this flaw to crash the
> system or, potentially, escalate their privileges on the system.
>=20
> The issue has been assigned CVE-2014-8159.
>=20
> The issue exists in the InfiniBand/RDMA/iWARP drivers since Linux
> Kernel version 2.6.13.
>=20
> Mellanox OFED 2.4-1.0.4 fixes the issue. Available from:
> http://www.mellanox.com/page/products_dyn?product_family=3D26&mtag=3D=
linux_sw_drivers=20
>=20
> RedHat errata: https://access.redhat.com/security/cve/CVE-2014-8159
> Canonical errata: http://people.canonical.com/~ubuntu-security/cve/20=
14/CVE-2014-8159.html
> Novell (Suse) bug tracking: https://bugzilla.novell.com/show_bug.cgi?=
id=3D914742
>=20
>=20
> The following patch fixes the issue:
>=20
> --------------- 8< ------------------------------
>=20
> From d4d68430d4a12c569e28b4f4468284ea22111186 Mon Sep 17 00:00:00 200=
1
> From: Shachar Raindel <raindel@mellanox.com>
> Date: Sun, 04 Jan 2015 18:30:32 +0200
> Subject: [PATCH] IB/core: Prevent integer overflow in ib_umem_get add=
ress arithmetic
>=20
> Properly verify that the resulting page aligned end address is larger
> than both the start address and the length of the memory area
> requested.
>=20
> Both the start and length arguments for ib_umem_get are controlled by
> the user. A misbehaving user can provide values which will cause an
> integer overflow when calculating the page aligned end address.
>=20
> This overflow can cause also miscalculation of the number of pages
> mapped, and additional logic issues.
>=20
> Signed-off-by: Shachar Raindel <raindel@mellanox.com>
> Signed-off-by: Jack Morgenstein <jackm@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
>=20
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core=
/umem.c
> index aec7a6a..8c014b5 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -99,6 +99,14 @@
>  	if (dmasync)
>  		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
> =20
> +	/*
> +	 * If the combination of the addr and size requested for this memor=
y
> +	 * region causes an integer overflow, return error.
> +	 */
> +	if ((PAGE_ALIGN(addr + size) <=3D size) ||
> +	    (PAGE_ALIGN(addr + size) <=3D addr))
> +		return ERR_PTR(-EINVAL);
> +

Can access_ok() be used here ?

         if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ,
                        addr, size))
                  return ERR_PTR(-EINVAL);


>  	if (!can_do_mlock())
>  		return ERR_PTR(-EPERM);
>=20

Regards.

--=20
Yann Droneaud
OPTEYA
