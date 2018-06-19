From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Try slot reset before secondary bus reset
Date: Tue, 19 Jun 2018 16:43:46 -0500
Message-ID: <20180619214346.GD33049@bhelgaas-glaptop.roam.corp.google.com>
References: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524167784-5911-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-pci@vger.kernel.org, sulrich@codeaurora.org, timur@codeaurora.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, open list <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 19, 2018 at 03:56:23PM -0400, Sinan Kaya wrote:
> The infiniband adapter might be connected to a PCI hotplug slot. Performing
> secondary bus reset on a hotplug slot causes PCI link up/down interrupts.
> 
> Hotplug driver removes the device from system when a link down interrupt
> is observed and performs re-enumeration when link up interrupt is observed.
> 
> This conflicts with what this code is trying to do. Try secondary bus reset
> only if pci_reset_slot() fails/unsupported.

Hi Sinan,

We had a bunch of discussion here but not sure we ever reached a
consensus.  It did seem like we'd like to avoid putting hotplug
knowledge in drivers, though.  What do you think the path forward is?

> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> ---
>  drivers/infiniband/hw/hfi1/pcie.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
> index 83d66e8..75f49e3 100644
> --- a/drivers/infiniband/hw/hfi1/pcie.c
> +++ b/drivers/infiniband/hw/hfi1/pcie.c
> @@ -908,7 +908,8 @@ static int trigger_sbr(struct hfi1_devdata *dd)
>  	 * delay after a reset is required.  Per spec requirements,
>  	 * the link is either working or not after that point.
>  	 */
> -	pci_reset_bridge_secondary_bus(dev->bus->self);
> +	if (pci_reset_slot(dev->slot))
> +		pci_reset_bridge_secondary_bus(dev->bus->self);
>  
>  	return 0;
>  }
> -- 
> 2.7.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
