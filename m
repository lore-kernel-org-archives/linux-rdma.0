From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3.10.y 0/4] IB/IPoIB fixes for SRIOV / cloud environment
Date: Tue, 6 Aug 2013 17:38:37 +0800
Message-ID: <20130806093837.GC27889@kroah.com>
References: <1375778322-24408-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375778322-24408-1-git-send-email-ogerlitz@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: roland@kernel.org, stable@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 06, 2013 at 11:38:38AM +0300, Or Gerlitz wrote:
> Hi Greg,
> 
> This series contains few fixes to the IB core, mlx4 IB driver and IPoIB. 
> 
> The patches enable working properly with IPoIB devices set over SRIOV 
> Virtual Functions probed to VMs in cloud environment when the cloud 
> management system uses non trivial settings of IB PKEYs (Partition-Keys
> , sort of Ethernet vlans equivalent).

That really sounds like a new feature, and not a bugfix, for these
devices, right?

I need an agreement from the IB maintainers that this really is stable
material before I can accept it.

greg k-h
