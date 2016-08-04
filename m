From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 12/15] IB/pvrdma: Add the main driver module for PVRDMA
Date: Thu, 4 Aug 2016 09:53:52 +0300
Message-ID: <20160804065352.GJ27667@leon.nu>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-13-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vbzKE9fGfpHIBC6T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266864-16888-13-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vbzKE9fGfpHIBC6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 04:27:41PM -0700, Adit Ranadive wrote:
> This patch adds the support to register a RDMA device with the kernel RDMA
> stack as well as a kernel module. This also initializes the underlying
> virtual PCI device.
>=20
> Changes from v1: Addressed 32-bit build errors. Addressed comments by
> Yuval Shaia.
>=20
> Changes v2->v3:
>  - Removed boolean in pvrdma_cmd_post.

Please put changelog after  "---", we don't want to see them in git
history.

>=20
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/pvrdma/pvrdma_main.c | 1190 ++++++++++++++++++++++=
++++++
>  1 file changed, 1190 insertions(+)
>  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_main.c
>=20
> diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_main.c b/drivers/infinib=
and/hw/pvrdma/pvrdma_main.c
> new file mode 100644
> index 0000000..df94a8bf
> --- /dev/null
> +++ b/drivers/infiniband/hw/pvrdma/pvrdma_main.c
> @@ -0,0 +1,1190 @@
> +/*
> + * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of EITHER the GNU General Public License
> + * version 2 as published by the Free Software Foundation or the BSD
> + * 2-Clause License. This program is distributed in the hope that it
> + * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
> + * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License version 2 for more details at
> + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program available in the file COPYING in the main
> + * directory of this source tree.
> + *
> + * The BSD 2-Clause License
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> + * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> + * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
> + * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> + * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
> + * OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/inetdevice.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <rdma/ib_addr.h>
> +#include <rdma/ib_smi.h>
> +#include <rdma/ib_user_verbs.h>
> +#include <net/addrconf.h>
> +
> +#include "pvrdma.h"
> +#include "pvrdma_user.h"
> +
> +#define PCI_DEVICE_ID_VMWARE_VMXNET3	0x07B0

You have this define in drivers/net/vmxnet3/vmxnet3_int.h and it looks
strange to have same defines two different files.

Does it belong to include/linux/pci_ids.h file?=20

> +
> +#define DRV_NAME	"pvrdma"
> +#define DRV_VERSION	"1.0"
> +#define DRV_RELDATE	"January 1, 2013"
> +
> +static const char pvrdma_version[] =3D
> +	DRV_NAME ": PVRDMA InfiniBand driver v"
> +	DRV_VERSION " (" DRV_RELDATE ")\n";
> +
> +static DEFINE_MUTEX(pvrdma_device_list_lock);
> +static LIST_HEAD(pvrdma_device_list);
> +
> +static int pvrdma_add_gid(struct ib_device *ibdev,
> +			  u8 port_num,
> +			  unsigned int index,
> +			  const union ib_gid *gid,
> +			  const struct ib_gid_attr *attr,
> +			  void **context);
> +static int pvrdma_del_gid(struct ib_device *ibdev,
> +			  u8 port_num,
> +			  unsigned int index,
> +			  void **context);
> +
> +
> +static ssize_t show_hca(struct device *device, struct device_attribute *=
attr,
> +			char *buf)
> +{
> +	return sprintf(buf, "PVRDMA%s\n", DRV_VERSION);
> +}
> +
> +static ssize_t show_fw_ver(struct device *device,
> +			   struct device_attribute *attr, char *buf)

We have general show_fw_ver utility in core/sysfs.c,  Please use it.

> +{
> +	struct pvrdma_dev *dev =3D
> +		container_of(device, struct pvrdma_dev, ib_dev.dev);
> +
> +	return sprintf(buf, "%d.%d.%d\n",
> +		       (int)(dev->dsr->caps.fw_ver >> 32),
> +		       (int)(dev->dsr->caps.fw_ver >> 16) & 0xffff,
> +		       (int)dev->dsr->caps.fw_ver & 0xffff);
> +}
> +
> +static ssize_t show_rev(struct device *device, struct device_attribute *=
attr,
> +			char *buf)
> +{
> +	return sprintf(buf, "%d\n", PVRDMA_REV_ID);
> +}
> +
> +static ssize_t show_board(struct device *device, struct device_attribute=
 *attr,
> +			  char *buf)
> +{
> +	return sprintf(buf, "%d\n", PVRDMA_BOARD_ID);
> +}
> +
> +static DEVICE_ATTR(hw_rev,   S_IRUGO, show_rev,	   NULL);
> +static DEVICE_ATTR(fw_ver,   S_IRUGO, show_fw_ver, NULL);
> +static DEVICE_ATTR(hca_type, S_IRUGO, show_hca,	   NULL);
> +static DEVICE_ATTR(board_id, S_IRUGO, show_board,  NULL);
> +
> +static struct device_attribute *pvrdma_class_attributes[] =3D {
> +	&dev_attr_hw_rev,
> +	&dev_attr_fw_ver,
> +	&dev_attr_hca_type,
> +	&dev_attr_board_id
> +};
> +

--vbzKE9fGfpHIBC6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXouaAAAoJEORje4g2clinizMP/1gcputtJ88KvGhT8ZnFsKb3
fbWiK/HCuSPazytG/mLbaRBkbChQhsj43pb54c1gcQJiS9Sx9R3zBlSZZpI3zbO5
/ka1XEztQOvegykiBzFdPZy2MIGP6L8f8/f+0vVmXosEUGZ48+SONLm1S7fehdvt
wW1s5c0s4/nQQtx3uUu2eW8icjA0IuQd8dc2NLRLTiSkItQSai2fSA4D+os7qnOf
5h9Fff/19ICl6hOstf54fUnXQxfmBPZwHWPL2J38+FnqHeXbt8YWIBi60mMyepvQ
dhlBEncpYR0ij3Jpe77Y+hGp7TdbXa3I2zupes0+UDKKn+YKPqT4gJU3ganGNAND
9yWie+Z6NGcMArBWFmHrzZcQiLCwi9aK+qjms+MOhHpmYLLxbnYaDyptu6EOhjVT
kY/JDe2sDp/R7+/ixu9/EmqbOng78kNG82kdwftnvkPQXxSkgYH84WSHC7Ub8TXi
DfKRgga8yrqhvuqw3DVZOmvjesjMUIX4c1vC0/gRGEW1G8t/208+PvM8E5m2YA+d
gu373Ryorlt3QAIrTGNK+oY+keHmvKGNrFY2e0jnPMvHoARgOzAU1QF9Sbz0LDmO
wUvboeBFKllQF/b+1kjCCXQ5FqI9Dxlk2SVKhKAfjoLEW7nfDaE6RSf2ta+JsaXh
Rq36abyWXqMjGcaQXGcp
=kJux
-----END PGP SIGNATURE-----

--vbzKE9fGfpHIBC6T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
