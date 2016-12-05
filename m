From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/28] bnxt_re: Add bnxt_re RoCE driver files
Date: Mon, 5 Dec 2016 10:16:14 -0500
Message-ID: <09068db2-1a14-9fbb-074b-4cf000fbddfb@redhat.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <1480919912-1079-9-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dAPQRC2cq2TFFSBL47SgIipHpOB5XcutF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480919912-1079-9-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dAPQRC2cq2TFFSBL47SgIipHpOB5XcutF
Content-Type: multipart/mixed; boundary="i3JherPnV9TtEGhsUGF4f3ukVQbPqQKXs";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
 Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
 Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
 Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Message-ID: <09068db2-1a14-9fbb-074b-4cf000fbddfb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/28] bnxt_re: Add bnxt_re RoCE driver files
References: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 <1480919912-1079-9-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1480919912-1079-9-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

--i3JherPnV9TtEGhsUGF4f3ukVQbPqQKXs
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/5/2016 1:38 AM, Selvin Xavier wrote:

> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index fb3fb89..a4fab22 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -91,4 +91,6 @@ source "drivers/infiniband/hw/hfi1/Kconfig"
> =20
>  source "drivers/infiniband/hw/qedr/Kconfig"
> =20
> +source "drivers/infiniband/hw/bnxtre/Kconfig"
> +
>  endif # INFINIBAND
> diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Mak=
efile
> index e7a5ed9..7227b36 100644
> --- a/drivers/infiniband/hw/Makefile
> +++ b/drivers/infiniband/hw/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_INFINIBAND_USNIC)		+=3D usnic/
>  obj-$(CONFIG_INFINIBAND_HFI1)		+=3D hfi1/
>  obj-$(CONFIG_INFINIBAND_HNS)		+=3D hns/
>  obj-$(CONFIG_INFINIBAND_QEDR)		+=3D qedr/
> +obj-$(CONFIG_INFINIBAND_BNXTRE)		+=3D bnxtre/
> diff --git a/drivers/infiniband/hw/bnxtre/Kconfig b/drivers/infiniband/=
hw/bnxtre/Kconfig
> new file mode 100644
> index 0000000..2637544
> --- /dev/null
> +++ b/drivers/infiniband/hw/bnxtre/Kconfig
> @@ -0,0 +1,9 @@
> +config INFINIBAND_BNXTRE
> +    tristate "Broadcom Netxtreme HCA support"
> +    depends on ETHERNET && NETDEVICES && PCI && INET
> +    select NET_VENDOR_BROADCOM
> +    select BNXT
> +    ---help---
> +	  This driver supports Broadcom NetXtreme-C/E 10/25/40/50 gigabit
> +	  RoCE HCAs.  To compile this driver as a module, choose M here:
> +	  the module will be called bnxt_re.
> diff --git a/drivers/infiniband/hw/bnxtre/Makefile b/drivers/infiniband=
/hw/bnxtre/Makefile
> new file mode 100644
> index 0000000..0521489
> --- /dev/null
> +++ b/drivers/infiniband/hw/bnxtre/Makefile
> @@ -0,0 +1,5 @@
> +
> +obj-$(CONFIG_INFINIBAND_BNXTRE) +=3D bnxt_re.o
> +bnxt_re-y :=3D bnxt_re_main.o bnxt_re_ib_verbs.o \
> +	     bnxt_qplib_res.o bnxt_qplib_rcfw.o	\
> +	     bnxt_qplib_sp.o bnxt_qplib_fp.o

A lot of times I prefer these files to be the final patch in the series.
 It's completely not possible to break bisectability if these are last.
Then again, if I squash this down to one commit it doesn't really matter.=
=2E..

> diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.c b/drivers/inf=
iniband/hw/bnxtre/bnxt_qplib_fp.c
> new file mode 100644
> index 0000000..34873f4
> --- /dev/null
> +++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.c
> @@ -0,0 +1,12 @@
> +/* Broadcom NetXtreme-C/E RoCE driver.
> + *
> + * Copyright (c) 2016 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation.
> + */

This copyright, repeated many times in the various skeleton files...

> diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c b/drivers/infi=
niband/hw/bnxtre/bnxt_re_main.c
> new file mode 100644
> index 0000000..4c377dc
> --- /dev/null
> +++ b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
> @@ -0,0 +1,96 @@
> +/* Broadcom NetXtreme-C/E RoCE driver.
> + *
> + * Copyright (c) 2016 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation.
> + */
> +
> +/*
> + * Description: Main component of the bnxt_re driver
> + */
> +
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/rculist.h>
> +#include "bnxt_re.h"
> +static char version[] =3D
> +		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
> +
> +
> +MODULE_AUTHOR("Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>");
> +MODULE_DESCRIPTION(BNXT_RE_DESC " Driver");
> +MODULE_LICENSE("Dual BSD/GPL");

and this module license description do not agree.  Please make
everything consistent.  I don't care if it's GPLv2 or Dual licensed, it
simply needs to be consistent.




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--i3JherPnV9TtEGhsUGF4f3ukVQbPqQKXs--

--dAPQRC2cq2TFFSBL47SgIipHpOB5XcutF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYRYTFAAoJELgmozMOVy/d+gwP/3MdGd+1iykhyoIIzWMF39w6
uzDevBuPXwcrS17a8aNnapOdid61jG07sydL9ZawLkMnJwl+VTsNdFp+jMvo1m86
HTdm2HMsPyUnT3CEMH7blXSiJZSc9ZM4VLo60JFVkB1wva/xjwBDjlg4b8HvoHfb
k9u4ZNkOr9j9QN5Est4qB5bVwWVw0CCEr5s05ZJ6iEv7x6b+GkovsM5opdlFx0N5
GErTQ6Th76t/zdBDWkZJaY1Gej2B9D8X/wSuf2aIGTwyu23E/4z9Sh3uwSitdRxn
vq3gjVu0PkfHJ6z7WIov707zqNFrx1UOy59g6JpFBv8uN3OJLuliZkUMixMIq7UK
yE6oVVR6Xe0Wd8IIu9EL82kN4V2jLg3DmPIBBlDqtzTyiojvC2g6OR8queP2Xn2e
BXgQwgRmmBP0o/jUy+XSYyntlYmi/BPEf+O82wWkJEGWA0oxEtpyyL5j09wxkCfS
PGmftZzeGzQrLoZ4TafaXQJlKzDsSODgt8Tu1YpcBCkSBB5PZH/zdxV80AF6KCMD
Qaj6DyZgQvwKoWZtPJr1mzUu3c8H+5BoFf+Mlbp2O883+MfcuxEg6yKj9w1xQmxv
0sZapSbZOzehHihbzHd5zUR8Oi1edlqQqRYoer8mimRTHmy+T3AXLsTkCG8WKLJx
tm3ZcziTxVhliwG2b0bk
=Fcw3
-----END PGP SIGNATURE-----

--dAPQRC2cq2TFFSBL47SgIipHpOB5XcutF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
