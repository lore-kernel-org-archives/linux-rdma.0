From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 11:43:49 -0500
Message-ID: <00f401d30565$311ee360$935caa20$@opengridcomputing.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com> <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com> <20170725164004.GA20959@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170725164004.GA20959-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> >
> > Hey Jason,
> >
> > Thanks for doing all this!  I'm testing with cxgb4 today.
> >
> > I get these errors building the rpms using the spec file in your tree:
> 
> I think you are using ./rdma-core.spec? I forgot about that one and
> didn't make it work, I will fix it.
> 
> You probably want to use redhat/rdma-core.spec anyhow?
>

Ok.  I haven't been paying attention to the distro-specific stuff. I had a
process I have been following to build an rpm from ./rdma-core.spec.  I'll try
the redhat spec file since I'm installing on a RHEL7.2 system.
 
> When testing, you want to start with a system that doesn't load any
> modules, then install the new rpms and see what happens. (rdma-core, iwpmd)
> 

I've uninstalled all the pertinent packages, I think, with this:

yum autoremove -y libibverbs librdmacm libibumad libiwpm

> For iwarp I expect that systemd will auto start these units:
> 
>   rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org  loaded active     exited    Load RDMA
> modules from /etc/rdma/modules/iwpmd.conf
>   rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org   loaded active     exited    Load RDMA
modules
> from /etc/rdma/modules/rdma.conf
>   rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org  loaded active     exited    Load RDMA
modules
> from /etc/rdma/modules/iwarp.conf
>   iwpmd.service                    loaded active     running   iWarp Port
Mapper
> 
> And you should have a reasonable set of modules loaded. Check the
> journal for interesting errors also..
> 

Will do.

> For cxgb4 these are the two critical udev lines:
> 
> ENV{ID_NET_DRIVER}=="cxgb4", RUN{builtin}+="kmod load iw_cxgb4"
> DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"
> 
> The first should load iw_cxgb4 if an ethernet device with the cxgb4
> driver is found (the driver name being matched is as reported by
> ethtool -i)
> 
> Both need to trigger for things to work properly, you can check with:
> 
> $ udevadm info /sys/class/net/ethX
> $ udevadm info /sys/class/infiniband/cxgb4_0 # ??
>

Thanks!  I'll let you know how it goes.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
