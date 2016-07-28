From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 05/15] IB/pvrdma: Add UAR support
Date: Thu, 28 Jul 2016 13:13:36 -0700
Message-ID: <20160728131336.30907f0b@adits-macbook-pro.local>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
	<1468352205-9137-6-git-send-email-aditr@vmware.com>
	<20160727140611.GC3549@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727140611.GC3549-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 27 Jul 2016 17:06:12 +0300
Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Jul 12, 2016 at 12:36:35PM -0700, Adit Ranadive wrote:
> > This patch adds the UAR support for the paravirtual RDMA device. The UAR
> > pages are MMIO pages from the virtual PCI space. We define offsets within
> > this page to provide the fast data-path operations.
> > 
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c | 128
> > +++++++++++++++++++++++++ 1 file changed, 128 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
> > 
> > diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
> > b/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c new file mode 100644
> > index 0000000..d854f6d
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/pvrdma/pvrdma_doorbell.c
> > @@ -0,0 +1,128 @@
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
> > + *
> > https://urldefense.proofpoint.com/v2/url?u=http-3A__www.gnu.org_licenses_old-2Dlicenses_gpl-2D2.0.en.html&d=CwIBAg&c=Sqcl0Ez6M0X8aeM67LKIiDJAXVeAw-YihVMNtXt-uEs&r=uGpVYdpWLb65FRYUmM4EfQ&m=tNZWuWp3kE1s-gan-hE-5OXvDfvRDs9-8F-8KAmtUuA&s=sMzAhVyP3X8sxMREMqDO2OCcL6iGgSPFW_cbNPeGKUA&e= .
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
> > +#include <linux/bitmap.h>
> > +#include <linux/errno.h>
> > +#include <linux/slab.h>
> > +
> > +#include "pvrdma.h"
> > +
> > +int pvrdma_uar_table_init(struct pvrdma_dev *dev)
> > +{
> > +	u32 num = dev->dsr->caps.max_uar;
> > +	u32 mask = num - 1;
> > +	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
> > +
> > +	/* Power of 2 */
> > +	if (num != 1 << (ffs(num) - 1))
> > +		return -EINVAL;
> > +
> > +	tbl->last = 0;
> > +	tbl->top = 0;
> > +	tbl->max = num;
> > +	tbl->mask = mask;
> > +	spin_lock_init(&tbl->lock);
> > +	tbl->table = kcalloc(BITS_TO_LONGS(num), sizeof(long), GFP_KERNEL);
> > +	if (!tbl->table)
> > +		return -ENOMEM;
> > +
> > +	/* 0th UAR is taken by the device. */
> > +	set_bit(0, tbl->table);
> > +
> > +	return 0;
> > +}
> > +
> > +void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev)
> > +{
> > +	struct pvrdma_id_table *tbl = &dev->uar_table.tbl;
> > +
> > +	kfree(tbl->table);
> > +}
> > +
> > +int pvrdma_uar_alloc(struct pvrdma_dev *dev, struct pvrdma_uar_map *uar)
> > +{
> > +	struct pvrdma_id_table *tbl;
> > +	unsigned long flags;
> > +	u32 obj;
> > +
> > +	tbl = &dev->uar_table.tbl;
> > +
> > +	spin_lock_irqsave(&tbl->lock, flags);
> > +	obj = find_next_zero_bit(tbl->table, tbl->max, tbl->last);
> > +	if (obj >= tbl->max) {
> > +		tbl->top = (tbl->top + tbl->max) & tbl->mask;
> > +		obj = find_first_zero_bit(tbl->table, tbl->max);
> > +	}
> > +
> > +	if (obj < tbl->max) {
> > +		set_bit(obj, tbl->table);
> > +		obj |= tbl->top;
> > +	} else {
> > +		spin_unlock_irqrestore(&tbl->lock, flags);
> > +		return -ENOMEM;
> > +	}  
> 
> Please consider restructuring the above block to something like this:
> 	if (obj >= tbl->max) {
> 		spin_unlock_irqrestore(&tbl->lock, flags);
> 		return -ENOMEM;
> 	}
> 
> 	set_bit(obj, tbl->table);
> 	obj |= tbl->top;
> 

Done. Will add this in v3.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
