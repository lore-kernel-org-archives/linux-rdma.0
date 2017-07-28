From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Fri, 28 Jul 2017 10:56:14 -0600
Message-ID: <20170728165614.GA14302@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501256525.4572.44.camel@profitbricks.com>
 <20170728154749.GA9646@obsidianresearch.com>
 <1501260065.4572.47.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501260065.4572.47.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 28, 2017 at 06:41:05PM +0200, Benjamin Drung wrote:
> Am Freitag, den 28.07.2017, 09:47 -0600 schrieb Jason Gunthorpe:
> > On Fri, Jul 28, 2017 at 05:42:05PM +0200, Benjamin Drung wrote:
> > 
> > > $ journalctl | grep mlx
> > > mlx4_core: Mellanox ConnectX core driver v3.3-1.0.4 (03 Jul 2016)
> > > mlx4_core: Initializing 0000:02:00.0
> > > mlx4_core: device is working in RoCE mode: Roce V1
> > 
> > So you are running purely in roce mode?
> 
> I want to use mlx4_ib and IPoIB. The output is the same for a properly
> working system, but these system will load mlx4_ib and then more logs
> will appear.

This approach relies on this patch in upstream:

commit b046ffe54dc13ff8ae918c83bedb71aa7919d63b
Author: Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Tue Oct 15 16:55:24 2013 +0200

    net/mlx4_core: Load higher level modules according to ports type
    
    Mellanox ConnectX architecture is:  mlx4_core is the lower level
    PCI driver which register on the PCI id, and protocol specific drivers
    are depended on it: mlx4_en - for Ethernet and mlx4_ib for Infiniband.
    NIC could have multiple ports which can change their type dynamically.
    We use the request_module() call to load the relevant protocol driver
    when needed: on loading time or at port type change event.

$ git describe --contains b046ffe54dc13ff8ae918c83bedb71aa7919d63b
v3.13-rc1~105^2~189^2

And it works fine on my 4.13 stock systems with mlx4.

Are you using an initrd? If you have mlx4_core in the initrd then you
must also have mlx4_ib and mlx4_en as well, otherwise the kernel
triggered autoload will fail to find the module in the initrd and it
will not be retried.

Try rmmod mlx4_core; modprobe mlx4_core right after booting, if that
triggers all the module loads then the above is likely the problem.

> > What does this say:
> > 
> > $ udevadm info /sys/class/net/XXX
> > 
> > Where 'XXX' is the ethernet device for the mlx4?
> 
> The net device is missing. When I load mlx4_ib manually, they will
> appear and show:

Right, you are using IB mode not ROCE mode, so there is no ethernet
device expected. I didn't mean the ipoib device..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
