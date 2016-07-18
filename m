From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/15] IB/pvrdma: Add UAR support
Date: Mon, 18 Jul 2016 16:25:45 +0300
Message-ID: <20160718132545.GD20674@leon.nu>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-6-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468352205-9137-6-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 12:36:35PM -0700, Adit Ranadive wrote:
> This patch adds the UAR support for the paravirtual RDMA device. The UAR
> pages are MMIO pages from the virtual PCI space. We define offsets within
> this page to provide the fast data-path operations.
>=20
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c | 128 +++++++++++++++++++=
++++++
>  1 file changed, 128 insertions(+)
>  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
>=20
> diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c b/drivers/inf=
iniband/hw/pvrdma/pvrdma_doorbell.c
> new file mode 100644
> index 0000000..d854f6d
> --- /dev/null
> +++ b/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
> @@ -0,0 +1,128 @@
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
> +#include <linux/bitmap.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +
> +#include "pvrdma.h"
> +
> +int pvrdma_uar_table_init(struct pvrdma_dev *dev)
> +{
> +	u32 num =3D dev->dsr->caps.max_uar;
> +	u32 mask =3D num - 1;
> +	struct pvrdma_id_table *tbl =3D &dev->uar_table.tbl;
> +
> +	/* Power of 2 */
> +	if (num !=3D 1 << (ffs(num) - 1))
> +		return -EINVAL;

Can functions/macros defined in include/linux/log2.h replace the code
above?

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXjNjZAAoJEORje4g2clinCTAP/Rxe0zS6BqtPe7/oz9gHeTqW
l3Vq2Q5/NVPsJRyCjvWg1OE5wXHsm8ZLauEPnHH1xq4R0ltR78F8100i3kCJbTYa
xPfcEVmyrZ6gjRdknQiqwZZA7JQuU5Les88ctx5gJIKnCmLLnuOks+ItKEX6lzIf
c5w0+dM85A4phRKP0hklwsIfOQF0iKT7aZBwQtUQvL+q8G9cDgWcSrrm7xi2TlQ+
KaTTOsqeOelc8DBWVAkXTrC0/nR8aJrfz1BgUpmWS8er0RhNjkCgJ9wh0gQUff+6
ZKUv7Cfx2ZXiVCReLuCkUcZ2M0R3o5Z4jiApOngY9SGUY7ZuYC0HVuGKm110tADL
UNVnspvI2/5CVBjZibpUL+9pRXDOkvjAdm4lxv3Qo37r6pD1xDD8izan0AFDZ17K
IKzdHCyOuqgy31gYGFVtkdaxbEWxpSGRfBF7Ia3e8X8PGFFxx9UMDCp4n2VSLOoO
/Oi3JNVLrtnyk2B3uKXaqOHYic5Sj3qHTpCWg2FaOrzqE344f/qMnioIwe/10Qo7
6yK5mnCefN4od8TdM+M89P5m1840gIE4Y6iHfaGNK6bR7zlQsqM4U67XZCLxUr7X
hpTeiTMTW4jUg78JYOAlFAxYKuQdT8Ao7HMpUzKdcAOvF369+IrwdiyYjC/d+Z56
13/PO75x+doNpAM925cT
=hXlZ
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
