From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] vmw_pvrdma: Release netdev when vmxnet3 module
 is removed
Date: Sat, 30 Jun 2018 22:15:07 +0300
Message-ID: <20180630191507.dtzpvvvicmphnzsz@mwanda>
References: <20180628135938.19625-1-nhorman@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20180628135938.19625-1-nhorman@tuxdriver.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
To: kbuild@01.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Adit Ranadive <aditr@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, Doug Ledford <dledford@redhat.com>, kbuild-all@01.org
List-Id: linux-rdma@vger.kernel.org

Hi Neil,

I love your patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Neil-Horman/vmw_pvrdma-Release-netdev-when-vmxnet3-module-is-removed/20180628-232414

smatch warnings:
drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c:987 pvrdma_pci_probe() warn: variable dereferenced before check 'dev->netdev' (see line 985)

# https://github.com/0day-ci/linux/commit/d5bb424e18e2ecab4ac590a66b0cca9dfb96d3da
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout d5bb424e18e2ecab4ac590a66b0cca9dfb96d3da
vim +987 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c

29c8d9eb Adit Ranadive     2016-10-02   784  
29c8d9eb Adit Ranadive     2016-10-02   785  static int pvrdma_pci_probe(struct pci_dev *pdev,
29c8d9eb Adit Ranadive     2016-10-02   786  			    const struct pci_device_id *id)
29c8d9eb Adit Ranadive     2016-10-02   787  {
29c8d9eb Adit Ranadive     2016-10-02   788  	struct pci_dev *pdev_net;
29c8d9eb Adit Ranadive     2016-10-02   789  	struct pvrdma_dev *dev;
29c8d9eb Adit Ranadive     2016-10-02   790  	int ret;
29c8d9eb Adit Ranadive     2016-10-02   791  	unsigned long start;
29c8d9eb Adit Ranadive     2016-10-02   792  	unsigned long len;
29c8d9eb Adit Ranadive     2016-10-02   793  	dma_addr_t slot_dma = 0;
29c8d9eb Adit Ranadive     2016-10-02   794  
29c8d9eb Adit Ranadive     2016-10-02   795  	dev_dbg(&pdev->dev, "initializing driver %s\n", pci_name(pdev));
29c8d9eb Adit Ranadive     2016-10-02   796  
29c8d9eb Adit Ranadive     2016-10-02   797  	/* Allocate zero-out device */
29c8d9eb Adit Ranadive     2016-10-02   798  	dev = (struct pvrdma_dev *)ib_alloc_device(sizeof(*dev));
29c8d9eb Adit Ranadive     2016-10-02   799  	if (!dev) {
29c8d9eb Adit Ranadive     2016-10-02   800  		dev_err(&pdev->dev, "failed to allocate IB device\n");
29c8d9eb Adit Ranadive     2016-10-02   801  		return -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02   802  	}
29c8d9eb Adit Ranadive     2016-10-02   803  
29c8d9eb Adit Ranadive     2016-10-02   804  	mutex_lock(&pvrdma_device_list_lock);
29c8d9eb Adit Ranadive     2016-10-02   805  	list_add(&dev->device_link, &pvrdma_device_list);
29c8d9eb Adit Ranadive     2016-10-02   806  	mutex_unlock(&pvrdma_device_list_lock);
29c8d9eb Adit Ranadive     2016-10-02   807  
29c8d9eb Adit Ranadive     2016-10-02   808  	ret = pvrdma_init_device(dev);
29c8d9eb Adit Ranadive     2016-10-02   809  	if (ret)
29c8d9eb Adit Ranadive     2016-10-02   810  		goto err_free_device;
29c8d9eb Adit Ranadive     2016-10-02   811  
29c8d9eb Adit Ranadive     2016-10-02   812  	dev->pdev = pdev;
29c8d9eb Adit Ranadive     2016-10-02   813  	pci_set_drvdata(pdev, dev);
29c8d9eb Adit Ranadive     2016-10-02   814  
29c8d9eb Adit Ranadive     2016-10-02   815  	ret = pci_enable_device(pdev);
29c8d9eb Adit Ranadive     2016-10-02   816  	if (ret) {
29c8d9eb Adit Ranadive     2016-10-02   817  		dev_err(&pdev->dev, "cannot enable PCI device\n");
29c8d9eb Adit Ranadive     2016-10-02   818  		goto err_free_device;
29c8d9eb Adit Ranadive     2016-10-02   819  	}
29c8d9eb Adit Ranadive     2016-10-02   820  
29c8d9eb Adit Ranadive     2016-10-02   821  	dev_dbg(&pdev->dev, "PCI resource flags BAR0 %#lx\n",
29c8d9eb Adit Ranadive     2016-10-02   822  		pci_resource_flags(pdev, 0));
29c8d9eb Adit Ranadive     2016-10-02   823  	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
29c8d9eb Adit Ranadive     2016-10-02   824  		(unsigned long long)pci_resource_len(pdev, 0));
29c8d9eb Adit Ranadive     2016-10-02   825  	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
29c8d9eb Adit Ranadive     2016-10-02   826  		(unsigned long long)pci_resource_start(pdev, 0));
29c8d9eb Adit Ranadive     2016-10-02   827  	dev_dbg(&pdev->dev, "PCI resource flags BAR1 %#lx\n",
29c8d9eb Adit Ranadive     2016-10-02   828  		pci_resource_flags(pdev, 1));
29c8d9eb Adit Ranadive     2016-10-02   829  	dev_dbg(&pdev->dev, "PCI resource len %#llx\n",
29c8d9eb Adit Ranadive     2016-10-02   830  		(unsigned long long)pci_resource_len(pdev, 1));
29c8d9eb Adit Ranadive     2016-10-02   831  	dev_dbg(&pdev->dev, "PCI resource start %#llx\n",
29c8d9eb Adit Ranadive     2016-10-02   832  		(unsigned long long)pci_resource_start(pdev, 1));
29c8d9eb Adit Ranadive     2016-10-02   833  
29c8d9eb Adit Ranadive     2016-10-02   834  	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
29c8d9eb Adit Ranadive     2016-10-02   835  	    !(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
29c8d9eb Adit Ranadive     2016-10-02   836  		dev_err(&pdev->dev, "PCI BAR region not MMIO\n");
29c8d9eb Adit Ranadive     2016-10-02   837  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02   838  		goto err_free_device;
29c8d9eb Adit Ranadive     2016-10-02   839  	}
29c8d9eb Adit Ranadive     2016-10-02   840  
29c8d9eb Adit Ranadive     2016-10-02   841  	ret = pci_request_regions(pdev, DRV_NAME);
29c8d9eb Adit Ranadive     2016-10-02   842  	if (ret) {
29c8d9eb Adit Ranadive     2016-10-02   843  		dev_err(&pdev->dev, "cannot request PCI resources\n");
29c8d9eb Adit Ranadive     2016-10-02   844  		goto err_disable_pdev;
29c8d9eb Adit Ranadive     2016-10-02   845  	}
29c8d9eb Adit Ranadive     2016-10-02   846  
29c8d9eb Adit Ranadive     2016-10-02   847  	/* Enable 64-Bit DMA */
29c8d9eb Adit Ranadive     2016-10-02   848  	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
29c8d9eb Adit Ranadive     2016-10-02   849  		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
29c8d9eb Adit Ranadive     2016-10-02   850  		if (ret != 0) {
29c8d9eb Adit Ranadive     2016-10-02   851  			dev_err(&pdev->dev,
29c8d9eb Adit Ranadive     2016-10-02   852  				"pci_set_consistent_dma_mask failed\n");
29c8d9eb Adit Ranadive     2016-10-02   853  			goto err_free_resource;
29c8d9eb Adit Ranadive     2016-10-02   854  		}
29c8d9eb Adit Ranadive     2016-10-02   855  	} else {
29c8d9eb Adit Ranadive     2016-10-02   856  		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
29c8d9eb Adit Ranadive     2016-10-02   857  		if (ret != 0) {
29c8d9eb Adit Ranadive     2016-10-02   858  			dev_err(&pdev->dev,
29c8d9eb Adit Ranadive     2016-10-02   859  				"pci_set_dma_mask failed\n");
29c8d9eb Adit Ranadive     2016-10-02   860  			goto err_free_resource;
29c8d9eb Adit Ranadive     2016-10-02   861  		}
29c8d9eb Adit Ranadive     2016-10-02   862  	}
29c8d9eb Adit Ranadive     2016-10-02   863  
29c8d9eb Adit Ranadive     2016-10-02   864  	pci_set_master(pdev);
29c8d9eb Adit Ranadive     2016-10-02   865  
29c8d9eb Adit Ranadive     2016-10-02   866  	/* Map register space */
29c8d9eb Adit Ranadive     2016-10-02   867  	start = pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
29c8d9eb Adit Ranadive     2016-10-02   868  	len = pci_resource_len(dev->pdev, PVRDMA_PCI_RESOURCE_REG);
29c8d9eb Adit Ranadive     2016-10-02   869  	dev->regs = ioremap(start, len);
29c8d9eb Adit Ranadive     2016-10-02   870  	if (!dev->regs) {
29c8d9eb Adit Ranadive     2016-10-02   871  		dev_err(&pdev->dev, "register mapping failed\n");
29c8d9eb Adit Ranadive     2016-10-02   872  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02   873  		goto err_free_resource;
29c8d9eb Adit Ranadive     2016-10-02   874  	}
29c8d9eb Adit Ranadive     2016-10-02   875  
29c8d9eb Adit Ranadive     2016-10-02   876  	/* Setup per-device UAR. */
29c8d9eb Adit Ranadive     2016-10-02   877  	dev->driver_uar.index = 0;
29c8d9eb Adit Ranadive     2016-10-02   878  	dev->driver_uar.pfn =
29c8d9eb Adit Ranadive     2016-10-02   879  		pci_resource_start(dev->pdev, PVRDMA_PCI_RESOURCE_UAR) >>
29c8d9eb Adit Ranadive     2016-10-02   880  		PAGE_SHIFT;
29c8d9eb Adit Ranadive     2016-10-02   881  	dev->driver_uar.map =
29c8d9eb Adit Ranadive     2016-10-02   882  		ioremap(dev->driver_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
29c8d9eb Adit Ranadive     2016-10-02   883  	if (!dev->driver_uar.map) {
29c8d9eb Adit Ranadive     2016-10-02   884  		dev_err(&pdev->dev, "failed to remap UAR pages\n");
29c8d9eb Adit Ranadive     2016-10-02   885  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02   886  		goto err_unmap_regs;
29c8d9eb Adit Ranadive     2016-10-02   887  	}
29c8d9eb Adit Ranadive     2016-10-02   888  
05297b66 Bryan Tan         2017-08-22   889  	dev->dsr_version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
29c8d9eb Adit Ranadive     2016-10-02   890  	dev_info(&pdev->dev, "device version %d, driver version %d\n",
05297b66 Bryan Tan         2017-08-22   891  		 dev->dsr_version, PVRDMA_VERSION);
29c8d9eb Adit Ranadive     2016-10-02   892  
58355656 Himanshu Jha      2017-12-31   893  	dev->dsr = dma_zalloc_coherent(&pdev->dev, sizeof(*dev->dsr),
29c8d9eb Adit Ranadive     2016-10-02   894  				       &dev->dsrbase, GFP_KERNEL);
29c8d9eb Adit Ranadive     2016-10-02   895  	if (!dev->dsr) {
29c8d9eb Adit Ranadive     2016-10-02   896  		dev_err(&pdev->dev, "failed to allocate shared region\n");
29c8d9eb Adit Ranadive     2016-10-02   897  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02   898  		goto err_uar_unmap;
29c8d9eb Adit Ranadive     2016-10-02   899  	}
29c8d9eb Adit Ranadive     2016-10-02   900  
29c8d9eb Adit Ranadive     2016-10-02   901  	/* Setup the shared region */
29c8d9eb Adit Ranadive     2016-10-02   902  	dev->dsr->driver_version = PVRDMA_VERSION;
29c8d9eb Adit Ranadive     2016-10-02   903  	dev->dsr->gos_info.gos_bits = sizeof(void *) == 4 ?
29c8d9eb Adit Ranadive     2016-10-02   904  		PVRDMA_GOS_BITS_32 :
29c8d9eb Adit Ranadive     2016-10-02   905  		PVRDMA_GOS_BITS_64;
29c8d9eb Adit Ranadive     2016-10-02   906  	dev->dsr->gos_info.gos_type = PVRDMA_GOS_TYPE_LINUX;
29c8d9eb Adit Ranadive     2016-10-02   907  	dev->dsr->gos_info.gos_ver = 1;
29c8d9eb Adit Ranadive     2016-10-02   908  	dev->dsr->uar_pfn = dev->driver_uar.pfn;
29c8d9eb Adit Ranadive     2016-10-02   909  
29c8d9eb Adit Ranadive     2016-10-02   910  	/* Command slot. */
29c8d9eb Adit Ranadive     2016-10-02   911  	dev->cmd_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
29c8d9eb Adit Ranadive     2016-10-02   912  					   &slot_dma, GFP_KERNEL);
29c8d9eb Adit Ranadive     2016-10-02   913  	if (!dev->cmd_slot) {
29c8d9eb Adit Ranadive     2016-10-02   914  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02   915  		goto err_free_dsr;
29c8d9eb Adit Ranadive     2016-10-02   916  	}
29c8d9eb Adit Ranadive     2016-10-02   917  
29c8d9eb Adit Ranadive     2016-10-02   918  	dev->dsr->cmd_slot_dma = (u64)slot_dma;
29c8d9eb Adit Ranadive     2016-10-02   919  
29c8d9eb Adit Ranadive     2016-10-02   920  	/* Response slot. */
29c8d9eb Adit Ranadive     2016-10-02   921  	dev->resp_slot = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
29c8d9eb Adit Ranadive     2016-10-02   922  					    &slot_dma, GFP_KERNEL);
29c8d9eb Adit Ranadive     2016-10-02   923  	if (!dev->resp_slot) {
29c8d9eb Adit Ranadive     2016-10-02   924  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02   925  		goto err_free_slots;
29c8d9eb Adit Ranadive     2016-10-02   926  	}
29c8d9eb Adit Ranadive     2016-10-02   927  
29c8d9eb Adit Ranadive     2016-10-02   928  	dev->dsr->resp_slot_dma = (u64)slot_dma;
29c8d9eb Adit Ranadive     2016-10-02   929  
29c8d9eb Adit Ranadive     2016-10-02   930  	/* Async event ring */
6332dee8 Adit Ranadive     2017-02-22   931  	dev->dsr->async_ring_pages.num_pages = PVRDMA_NUM_RING_PAGES;
29c8d9eb Adit Ranadive     2016-10-02   932  	ret = pvrdma_page_dir_init(dev, &dev->async_pdir,
29c8d9eb Adit Ranadive     2016-10-02   933  				   dev->dsr->async_ring_pages.num_pages, true);
29c8d9eb Adit Ranadive     2016-10-02   934  	if (ret)
29c8d9eb Adit Ranadive     2016-10-02   935  		goto err_free_slots;
29c8d9eb Adit Ranadive     2016-10-02   936  	dev->async_ring_state = dev->async_pdir.pages[0];
29c8d9eb Adit Ranadive     2016-10-02   937  	dev->dsr->async_ring_pages.pdir_dma = dev->async_pdir.dir_dma;
29c8d9eb Adit Ranadive     2016-10-02   938  
29c8d9eb Adit Ranadive     2016-10-02   939  	/* CQ notification ring */
6332dee8 Adit Ranadive     2017-02-22   940  	dev->dsr->cq_ring_pages.num_pages = PVRDMA_NUM_RING_PAGES;
29c8d9eb Adit Ranadive     2016-10-02   941  	ret = pvrdma_page_dir_init(dev, &dev->cq_pdir,
29c8d9eb Adit Ranadive     2016-10-02   942  				   dev->dsr->cq_ring_pages.num_pages, true);
29c8d9eb Adit Ranadive     2016-10-02   943  	if (ret)
29c8d9eb Adit Ranadive     2016-10-02   944  		goto err_free_async_ring;
29c8d9eb Adit Ranadive     2016-10-02   945  	dev->cq_ring_state = dev->cq_pdir.pages[0];
29c8d9eb Adit Ranadive     2016-10-02   946  	dev->dsr->cq_ring_pages.pdir_dma = dev->cq_pdir.dir_dma;
29c8d9eb Adit Ranadive     2016-10-02   947  
29c8d9eb Adit Ranadive     2016-10-02   948  	/*
29c8d9eb Adit Ranadive     2016-10-02   949  	 * Write the PA of the shared region to the device. The writes must be
29c8d9eb Adit Ranadive     2016-10-02   950  	 * ordered such that the high bits are written last. When the writes
29c8d9eb Adit Ranadive     2016-10-02   951  	 * complete, the device will have filled out the capabilities.
29c8d9eb Adit Ranadive     2016-10-02   952  	 */
29c8d9eb Adit Ranadive     2016-10-02   953  
29c8d9eb Adit Ranadive     2016-10-02   954  	pvrdma_write_reg(dev, PVRDMA_REG_DSRLOW, (u32)dev->dsrbase);
29c8d9eb Adit Ranadive     2016-10-02   955  	pvrdma_write_reg(dev, PVRDMA_REG_DSRHIGH,
29c8d9eb Adit Ranadive     2016-10-02   956  			 (u32)((u64)(dev->dsrbase) >> 32));
29c8d9eb Adit Ranadive     2016-10-02   957  
29c8d9eb Adit Ranadive     2016-10-02   958  	/* Make sure the write is complete before reading status. */
29c8d9eb Adit Ranadive     2016-10-02   959  	mb();
29c8d9eb Adit Ranadive     2016-10-02   960  
05297b66 Bryan Tan         2017-08-22   961  	/* The driver supports RoCE V1 and V2. */
05297b66 Bryan Tan         2017-08-22   962  	if (!PVRDMA_SUPPORTED(dev)) {
05297b66 Bryan Tan         2017-08-22   963  		dev_err(&pdev->dev, "driver needs RoCE v1 or v2 support\n");
29c8d9eb Adit Ranadive     2016-10-02   964  		ret = -EFAULT;
29c8d9eb Adit Ranadive     2016-10-02   965  		goto err_free_cq_ring;
29c8d9eb Adit Ranadive     2016-10-02   966  	}
29c8d9eb Adit Ranadive     2016-10-02   967  
29c8d9eb Adit Ranadive     2016-10-02   968  	/* Paired vmxnet3 will have same bus, slot. But func will be 0 */
29c8d9eb Adit Ranadive     2016-10-02   969  	pdev_net = pci_get_slot(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
29c8d9eb Adit Ranadive     2016-10-02   970  	if (!pdev_net) {
29c8d9eb Adit Ranadive     2016-10-02   971  		dev_err(&pdev->dev, "failed to find paired net device\n");
29c8d9eb Adit Ranadive     2016-10-02   972  		ret = -ENODEV;
29c8d9eb Adit Ranadive     2016-10-02   973  		goto err_free_cq_ring;
29c8d9eb Adit Ranadive     2016-10-02   974  	}
29c8d9eb Adit Ranadive     2016-10-02   975  
29c8d9eb Adit Ranadive     2016-10-02   976  	if (pdev_net->vendor != PCI_VENDOR_ID_VMWARE ||
29c8d9eb Adit Ranadive     2016-10-02   977  	    pdev_net->device != PCI_DEVICE_ID_VMWARE_VMXNET3) {
29c8d9eb Adit Ranadive     2016-10-02   978  		dev_err(&pdev->dev, "failed to find paired vmxnet3 device\n");
29c8d9eb Adit Ranadive     2016-10-02   979  		pci_dev_put(pdev_net);
29c8d9eb Adit Ranadive     2016-10-02   980  		ret = -ENODEV;
29c8d9eb Adit Ranadive     2016-10-02   981  		goto err_free_cq_ring;
29c8d9eb Adit Ranadive     2016-10-02   982  	}
29c8d9eb Adit Ranadive     2016-10-02   983  
29c8d9eb Adit Ranadive     2016-10-02   984  	dev->netdev = pci_get_drvdata(pdev_net);
d5bb424e Neil Horman       2018-06-28  @985  	dev_hold(dev->netdev);
                                                ^^^^^^^^^^^^^^^^^^^^^
Dereferenced inside the function

29c8d9eb Adit Ranadive     2016-10-02   986  	pci_dev_put(pdev_net);
29c8d9eb Adit Ranadive     2016-10-02  @987  	if (!dev->netdev) {
                                                     ^^^^^^^^^^^
Checked too late.

29c8d9eb Adit Ranadive     2016-10-02   988  		dev_err(&pdev->dev, "failed to get vmxnet3 device\n");
29c8d9eb Adit Ranadive     2016-10-02   989  		ret = -ENODEV;
29c8d9eb Adit Ranadive     2016-10-02   990  		goto err_free_cq_ring;
29c8d9eb Adit Ranadive     2016-10-02   991  	}
29c8d9eb Adit Ranadive     2016-10-02   992  
29c8d9eb Adit Ranadive     2016-10-02   993  	dev_info(&pdev->dev, "paired device to %s\n", dev->netdev->name);
29c8d9eb Adit Ranadive     2016-10-02   994  
29c8d9eb Adit Ranadive     2016-10-02   995  	/* Interrupt setup */
29c8d9eb Adit Ranadive     2016-10-02   996  	ret = pvrdma_alloc_intrs(dev);
29c8d9eb Adit Ranadive     2016-10-02   997  	if (ret) {
29c8d9eb Adit Ranadive     2016-10-02   998  		dev_err(&pdev->dev, "failed to allocate interrupts\n");
29c8d9eb Adit Ranadive     2016-10-02   999  		ret = -ENOMEM;
ff89b070 Adit Ranadive     2017-01-19  1000  		goto err_free_cq_ring;
29c8d9eb Adit Ranadive     2016-10-02  1001  	}
29c8d9eb Adit Ranadive     2016-10-02  1002  
29c8d9eb Adit Ranadive     2016-10-02  1003  	/* Allocate UAR table. */
29c8d9eb Adit Ranadive     2016-10-02  1004  	ret = pvrdma_uar_table_init(dev);
29c8d9eb Adit Ranadive     2016-10-02  1005  	if (ret) {
29c8d9eb Adit Ranadive     2016-10-02  1006  		dev_err(&pdev->dev, "failed to allocate UAR table\n");
29c8d9eb Adit Ranadive     2016-10-02  1007  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02  1008  		goto err_free_intrs;
29c8d9eb Adit Ranadive     2016-10-02  1009  	}
29c8d9eb Adit Ranadive     2016-10-02  1010  
29c8d9eb Adit Ranadive     2016-10-02  1011  	/* Allocate GID table */
29c8d9eb Adit Ranadive     2016-10-02  1012  	dev->sgid_tbl = kcalloc(dev->dsr->caps.gid_tbl_len,
29c8d9eb Adit Ranadive     2016-10-02  1013  				sizeof(union ib_gid), GFP_KERNEL);
29c8d9eb Adit Ranadive     2016-10-02  1014  	if (!dev->sgid_tbl) {
29c8d9eb Adit Ranadive     2016-10-02  1015  		ret = -ENOMEM;
29c8d9eb Adit Ranadive     2016-10-02  1016  		goto err_free_uar_table;
29c8d9eb Adit Ranadive     2016-10-02  1017  	}
29c8d9eb Adit Ranadive     2016-10-02  1018  	dev_dbg(&pdev->dev, "gid table len %d\n", dev->dsr->caps.gid_tbl_len);
29c8d9eb Adit Ranadive     2016-10-02  1019  
29c8d9eb Adit Ranadive     2016-10-02  1020  	pvrdma_enable_intrs(dev);
29c8d9eb Adit Ranadive     2016-10-02  1021  
29c8d9eb Adit Ranadive     2016-10-02  1022  	/* Activate pvrdma device */
29c8d9eb Adit Ranadive     2016-10-02  1023  	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_ACTIVATE);
29c8d9eb Adit Ranadive     2016-10-02  1024  
29c8d9eb Adit Ranadive     2016-10-02  1025  	/* Make sure the write is complete before reading status. */
29c8d9eb Adit Ranadive     2016-10-02  1026  	mb();
29c8d9eb Adit Ranadive     2016-10-02  1027  
29c8d9eb Adit Ranadive     2016-10-02  1028  	/* Check if device was successfully activated */
29c8d9eb Adit Ranadive     2016-10-02  1029  	ret = pvrdma_read_reg(dev, PVRDMA_REG_ERR);
29c8d9eb Adit Ranadive     2016-10-02  1030  	if (ret != 0) {
29c8d9eb Adit Ranadive     2016-10-02  1031  		dev_err(&pdev->dev, "failed to activate device\n");
29c8d9eb Adit Ranadive     2016-10-02  1032  		ret = -EFAULT;
29c8d9eb Adit Ranadive     2016-10-02  1033  		goto err_disable_intr;
29c8d9eb Adit Ranadive     2016-10-02  1034  	}
29c8d9eb Adit Ranadive     2016-10-02  1035  
29c8d9eb Adit Ranadive     2016-10-02  1036  	/* Register IB device */
29c8d9eb Adit Ranadive     2016-10-02  1037  	ret = pvrdma_register_device(dev);
29c8d9eb Adit Ranadive     2016-10-02  1038  	if (ret) {
29c8d9eb Adit Ranadive     2016-10-02  1039  		dev_err(&pdev->dev, "failed to register IB device\n");
29c8d9eb Adit Ranadive     2016-10-02  1040  		goto err_disable_intr;
29c8d9eb Adit Ranadive     2016-10-02  1041  	}
29c8d9eb Adit Ranadive     2016-10-02  1042  
29c8d9eb Adit Ranadive     2016-10-02  1043  	dev->nb_netdev.notifier_call = pvrdma_netdevice_event;
29c8d9eb Adit Ranadive     2016-10-02  1044  	ret = register_netdevice_notifier(&dev->nb_netdev);
29c8d9eb Adit Ranadive     2016-10-02  1045  	if (ret) {
29c8d9eb Adit Ranadive     2016-10-02  1046  		dev_err(&pdev->dev, "failed to register netdevice events\n");
29c8d9eb Adit Ranadive     2016-10-02  1047  		goto err_unreg_ibdev;
29c8d9eb Adit Ranadive     2016-10-02  1048  	}
29c8d9eb Adit Ranadive     2016-10-02  1049  
29c8d9eb Adit Ranadive     2016-10-02  1050  	dev_info(&pdev->dev, "attached to device\n");
29c8d9eb Adit Ranadive     2016-10-02  1051  	return 0;
29c8d9eb Adit Ranadive     2016-10-02  1052  
29c8d9eb Adit Ranadive     2016-10-02  1053  err_unreg_ibdev:
29c8d9eb Adit Ranadive     2016-10-02  1054  	ib_unregister_device(&dev->ib_dev);
29c8d9eb Adit Ranadive     2016-10-02  1055  err_disable_intr:
29c8d9eb Adit Ranadive     2016-10-02  1056  	pvrdma_disable_intrs(dev);
29c8d9eb Adit Ranadive     2016-10-02  1057  	kfree(dev->sgid_tbl);
29c8d9eb Adit Ranadive     2016-10-02  1058  err_free_uar_table:
29c8d9eb Adit Ranadive     2016-10-02  1059  	pvrdma_uar_table_cleanup(dev);
29c8d9eb Adit Ranadive     2016-10-02  1060  err_free_intrs:
29c8d9eb Adit Ranadive     2016-10-02  1061  	pvrdma_free_irq(dev);
7bf3976d Christoph Hellwig 2017-02-15  1062  	pci_free_irq_vectors(pdev);
29c8d9eb Adit Ranadive     2016-10-02  1063  err_free_cq_ring:
29c8d9eb Adit Ranadive     2016-10-02  1064  	pvrdma_page_dir_cleanup(dev, &dev->cq_pdir);
29c8d9eb Adit Ranadive     2016-10-02  1065  err_free_async_ring:
29c8d9eb Adit Ranadive     2016-10-02  1066  	pvrdma_page_dir_cleanup(dev, &dev->async_pdir);
29c8d9eb Adit Ranadive     2016-10-02  1067  err_free_slots:
29c8d9eb Adit Ranadive     2016-10-02  1068  	pvrdma_free_slots(dev);
29c8d9eb Adit Ranadive     2016-10-02  1069  err_free_dsr:
29c8d9eb Adit Ranadive     2016-10-02  1070  	dma_free_coherent(&pdev->dev, sizeof(*dev->dsr), dev->dsr,
29c8d9eb Adit Ranadive     2016-10-02  1071  			  dev->dsrbase);
29c8d9eb Adit Ranadive     2016-10-02  1072  err_uar_unmap:
29c8d9eb Adit Ranadive     2016-10-02  1073  	iounmap(dev->driver_uar.map);
29c8d9eb Adit Ranadive     2016-10-02  1074  err_unmap_regs:
29c8d9eb Adit Ranadive     2016-10-02  1075  	iounmap(dev->regs);
29c8d9eb Adit Ranadive     2016-10-02  1076  err_free_resource:
29c8d9eb Adit Ranadive     2016-10-02  1077  	pci_release_regions(pdev);
29c8d9eb Adit Ranadive     2016-10-02  1078  err_disable_pdev:
29c8d9eb Adit Ranadive     2016-10-02  1079  	pci_disable_device(pdev);
29c8d9eb Adit Ranadive     2016-10-02  1080  	pci_set_drvdata(pdev, NULL);
29c8d9eb Adit Ranadive     2016-10-02  1081  err_free_device:
29c8d9eb Adit Ranadive     2016-10-02  1082  	mutex_lock(&pvrdma_device_list_lock);
29c8d9eb Adit Ranadive     2016-10-02  1083  	list_del(&dev->device_link);
29c8d9eb Adit Ranadive     2016-10-02  1084  	mutex_unlock(&pvrdma_device_list_lock);
29c8d9eb Adit Ranadive     2016-10-02  1085  	ib_dealloc_device(&dev->ib_dev);
29c8d9eb Adit Ranadive     2016-10-02  1086  	return ret;
29c8d9eb Adit Ranadive     2016-10-02  1087  }
29c8d9eb Adit Ranadive     2016-10-02  1088  
