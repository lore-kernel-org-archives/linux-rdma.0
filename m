From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Fri, 28 Jul 2017 17:42:05 +0200
Message-ID: <1501256525.4572.44.camel@profitbricks.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501194685-9447-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

Am Donnerstag, den 27.07.2017, 16:31 -0600 schrieb Jason Gunthorpe:
> Here is the next revision of the systemd module autoloading approach.
> 
> All the comments have been collected and a few other things
> addressed.
> 
> Notably, at least on debian, when rdma-core is installed for the
> first time it
> activates the new udev rules and moduels autoload immediately, no
> reboot
> required. Not sure about RH's policies, so leaving this to them to
> copy if
> desired.
> 
> There have been positive test results now for rxe, mlx4 (IB), qedr
> and cxgb4
> on Debian derived.
> 
> This is now a PR:
> 
>  https://github.com/linux-rdma/rdma-core/pull/174/commits

thanks for your work. I reviewed the commits and commented them on
GitHub.

I tested the whole patch set on our Debian jessie system (with Mellanox
OFED kernel modules on kernel 4.4), but it failed to load properly.

The mlx4_core module was loaded, but not mlx4_ib. The directory
/sys/class/infiniband is empty.

$ sudo find /sys/ -name '*mlx*'
/sys/bus/pci/drivers/mlx4_core
/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/mlx4_port1_mtu
/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/mlx4_port2_mtu
/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/mlx4_port1
/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/mlx4_port2

$ journalctl | grep mlx
mlx4_core: Mellanox ConnectX core driver v3.3-1.0.4 (03 Jul 2016)
mlx4_core: Initializing 0000:02:00.0
mlx4_core: device is working in RoCE mode: Roce V1
mlx4_core: gid_type 1 for UD QPs is not supported by the devicegid_type 0 was chosen instead
mlx4_core: UD QP Gid type is: V1
mlx4_core 0000:02:00.0: PCIe link speed is 8.0GT/s, device supports 8.0GT/s
mlx4_core 0000:02:00.0: PCIe link width is x8, device supports x8

No clue how to further debug it.

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
