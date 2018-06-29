From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] vmw_pvrdma: Release netdev when vmxnet3 module is removed
Date: Fri, 29 Jun 2018 07:21:27 -0400
Message-ID: <20180629112127.GA16153@hmswarspite.think-freely.org>
References: <20180628135938.19625-1-nhorman@tuxdriver.com>
 <20180628185946.GC379@ziepe.ca>
 <20180628194526.GA14168@hmswarspite.think-freely.org>
 <20180628203709.GD379@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180628203709.GD379@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, Adit Ranadive <aditr@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 28, 2018 at 02:37:09PM -0600, Jason Gunthorpe wrote:
> On Thu, Jun 28, 2018 at 03:45:26PM -0400, Neil Horman wrote:
> > On Thu, Jun 28, 2018 at 12:59:46PM -0600, Jason Gunthorpe wrote:
> > > On Thu, Jun 28, 2018 at 09:59:38AM -0400, Neil Horman wrote:
> > > > On repeated module load/unload cycles, its possible for the pvrmda
> > > > driver to encounter this crash:
> > > > 
> > > > ...
> > > > 297.032448] RIP: 0010:[<ffffffff839e4620>]  [<ffffffff839e4620>] netdev_walk_all_upper_dev_rcu+0x50/0xb0
> > > > [  297.034078] RSP: 0018:ffff95087780bd08  EFLAGS: 00010286
> > > > [  297.034986] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff95087a0c0000
> > > > [  297.036196] RDX: ffff95087a0c0000 RSI: ffffffff839e44e0 RDI: ffff950835d0c000
> > > > [  297.037421] RBP: ffff95087780bd40 R08: ffff95087a0e0ea0 R09: abddacd03f8e0ea0
> > > > [  297.038636] R10: abddacd03f8e0ea0 R11: ffffef5901e9dbc0 R12: ffff95087a0c0000
> > > > [  297.039854] R13: ffffffff839e44e0 R14: ffff95087a0c0000 R15: ffff950835d0c828
> > > > [  297.041071] FS:  0000000000000000(0000) GS:ffff95087fc00000(0000) knlGS:0000000000000000
> > > > [  297.042443] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [  297.043429] CR2: ffffffffffffffe8 CR3: 000000007a652000 CR4: 00000000003607f0
> > > > [  297.044674] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [  297.045893] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > [  297.047109] Call Trace:
> > > > [  297.047545]  [<ffffffff839e4698>] netdev_has_upper_dev_all_rcu+0x18/0x20
> > > > [  297.048691]  [<ffffffffc05d31af>] is_eth_port_of_netdev+0x2f/0xa0 [ib_core]
> > > > [  297.049886]  [<ffffffffc05d3180>] ? is_eth_active_slave_of_bonding_rcu+0x70/0x70 [ib_core]
> > > > ...
> > > > 
> > > > This occurs because vmw_pvrdma on probe stores a pointer to the netdev
> > > > that exists on function 0 of the same bus/device/slot (which represents
> > > > the vmxnet3 ethernet driver).  However, it never removes this pointer if
> > > > the vmxnet3 module is removed, leading to crashes resulting from use
> > > > after free dereferencing incidents like the one above.
> > > > 
> > > > The fix is pretty straightforward.  vmw_pvrdma should listen for
> > > > NETDEV_REGISTER and NETDEV_UNREGISTER events in its event listener code
> > > > block, and update the stored netdev pointer accordingly.  This solution
> > > > has been tested by myself and the reporter with successful results.
> > > > This fix also allows the pvrdma driver to find its underlying ethernet
> > > > device in the event that vmxnet3 is loaded after pvrdma, which it was
> > > > not able to do before.
> > > > 
> > > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > > Reported-by: ruquin@redhat.com
> > > > CC: Adit Ranadive <aditr@vmware.com>
> > > > CC: VMware PV-Drivers <pv-drivers@vmware.com>
> > > > CC: Doug Ledford <dledford@redhat.com>
> > > > CC: Jason Gunthorpe <jgg@ziepe.ca>
> > > > CC: linux-kernel@vger.kernel.org
> > > >  .../infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 25 +++++++++++++++++--
> > > >  1 file changed, 23 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> > > > index 0be33a81bbe6..5b4782078a74 100644
> > > > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> > > > @@ -699,8 +699,12 @@ static int pvrdma_del_gid(const struct ib_gid_attr *attr, void **context)
> > > >  }
> > > >  
> > > >  static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
> > > > +					  struct net_device *ndev,
> > > >  					  unsigned long event)
> > > >  {
> > > > +	struct pci_dev *pdev_net;
> > > > +
> > > > +
> > > >  	switch (event) {
> > > >  	case NETDEV_REBOOT:
> > > >  	case NETDEV_DOWN:
> > > > @@ -718,6 +722,21 @@ static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
> > > >  		else
> > > >  			pvrdma_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
> > > >  		break;
> > > > +	case NETDEV_UNREGISTER:
> > > > +		dev_put(dev->netdev);
> > > > +		dev->netdev = NULL;
> > > > +		break;
> > > > +	case NETDEV_REGISTER:
> > > > +		/* Paired vmxnet3 will have same bus, slot. But func will be 0 */
> > > > +		pdev_net = pci_get_slot(dev->pdev->bus, PCI_DEVFN(PCI_SLOT(dev->pdev->devfn), 0));
> > > > +		if ((dev->netdev == NULL) && (pci_get_drvdata(pdev_net) == ndev)) {
> > > > +			/* this is our netdev */
> > > > +			dev->netdev = ndev;
> > > > +			dev_hold(ndev);
> > > > +		}
> > > > +		pci_dev_put(pdev_net);
> > > > +		break;
> > > > +
> > > >  	default:
> > > >  		dev_dbg(&dev->pdev->dev, "ignore netdevice event %ld on %s\n",
> > > >  			event, dev->ib_dev.name);
> > > > @@ -734,8 +753,9 @@ static void pvrdma_netdevice_event_work(struct work_struct *work)
> > > >  
> > > >  	mutex_lock(&pvrdma_device_list_lock);
> > > >  	list_for_each_entry(dev, &pvrdma_device_list, device_link) {
> > > > -		if (dev->netdev == netdev_work->event_netdev) {
> > > > -			pvrdma_netdevice_event_handle(dev, netdev_work->event);
> > > > +		if ((netdev_work->event == NETDEV_REGISTER) ||
> > > > +		    (dev->netdev == netdev_work->event_netdev)) {
> > > > +			pvrdma_netdevice_event_handle(dev, netdev_work->event_netdev, netdev_work->event);
> > > >  			break;
> > > >  		}
> > > >  	}
> > > > @@ -962,6 +982,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
> > > >  	}
> > > >  
> > > >  	dev->netdev = pci_get_drvdata(pdev_net);
> > > > +	dev_hold(dev->netdev);
> > > >  	pci_dev_put(pdev_net);
> > > >  	if (!dev->netdev) {
> > > >  		dev_err(&pdev->dev, "failed to get vmxnet3 device\n");
> > > 
> > > I see a lot of new dev_hold's here, where are the matching
> > > dev_puts()?
> > > 
> > I'm not sure I'd call 2 alot, but sure, there is a new dev_hold in the
> > pvrdma_pci_probe routine, to hold a reference to the netdev that is looked up
> > there.  It is balanced by the NETDEV_UNREGISTER case in
> > pvrdma_netdevice_event_handle.  The UNREGISTER clause is also balancing the
> > NETDEV_REGISTER case of the hanlder that looks up the matching netdev should a
> > new device be registered.  Note that we will only hold a single device at a
> > time, because a given pvrdma device only recongnizes a single vmxnet3 device
> > (the one on function 0 of its own bus/device tuple).
> 
> I don't see how the dev_hold in pvrdma_pci_probe is undone during
> error unwind (eg goto err_free_cq_ring)
> 
Ah, I missed that, thank you, I'll update the patch.

> And I don't see how it is put when pvrdma_pci_remove() is called.
> 
Yup, you're right, it should be dropped there too, immediately after the
unregisteration of the netdevice notifier.


> Jason
> 
