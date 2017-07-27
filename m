From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Thu, 27 Jul 2017 10:36:35 -0600
Message-ID: <20170727163635.GA13245@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <BN3PR07MB257807A6AE85B9B5575AAD7AF8BE0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB257807A6AE85B9B5575AAD7AF8BE0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 27, 2017 at 07:47:03AM +0000, Amrani, Ram wrote:
> Hi Jason,
> 
> > I do not have nearly enough hardware to exhaustively test this, I have checked
> > that the basic elements are working, but there is lots of room for little
> > errors, particularly in module names and udev matching. It would be great of
> > someone could try this on iwarp hardware and confirm all the autoloading works
> > as expected.
> > 
> > As should the active roce vendors. I expect that all roce hardware will
> > autoload the RDMA modules with this approach.
> 
> It works for qedr.
> 
> I have followed Steve's steps and built the rpms on Red Hat 7.3 from
> your repo/systemd.  I've removed all the previous libraries and
> 98-rdma.rules and then installed the newly built rpms After that I
> rebooted and qedr was loaded.  I didn't have to configure the
> interfaces as Steve did (ifconfig <device> up).

Okay, that is good.. I thin kthe ifconfig up thing is unique to cxgb4

> I've notice that 98-rdma.rules got recreated, but the new file
> doesn't contain any qed entry.

Because no-one sent a patch for the RedHat boot stuff when QED was
merged..

> Why is it recreated? If it is in use, why isn't qed listed?

The redhat/rdma-core.spec packaging (used by cbuild/etc) still
includes this file, you will have to remove it manually.

> > +# Hardware that supports iWarp
> > +DRIVERS=="cxgb3", ENV{ID_RDMA_IWARP}="1"
> > +DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"
> > +
> > +# Hardware that supports RoCE
> > +DRIVERS=="be2net", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="bnxt_en", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="hns", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="i40e", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="mlx4_core", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="mlx5_core", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="qede", ENV{ID_RDMA_ROCE}="1"
> 
> We've recently sent iWARP patches this means qede will be used by
> either RoCE or iWARP.  In any case the RDMA driver is the same -
> qedr.

For the interm, you should research this and find a way to tell what
mode the RDMA device is in from sysfs, eg you may be able to match the
node_type sysfile or something else appropraite for your device.

You want set the ID_ tags properly if possible.

If you cannot, then you must set both tags to get correct behavior in
all situations (as the mlx drivers do)

My hope is to eventually have this work automatically, but that would
be based on the rdma netlink Leon is working on.

> Can you explain what effect does this ENV property has on actual
> operation?  How do you think it should look in the light of the
> upcoming patch?

Within rdma-core ID_RDMA_IWARP will cause /etc/rdma/modules/iwarp.conf
to be processed and iwpmd to be started.

ID_RDMA_ROCE will cause /etc/rdma/modules/roce.conf to be processed.

Due to iwpmd it is best to get this right.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
