From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-next] RDMA: Remove useless MODULE_VERSION
Date: Wed, 28 Jun 2017 12:11:22 +0000
Message-ID: <BN3PR07MB2578E61CC646F07E35186F66F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20170626055822.18946-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170626055822.18946-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For qedr changes:

Acked-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

=20
> diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qe=
dr/main.c
> index 6a72095d6c7a..6c5639caab20 100644
> --- a/drivers/infiniband/hw/qedr/main.c
> +++ b/drivers/infiniband/hw/qedr/main.c
> @@ -47,7 +47,6 @@
>  MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
>  MODULE_AUTHOR("QLogic Corporation");
>  MODULE_LICENSE("Dual BSD/GPL");
> -MODULE_VERSION(QEDR_MODULE_VERSION);
>=20
>  #define QEDR_WQ_MULTIPLIER_DFT	(3)
>=20
> diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qe=
dr/qedr.h
> index aa08c76a4245..0e95ffd6c14a 100644
> --- a/drivers/infiniband/hw/qedr/qedr.h
> +++ b/drivers/infiniband/hw/qedr/qedr.h
> @@ -41,7 +41,6 @@
>  #include <linux/qed/roce_common.h>
>  #include "qedr_hsi_rdma.h"
>=20
> -#define QEDR_MODULE_VERSION	"8.10.10.0"
>  #define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
>  #define DP_NAME(dev) ((dev)->ibdev.name)
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
