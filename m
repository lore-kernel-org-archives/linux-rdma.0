From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/3] RDMA/vmw_pvrdma: Update device query
 parameters
Date: Sun, 20 Aug 2017 23:56:26 -0700
Message-ID: <32182246-e301-4529-c63a-20e616bb6f2a@vmware.com>
References: <cover.1503073950.git.aditr@vmware.com>
 <6eb31ebec69c1d28b83cb44e84cdb01ebdec3827.1503073950.git.aditr@vmware.com>
 <20170820061122.GD18138@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170820061122.GD18138-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat Aug 19 2017 23:11:22 GMT-0700 (PDT), Leon Romanovsky wrote:
> On Fri, Aug 18, 2017 at 09:44:48AM -0700, Adit Ranadive wrote:
> > Added support for two device caps - max_sge_rd, max_fast_reg_page_list_len.
> > Simplified some of the RoCEv2 versioning code and added 2 more device cap
> > flags.
> >
> > Acked-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  1 +
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 19 ++++++++++---------
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    |  7 +++----
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |  9 +++++++++
> >  4 files changed, 23 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> > index 513a182..ea10155 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> > @@ -194,6 +194,7 @@ struct pvrdma_dev {
> >  	void *resp_slot;
> >  	unsigned long flags;
> >  	struct list_head device_link;
> > +	unsigned int dsr_version;
> >
> >  	/* Locking and interrupt information. */
> >  	spinlock_t cmd_lock; /* Command lock. */
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > index 71df5d1..d947557 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > @@ -50,7 +50,15 @@
> >
> >  #include "pvrdma_verbs.h"
> >
> > -#define PVRDMA_VERSION			18
> > +/*
> > + * PVRDMA version macros. Some new features require updates to PVRDMA_VERSION.
> > + * These macros allow us to check for different features if necessary.
> > + */
> > +
> > +#define PVRDMA_ROCEV1_VERSION		17
> > +#define PVRDMA_ROCEV2_VERSION		18
> > +#define PVRDMA_VERSION			PVRDMA_ROCEV2_VERSION
> > +
> >  #define PVRDMA_BOARD_ID			1
> >  #define PVRDMA_REV_ID			1
> >
> > @@ -123,13 +131,6 @@
> >  #define PVRDMA_GID_TYPE_FLAG_ROCE_V1	BIT(0)
> >  #define PVRDMA_GID_TYPE_FLAG_ROCE_V2	BIT(1)
> >
> > -/*
> > - * PVRDMA version macros. Some new features require updates to PVRDMA_VERSION.
> > - * These macros allow us to check for different features if necessary.
> > - */
> > -
> > -#define PVRDMA_VERSION_ROCEV2_SUPPORT	18
> > -
>  
>  You added it in previous patch of the same series. Please don't send
>  patches with code which is going to be removed/rewritten immediately.

The previous patch was posted a while back internally. I had to do some cleanup
(second patch) before sending it out. I'll send out a v1 with this merged into
the first patch.

>  
> >  enum pvrdma_pci_resource {
> >  	PVRDMA_PCI_RESOURCE_MSIX,	/* BAR0: MSI-X, MMIO. */
> >  	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
> > @@ -232,7 +233,7 @@ struct pvrdma_device_caps {
> >  	u8  atomic_ops;				/* PVRDMA_ATOMIC_OP_* bits */
> >  	u8  bmme_flags;				/* FRWR Mem Mgmt Extensions */
> >  	u8  gid_types;				/* PVRDMA_GID_TYPE_FLAG_ */
> > -	u8  reserved[4];
> > +	u32 max_fast_reg_page_list_len;
> >  };
> >
> >  struct pvrdma_ring_page_info {
> > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> > index 6fd5828..ae536a4 100644
> > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> > @@ -729,7 +729,6 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
> >  	int ret;
> >  	unsigned long start;
> >  	unsigned long len;
> > -	unsigned int version;
> >  	dma_addr_t slot_dma = 0;
> >
> >  	dev_dbg(&pdev->dev, "initializing driver %s\n", pci_name(pdev));
> > @@ -826,9 +825,9 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
> >  		goto err_unmap_regs;
> >  	}
> >
> > -	version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
> > +	dev->dsr_version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
> >  	dev_info(&pdev->dev, "device version %d, driver version %d\n",
> > -		 version, PVRDMA_VERSION);
> > +		 dev->dsr_version, PVRDMA_VERSION);
> >
> >  	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
> >  				      &dev->dsrbase, GFP_KERNEL);
> > @@ -908,7 +907,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
> >  	}
> >
> >  	/* PVRDMA supports RoCE V1 or V2. */
> > -	if (version >= PVRDMA_VERSION_ROCEV2_SUPPORT &&
> > +	if (dev->dsr_version >= PVRDMA_ROCEV2_VERSION &&
>  
>  Your whole idea of version is shaky. You need to move to capability bits per
>  feature model and not rely on global version. In the near future, your code will
>  be full of checks like this.

Why does the type of check matter? We would have to do a check anyway if there
were capability bits exposed. In our case the global version is essentially the
feature model for the device given that it isn't as feature rich as some of the
other RDMA providers so doing a blanket check on the version seems the simplest
way to go. I think the check here for the version is redundant anyways and can
remove that in v1.

>  There is a reason why you don't see many device driver here relies on FW version,
>  which is similar to your versioning scheme.

I agree but in our case we can't update the FW version without exposing any new
capabilities (due to compatibility reasons) so is essentially tied to the
feature caps. As a compromise I can add a macro that checks the caps so the
various version checks are a bit less obnoxious.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
