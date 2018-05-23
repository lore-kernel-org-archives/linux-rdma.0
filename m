From: David Miller <davem@davemloft.net>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Wed, 23 May 2018 15:00:10 -0400 (EDT)
Message-ID: <20180523.150010.1920539704834947370.davem@davemloft.net>
References: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: dledford@redhat.com, jgg@mellanox.com, sindhu.devale@intel.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, shiraz.saleem@intel.com
List-Id: linux-rdma@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 22 May 2018 13:38:31 -0700

> From: Sindhu Devale <sindhu.devale@intel.com>
> 
> Currently i40iw is dependent on i40e symbols
> i40e_register_client and i40e_unregister_client due to
> which i40iw cannot be loaded without i40e being loaded.
> 
> This patch allows RDMA driver to build and load without
> linking to LAN driver and without LAN driver being loaded
> first. Once the LAN driver is loaded, the RDMA driver
> is notified through the netdevice notifiers to register
> as client to the LAN driver. Add function pointers to IDC
> register/unregister in the private VSI structure. This
> allows a RDMA driver to build without linking to i40e.
> 
> Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

If two drivers depend upon eachother, and a change to one can create
an incompatibility with the other, by definition they must be upgraded
together.

This doesn't even get into recompiling or anything like that, it's a
simple fact of life.

I'm not applying this sorry.
