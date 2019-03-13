From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
 i40e_netdev_priv
Date: Wed, 13 Mar 2019 10:28:41 -0300
Message-ID: <20190313132841.GI20037@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-2-shiraz.saleem@intel.com>
 <20190215172233.GC30706@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7A5A471B8@fmsmsx124.amr.corp.intel.com>
 <20190221193523.GO17500@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B11DF23@ORSMSX101.amr.corp.intel.com>
 <20190222202340.GY17500@ziepe.ca>
 <c53c117d58b8bbe325b3b32d6681b84cf422b773.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c53c117d58b8bbe325b3b32d6681b84cf422b773.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Ertman, David M" <david.m.ertman@intel.com>, "Saleem, Shiraz" <shiraz.saleem@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Patil, Kiran" <kiran.patil@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 12, 2019 at 07:11:08PM -0700, Jeff Kirsher wrote:
> > > I am assuming that the term PCI driver is being used to mean the PCI
> > > subsystem in the kernel.  If this assumption is wrong, please disregard
> > > the next
> > > paragraph, but the following points will still apply.
> > 
> > No, I mean the driver that has the struct pci_driver for the PCI
> > function. Maybe that is the LAN driver for this case.
> 
> Sorry for the delayed response, I was dealing with a death in the family.

My condolences

> I want to make sure we are on the same page, so please correct me if I am
> wrong.  The Intel RDMA driver is not a stand-alone PCI function driver
> because there is no separate PCI function for RDMA, so the RDMA driver does
> not call pci_register_driver(), that is done with the LAN driver.  The
> Intel RDMA driver still needs to access to HW resources which is accessible
> only through the LAN PF driver (e.g. i40e/ice) and does not have its own
> netdev, so it uses the netdev exposed by the LAN PF driver.  The access to
> the netdev is needed so that it can listen to RT netlink messages and other
> reasons.

Whichever driver own the pci_driver is the one that has to setup the
other driver core elements. Sounds like it is the net driver in your
design.
 
> We refer to "software bus" because out hardware doe not expose the hardware
> bus, so our APIs to bus_register/unregister are actually using a software
> bus, which is exposed and managed by the LAN driver.

You have a multi-function device, and we have the mfd subsystem to
help these cases. Probably this driver should use it.

> > Register a device driver to the driver core and wait for the driver
> > core to call that driver's probe method.
> 
> Yes, the LAN PF driver is the software component exposing and managing the
> bus, so it is the one who will call probe/remove of the peer driver (RDMA
> driver).  Although netdev notifiers based approach is needed if the RDMA
> driver was loaded first before the LAN PF driver (i40e or ice) is loaded.

Why would notifiers be needed? Driver core handles all these ordering
things. If you have a device_driver with no device it waits until a
device gets plugged in to call probe.

Jason
