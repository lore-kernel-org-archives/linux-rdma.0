From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 13/16] IB/pvrdma: Add the main driver module for PVRDMA
Date: Mon, 2 Jan 2017 10:50:12 +0200
Message-ID: <20170102085012.GA3671@yuval-lap>
References: <cover.1475458407.git.aditr@vmware.com>
 <d52d003f8befeb883a05b5234a90e7d6430218f2.1475458407.git.aditr@vmware.com>
 <20161208122338.GA4627@yuval-lap>
 <eb847a54-6319-66a8-3703-bf942cb29084@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <eb847a54-6319-66a8-3703-bf942cb29084-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 29, 2016 at 02:31:18PM -0800, Adit Ranadive wrote:
> On Thu, Dec 08, 2016 at 2:23:39PM +0200, Yuval Shaia wrote:
> > +
> > > +static int pvrdma_pci_probe(struct pci_dev *pdev,
> > > +			    const struct pci_device_id *id)
> > > +{
> > > +	struct pci_dev *pdev_net;
> > > +	struct pvrdma_dev *dev;
> > > +	int ret;
> > > +	unsigned long start;
> > > +	unsigned long len;
> > > +	unsigned int version;
> > > +	dma_addr_t slot_dma = 0;
> > > +
> > > +	dev_dbg(&pdev->dev, "initializing driver %s\n", pci_name(pdev));
> > > +
> > > +	/* Allocate zero-out device */
> > > +	dev = (struct pvrdma_dev *)ib_alloc_device(sizeof(*dev));
> > > +	if (!dev) {
> > > +		dev_err(&pdev->dev, "failed to allocate IB device\n");
> > > +		return -ENOMEM;
> > > +	}
> > > +
> > > +	mutex_lock(&pvrdma_device_list_lock);
> > > +	list_add(&dev->device_link, &pvrdma_device_list);
> > > +	mutex_unlock(&pvrdma_device_list_lock);
> > > +
> > > +	ret = pvrdma_init_device(dev);
> > > +	if (ret)
> > > +		goto err_free_device;
> > > +
> > > +	dev->pdev = pdev;
> > > +	pci_set_drvdata(pdev, dev);
> > > +
> > > +	ret = pci_enable_device(pdev);
> > > +	if (ret) {
> > > +		dev_err(&pdev->dev, "cannot enable PCI device\n");
> > > +		goto err_free_device;
> > > +	}
> > > +
> > > +	dev_dbg(&pdev->dev, "PCI resource flags BAR0 %#lx\n",
> > > +		pci_resource_flags(pdev, 0));
> > > +	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
> > > +		(unsigned long long)pci_resource_len(pdev, 0));
> > > +	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
> > > +		(unsigned long long)pci_resource_start(pdev, 0));
> > > +	dev_dbg(&pdev->dev, "PCI resource flags BAR1 %#lx\n",
> > > +		pci_resource_flags(pdev, 1));
> > > +	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
> > > +		(unsigned long long)pci_resource_len(pdev, 1));
> > > +	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
> > > +		(unsigned long long)pci_resource_start(pdev, 1));
> > > +
> > > +	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
> > > +	    !(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
> > > +		dev_err(&pdev->dev, "PCI BAR region not MMIO\n");
> > > +		ret = -ENOMEM;
> > > +		goto err_free_device;
> > > +	}
> > > +
> > > +	ret = pci_request_regions(pdev, DRV_NAME);
> > > +	if (ret) {
> > > +		dev_err(&pdev->dev, "cannot request PCI resources\n");
> > > +		goto err_disable_pdev;
> > > +	}
> > > +
> > > +	/* Enable 64-Bit DMA */
> > > +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
> > > +		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> > > +		if (ret != 0) {
> > > +			dev_err(&pdev->dev,
> > > +				"pci_set_consistent_dma_mask failed\n");
> > > +			goto err_free_resource;
> > > +		}
> > > +	} else {
> > > +		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> > > +		if (ret != 0) {
> > > +			dev_err(&pdev->dev,
> > > +				"pci_set_dma_mask failed\n");
> > > +			goto err_free_resource;
> > > +		}
> > > +	}
> > > +
> > > +	pci_set_master(pdev);
> > > +
> > > +	/* Map register space */
> > > +	start = pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
> > > +	len = pci_resource_len(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
> > > +	dev->regs = ioremap(start, len);
> > > +	if (!dev->regs) {
> > > +		dev_err(&pdev->dev, "register mapping failed\n");
> > > +		ret = -ENOMEM;
> > > +		goto err_free_resource;
> > > +	}
> > > +
> > > +	/* Setup per-device UAR. */
> > > +	dev->driver_uar.index = 0;
> > > +	dev->driver_uar.pfn =
> > > +		pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_UAR) >>
> > > +		PAGE_SHIFT;
> > > +	dev->driver_uar.map =
> > > +		ioremap(dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
> > > +	if (!dev->driver_uar.map) {
> > > +		dev_err(&pdev->dev, "failed to remap UAR pages\n");
> > > +		ret = -ENOMEM;
> > > +		goto err_unmap_regs;
> > > +	}
> > > +
> > > +	version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
> > > +	dev_info(&pdev->dev, "device version %d, driver version %d\n",
> > > +		 version, PVRDMA_VERSION);
> > > +	if (version < PVRDMA_VERSION) {
> > > +		dev_err(&pdev->dev, "incompatible device version\n");
> > > +		goto err_uar_unmap;
> > > +	}
> > > +
> > > +	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
> > > +				      &dev->dsrbase, GFP_KERNEL);
> > > +	if (!dev->dsr) {
> > > +		dev_err(&pdev->dev, "failed to allocate shared region\n");
> > > +		ret = -ENOMEM;
> > > +		goto err_uar_unmap;
> > > +	}
> > > +
> > > +	/* Setup the shared region */
> > > +	memset(dev->dsr, 0, sizeof(*dev->dsr));
> > > +	dev->dsr->driver_version = PVRDMA_VERSION;
> > > +	dev->dsr->gos_info.gos_bits = sizeof(void *) == 4 ?
> > > +		PVRDMA_GOS_BITS_32 :
> > > +		PVRDMA_GOS_BITS_64;
> > > +	dev->dsr->gos_info.gos_type = PVRDMA_GOS_TYPE_LINUX;
> > > +	dev->dsr->gos_info.gos_ver = 1;
> > > +	dev->dsr->uar_pfn = dev->driver_uar.pfn;
> > > +
> > > +	/* Command slot. */
> > > +	dev->cmd_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> > > +					   &slot_dma, GFP_KERNEL);
> > > +	if (!dev->cmd_slot) {
> > > +		ret = -ENOMEM;
> > > +		goto err_free_dsr;
> > > +	}
> > > +
> > > +	dev->dsr->cmd_slot_dma = (u64)slot_dma;
> > > +
> > > +	/* Response slot. */
> > > +	dev->resp_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> > > +					    &slot_dma, GFP_KERNEL);
> > > +	if (!dev->resp_slot) {
> > > +		ret = -ENOMEM;
> > > +		goto err_free_slots;
> > > +	}
> > > +
> > > +	dev->dsr->resp_slot_dma = (u64)slot_dma;
> > > +
> > > +	/* Async event ring */
> > > +	dev->dsr->async_ring_pages.num_pages = 4;
> > 
> > Why 4?
> > Actually question is why driver hard-coded this value as apposed to other
> > HW resources rings (such as CQ, QP) that is calculated based on element
> > size and max element number that supported by the HW?
> 
> In order to support finding these pages dynamically, we would have to split out
> the way our driver <-> device interaction works. We would have to pass down the
> event ring info after the hw caps are read. I dont think its worthwhile to do 
> that since the rings are used only between the driver and the device.

I understand that but it breaks the driver-wide way of allocation HW-driver
resource where usually HW determine the size.
I guess it is a cosmetics thing so feel free to ignore.

> 
> I can turn this into a macro so atleast its defined only in one place.

Macro is sure more elegant way for this.

> 
> Thanks,
> Adit
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
