From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
 i40e_netdev_priv
Date: Fri, 15 Feb 2019 10:22:33 -0700
Message-ID: <20190215172233.GC30706@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-2-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215171107.6464-2-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 11:10:48AM -0600, Shiraz Saleem wrote:
> Expose the register/unregister function pointers in the struct
> i40e_netdev_priv which is accesible via the netdev_priv() interface
> in the RDMA driver. On a netdev notification in the RDMA driver,
> the appropriate LAN driver register/unregister functions are invoked
> from the struct i40e_netdev_priv structure,

Why? In later patches we get an entire device_add() based thing. Why do
you need two things?

The RDMA driver should bind to the thing that device_add created and
from there reliably get the netdev. It should not listen to netdev
notifiers for attachment.

It would be excellent if you could make this more general as pretty
much every single RDMA driver has some open coded (and often wrongly
locked) version of this attachment process.

This series is very big, so if you can see a way to make a general
attachment scheme based around device_add/etc it would be a great
pre-cursor series.

Jason
