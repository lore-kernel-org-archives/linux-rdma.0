From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] vmw_pvrdma: Release netdev when vmxnet3 module is removed
Date: Fri, 29 Jun 2018 07:33:55 -0400
Message-ID: <20180629113355.GB16153@hmswarspite.think-freely.org>
References: <20180628135938.19625-1-nhorman@tuxdriver.com>
 <20180628185946.GC379@ziepe.ca>
 <20180628194526.GA14168@hmswarspite.think-freely.org>
 <20180628203709.GD379@ziepe.ca>
 <74E5B871-3D33-4C75-8FD4-C5D5BE2182AD@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <74E5B871-3D33-4C75-8FD4-C5D5BE2182AD@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adit Ranadive <aditr@vmware.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, pv-drivers <pv-drivers@vmware.com>, Doug Ledford <dledford@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 28, 2018 at 09:15:46PM +0000, Adit Ranadive wrote:
> On 6/28/18, 1:37 PM, "Jason Gunthorpe" <jgg@ziepe.ca> wrote:
> > On Thu, Jun 28, 2018 at 03:45:26PM -0400, Neil Horman wrote:
> > > On Thu, Jun 28, 2018 at 12:59:46PM -0600, Jason Gunthorpe wrote:
> > > > On Thu, Jun 28, 2018 at 09:59:38AM -0400, Neil Horman wrote:
> > > > > On repeated module load/unload cycles, its possible for the pvrmda
> > > > > driver to encounter this crash:
> <snip>
> > > > > @@ -962,6 +982,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
> > > > >  	}
> > > > >  
> > > > >  	dev->netdev = pci_get_drvdata(pdev_net);
> > > > > +	dev_hold(dev->netdev);
> 
> That doesn't seem right. If the vmxnet3 driver isn't loaded at all or failed
> to create a netdev, you would be requesting a hold on a NULL netdev. What if
> you moved this to after the if(!dev->netdev) check?
> 
You're correct, I was thinking that there was a null check in dev_hold, but
there isn't, it needs to be moved after the the !dev->netdev, and released in
the error path.

> > > > >  	pci_dev_put(pdev_net);
> > > > >  	if (!dev->netdev) {
> > > > >  		dev_err(&pdev->dev, "failed to get vmxnet3 device\n");
> > > > 
> > > > I see a lot of new dev_hold's here, where are the matching
> > > > dev_puts()?
> > > > 
> > I'm not sure I'd call 2 alot, but sure, there is a new dev_hold in the
> > pvrdma_pci_probe routine, to hold a reference to the netdev that is looked up
> > there.  It is balanced by the NETDEV_UNREGISTER case in
> > pvrdma_netdevice_event_handle.  The UNREGISTER clause is also balancing the
> > NETDEV_REGISTER case of the hanlder that looks up the matching netdev should a
> > new device be registered.  Note that we will only hold a single device at a
> > time, because a given pvrdma device only recongnizes a single vmxnet3 device
> > (the one on function 0 of its own bus/device tuple).
> > 
> > I don't see how the dev_hold in pvrdma_pci_probe is undone during
> > error unwind (eg goto err_free_cq_ring)
> > 
> > And I don't see how it is put when pvrdma_pci_remove() is called.
> 
> That's right. These seem missing as well. 
> 
yup
