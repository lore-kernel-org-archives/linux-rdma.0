From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 13/16] IB/pvrdma: Add the main driver module for PVRDMA
Date: Thu, 8 Dec 2016 14:23:39 +0200
Message-ID: <20161208122338.GA4627@yuval-lap>
References: <cover.1475458407.git.aditr@vmware.com>
 <d52d003f8befeb883a05b5234a90e7d6430218f2.1475458407.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d52d003f8befeb883a05b5234a90e7d6430218f2.1475458407.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

+
> +static int pvrdma_pci_probe(struct pci_dev *pdev,
> +			    const struct pci_device_id *id)
> +{
> +	struct pci_dev *pdev_net;
> +	struct pvrdma_dev *dev;
> +	int ret;
> +	unsigned long start;
> +	unsigned long len;
> +	unsigned int version;
> +	dma_addr_t slot_dma = 0;
> +
> +	dev_dbg(&pdev->dev, "initializing driver %s\n", pci_name(pdev));
> +
> +	/* Allocate zero-out device */
> +	dev = (struct pvrdma_dev *)ib_alloc_device(sizeof(*dev));
> +	if (!dev) {
> +		dev_err(&pdev->dev, "failed to allocate IB device\n");
> +		return -ENOMEM;
> +	}
> +
> +	mutex_lock(&pvrdma_device_list_lock);
> +	list_add(&dev->device_link, &pvrdma_device_list);
> +	mutex_unlock(&pvrdma_device_list_lock);
> +
> +	ret = pvrdma_init_device(dev);
> +	if (ret)
> +		goto err_free_device;
> +
> +	dev->pdev = pdev;
> +	pci_set_drvdata(pdev, dev);
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot enable PCI device\n");
> +		goto err_free_device;
> +	}
> +
> +	dev_dbg(&pdev->dev, "PCI resource flags BAR0 %#lx\n",
> +		pci_resource_flags(pdev, 0));
> +	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
> +		(unsigned long long)pci_resource_len(pdev, 0));
> +	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
> +		(unsigned long long)pci_resource_start(pdev, 0));
> +	dev_dbg(&pdev->dev, "PCI resource flags BAR1 %#lx\n",
> +		pci_resource_flags(pdev, 1));
> +	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
> +		(unsigned long long)pci_resource_len(pdev, 1));
> +	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
> +		(unsigned long long)pci_resource_start(pdev, 1));
> +
> +	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
> +	    !(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
> +		dev_err(&pdev->dev, "PCI BAR region not MMIO\n");
> +		ret = -ENOMEM;
> +		goto err_free_device;
> +	}
> +
> +	ret = pci_request_regions(pdev, DRV_NAME);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot request PCI resources\n");
> +		goto err_disable_pdev;
> +	}
> +
> +	/* Enable 64-Bit DMA */
> +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
> +		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> +		if (ret != 0) {
> +			dev_err(&pdev->dev,
> +				"pci_set_consistent_dma_mask failed\n");
> +			goto err_free_resource;
> +		}
> +	} else {
> +		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (ret != 0) {
> +			dev_err(&pdev->dev,
> +				"pci_set_dma_mask failed\n");
> +			goto err_free_resource;
> +		}
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	/* Map register space */
> +	start = pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
> +	len = pci_resource_len(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
> +	dev->regs = ioremap(start, len);
> +	if (!dev->regs) {
> +		dev_err(&pdev->dev, "register mapping failed\n");
> +		ret = -ENOMEM;
> +		goto err_free_resource;
> +	}
> +
> +	/* Setup per-device UAR. */
> +	dev->driver_uar.index = 0;
> +	dev->driver_uar.pfn =
> +		pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_UAR) >>
> +		PAGE_SHIFT;
> +	dev->driver_uar.map =
> +		ioremap(dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
> +	if (!dev->driver_uar.map) {
> +		dev_err(&pdev->dev, "failed to remap UAR pages\n");
> +		ret = -ENOMEM;
> +		goto err_unmap_regs;
> +	}
> +
> +	version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
> +	dev_info(&pdev->dev, "device version %d, driver version %d\n",
> +		 version, PVRDMA_VERSION);
> +	if (version < PVRDMA_VERSION) {
> +		dev_err(&pdev->dev, "incompatible device version\n");
> +		goto err_uar_unmap;
> +	}
> +
> +	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
> +				      &dev->dsrbase, GFP_KERNEL);
> +	if (!dev->dsr) {
> +		dev_err(&pdev->dev, "failed to allocate shared region\n");
> +		ret = -ENOMEM;
> +		goto err_uar_unmap;
> +	}
> +
> +	/* Setup the shared region */
> +	memset(dev->dsr, 0, sizeof(*dev->dsr));
> +	dev->dsr->driver_version = PVRDMA_VERSION;
> +	dev->dsr->gos_info.gos_bits = sizeof(void *) == 4 ?
> +		PVRDMA_GOS_BITS_32 :
> +		PVRDMA_GOS_BITS_64;
> +	dev->dsr->gos_info.gos_type = PVRDMA_GOS_TYPE_LINUX;
> +	dev->dsr->gos_info.gos_ver = 1;
> +	dev->dsr->uar_pfn = dev->driver_uar.pfn;
> +
> +	/* Command slot. */
> +	dev->cmd_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> +					   &slot_dma, GFP_KERNEL);
> +	if (!dev->cmd_slot) {
> +		ret = -ENOMEM;
> +		goto err_free_dsr;
> +	}
> +
> +	dev->dsr->cmd_slot_dma = (u64)slot_dma;
> +
> +	/* Response slot. */
> +	dev->resp_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> +					    &slot_dma, GFP_KERNEL);
> +	if (!dev->resp_slot) {
> +		ret = -ENOMEM;
> +		goto err_free_slots;
> +	}
> +
> +	dev->dsr->resp_slot_dma = (u64)slot_dma;
> +
> +	/* Async event ring */
> +	dev->dsr->async_ring_pages.num_pages = 4;

