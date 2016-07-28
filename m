From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/15] IB/pvrdma: Add the paravirtual RDMA device
 specification
Date: Thu, 28 Jul 2016 13:17:55 -0700
Message-ID: <20160728131755.35f6d42a@adits-macbook-pro.local>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
	<1468352205-9137-5-git-send-email-aditr@vmware.com>
	<20160721084508.GA8661@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721084508.GA8661-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 21 Jul 2016 11:45:09 +0300
Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Two minor comments.
> Besides that - Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> Yuval
> 
> On Tue, Jul 12, 2016 at 12:36:34PM -0700, Adit Ranadive wrote:
> > This patch describes the main specification of the underlying virtual RDMA
> > device. The pvrdma_dev_api header file defines the Verbs commands and
> > their parameters that can be issued to the device backend.
> > 
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_defs.h    | 300 ++++++++++++++++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h | 342
> > ++++++++++++++++++++++++++ 2 files changed, 642 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_defs.h
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_dev_api.h
> > 
> > diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_defs.h
> > b/drivers/infiniband/hw/pvrdma/pvrdma_defs.h new file mode 100644
> > index 0000000..225cba4
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/pvrdma/pvrdma_defs.h
> > @@ -0,0 +1,300 @@
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
> > https://urldefense.proofpoint.com/v2/url?u=http-3A__www.gnu.org_licenses_old-2Dlicenses_gpl-2D2.0.en.html&d=CwIBAg&c=Sqcl0Ez6M0X8aeM67LKIiDJAXVeAw-YihVMNtXt-uEs&r=uGpVYdpWLb65FRYUmM4EfQ&m=czr8sWJhFSFR3J4meRKD6XraZLGcdnFbdCzUt9taPoM&s=w9TucKdjv27QS7PpvjqjVfU9uV35OBXlSCMXLdq9nQQ&e= .
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
> > +#ifndef __PVRDMA_DEFS_H__
> > +#define __PVRDMA_DEFS_H__
> > +
> > +#include <linux/types.h>
> > +#include "pvrdma_ib_verbs.h"
> > +#include "pvrdma_uapi.h"
> > +
> > +/*
> > + * Masks and accessors for page directory, which is a two-level lookup:
> > + * page directory -> page table -> page. Only one directory for now, but we
> > + * could expand that easily. 9 bits for tables, 9 bits for pages, gives one
> > + * gigabyte for memory regions and so forth.
> > + */
> > +
> > +#define PVRDMA_PAGE_DIR_DIR(x)		(((x) >> 18) & 0x1)
> > +#define PVRDMA_PAGE_DIR_TABLE(x)	(((x) >> 9) & 0x1ff)  
> 
> Suggesting to add #define for the above 9 and 18, ex PVRDMA_PAGE_DIR_SHIFT
> or something like that.
> 

Will add this in v3.

