From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Fri, 28 Jul 2017 09:47:49 -0600
Message-ID: <20170728154749.GA9646@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501256525.4572.44.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501256525.4572.44.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 28, 2017 at 05:42:05PM +0200, Benjamin Drung wrote:

> $ journalctl | grep mlx
> mlx4_core: Mellanox ConnectX core driver v3.3-1.0.4 (03 Jul 2016)
> mlx4_core: Initializing 0000:02:00.0
> mlx4_core: device is working in RoCE mode: Roce V1

So you are running purely in roce mode?

What does this say:

$ udevadm info /sys/class/net/XXX

Where 'XXX' is the ethernet device for the mlx4?

> No clue how to further debug it.

This is the line that is expected to load mlx4_ib:

ENV{ID_NET_DRIVER}=="mlx4_en", RUN{builtin}+="kmod load mlx4_ib"

So we should see ID_NET_DRIVER=mlx4_en in the above udevadm print.

>From there run

$ udevadm test /sys/class/net/XXX

And confirm it tries to load the module..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
