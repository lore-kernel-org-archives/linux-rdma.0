From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-next 12/13] IB/{hfi1, qib}: Add handling of kernel
 restart
Date: Thu, 5 Apr 2018 13:17:57 -0600
Message-ID: <20180405191757.GA13857@ziepe.ca>
References: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
 <20180405030308.18766.22246.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405030308.18766.22246.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 04, 2018 at 08:03:12PM -0700, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin@intel.com>
> 
> A warm restart will fail to unload the driver, leaving link state
> potentially flapping up to the point the BIOS resets the adapter.
> Correct the issue by hooking the shutdown pci method,
> which will bring link down and remove the driver.
> 
> Cc: <stable@vger.kernel.org> # 4.9.x
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Alex Estrin <alex.estrin@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>  drivers/infiniband/hw/hfi1/hfi.h     |    1 +
>  drivers/infiniband/hw/hfi1/init.c    |    5 +++++
>  drivers/infiniband/hw/qib/qib.h      |    1 +
>  drivers/infiniband/hw/qib/qib_init.c |    5 +++++
>  4 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
> index 4305000..777abb8 100644
> +++ b/drivers/infiniband/hw/hfi1/hfi.h
> @@ -1857,6 +1857,7 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
>  #define HFI1_HAS_SDMA_TIMEOUT  0x8
>  #define HFI1_HAS_SEND_DMA      0x10   /* Supports Send DMA */
>  #define HFI1_FORCED_FREEZE     0x80   /* driver forced freeze mode */
> +#define HFI1_REMOVE           0x100   /* unloading device */
>  
>  /* IB dword length mask in PBC (lower 11 bits); same for all chips */
>  #define HFI1_PBC_LENGTH_MASK                     ((1 << 11) - 1)
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
> index c45cca5..20fa898 100644
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -1388,6 +1388,7 @@ void hfi1_disable_after_error(struct hfi1_devdata *dd)
>  	.name = DRIVER_NAME,
>  	.probe = init_one,
>  	.remove = remove_one,
> +	.shutdown = remove_one,
>  	.id_table = hfi1_pci_tbl,
>  	.err_handler = &hfi1_pci_err_handler,
>  };
> @@ -1768,6 +1769,10 @@ static void remove_one(struct pci_dev *pdev)
>  {
>  	struct hfi1_devdata *dd = pci_get_drvdata(pdev);
>  
> +	if (dd->flags & HFI1_REMOVE)
> +		return;
> +	dd->flags |= HFI1_REMOVE;
> +
>  	/* close debugfs files before ib unregister */
>  	hfi1_dbg_ibdev_exit(&dd->verbs_dev);
>  
> diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
> index 4607245..677b757 100644
> +++ b/drivers/infiniband/hw/qib/qib.h
> @@ -1228,6 +1228,7 @@ int qib_cdev_init(int minor, const char *name,
>  #define QIB_BADINTR           0x8000 /* severe interrupt problems */
>  #define QIB_DCA_ENABLED       0x10000 /* Direct Cache Access enabled */
>  #define QIB_HAS_QSFP          0x20000 /* device (card instance) has QSFP */
> +#define QIB_REMOVE            0x40000 /* unloading device */
>  
>  /*
>   * values for ppd->lflags (_ib_port_ related flags)
> diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
> index 3990f38..796dea4 100644
> +++ b/drivers/infiniband/hw/qib/qib_init.c
> @@ -1201,6 +1201,7 @@ void qib_disable_after_error(struct qib_devdata *dd)
>  	.name = QIB_DRV_NAME,
>  	.probe = qib_init_one,
>  	.remove = qib_remove_one,
> +	.shutdown = qib_remove_one,

No way, qib_remove_one() ultimately calls ib_unregister_device() which
is not approprite for a shutdown callback, especially since these
drivers do not support RDMA hot removal.

I think you need something lighter weight that just turns off the
physical port.

Jason
