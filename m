From: "Parvi Kaustubhi (pkaustub)" <pkaustub@cisco.com>
Subject: Re: [PATCH 2/2] infiniband: prefix header search paths with
 $(srctree)/
Date: Fri, 25 Jan 2019 21:35:07 +0000
Message-ID: <DAD82200-BFAE-43C7-B668-7D1AED5D5C15@cisco.com>
References: <1548391171-6407-1-git-send-email-yamada.masahiro@socionext.com>
 <1548391171-6407-3-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548391171-6407-3-git-send-email-yamada.masahiro@socionext.com>
Content-Language: en-US
Content-ID: <CC49761C65E12C43B53365F6DEFC97CA@emea.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Somnath Kotur <somnath.kotur@broadcom.com>, "Christian Benvenuti (benve)" <benve@cisco.com>, "Nelson Escobar (neescoba)" <neescoba@cisco.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Lijun Ou <oulijun@huawei.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Steve Wise <swise@chelsio.com>, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Selvin Xavier <selvin.xavier@broadcom.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Devesh Sharma <devesh.sharma@broadcom.com>
List-Id: linux-rdma@vger.kernel.org

Thanks,

Acked-by: Parvi Kaustubhi <pkaustub@cisco.com>

> On Jan 24, 2019, at 8:39 PM, Masahiro Yamada <yamada.masahiro@socionext.c=
om> wrote:
>=20
> Currently, the Kbuild core manipulates header search paths in a crazy
> way [1].
>=20
> To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
> the search paths in the srctree. Some Makefiles are already written in
> that way, but not all. The goal of this work is to make the notation
> consistent, and finally get rid of the gross hacks.
>=20
> Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
> ("kbuild: do not drop -I without parameter").
>=20
> [1]: https://patchwork.kernel.org/patch/9632347/
>=20
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>=20
> drivers/infiniband/hw/bnxt_re/Makefile | 2 +-
> drivers/infiniband/hw/cxgb3/Makefile   | 2 +-
> drivers/infiniband/hw/cxgb4/Makefile   | 4 ++--
> drivers/infiniband/hw/hns/Makefile     | 2 +-
> drivers/infiniband/hw/i40iw/Makefile   | 2 +-
> drivers/infiniband/hw/ocrdma/Makefile  | 2 +-
> drivers/infiniband/hw/usnic/Makefile   | 2 +-
> 7 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/bnxt_re/Makefile b/drivers/infiniband/=
hw/bnxt_re/Makefile
> index 6e3bc25..ee9bb1b 100644
> --- a/drivers/infiniband/hw/bnxt_re/Makefile
> +++ b/drivers/infiniband/hw/bnxt_re/Makefile
> @@ -1,6 +1,6 @@
> # SPDX-License-Identifier: GPL-2.0
>=20
> -ccflags-y :=3D -Idrivers/net/ethernet/broadcom/bnxt
> +ccflags-y :=3D -I $(srctree)/drivers/net/ethernet/broadcom/bnxt
> obj-$(CONFIG_INFINIBAND_BNXT_RE) +=3D bnxt_re.o
> bnxt_re-y :=3D main.o ib_verbs.o \
> 	     qplib_res.o qplib_rcfw.o	\
> diff --git a/drivers/infiniband/hw/cxgb3/Makefile b/drivers/infiniband/hw=
/cxgb3/Makefile
> index 66fe091..34bb86a 100644
> --- a/drivers/infiniband/hw/cxgb3/Makefile
> +++ b/drivers/infiniband/hw/cxgb3/Makefile
> @@ -1,5 +1,5 @@
> # SPDX-License-Identifier: GPL-2.0
> -ccflags-y :=3D -Idrivers/net/ethernet/chelsio/cxgb3
> +ccflags-y :=3D -I $(srctree)/drivers/net/ethernet/chelsio/cxgb3
>=20
> obj-$(CONFIG_INFINIBAND_CXGB3) +=3D iw_cxgb3.o
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/Makefile b/drivers/infiniband/hw=
/cxgb4/Makefile
> index 9edd920..31a87d9 100644
> --- a/drivers/infiniband/hw/cxgb4/Makefile
> +++ b/drivers/infiniband/hw/cxgb4/Makefile
> @@ -1,5 +1,5 @@
> -ccflags-y :=3D -Idrivers/net/ethernet/chelsio/cxgb4
> -ccflags-y +=3D -Idrivers/net/ethernet/chelsio/libcxgb
> +ccflags-y :=3D -I $(srctree)/drivers/net/ethernet/chelsio/cxgb4
> +ccflags-y +=3D -I $(srctree)/drivers/net/ethernet/chelsio/libcxgb
>=20
> obj-$(CONFIG_INFINIBAND_CXGB4) +=3D iw_cxgb4.o
>=20
> diff --git a/drivers/infiniband/hw/hns/Makefile b/drivers/infiniband/hw/h=
ns/Makefile
> index 004c88b..e2a7f14 100644
> --- a/drivers/infiniband/hw/hns/Makefile
> +++ b/drivers/infiniband/hw/hns/Makefile
> @@ -2,7 +2,7 @@
> # Makefile for the Hisilicon RoCE drivers.
> #
>=20
> -ccflags-y :=3D  -Idrivers/net/ethernet/hisilicon/hns3
> +ccflags-y :=3D  -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
>=20
> obj-$(CONFIG_INFINIBAND_HNS) +=3D hns-roce.o
> hns-roce-objs :=3D hns_roce_main.o hns_roce_cmd.o hns_roce_pd.o \
> diff --git a/drivers/infiniband/hw/i40iw/Makefile b/drivers/infiniband/hw=
/i40iw/Makefile
> index 5a8a7a3..8942f82 100644
> --- a/drivers/infiniband/hw/i40iw/Makefile
> +++ b/drivers/infiniband/hw/i40iw/Makefile
> @@ -1,5 +1,5 @@
> # SPDX-License-Identifier: GPL-2.0
> -ccflags-y :=3D  -Idrivers/net/ethernet/intel/i40e
> +ccflags-y :=3D  -I $(srctree)/drivers/net/ethernet/intel/i40e
>=20
> obj-$(CONFIG_INFINIBAND_I40IW) +=3D i40iw.o
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/Makefile b/drivers/infiniband/h=
w/ocrdma/Makefile
> index d1bfd4f..e3f20ca 100644
> --- a/drivers/infiniband/hw/ocrdma/Makefile
> +++ b/drivers/infiniband/hw/ocrdma/Makefile
> @@ -1,4 +1,4 @@
> -ccflags-y :=3D -Idrivers/net/ethernet/emulex/benet
> +ccflags-y :=3D -I $(srctree)/drivers/net/ethernet/emulex/benet
>=20
> obj-$(CONFIG_INFINIBAND_OCRDMA)	+=3D ocrdma.o
>=20
> diff --git a/drivers/infiniband/hw/usnic/Makefile b/drivers/infiniband/hw=
/usnic/Makefile
> index 94ae7a1..f12a493 100644
> --- a/drivers/infiniband/hw/usnic/Makefile
> +++ b/drivers/infiniband/hw/usnic/Makefile
> @@ -1,5 +1,5 @@
> # SPDX-License-Identifier: GPL-2.0
> -ccflags-y :=3D -Idrivers/net/ethernet/cisco/enic
> +ccflags-y :=3D -I $(srctree)/drivers/net/ethernet/cisco/enic
>=20
> obj-$(CONFIG_INFINIBAND_USNIC)+=3D usnic_verbs.o
>=20
> --=20
> 2.7.4
>=20
