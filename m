From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 02/15] IB/pvrdma: Add virtual device RDMA structures
Date: Tue, 23 Aug 2016 17:46:27 +0000
Message-ID: <BLUPR0501MB836ACEAF51DF69E5623EBF5C5EB0@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-3-git-send-email-aditr@vmware.com>
 <20160821115441.GB22012@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160821115441.GB22012-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 21, 2016 at 04:55:20 -0700, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org=
> wrote:
> On Wed, Aug 03, 2016 at 04:27:31PM -0700, Adit Ranadive wrote:
> > This patch adds the various Verbs structures that we support in the
> > virtual RDMA device. We have re-mapped the ones from the RDMA core stac=
k
> > to make sure we can maintain compatibility with our backend.
> >
> > Changes v2->v3:
> >  - Added , to end of enums missing them.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h | 450 +++++++++++++++++=
++++++++
> >  1 file changed, 450 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h
> >
> > diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h b/drivers/i=
nfiniband/hw/pvrdma/pvrdma_ib_verbs.h
> > new file mode 100644
> > index 0000000..4bef8b4
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/pvrdma/pvrdma_ib_verbs.h
> > @@ -0,0 +1,450 @@
> > +/*
> > + * [PLEASE NOTE:  VMWARE, INC. ELECTS TO USE AND DISTRIBUTE THIS COMPO=
NENT
> > + * UNDER THE TERMS OF THE OpenIB.org BSD license.  THE ORIGINAL LICENS=
E TERMS
> > + * ARE REPRODUCED BELOW ONLY AS A REFERENCE.]
> > + *
> > + * Copyright (c) 2004 Mellanox Technologies Ltd.  All rights reserved.
> > + * Copyright (c) 2004 Infinicon Corporation.  All rights reserved.
> > + * Copyright (c) 2004 Intel Corporation.  All rights reserved.
> > + * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
> > + * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
> > + * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
> > + * Copyright (c) 2005, 2006, 2007 Cisco Systems.  All rights reserved.
> > + * Copyright (c) 2015-2016 VMware, Inc.  All rights reserved.
> > + *
> > + * This software is available to you under a choice of one of two
> > + * licenses.  You may choose to be licensed under the terms of the GNU
> > + * General Public License (GPL) Version 2, available from the file
> > + * COPYING in the main directory of this source tree, or the
> > + * OpenIB.org BSD license below:
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
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> > + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> > + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> > + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> > + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> > + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> > + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + */
> > +
> > +#ifndef __PVRDMA_IB_VERBS_H__
> > +#define __PVRDMA_IB_VERBS_H__
> > +
> > +#include <linux/types.h>
> > +
> > +union pvrdma_gid {
> > +	__u8	raw[16];
> > +	struct {
> > +		__be64	subnet_prefix;
> > +		__be64	interface_id;
> > +	} global;
> > +};
>=20
> Any reason why not to use ib_gid?
> Suggesting to utilize definitions from rdma/ib_verbs.h as much as you can=
.

Thanks for taking a look at this! The main reason we don't re-use the IB st=
ructures here is for
compatibility reasons. We re-use these PVRDMA defined structures in our vir=
tual device too so
we want to be consistent between the driver and the device itself. Thus, we=
 can protect the
virtual device from any non-compatible changes in the IB structs.
Hope that clarifies the issue!

- Adit=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
