From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
 i40e_netdev_priv
Date: Thu, 21 Feb 2019 12:35:23 -0700
Message-ID: <20190221193523.GO17500@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-2-shiraz.saleem@intel.com>
 <20190215172233.GC30706@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7A5A471B8@fmsmsx124.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A5A471B8@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, "Patil, Kiran" <kiran.patil@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 21, 2019 at 02:19:33AM +0000, Saleem, Shiraz wrote:
> >Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
> >i40e_netdev_priv
> >
> >On Fri, Feb 15, 2019 at 11:10:48AM -0600, Shiraz Saleem wrote:
> >> Expose the register/unregister function pointers in the struct
> >> i40e_netdev_priv which is accesible via the netdev_priv() interface in
> >> the RDMA driver. On a netdev notification in the RDMA driver, the
> >> appropriate LAN driver register/unregister functions are invoked from
> >> the struct i40e_netdev_priv structure,
> >
> >Why? In later patches we get an entire device_add() based thing. Why do you
> >need two things?
> >
> >The RDMA driver should bind to the thing that device_add created and from there
> >reliably get the netdev. It should not listen to netdev notifiers for attachment.
> 
> In the new IDC mechanism between ice<->irdma, the LAN driver setups up the
> device for us and attaches it to a software bus via device_add() based mechanism.
> However, RDMA driver binds to the device only when the LAN 'register' function is
> called in irdma.

That doesn't make sense. The PCI driver should always create the
required struct device attachment point when attachment is
becomes possible.

> There is no ordering guarantee in which irdma, i40e and ice modules load.
> The netdev notifier is for the case where the irdma loads before
> i40e or ice.

You are supposed to use the driver core to handle this ordering.

The pci driver creates the attachment points in the correct order,
when they are ready for use, and the driver core will automatically
attach registered device drivers to the attachement points, no matter
the module load loader.

You will have a netdev and a rdma attachment point, sounds like the
RDMA one is created once the netdev is happy.

Maybe what you are missing is a struct device_driver?

Jason
