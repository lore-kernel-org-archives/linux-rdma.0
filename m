From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
 i40e_netdev_priv
Date: Thu, 21 Feb 2019 02:19:33 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A471B8@fmsmsx124.amr.corp.intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-2-shiraz.saleem@intel.com>
 <20190215172233.GC30706@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215172233.GC30706@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, "Patil, Kiran" <kiran.patil@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>
List-Id: linux-rdma@vger.kernel.org

>Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
>i40e_netdev_priv
>
>On Fri, Feb 15, 2019 at 11:10:48AM -0600, Shiraz Saleem wrote:
>> Expose the register/unregister function pointers in the struct
>> i40e_netdev_priv which is accesible via the netdev_priv() interface in
>> the RDMA driver. On a netdev notification in the RDMA driver, the
>> appropriate LAN driver register/unregister functions are invoked from
>> the struct i40e_netdev_priv structure,
>
>Why? In later patches we get an entire device_add() based thing. Why do you
>need two things?
>
>The RDMA driver should bind to the thing that device_add created and from there
>reliably get the netdev. It should not listen to netdev notifiers for attachment.

In the new IDC mechanism between ice<->irdma, the LAN driver setups up the
device for us and attaches it to a software bus via device_add() based mechanism.
However, RDMA driver binds to the device only when the LAN 'register' function is
called in irdma. In order to do a unified RDMA driver, this register function is exposed
in the private netdev struct of each LAN driver, so we need a matching LAN driver
netdev (ice or i40e) in irdma to call the 'register' function in the first place.
.
Once the binding is done, the bus infrastructure triggers the probe() for the device
into the 'ice' driver and it in turn calls the irdma probe() where we can get also get
the netdev like your referring to. But there is no software bus object or device the
RDMA driver can bind to without a matching LAN driver being loaded and calling its
register. 

There is no ordering guarantee in which irdma, i40e and ice modules load.
The netdev notifier is for the case where the irdma loads before i40e or ice.
The irdma driver listen to the notifiers so that when a supporting LAN drivers netdev
appears (on load), it can register with it.

Shiraz
