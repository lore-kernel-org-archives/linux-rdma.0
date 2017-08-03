From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Thu, 3 Aug 2017 11:52:42 -0600
Message-ID: <20170803175242.GA31628@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501256525.4572.44.camel@profitbricks.com>
 <20170728154749.GA9646@obsidianresearch.com>
 <1501260065.4572.47.camel@profitbricks.com>
 <20170728165614.GA14302@obsidianresearch.com>
 <1501761659.3581.2.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501761659.3581.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 03, 2017 at 02:00:59PM +0200, Benjamin Drung wrote:

> Yes. That was the issue. I am using an initrd (from initramfs-tools).
> The mlx4_core module was included in the initrd, but mlx4_ib was
> missing. I tweaked initramfs-tools to include mlx4_ib and then it was
> autoloaded. Thanks.

Do you know how to fix this generally for Debian? Is it possible?

> Remaining problem: The IPoIB InfiniBand partition does not come up
> correctly:

AFAIK, M-DOWN means 'master-down', it means that the interface 'ib1'
is down. 'ip link set up dev ib1'

Something wrong with ordering of the legacy network setup script?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
