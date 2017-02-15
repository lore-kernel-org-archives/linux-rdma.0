From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] vmw_pvrdma: switch to pci_alloc_irq_vectors
Date: Wed, 15 Feb 2017 08:42:57 +0100
Message-ID: <20170215074257.GA15995@lst.de>
References: <20170209151143.15684-1-hch@lst.de> <e8931e40-2187-f67b-7571-79f4744fe3bf@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e8931e40-2187-f67b-7571-79f4744fe3bf-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > +	ret = request_irq(pci_irq_vector(dev->pdev, 0), pvrdma_intr0_handler,
> > +			pdev->msix_enabled ? 0 : IRQF_SHARED, DRV_NAME, dev);
> > +	if (ret) {
> > +		dev_err(&dev->pdev->dev,
> > +			"failed to request interrupt 0\n");
> > +		goto out_free_vectors;
> >  	}
> >  
> > +	for (i = i; i < nr_vectors; i++) {
> 
> This should be i = 1. Looks like IRQ vector 0 was requested above.

Yeah, should be 1 and was intended as such.

> 
> > +		ret = request_irq(pci_irq_vector(dev->pdev, 0),
> 
> This should pci_irq_vector(dev->pdev, i)

Fixed.

> >  	pvrdma_free_irq(dev);
> > -	pvrdma_disable_msi_all(dev);
> > +	pci_free_irq_vectors(pdev);
> 
> There might be a conflict here. We had a fix in commit ff89b070b7c9.

I've rebased to linux-next to avoid the conflict.

I'll also fix up the free patch to use a loop - while the number of
vectors currently is fixed at three that keeps it symmetric.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
