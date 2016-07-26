From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/15] IB/pvrdma: Add paravirtual rdma device
Date: Tue, 26 Jul 2016 08:38:20 +0300
Message-ID: <20160726053820.GE20674@leon.nu>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-2-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3gPeeaTISh83WAP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468352205-9137-2-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--w3gPeeaTISh83WAP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 12:36:31PM -0700, Adit Ranadive wrote:
> This patch adds the main device-level structures and functions to be used
> to provide RDMA functionality. Also, we define conversion functions from
> the IB core stack structures to the device-specific ones.
>=20
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/pvrdma/pvrdma.h | 459 ++++++++++++++++++++++++++++=
++++++
>  1 file changed, 459 insertions(+)
>  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h
>=20
> diff --git a/drivers/infiniband/hw/pvrdma/pvrdma.h b/drivers/infiniband/h=
w/pvrdma/pvrdma.h
> new file mode 100644
> index 0000000..0dc5bd2
> --- /dev/null
> +++ b/drivers/infiniband/hw/pvrdma/pvrdma.h
> @@ -0,0 +1,459 @@
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
> +#ifndef __PVRDMA_H__
> +#define __PVRDMA_H__
> +
> +#include <linux/compiler.h>
> +#include <linux/interrupt.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <linux/semaphore.h>
> +#include <rdma/ib_umem.h>
> +#include <rdma/ib_verbs.h>
> +
> +#include "pvrdma_defs.h"
> +#include "pvrdma_dev_api.h"
> +#include "pvrdma_verbs.h"
> +
> +/* NOT the same as BIT_MASK(). */
> +#define PVRDMA_MASK(n) ((n << 1) - 1)
> +
> +/*
> + * VMware PVRDMA vendor id and PCI device id.
> + */
> +#ifndef PCI_VENDOR_ID_VMWARE
> +#define PCI_VENDOR_ID_VMWARE		0x15AD
> +#endif

Any special reason to do it?
You have this define in include/linux/pci_ids.h file.

> +#define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820

--w3gPeeaTISh83WAP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXlvdMAAoJEORje4g2clinFyYQALaDx3g9MAkV8SZhuZsAMoKa
LG1y3Hp7ZgN6fFJinruo8ubbCLvWUZT1JtBHQjijO4Tnwat7KIQjY4vF+5NBds5j
efj8IU9HVoda1/lIjDiWpjmURGBEuiYG1QngUD9vxuOwgmpPN6AxseQ6A4VVg9O6
YtsNmcH0LA3/gMT6BYOucmSFHRm5NjjQWccJruYnVjH6BhRQRVS/clQ9/4LLBJ+3
9XuPUCfdv0dmkWmBjIoPwawoD1fwsJyOkupMfmfJz8K55ZJ9YR+a07evQ1iTjd/Y
wXhPC40gYIkSNfvbcUB/MbrxzXfLs5DbRrdIWD2tdCYAzMK9X9FOvLNY5WE6Uya0
WnTm42w96EmXcJb7spxqzaoJxOA4OapXXxiQJcwzTWRYrZDWvoxUiXF32UvwoQq5
JhGy9MWlZfTQ1OP2+l77yG/Ea45bavbzZMWOGxCXfW+CTrQrzd1C+tlvMQwfqnx1
w+j01lsoKNiXg074X51j5qiR3xIwHTbIRyPAOa1lZHfoLNcLWCcv328Nm0Xy/DUK
HJdRy9j3ka0pWalKCDrJeXP3A8vDIrki7bKEV3X8sVosoHN3ATYk8pH8TrLygUBs
nocvksS6fxpo6DLtwolhRoBVbIoSBcKmrxj+ryzLp5CWRgTdRMflqSO6zywOjTuO
dnhtTodmvqUk+BV5peoS
=Crfj
-----END PGP SIGNATURE-----

--w3gPeeaTISh83WAP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