> > +#define PVRDMA_PAGE_DIR_PAGE(x)		((x) & 0x1ff)
> > +#define PVRDMA_PAGE_DIR_MAX_PAGES	(1 * 512 * 512)
> > +#define PVRDMA_MAX_FAST_REG_PAGES	128
> > +
> > +/*
> > + * Max MSI-X vectors.
> > + */
> > +
> > +#define PVRDMA_MAX_INTERRUPTS	3
> > +
> > +/* Register offsets within PCI resource on BAR1. */
> > +#define PVRDMA_REG_VERSION	0x00	/* R: Version of device. */
> > +#define PVRDMA_REG_DSRLOW	0x04	/* W: Device shared region
> > low PA. */ +#define PVRDMA_REG_DSRHIGH	0x08	/* W: Device
> > shared region high PA. */ +#define PVRDMA_REG_CTL
> > 0x0c	/* W: PVRDMA_DEVICE_CTL */ +#define PVRDMA_REG_REQUEST
> > 0x10	/* W: Indicate device request. */ +#define
> > PVRDMA_REG_ERR		0x14	/* R: Device error. */ +#define
> > PVRDMA_REG_ICR		0x18	/* R: Interrupt cause. */
> > +#define PVRDMA_REG_IMR		0x1c	/* R/W: Interrupt mask.
> > */ +#define PVRDMA_REG_MACL		0x20	/* R/W: MAC address
> > low. */ +#define PVRDMA_REG_MACH		0x24	/* R/W: MAC
> > address high. */ + +/* Object flags. */
> > +#define PVRDMA_CQ_FLAG_ARMED_SOL	BIT(0)	/* Armed for
> > solicited-only. */ +#define PVRDMA_CQ_FLAG_ARMED
> > BIT(1)	/* Armed. */ +#define PVRDMA_MR_FLAG_DMA
> > BIT(0)	/* DMA region. */ +#define PVRDMA_MR_FLAG_FRMR
> > BIT(1)	/* Fast reg memory region. */ +
> > +/*
> > + * Atomic operation capability (masked versions are extended atomic
> > + * operations.
> > + */
> > +
> > +#define PVRDMA_ATOMIC_OP_COMP_SWAP	BIT(0) /* Compare and swap. */
> > +#define PVRDMA_ATOMIC_OP_FETCH_ADD	BIT(1) /* Fetch and add. */
> > +#define PVRDMA_ATOMIC_OP_MASK_COMP_SWAP	BIT(2) /* Masked compare
> > and swap. */ +#define PVRDMA_ATOMIC_OP_MASK_FETCH_ADD	BIT(3) /*
> > Masked fetch and add. */ +
> > +/*
> > + * Base Memory Management Extension flags to support Fast Reg Memory
> > Regions
> > + * and Fast Reg Work Requests. Each flag represents a verb operation and we
> > + * must support all of them to qualify for the BMME device cap.
> > + */
> > +
> > +#define PVRDMA_BMME_FLAG_LOCAL_INV	BIT(0) /* Local Invalidate. */
> > +#define PVRDMA_BMME_FLAG_REMOTE_INV	BIT(1) /* Remote Invalidate. */
> > +#define PVRDMA_BMME_FLAG_FAST_REG_WR	BIT(2) /* Fast Reg Work
> > Request. */ +
> > +/*
> > + * GID types. The interpretation of the gid_types bit field in the device
> > + * capabilities will depend on the device mode. For now, the device only
> > + * supports RoCE as mode, so only the different GID types for RoCE are
> > + * defined.
> > + */
> > +
> > +#define PVRDMA_GID_TYPE_FLAG_ROCE_V1 BIT(0)
> > +#define PVRDMA_GID_TYPE_FLAG_ROCE_V2 BIT(1)
> > +
> > +enum pvrdma_pci_resource {
> > +	PVRDMA_PCI_RESOURCE_MSIX = 0,	/* BAR0: MSI-X, MMIO. */
> > +	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
> > +	PVRDMA_PCI_RESOURCE_UAR,	/* BAR2: UAR pages, MMIO, 64-bit.
> > */
> > +	PVRDMA_PCI_RESOURCE_LAST,	/* Last. */
> > +};
> > +
> > +enum pvrdma_device_ctl {
> > +	PVRDMA_DEVICE_CTL_ACTIVATE = 0,	/* Activate device. */
> > +	PVRDMA_DEVICE_CTL_QUIESCE,	/* Quiesce device. */
> > +	PVRDMA_DEVICE_CTL_RESET,	/* Reset device. */
> > +};
> > +
> > +enum pvrdma_intr_vector {
> > +	PVRDMA_INTR_VECTOR_RESPONSE	= 0,	/* Command
> > response. */
> > +	PVRDMA_INTR_VECTOR_ASYNC	= 1,	/* Async events. */
> > +	PVRDMA_INTR_VECTOR_CQ		= 2,	/* CQ
> > notification. */
> > +	/* Additional CQ notification vectors. */
> > +};
> > +
> > +enum pvrdma_intr_cause {
> > +	PVRDMA_INTR_CAUSE_RESPONSE	= (1 <<
> > PVRDMA_INTR_VECTOR_RESPONSE),
> > +	PVRDMA_INTR_CAUSE_ASYNC		= (1 <<
> > PVRDMA_INTR_VECTOR_ASYNC),
> > +	PVRDMA_INTR_CAUSE_CQ		= (1 << PVRDMA_INTR_VECTOR_CQ),
> > +};
> > +
> > +enum pvrdma_intr_type {
> > +	PVRDMA_INTR_TYPE_INTX = 0,	/* Legacy. */
> > +	PVRDMA_INTR_TYPE_MSI,		/* MSI. */
> > +	PVRDMA_INTR_TYPE_MSIX,		/* MSI-X. */
> > +};
> > +
> > +enum pvrdma_gos_bits {
> > +	PVRDMA_GOS_BITS_UNK = 0,	/* Unknown. */
> > +	PVRDMA_GOS_BITS_32,		/* 32-bit. */
> > +	PVRDMA_GOS_BITS_64,		/* 64-bit. */
> > +};
> > +
> > +enum pvrdma_gos_type {
> > +	PVRDMA_GOS_TYPE_UNK = 0,	/* Unknown. */
> > +	PVRDMA_GOS_TYPE_LINUX,		/* Linux. */
> > +};
> > +
> > +enum pvrdma_device_mode {
> > +	PVRDMA_DEVICE_MODE_ROCE = 0,	/* RoCE. */
> > +	PVRDMA_DEVICE_MODE_IWARP,	/* iWarp. */
> > +	PVRDMA_DEVICE_MODE_IB		/* InfiniBand. */
> > +};
> > +
> > +struct pvrdma_gos_info {
> > +	__u32 gos_bits:2;	/* W: PVRDMA_GOS_BITS_ */
> > +	__u32 gos_type:4;	/* W: PVRDMA_GOS_TYPE_ */
> > +	__u32 gos_ver:16;	/* W: Guest OS version. */
> > +	__u32 gos_misc:10;	/* W: Other. */
> > +	__u32 pad;		/*    Pad to 8-byte alignment. */  
> 
> Strip the spaces in comment.
> 

Ok. Did it here and other places below.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
