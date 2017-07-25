From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 10:40:04 -0600
Message-ID: <20170725164004.GA20959@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 11:27:50AM -0500, Steve Wise wrote:
> > I do not have nearly enough hardware to exhaustively test this, I have checked
> > that the basic elements are working, but there is lots of room for little
> > errors, particularly in module names and udev matching. It would be great of
> > someone could try this on iwarp hardware and confirm all the autoloading works
> > as expected.
> 
> Hey Jason,
> 
> Thanks for doing all this!  I'm testing with cxgb4 today.
> 
> I get these errors building the rpms using the spec file in your tree:

I think you are using ./rdma-core.spec? I forgot about that one and
didn't make it work, I will fix it.

You probably want to use redhat/rdma-core.spec anyhow?

When testing, you want to start with a system that doesn't load any
modules, then install the new rpms and see what happens. (rdma-core, iwpmd)

For iwarp I expect that systemd will auto start these units:

  rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org  loaded active     exited    Load RDMA modules from /etc/rdma/modules/iwpmd.conf
  rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org   loaded active     exited    Load RDMA modules from /etc/rdma/modules/rdma.conf
  rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org  loaded active     exited    Load RDMA modules from /etc/rdma/modules/iwarp.conf
  iwpmd.service                    loaded active     running   iWarp Port Mapper

And you should have a reasonable set of modules loaded. Check the
journal for interesting errors also..

For cxgb4 these are the two critical udev lines:

ENV{ID_NET_DRIVER}=="cxgb4", RUN{builtin}+="kmod load iw_cxgb4"
DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"

The first should load iw_cxgb4 if an ethernet device with the cxgb4
driver is found (the driver name being matched is as reported by
ethtool -i)

Both need to trigger for things to work properly, you can check with:

$ udevadm info /sys/class/net/ethX
$ udevadm info /sys/class/infiniband/cxgb4_0 # ??

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
