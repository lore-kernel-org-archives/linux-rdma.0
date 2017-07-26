From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Wed, 26 Jul 2017 10:24:19 -0600
Message-ID: <20170726162419.GC20499@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
 <20170725164004.GA20959@obsidianresearch.com>
 <011601d30576$c3ac38c0$4b04aa40$@opengridcomputing.com>
 <20170725213354.GE10905@obsidianresearch.com>
 <016901d30590$3eee9910$bccbcb30$@opengridcomputing.com>
 <20170725220210.GA15663@obsidianresearch.com>
 <009901d30618$2d957e30$88c07a90$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <009901d30618$2d957e30$88c07a90$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 26, 2017 at 09:05:03AM -0500, Steve Wise wrote:

> > I think you should change this to create the RDMA device when the
> > module is installed and the hardware is present..
> >
> 
> Not gonna happen.  cxgb4 doesn't setup the queues, rss, irq mappings, etc, until
> an interface is brought up.  So iw_cxgb4 cannot initialize and register with the
> rdma core until that happens. 

But it doesn't tear all that stuff down on ifdown?

> > Basically, it is very hard to start a RDMA daemon and not have it race
> > with something and randomly fail to start properly the more hotpluggy
> > things are.
> 
> I think these races exist today, no?  Or is this patch series introducing the
> races?   The iwpmd does not need the providers registered at the time it starts.
> It will discover new iwarp providers as they initialize. 

There are races today, particularly with systemd, but I suspect they
are slightly different.. That doesn't mean we should ignore them :)

In particular the rdma.target approach loaded all the modules, even if
there wasn't hardware support, so when the cxgb4 RDMA device is
created everything is already to go. We still have races, but they are
probably smaller

Now, we don't even plug the modules until the RDMA device appears, so
we have broader possibilities for racing..

Overall it makes it hard to fit into the ideal system configuration
where RDMA sets up before network-pre.target when a RDMA device
doesn't even plug in until after network.target.

> Can you think of other ways to address your concerns?

Maybe we should have udev trigger loading iwarp services on the cxgb4
ethernet device? At least the races then become more like what we had
before. Are other roce/iwarp devices like this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
