From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Fri, 04 Aug 2017 18:22:31 +0200
Message-ID: <1501863751.3581.19.camel@profitbricks.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1501256525.4572.44.camel@profitbricks.com>
         <20170728154749.GA9646@obsidianresearch.com>
         <1501260065.4572.47.camel@profitbricks.com>
         <20170728165614.GA14302@obsidianresearch.com>
         <1501761659.3581.2.camel@profitbricks.com>
         <20170803175242.GA31628@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803175242.GA31628-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Donnerstag, den 03.08.2017, 11:52 -0600 schrieb Jason Gunthorpe:
> On Thu, Aug 03, 2017 at 02:00:59PM +0200, Benjamin Drung wrote:
> 
> > Yes. That was the issue. I am using an initrd (from initramfs-
> > tools).
> > The mlx4_core module was included in the initrd, but mlx4_ib was
> > missing. I tweaked initramfs-tools to include mlx4_ib and then it
> > was
> > autoloaded. Thanks.
> 
> Do you know how to fix this generally for Debian? Is it possible?

Analysis for Debian jessie/stretch:

$ sudo update-initramfs -uv
[...]
Copying module directory kernel/drivers/net
(excluding appletalk arcnet bonding can dummy.ko hamradio hippi ifb.ko
irda macvlan.ko macvtap.ko pcmcia sb1000.ko team tokenring tun.ko usb
veth.ko wan wimax wireless xen-netback.ko)
[...]
Adding module /lib/modules/$version/kernel/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko
Adding module /lib/modules/$version/kernel/drivers/net/ethernet/mellanox/mlx4/mlx4_core.ko

update-initramfs calls auto_add_modules() in
/usr/share/initramfs-tools/hook-functions which includes 'net' as
default. The 'net' option calls 
"copy_modules_dir kernel/drivers/net [...]" which copies the
mlx5_core.ko and mlx4_core.ko modules.

but the mlx4_ib.ko module is in the infiniband directory:

$ find kernel/drivers/infiniband ! -type d
kernel/drivers/infiniband/hw/mlx5/mlx5_ib.ko
kernel/drivers/infiniband/hw/mthca/ib_mthca.ko
kernel/drivers/infiniband/hw/mlx4/mlx4_ib.ko
kernel/drivers/infiniband/core/ib_sa.ko
kernel/drivers/infiniband/core/ib_umad.ko
kernel/drivers/infiniband/core/ib_netlink.ko
kernel/drivers/infiniband/core/ib_core.ko
kernel/drivers/infiniband/core/rdma_cm.ko
kernel/drivers/infiniband/core/ib_ucm.ko
kernel/drivers/infiniband/core/ib_addr.ko
kernel/drivers/infiniband/core/rdma_ucm.ko
kernel/drivers/infiniband/core/ib_cm.ko
kernel/drivers/infiniband/core/ib_uverbs.ko
kernel/drivers/infiniband/core/iw_cm.ko
kernel/drivers/infiniband/core/ib_mad.ko
kernel/drivers/infiniband/ulp/ipoib/ib_ipoib.ko
kernel/drivers/infiniband/ulp/srp/ib_srp.ko

By default, nothing from the infiniband directory is included. The
question is: What is the right thing to do? Should everything from
kernel/drivers/infiniband/hw be included in the initrd by default?

> > Remaining problem: The IPoIB InfiniBand partition does not come up
> > correctly:
> 
> AFAIK, M-DOWN means 'master-down', it means that the interface 'ib1'
> is down. 'ip link set up dev ib1'
> 
> Something wrong with ordering of the legacy network setup script?

Thanks. The master-down is correct, since we just use only the
InifiniBand partition and not the master device. Even the old
configuration had M-DOWN.

My ping tests were incorrect. I compared the IP configuration with the
previous configuration and it was identical. Then I discovered that the
ping target was not reachable even with the old configuration. I took a
different host that was pingable with the old config and this one was
pingable with rdma-core too. So rdma-core works as designed.

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
