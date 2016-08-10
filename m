From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 09/15] IB/pvrdma: Add UAR support
Date: Wed, 10 Aug 2016 06:54:39 +0300
Message-ID: <20160810035439.GF23921@leon.nu>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-10-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XIiC+We3v3zHqZ6Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266864-16888-10-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--XIiC+We3v3zHqZ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 04:27:38PM -0700, Adit Ranadive wrote:
> This patch adds the UAR support for the paravirtual RDMA device. The UAR
> pages are MMIO pages from the virtual PCI space. We define offsets within
> this page to provide the fast data-path operations.
>=20
> Changes v2->v3:
>  - Used is_power_of_2 function.
>  - Simplify pvrdma_uar_alloc function.
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
> index 0000000..c8c6c57
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
> +	if (!is_power_of_2(num))

This comment doesn't add any additional knowledge and can be removed.

> +		return -EINVAL;
> +

--XIiC+We3v3zHqZ6Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqqV/AAoJEORje4g2clinRNkP+wX1tRqjwboU8YYAc4tLtONt
7sanqb9edeRvXEhH/W3Ww/GwX8/6Bdjb7tSWVjs9+mmscgxxm1aliWHqnnHcRuk/
GaMVkjs4ospvma/POGqBFEZVWMthylAhedEfjWRGRrzcs932OrC2hfBWnWJPsssK
/e0BYdTnGeLQs5sP5iQ6Or5ahJxRqxHwazVvd+HWLRPYfLDx9IMN25waa6EwOXos
TA0AcUcNBPzfndm402sabAPoNjOG2Viq1iT2Hc1LhOBL5FXhA+SstOfnjQ3Jv7mb
A8isRBgOiHQ0tuqyaFiCeT65f4efQma4rKlbJM9Wrb6tXVe9ZSm6fI86srpFGI4S
fwxEILPaL2Fy1objzzVuKPWD1K5mA5X23UyTAhdYLIJrX+KlYJoSO5kfpaT9k0vZ
Hwbm1Xg3Yh8lKKB7l98hthvB8D+OStAmNglmgsqeVFIh/RuR14NNGWMWvp9OdJD2
PF7YBJoCk80wDxi4R9rEqWJGc3lmrWH4p+SCkIrmV0R4ugP0siJBLetE6sIXZ3Ur
lIgygjI4UUQ/CUEOZ3JGe7kdBwIy39RSiHT+AHiZohRqdDv2BV8ivoZJlqi4fngI
x6dngjmx8nDHRKWDDcy71Jd/xg7tmEBIC5w21ttruVSeL6Y5SiyXs1PfHVSjENEo
b2iGJIuKraJmjDdQaZP3
=kjW/
-----END PGP SIGNATURE-----

--XIiC+We3v3zHqZ6Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
