From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 10:55:26 -0600
Message-ID: <20170725165526.GA3164@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
 <20170725164004.GA20959@obsidianresearch.com>
 <00f401d30565$311ee360$935caa20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00f401d30565$311ee360$935caa20$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 11:43:49AM -0500, Steve Wise wrote:
> 
> > >
> > > Hey Jason,
> > >
> > > Thanks for doing all this!  I'm testing with cxgb4 today.
> > >
> > > I get these errors building the rpms using the spec file in your tree:
> > 
> > I think you are using ./rdma-core.spec? I forgot about that one and
> > didn't make it work, I will fix it.
> > 
> > You probably want to use redhat/rdma-core.spec anyhow?
> >
> 
> Ok.  I haven't been paying attention to the distro-specific stuff. I had a
> process I have been following to build an rpm from ./rdma-core.spec.  I'll try
> the redhat spec file since I'm installing on a RHEL7.2 system.

Actually.. Humm, I've been testing the debian build. If you use the
redhat/rdma-core.spec it will include the old redhat init scheme and
that kind of invalidates the testing of the new scheme ...

I just forced pushed the needed fix to my branch so you should be able
to keep doing what you were doing.

> I've uninstalled all the pertinent packages, I think, with this:
> 
> yum autoremove -y libibverbs librdmacm libibumad libiwpm

Also the rdma package needs to go (eg rdma.service and
/lib/udev/rules.d/98-rdma.rules must not exist)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
