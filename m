From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Common infrastructure for auto loading
 rdma modules
Date: Tue, 25 Jul 2017 11:39:47 -0600
Message-ID: <20170725173947.GA10905@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500929067-1583-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501002916.8931.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501002916.8931.4.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 05:15:18PM +0000, Bart Van Assche wrote:

Got all the spelling errors, thanks

> > +ib_ipoib
> > +
> > +# Access to fabric management SMPs and GMPs from userspace.
> > +ib_umad
> > +
> > +# SCSI Remote Protocol target support
> > +# ib_srpt
> > +
> > +# ib_ucm provides the obsolete /dev/infiniband/ucm0
> > +# ib_ucm
> 
> If ib_iser is loaded by default, should ib_srp also be loaded by default if the
> appropriate hardware is present? I don't think that there are fewer SRP users
> than iSER users.

ib_srp now autoloads when srp_daemon is started, which AFAIK, is a
requirement to use srp? Since it autoloads it does not need to be
specified in this file any more.

Generally as things learn to autoload they should be removed from
these files, and people should be really thinking hard about getting
things to autoload as it solves hard boot time ordering problems and
races.

iser is left uncommented only because that is historically what RH has
done by default. 

> > diff --git a/kernel-boot/rdma-description.rules b/kernel-boot/rdma-description.rules
> > [ ... ]
> > +# Hardware that supports RoCE
> > +DRIVERS=="be2net", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="bnxt_en", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="hns", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="i40e", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="mlx4_core", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="mlx5_core", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="qede", ENV{ID_RDMA_ROCE}="1"
> 
> Should the "rdma_rxe" driver be added to this list?

No.. I need to figure out something else for rxe. We have no way in
RDMA to determine the driver binding to the RDMA device (eg like
ethtool -i), the above is detecting which driver is bound to the PCI
device that the RDMA device is a child of.

Since rxe doesn't work that way, it cannot use this detection method.

What I'd like is proper kernel support to determine ID_RDMA_*, which I
think we can ultimately implement in Leon's rdma netlink.

> > +ENV{ID_NET_DRIVER}=="mlx4_en", RUN{builtin}+="kmod load mlx4_ib"
> > +ENV{ID_NET_DRIVER}=="mlx5_core", RUN{builtin}+="kmod load mlx5_ib"
> 
> Why this inconsistency between mlx4 and mlx5?

This is matching the net driver name (eg struct ethtool_drvinfo ->
driver) used by each thing.. As far as I can tell these are the names
Mellanox choose to report here. I think it reflects that in mlx5 the
mlx5_core module provides the netdevice support, while in mlx4 it is
in the mlx4_en module.

> Additionally, if these rules are added, shouldn't the
> request_module() calls be removed from the mlx4 and ml5 core
> drivers?

This approach still relies on those request_modules to support pure-IB
versions of Mellanox cards. I would think the rocee related
request_modules should ultimately be removed though.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
