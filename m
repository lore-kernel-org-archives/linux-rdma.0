From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC 03/19] net/ice: Add support for ice peer devices and drivers
Date: Tue, 12 Feb 2019 20:41:04 -0700
Message-ID: <20190213034104.GA8751@ziepe.ca>
References: <20190212214402.23284-1-shiraz.saleem@intel.com>
 <20190212214402.23284-4-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190212214402.23284-4-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 12, 2019 at 03:43:46PM -0600, Shiraz Saleem wrote:
> From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> 
> The E800 series of Ethernet devices has multiple hardware blocks, of
> which RDMA is one. The RDMA block isn't interfaced directly to PCI
> or any other bus. The RDMA driver (irdma) thus depends on the ice
> driver to provide access to the RDMA hardware block.
> 
> The ice driver first creates a pseudo bus and then creates and attaches
> a new device to the pseudo bus using device_register(). This new device
> is referred to as a "peer device" and the associated driver (i.e. irdma)
> is a "peer driver" to ice. Once the peer driver loads, it can call
> ice driver functions exposed to it via struct ice_ops. Similarly, ice can
> call peer driver functions exposed to it via struct ice_peer_ops.

This seems quite big for this straightforward description..
 
I was going to say I like the idea of using the driver model to
connect the drivers, but if it takes so much code ...

> +	/* check for reset in progress before proceeding */
> +	pf = pci_get_drvdata(peer_dev->pdev);
> +	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
> +		if (!ice_is_reset_in_progress(pf->state))
> +			break;
> +		msleep(100);
> +	}

Use proper locking, not loops with sleeps.

Jason
