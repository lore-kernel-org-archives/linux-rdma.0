From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
 i40e_netdev_priv
Date: Fri, 10 May 2019 08:31:02 -0500
Message-ID: <20190510133102.GA13780@ssaleem-MOBL4.amr.corp.intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-2-shiraz.saleem@intel.com>
 <20190215172233.GC30706@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7A5A471B8@fmsmsx124.amr.corp.intel.com>
 <20190221193523.GO17500@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B11DF23@ORSMSX101.amr.corp.intel.com>
 <20190222202340.GY17500@ziepe.ca>
 <c53c117d58b8bbe325b3b32d6681b84cf422b773.camel@intel.com>
 <20190313132841.GI20037@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313132841.GI20037@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Patil, Kiran" <kiran.patil@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 13, 2019 at 07:28:41AM -0600, Jason Gunthorpe wrote:
> 
> > > Register a device driver to the driver core and wait for the driver
> > > core to call that driver's probe method.
> > 
> > Yes, the LAN PF driver is the software component exposing and managing the
> > bus, so it is the one who will call probe/remove of the peer driver (RDMA
> > driver).  Although netdev notifiers based approach is needed if the RDMA
> > driver was loaded first before the LAN PF driver (i40e or ice) is loaded.
> 
> Why would notifiers be needed? Driver core handles all these ordering
> things. If you have a device_driver with no device it waits until a
> device gets plugged in to call probe.
> 

Hi Jason - Your feedback here is much appreciated and we have revisited our design based on it.
The platform driver/device model is a good fit for us with the addition of RDMA capable devices
to the virtual platform bus. Here are the highlights of design and how they address your concerns.

(1) irdma driver registers itself as a platform driver with its own probe()/remove() routines.
    It will support RDMA capable platform devices from different Intel HW generations. 
(2) The intel net driver will register RDMA capable devices on the platform bus.
(3) Exposing a virtual bus type in the netdev driver is redundant and thus removed.
    Additionally, it would require the bus object to be exported in order for irdma to register,
    which doesnt allow irdma to be unified. 
(4) In irdma bus probe(), we are able to reach each platform dev's associated net-specific
    data including the netdev. 
(5) There are no ordering dependencies between net-driver and irdma since it's managed by driver
    core as you stated. Listening to netdev notifiers for attachment is no longer required and
    thus removed.

We did a proof-of-concept of this revised design with 'irdma' and 'ice'.

The last 2 commits on github contain the specific changes to the 2 drivers to migrate to the new model.

https://github.com/shirazsaleem/linux-rdma/commits/poc-irdma-platform-driver
eba0979 ("RDMA/irdma: Register irdma as a platform driver")
32a7dea ("ice: Register RDMA peer devices to the virtual platform bus")

Thoughts?

Shiraz
