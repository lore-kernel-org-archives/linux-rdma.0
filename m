From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 05/15] IB/pvrdma: Add paravirtual rdma device
Date: Sun, 28 Aug 2016 16:06:57 +0300
Message-ID: <20160828130657.GM594@leon.nu>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-6-git-send-email-aditr@vmware.com>
 <20160825095920.GB14419@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="t5NgoZwlhlUmGr82"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160825095920.GB14419-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--t5NgoZwlhlUmGr82
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 25, 2016 at 12:59:21PM +0300, Yuval Shaia wrote:
> On Wed, Aug 03, 2016 at 04:27:34PM -0700, Adit Ranadive wrote:
> > This patch adds the main device-level structures and functions to be used
> > to provide RDMA functionality. Also, we define conversion functions from
> > the IB core stack structures to the device-specific ones.
> >
> > Changes v2->v3:
> >  - Removed VMware vendor id redefinition.
> >  - Removed the boolean in pvrdma_cmd_post.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma.h | 456 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 456 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma.h
> >
> > diff --git a/drivers/infiniband/hw/pvrdma/pvrdma.h b/drivers/infiniband/hw/pvrdma/pvrdma.h
> > new file mode 100644
> > index 0000000..8a45fcc
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/pvrdma/pvrdma.h
> > @@ -0,0 +1,456 @@
> > +/*
> > + * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of EITHER the GNU General Public License
> > + * version 2 as published by the Free Software Foundation or the BSD
> > + * 2-Clause License. This program is distributed in the hope that it
> > + * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
> > + * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
> > + * See the GNU General Public License version 2 for more details at
> > + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program available in the file COPYING in the main
> > + * directory of this source tree.
> > + *
> > + * The BSD 2-Clause License
> > + *
> > + *     Redistribution and use in source and binary forms, with or
> > + *     without modification, are permitted provided that the following
> > + *     conditions are met:
> > + *
> > + *      - Redistributions of source code must retain the above
> > + *        copyright notice, this list of conditions and the following
> > + *        disclaimer.
> > + *
> > + *      - Redistributions in binary form must reproduce the above
> > + *        copyright notice, this list of conditions and the following
> > + *        disclaimer in the documentation and/or other materials
> > + *        provided with the distribution.
> > + *
> > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> > + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> > + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> > + * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> > + * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
> > + * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> > + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> > + * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> > + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> > + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> > + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
> > + * OF THE POSSIBILITY OF SUCH DAMAGE.
> > + */
> > +
> > +#ifndef __PVRDMA_H__
> > +#define __PVRDMA_H__
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/list.h>
> > +#include <linux/mutex.h>
> > +#include <linux/pci.h>
> > +#include <linux/semaphore.h>
> > +#include <rdma/ib_umem.h>
> > +#include <rdma/ib_verbs.h>
> > +
> > +#include "pvrdma_defs.h"
> > +#include "pvrdma_dev_api.h"
> > +#include "pvrdma_verbs.h"
> > +
> > +/* NOT the same as BIT_MASK(). */
> > +#define PVRDMA_MASK(n) ((n << 1) - 1)
> > +
> > +/*
> > + * VMware PVRDMA PCI device id.
> > + */
> > +#define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
>
> I don't see a reason to define it locally in the driver.
> Suggesting to move it to include/linux/pci_ids.h

Interesting,
We already discussed it.

--t5NgoZwlhlUmGr82
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwuHxAAoJEORje4g2cline5UQAK+8o+O+cjCxOw3Z5p7LM/NV
LzFyQ8sxb3Y2jBrYMbgzKqFj1joZgKaSmCwCWjWT6iYutBQ5u+qjIvHApGmQG5cQ
feTEEDn244j34WNwzNr+kRxrWMKnwvdueR1SoQozIvCSBu9aHK5VMEyBV0f9bxlQ
16rvygvMBYatAkjLA/miSat067wEKXvPUaeebHXqGi/yLRJghM1lOHVY5CkR9Bf/
nIBc1q5QJvFw5k1gGYFAIf9PvKs5N0WHCrTir1Tjdx5OT33MmlCiURiO3RVU6K1x
NYDjq+jD/8buf6SnQxuLENhfM681xJhzJ5NvV4SUpK0/TzM7+7llHLbkmAGKV0mw
Ku51nrwoOVOBFLn/Wm9DJ6N9cIwGbugq7hIVp0c5Iuc8h99jrTKtposY0qDRsgEY
v8PxhnZRug0+N0YCxHkdFDmoMEqurtTLrXkLLkjRwDwkvDCDT4r2mcIe44ed1jka
spADrLoOG7y3UskOTCa4DK89b5X2dNZQhvzXIDEMPYxgpmlE0PHQGJJaBSx3Pfei
1aErLfighSb762CapTeTWu0GlKeguZOIj4dvLpZt2MJj25+JSX0mIxIe2NDH6AzB
CFapDs7lGpNN3FfdsZu5L7M65tyWIOJiVFF6GNtt7leYBDGiaJWcP/8PWZyYucmU
jRfiR06TsEKkXLmFR5tL
=XfeZ
-----END PGP SIGNATURE-----

--t5NgoZwlhlUmGr82--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
