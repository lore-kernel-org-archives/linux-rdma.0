From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until vmxnet3
 link is up
Date: Wed, 11 Jan 2017 14:19:04 -0800
Message-ID: <3d92c79f-f45f-868b-dfce-3b0f6f5a807e@vmware.com>
References: <cover.1484075557.git.aditr@vmware.com>
 <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
 <20170111083131.GA17240@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111083131.GA17240@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 10:31:32AM +0200, Yuval Shaia wrote:
> On Tue, Jan 10, 2017 at 11:15:39AM -0800, Adit Ranadive wrote:
> > From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > 
> > Currently on bootup, ethernet drivers seem to load before RDMA ones
> > in Linux. So while the vmxnet3 module is loaded before vmw_pvrdma,
> > the vmxnet3 link state may not necessarily be enabled by the stack
> > before pvrdma is loaded. This is a problem because if the pvrdma
> > module is loaded on bootup (by installing it in /lib/modules/*),
> > the pvrdma device comes up in a port down state.
> > 
> > Since this is the most common use case scenario, defer the activation
> > of the device till the paired vmxnet3 link actually comes up. One
> > downside of doing this is, if a user doesn't have the vmxnet3 link
> > up when the pvrdma driver is loaded, they may not see any output
> > for ibv_devinfo until the paired vmxnet3 link is enabled too. The
> > users somehow need to be aware of this.
> > 
> > This only changes how the device is activated the first time. Once
> > enabled if the link goes down, a pvrdma driver reload is still required
> > after link up.
> > 
> > Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> > Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  1 +
> >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 99 +++++++++++++++++---------
> >  2 files changed, 65 insertions(+), 35 deletions(-)
> > 

<...>

> >  static int pvrdma_pci_probe(struct pci_dev *pdev,
> >  			    const struct pci_device_id *id)
> >  {
> > @@ -867,14 +915,14 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
> >  	/* Enable 64-Bit DMA */
> >  	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
> >  		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> > -		if (ret != 0) {
> > +		if (ret) {
> >  			dev_err(&pdev->dev,
> >  				"pci_set_consistent_dma_mask failed\n");
> >  			goto err_free_resource;
> >  		}
> >  	} else {
> >  		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> > -		if (ret != 0) {
> > +		if (ret) {
> >  			dev_err(&pdev->dev,
> >  				"pci_set_dma_mask failed\n");
> >  			goto err_free_resource;
> > @@ -1029,7 +1077,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
> >  	if (ret) {
> >  		dev_err(&pdev->dev, "failed to allocate interrupts\n");
> >  		ret = -ENOMEM;
> > -		goto err_netdevice;
> > +		goto err_free_cq_ring;
> 
> This fix seems to be true regardless of $subject, right?

Correct. Thanks for the review!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
