From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Thu, 03 Aug 2017 14:00:59 +0200
Message-ID: <1501761659.3581.2.camel@profitbricks.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501256525.4572.44.camel@profitbricks.com>
         <20170728154749.GA9646@obsidianresearch.com>
         <1501260065.4572.47.camel@profitbricks.com>
         <20170728165614.GA14302@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170728165614.GA14302-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Freitag, den 28.07.2017, 10:56 -0600 schrieb Jason Gunthorpe:
> On Fri, Jul 28, 2017 at 06:41:05PM +0200, Benjamin Drung wrote:
> > Am Freitag, den 28.07.2017, 09:47 -0600 schrieb Jason Gunthorpe:
> > > On Fri, Jul 28, 2017 at 05:42:05PM +0200, Benjamin Drung wrote:
> > > 
> > > > $ journalctl | grep mlx
> > > > mlx4_core: Mellanox ConnectX core driver v3.3-1.0.4 (03 Jul
> > > > 2016)
> > > > mlx4_core: Initializing 0000:02:00.0
> > > > mlx4_core: device is working in RoCE mode: Roce V1
> > > 
> > > So you are running purely in roce mode?
> > 
> > I want to use mlx4_ib and IPoIB. The output is the same for a
> > properly
> > working system, but these system will load mlx4_ib and then more
> > logs
> > will appear.
> 
> This approach relies on this patch in upstream:
> 
> $ git describe --contains b046ffe54dc13ff8ae918c83bedb71aa7919d63b
> v3.13-rc1~105^2~189^2
> 
> And it works fine on my 4.13 stock systems with mlx4.

Yes, that commit is part of our 4.4 kernel.

> Are you using an initrd? If you have mlx4_core in the initrd then you
> must also have mlx4_ib and mlx4_en as well, otherwise the kernel
> triggered autoload will fail to find the module in the initrd and it
> will not be retried.

Yes. That was the issue. I am using an initrd (from initramfs-tools).
The mlx4_core module was included in the initrd, but mlx4_ib was
missing. I tweaked initramfs-tools to include mlx4_ib and then it was
autoloaded. Thanks.

Remaining problem: The IPoIB InfiniBand partition does not come up
correctly:

$ ip a
[...]
9: ib1.d00b@ib1: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc mq state UP group default qlen 1024
[...]

The corresponding config in /etc/network/interfaces:

auto ib0.d00b
iface ib0.d00b inet6 static
    address <redacted>
    netmask 64
    pre-up echo connected > /sys/class/net/$IFACE/mode
    dad-attempts 300

I tried bring up the device manually:

$ sudo ip link set dev ib0.d00b down
$ sudo ifup ib0.d00b
$ sudo ifdown ib0.d00b
$ sudo ifup ib0.d00b

But the result is still the same. It still has the M-DOWN state and
pinging other host does not work.

I haven't found useful information on the web regarding the M-DOWN
state.

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