Why 4?
Actually question is why driver hard-coded this value as apposed to other
HW resources rings (such as CQ, QP) that is calculated based on element
size and max element number that supported by the HW?

> +	ret = pvrdma_page_dir_init(dev, &dev->async_pdir,
> +				   dev->dsr->async_ring_pages.num_pages, true);
> +	if (ret)
> +		goto err_free_slots;
> +	dev->async_ring_state = dev->async_pdir.pages[0];
> +	dev->dsr->async_ring_pages.pdir_dma = dev->async_pdir.dir_dma;
> +
> +	/* CQ notification ring */
> +	dev->dsr->cq_ring_pages.num_pages = 4;

Ditto.

> +	ret = pvrdma_page_dir_init(dev, &dev->cq_pdir,
> +				   dev->dsr->cq_ring_pages.num_pages, true);
> +	if (ret)
> +		goto err_free_async_ring;
> +	dev->cq_ring_state = dev->cq_pdir.pages[0];
> +	dev->dsr->cq_ring_pages.pdir_dma = dev->cq_pdir.dir_dma;
> +
> +	/*
> +	 * Write the PA of the shared region to the device. The writes must be
> +	 * ordered such that the high bits are written last. When the writes
> +	 * complete, the device will have filled out the capabilities.
> +	 */
> +
> +	pvrdma_write_reg(dev, PVRDMA_REG_DSRLOW, (u32)dev->dsrbase);
> +	pvrdma_write_reg(dev, PVRDMA_REG_DSRHIGH,
> +			 (u32)((u64)(dev->dsrbase) >> 32));
> +
> +	/* Make sure the write is complete before reading status. */
> +	mb();
> +
> +	/* Currently, the driver only supports RoCE mode. */
> +	if (dev->dsr->caps.mode != PVRDMA_DEVICE_MODE_ROCE) {
> +		dev_err(&pdev->dev, "unsupported transport %d\n",
> +			dev->dsr->caps.mode);
> +		ret = -EFAULT;
> +		goto err_free_cq_ring;
> +	}
> +
> +	/* Currently, the driver only supports RoCE V1. */
> +	if (!(dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V1)) {
> +		dev_err(&pdev->dev, "driver needs RoCE v1 support\n");
> +		ret = -EFAULT;
> +		goto err_free_cq_ring;
> +	}
> +
> +	/* Paired vmxnet3 will have same bus, slot. But func will be 0 */
> +	pdev_net = pci_get_slot(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
> +	if (!pdev_net) {
> +		dev_err(&pdev->dev, "failed to find paired net device\n");
> +		ret = -ENODEV;
> +		goto err_free_cq_ring;
> +	}
> +
> +	if (pdev_net->vendor != PCI_VENDOR_ID_VMWARE ||
> +	    pdev_net->device != PCI_DEVICE_ID_VMWARE_VMXNET3) {
> +		dev_err(&pdev->dev, "failed to find paired vmxnet3 device\n");
> +		pci_dev_put(pdev_net);
> +		ret = -ENODEV;
> +		goto err_free_cq_ring;
> +	}
> +
> +	dev->netdev = pci_get_drvdata(pdev_net);
> +	pci_dev_put(pdev_net);
> +	if (!dev->netdev) {
> +		dev_err(&pdev->dev, "failed to get vmxnet3 device\n");
> +		ret = -ENODEV;
> +		goto err_free_cq_ring;
> +	}
> +
> +	dev_info(&pdev->dev, "paired device to %s\n", dev->netdev->name);
> +
> +	/* Interrupt setup */
> +	ret = pvrdma_alloc_intrs(dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to allocate interrupts\n");
> +		ret = -ENOMEM;
> +		goto err_netdevice;
> +	}
> +
> +	/* Allocate UAR table. */
> +	ret = pvrdma_uar_table_init(dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to allocate UAR table\n");
> +		ret = -ENOMEM;
> +		goto err_free_intrs;
> +	}
> +
> +	/* Allocate GID table */
> +	dev->sgid_tbl = kcalloc(dev->dsr->caps.gid_tbl_len,
> +				sizeof(union ib_gid), GFP_KERNEL);
> +	if (!dev->sgid_tbl) {
> +		ret = -ENOMEM;
> +		goto err_free_uar_table;
> +	}
> +	dev_dbg(&pdev->dev, "gid table len %d\n", dev->dsr->caps.gid_tbl_len);
> +
> +	pvrdma_enable_intrs(dev);
> +
> +	/* Activate pvrdma device */
> +	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_ACTIVATE);
> +
> +	/* Make sure the write is complete before reading status. */
> +	mb();
> +
> +	/* Check if device was successfully activated */
> +	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "failed to activate device\n");
> +		ret = -EFAULT;
> +		goto err_disable_intr;
> +	}
> +
> +	/* Register IB device */
> +	ret = pvrdma_register_device(dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register IB device\n");
> +		goto err_disable_intr;
> +	}
> +
> +	dev->nb_netdev.notifier_call = pvrdma_netdevice_event;
> +	ret = register_netdevice_notifier(&dev->nb_netdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register netdevice events\n");
> +		goto err_unreg_ibdev;
> +	}
> +
> +	dev_info(&pdev->dev, "attached to device\n");
> +	return 0;
> +
> +err_unreg_ibdev:
> +	ib_unregister_device(&dev->ib_dev);
> +err_disable_intr:
> +	pvrdma_disable_intrs(dev);
> +	kfree(dev->sgid_tbl);
> +err_free_uar_table:
> +	pvrdma_uar_table_cleanup(dev);
> +err_free_intrs:
> +	pvrdma_free_irq(dev);
> +	pvrdma_disable_msi_all(dev);
> +err_netdevice:
> +	unregister_netdevice_notifier(&dev->nb_netdev);
> +err_free_cq_ring:
> +	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
> +err_free_async_ring:
> +	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
> +err_free_slots:
> +	pvrdma_free_slots(dev);
> +err_free_dsr:
> +	dma_free_coherent(&pdev->dev, sizeof(*dev->dsr), dev->dsr,
> +			  dev->dsrbase);
> +err_uar_unmap:
> +	iounmap(dev->driver_uar.map);
> +err_unmap_regs:
> +	iounmap(dev->regs);
> +err_free_resource:
> +	pci_release_regions(pdev);
> +err_disable_pdev:
> +	pci_disable_device(pdev);
> +	pci_set_drvdata(pdev, NULL);
> +err_free_device:
> +	mutex_lock(&pvrdma_device_list_lock);
> +	list_del(&dev->device_link);
> +	mutex_unlock(&pvrdma_device_list_lock);
> +	ib_dealloc_device(&dev->ib_dev);
> +	return ret;
> +}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
