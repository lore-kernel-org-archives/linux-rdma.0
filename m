From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2] pci: drop link_reset
Date: Thu, 9 Feb 2017 16:50:50 -0600
Message-ID: <20170209225050.GA29169@bhelgaas-glaptop.roam.corp.google.com>
References: <1485279206-27729-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485279206-27729-1-git-send-email-mst@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Linas Vepstas <linasvepstas@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Frank Haverkamp <haver@linux.vnet.ibm.com>, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, linux-pci@vger.kernel.org, linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 24, 2017 at 07:35:56PM +0200, Michael S. Tsirkin wrote:
> No hardware seems to actually call link_reset, and
> no driver implements it as more than a nop stub.
> 
> This drops the mentions of the callback from everywhere.
> It's dropped from the documentation as well, but
> the doc really needs to be updated to reflect
> reality better (e.g. on pcie slot reset is the link reset).
> 
> This will be done in a later patch.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied to pci/aer for v4.11, thanks.

> ---
> 
> changes from v2:
> 	- drop from genwqe as well
> 
> Note: Doug has patches dropping the implementation from infiniband card
> drivers in his tree already. This is unlikely to cause conflicts though.
> 
>  Documentation/PCI/pci-error-recovery.txt | 24 +++---------------------
>  drivers/infiniband/hw/hfi1/pcie.c        | 10 ----------
>  drivers/infiniband/hw/qib/qib_pcie.c     |  8 --------
>  drivers/media/pci/ngene/ngene-cards.c    |  7 -------
>  drivers/misc/genwqe/card_base.c          |  1 -
>  include/linux/pci.h                      |  3 ---
>  6 files changed, 3 insertions(+), 50 deletions(-)
> 
> diff --git a/Documentation/PCI/pci-error-recovery.txt b/Documentation/PCI/pci-error-recovery.txt
> index ac26869..da3b217 100644
> --- a/Documentation/PCI/pci-error-recovery.txt
> +++ b/Documentation/PCI/pci-error-recovery.txt
> @@ -78,7 +78,6 @@ struct pci_error_handlers
>  {
>  	int (*error_detected)(struct pci_dev *dev, enum pci_channel_state);
>  	int (*mmio_enabled)(struct pci_dev *dev);
> -	int (*link_reset)(struct pci_dev *dev);
>  	int (*slot_reset)(struct pci_dev *dev);
>  	void (*resume)(struct pci_dev *dev);
>  };
> @@ -104,8 +103,7 @@ if it implements any, it must implement error_detected(). If a callback
>  is not implemented, the corresponding feature is considered unsupported.
>  For example, if mmio_enabled() and resume() aren't there, then it
>  is assumed that the driver is not doing any direct recovery and requires
> -a slot reset. If link_reset() is not implemented, the card is assumed to
> -not care about link resets. Typically a driver will want to know about
> +a slot reset.  Typically a driver will want to know about
>  a slot_reset().
>  
>  The actual steps taken by a platform to recover from a PCI error
> @@ -232,25 +230,9 @@ proceeds to STEP 4 (Slot Reset)
>  
>  STEP 3: Link Reset
>  ------------------
> -The platform resets the link, and then calls the link_reset() callback
> -on all affected device drivers.  This is a PCI-Express specific state
> +The platform resets the link.  This is a PCI-Express specific step
>  and is done whenever a non-fatal error has been detected that can be
> -"solved" by resetting the link. This call informs the driver of the
> -reset and the driver should check to see if the device appears to be
> -in working condition.
> -
> -The driver is not supposed to restart normal driver I/O operations
> -at this point.  It should limit itself to "probing" the device to
> -check its recoverability status. If all is right, then the platform
> -will call resume() once all drivers have ack'd link_reset().
> -
> -	Result codes:
> -		(identical to STEP 3 (MMIO Enabled)
> -
> -The platform then proceeds to either STEP 4 (Slot Reset) or STEP 5
> -(Resume Operations).
> -
> ->>> The current powerpc implementation does not implement this callback.
> +"solved" by resetting the link.
>  
>  STEP 4: Slot Reset
>  ------------------
> diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
> index 4ac8f33..ebd941f 100644
> --- a/drivers/infiniband/hw/hfi1/pcie.c
> +++ b/drivers/infiniband/hw/hfi1/pcie.c
> @@ -598,15 +598,6 @@ pci_slot_reset(struct pci_dev *pdev)
>  	return PCI_ERS_RESULT_CAN_RECOVER;
>  }
>  
> -static pci_ers_result_t
> -pci_link_reset(struct pci_dev *pdev)
> -{
> -	struct hfi1_devdata *dd = pci_get_drvdata(pdev);
> -
> -	dd_dev_info(dd, "HFI1 link_reset function called, ignored\n");
> -	return PCI_ERS_RESULT_CAN_RECOVER;
> -}
> -
>  static void
>  pci_resume(struct pci_dev *pdev)
>  {
> @@ -625,7 +616,6 @@ pci_resume(struct pci_dev *pdev)
>  const struct pci_error_handlers hfi1_pci_err_handler = {
>  	.error_detected = pci_error_detected,
>  	.mmio_enabled = pci_mmio_enabled,
> -	.link_reset = pci_link_reset,
>  	.slot_reset = pci_slot_reset,
>  	.resume = pci_resume,
>  };
> diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
> index 6abe1c6..c379b83 100644
> --- a/drivers/infiniband/hw/qib/qib_pcie.c
> +++ b/drivers/infiniband/hw/qib/qib_pcie.c
> @@ -682,13 +682,6 @@ qib_pci_slot_reset(struct pci_dev *pdev)
>  	return PCI_ERS_RESULT_CAN_RECOVER;
>  }
>  
> -static pci_ers_result_t
> -qib_pci_link_reset(struct pci_dev *pdev)
> -{
> -	qib_devinfo(pdev, "QIB link_reset function called, ignored\n");
> -	return PCI_ERS_RESULT_CAN_RECOVER;
> -}
> -
>  static void
>  qib_pci_resume(struct pci_dev *pdev)
>  {
> @@ -707,7 +700,6 @@ qib_pci_resume(struct pci_dev *pdev)
>  const struct pci_error_handlers qib_pci_err_handler = {
>  	.error_detected = qib_pci_error_detected,
>  	.mmio_enabled = qib_pci_mmio_enabled,
> -	.link_reset = qib_pci_link_reset,
>  	.slot_reset = qib_pci_slot_reset,
>  	.resume = qib_pci_resume,
>  };
> diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
> index 423e8c8..8438c1c 100644
> --- a/drivers/media/pci/ngene/ngene-cards.c
> +++ b/drivers/media/pci/ngene/ngene-cards.c
> @@ -781,12 +781,6 @@ static pci_ers_result_t ngene_error_detected(struct pci_dev *dev,
>  	return PCI_ERS_RESULT_CAN_RECOVER;
>  }
>  
> -static pci_ers_result_t ngene_link_reset(struct pci_dev *dev)
> -{
> -	printk(KERN_INFO DEVICE_NAME ": link reset\n");
> -	return 0;
> -}
> -
>  static pci_ers_result_t ngene_slot_reset(struct pci_dev *dev)
>  {
>  	printk(KERN_INFO DEVICE_NAME ": slot reset\n");
> @@ -800,7 +794,6 @@ static void ngene_resume(struct pci_dev *dev)
>  
>  static const struct pci_error_handlers ngene_errors = {
>  	.error_detected = ngene_error_detected,
> -	.link_reset = ngene_link_reset,
>  	.slot_reset = ngene_slot_reset,
>  	.resume = ngene_resume,
>  };
> diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
> index 6c1f49a..4fd21e8 100644
> --- a/drivers/misc/genwqe/card_base.c
> +++ b/drivers/misc/genwqe/card_base.c
> @@ -1336,7 +1336,6 @@ static int genwqe_sriov_configure(struct pci_dev *dev, int numvfs)
>  static struct pci_error_handlers genwqe_err_handler = {
>  	.error_detected = genwqe_err_error_detected,
>  	.mmio_enabled	= genwqe_err_result_none,
> -	.link_reset	= genwqe_err_result_none,
>  	.slot_reset	= genwqe_err_slot_reset,
>  	.resume		= genwqe_err_resume,
>  };
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index e2d1a12..2c0158b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -678,9 +678,6 @@ struct pci_error_handlers {
>  	/* MMIO has been re-enabled, but not DMA */
>  	pci_ers_result_t (*mmio_enabled)(struct pci_dev *dev);
>  
> -	/* PCI Express link has been reset */
> -	pci_ers_result_t (*link_reset)(struct pci_dev *dev);
> -
>  	/* PCI slot has been reset */
>  	pci_ers_result_t (*slot_reset)(struct pci_dev *dev);
>  
> -- 
> MST
