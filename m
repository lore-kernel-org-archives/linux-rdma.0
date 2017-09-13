From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 00/20] RDMA/hns: Add hip08 RoCE driver support
Date: Wed, 13 Sep 2017 20:55:54 +0300
Message-ID: <20170913175554.GX3405@mtr-leonro.local>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oYAXToTM8kn9Ra/9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504084998-64397-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--oYAXToTM8kn9Ra/9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 30, 2017 at 05:22:58PM +0800, Wei Hu (Xavier) wrote:
> This patchset adds support for the HiSilicon RoCE engine in the hip08
> SoC.
>
> The driver is refactored so it can support both platform and pci device.
> And hip08 RoCE engine is a pci device, hip06 RoCE engine is a platform
> device.
>
> New hardware layer file hns_roce_hw_v2.c is added for hw v2 support,
> which also includes pci device probing and initialization.
>
> Common functionality is still in hns-roce driver, along with device
> initialization.
>
> This patchset depends on hns3 NIC driver which had been accepted by David,
> and is based on for-next branch of the repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
>
> Shaobo Xu (3):
>   RDMA/hns: Add the interfaces to support multi hop addressing for the
>     contexts in hip08
>   RDMA/hns: Update the interfaces for MTT/CQE multi hop addressing in
>     hip08
>   RDMA/hns: Split CQE from MTT in hip08
>
> Wei Hu (Xavier) (17):
>   RDMA/hns: Split hw v1 driver from hns roce driver
>   RDMA/hns: Move priv in order to add multiple hns_roce support
>   RDMA/hns: Initialize the PCI device for hip08 RoCE
>   RDMA/hns: Modify assignment device variable to support both PCI device
>     and platform device
>   RDMA/hns: Add command queue support for hip08 RoCE driver
>   RDMA/hns: Add profile support for hip08 driver
>   RDMA/hns: Add mailbox's implementation for hip08 RoCE driver
>   RDMA/hns: Configure BT BA and BT attribute for the contexts in hip08
>   RDMA/hns: Support multi hop addressing for PBL in hip08
>   RDMA/hns: Configure mac&gid and user access region for hip08 RoCE
>     driver
>   RDMA/hns: Add CQ operations support for hip08 RoCE driver
>   RDMA/hns: Add QP operations support for hip08 SoC
>   RDMA/hns: Add support for processing send wr and receive wr
>   RDMA/hns: Configure the MTPT in hip08
>   RDMA/hns: Add releasing resource operation in error branch
>   RDMA/hns: Replace condition statement using hardware version
>     information
>   RDMA/hns: Fix inconsistent warning
>
>  drivers/infiniband/hw/hns/Kconfig           |   25 +-
>  drivers/infiniband/hw/hns/Makefile          |    8 +-
>  drivers/infiniband/hw/hns/hns_roce_ah.c     |    2 +-
>  drivers/infiniband/hw/hns/hns_roce_alloc.c  |    8 +-
>  drivers/infiniband/hw/hns/hns_roce_cmd.c    |  107 +-
>  drivers/infiniband/hw/hns/hns_roce_cmd.h    |   50 +
>  drivers/infiniband/hw/hns/hns_roce_common.h |   23 +
>  drivers/infiniband/hw/hns/hns_roce_cq.c     |   72 +-
>  drivers/infiniband/hw/hns/hns_roce_device.h |   98 +-
>  drivers/infiniband/hw/hns/hns_roce_hem.c    |  699 +++++-
>  drivers/infiniband/hw/hns/hns_roce_hem.h    |   32 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  401 +++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.h  |    5 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 3128 +++++++++++++++++++++++++++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  | 1165 ++++++++++
>  drivers/infiniband/hw/hns/hns_roce_main.c   |  324 +--
>  drivers/infiniband/hw/hns/hns_roce_mr.c     |  513 ++++-
>  drivers/infiniband/hw/hns/hns_roce_pd.c     |   20 +-
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  179 +-
>  19 files changed, 6318 insertions(+), 541 deletions(-)
>  create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>  create mode 100644 drivers/infiniband/hw/hns/hns_roce_hw_v2.h
>
> --

As far as I can see, it is ready to be merged.

Thanks,

--oYAXToTM8kn9Ra/9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm5cSoACgkQ5GN7iDZy
WKeLzA//SgBNW7Q/zZtu2Y2LfWb1Y1guNc5Kfv5krxw1lgs7/bd6wIIA7KyXIc5v
sS5Wby+LqChOPMOPp3V7AjhwzMI0uCLLdBjbEszT4Gszbo1IkVT44/WOjkb/ozvu
H/qIigwjzyxup34rl8XSoYqVt+Zyd1H5AR8V57Vdc9oK8QSBAWYmsGFN43hWBLQ9
4yVn6o8Uyh8V661buj0wELw9AoQsHroVnuAn83UKl9l3jAwa7vX11gWL43I+Wwaj
J2wJxN1X+XtyGqhmpn2vyJRf6Eo253hPaXd1tpYe6dY9deBrYcZnQ82eKU6AxhAu
CXSKECw0m9qhbEkeVkfwmI6VKneFDGBxC7KhFHriZk66YGtsjnfNXnjHDaJm45fG
vnsB7pftEcXr6+I4IbaYoRlsK70GLzi/iiMTfO/FZIwL7GIT2sFuO3FfRn3HPAhR
/+v9N8feOX6R0W6Y71ceSNu7jgfhU0lEsyeWs8PqUJma46q609UiLu22Mxzf5WHx
bOkZss08ExeEDoEMw3qogcnEf9w1mT9tzvIBAjpqH92+G3v9uUwXOWmqLhVDrkfp
01aufbhdcynKbaAaTkib7QoGVMSp+3Zt608gpySOAadzacvermrFRJTvVUpor6gM
USfe125uN+MQoRYWZqLzEJw+713XhGRxDlUjg8N48ziTo34hrEc=
=JyWz
-----END PGP SIGNATURE-----

--oYAXToTM8kn9Ra/9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
