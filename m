From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Fri, 28 Jul 2017 18:41:05 +0200
Message-ID: <1501260065.4572.47.camel@profitbricks.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501256525.4572.44.camel@profitbricks.com>
         <20170728154749.GA9646@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170728154749.GA9646-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Freitag, den 28.07.2017, 09:47 -0600 schrieb Jason Gunthorpe:
> On Fri, Jul 28, 2017 at 05:42:05PM +0200, Benjamin Drung wrote:
> 
> > $ journalctl | grep mlx
> > mlx4_core: Mellanox ConnectX core driver v3.3-1.0.4 (03 Jul 2016)
> > mlx4_core: Initializing 0000:02:00.0
> > mlx4_core: device is working in RoCE mode: Roce V1
> 
> So you are running purely in roce mode?

I want to use mlx4_ib and IPoIB. The output is the same for a properly
working system, but these system will load mlx4_ib and then more logs
will appear.

> What does this say:
> 
> $ udevadm info /sys/class/net/XXX
> 
> Where 'XXX' is the ethernet device for the mlx4?

The net device is missing. When I load mlx4_ib manually, they will
appear and show:

$ sudo udevadm info /sys/class/net/ib0
P: /devices/pci0000:00/0000:00:02.0/0000:02:00.0/net/ib0
E: DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:02:00.0/net/ib0
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=MT27500 Family [ConnectX-3]
E: ID_MODEL_ID=0x1003
E: ID_NET_DRIVER=ib_ipoib
E: ID_PATH=pci-0000:02:00.0
E: ID_PATH_TAG=pci-0000_02_00_0
E: ID_PCI_CLASS_FROM_DATABASE=Network controller
E: ID_PCI_SUBCLASS_FROM_DATABASE=Network controller
E: ID_VENDOR_FROM_DATABASE=Mellanox Technologies
E: ID_VENDOR_ID=0x15b3
E: IFINDEX=6
E: INTERFACE=ib0
E: SUBSYSTEM=net
E: SYSTEMD_ALIAS=/sys/subsystem/net/devices/ib0
E: TAGS=:systemd:
E: USEC_INITIALIZED=65619465

> > No clue how to further debug it.
> 
> This is the line that is expected to load mlx4_ib:
> 
> ENV{ID_NET_DRIVER}=="mlx4_en", RUN{builtin}+="kmod load mlx4_ib"
> 
> So we should see ID_NET_DRIVER=mlx4_en in the above udevadm print.

Strange. It is ib_ipoib instead of mlx4_en.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
