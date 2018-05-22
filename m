From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Tue, 22 May 2018 14:56:12 -0600
Message-ID: <20180522205612.GD7502@mellanox.com>
References: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: davem@davemloft.net, dledford@redhat.com, Sindhu Devale <sindhu.devale@intel.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 22, 2018 at 01:38:31PM -0700, Jeff Kirsher wrote:
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

Why would you want to do this? The rdma driver is non-functional
without the ethernet driver, so why on earth would we want to defeat
the module dependency mechanism?

Jason
