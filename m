From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 16:02:10 -0600
Message-ID: <20170725220210.GA15663@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
 <20170725164004.GA20959@obsidianresearch.com>
 <011601d30576$c3ac38c0$4b04aa40$@opengridcomputing.com>
 <20170725213354.GE10905@obsidianresearch.com>
 <016901d30590$3eee9910$bccbcb30$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <016901d30590$3eee9910$bccbcb30$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 04:52:01PM -0500, Steve Wise wrote:

> > This sort of hotplug that cxbg4 does is quite strange, what happens
> > when 'ip link set X down' is done? Does it remove the RDMA device?
> > Does 'ip link set down' block until all users go away?
> 
> No.  iw_cxgb4 just triggers on the first 'up', to add the rdma provider instance
> for that device.  The Low Level Driver (LLD), cxgb4, passes the CXGB4_STATE_UP
> event to all registered upper level drivers (ULDs) when the first port is
> enabled (see cxgb_up).  Any rdma connections that are active when a link goes
> down still function, as any TCP connection would function if the interface was
> brought down;  eg: tcp retransmits if there is pending data until it gives up
> and aborts the connection.  So Netdev link down/up transitions are hidden from
> the rdma application.   

I think you should change this to create the RDMA device when the
module is installed and the hardware is present..

> > This is going to make it harder for cxgb users to get a reliably
> > bootup at this time, we need more kernel autoloading for things to be
> > reliable, and I'm sure iwpmd.service needs some dependency adjusting,
> > I just don't know enough about it to do it right. :\
> 
> I don't understand?

At the present moment udev will start running rules at the link up
time, which happens sometime around 'network.target'

However, systemd will continue processing unknowing what udev is
doing.

So, if you have a RDMA enabled daemon, and you make it start after the
RDMA device is plugged we have some races..

- udev is creating /dev/ nodes and telling systemd to start module loading
  units, and run iwpmd
- systemd may have already started loading the RDMA daemon before udev
  gets to any of this (racy) eg the /dev/ nodes may not exist yet, or
  the modules may still in process to be loaded
- systemd may have started iwpmd, but it is not yet ready and then
  starts the RDMA daemon (racy differently, this is helped with
  sd_notify)
- The RDMA daemon now needs explicit dependencies on the RDMA device
  to order properly, something simple like sysinit.target isn't going to work

Basically, it is very hard to start a RDMA daemon and not have it race
with something and randomly fail to start properly the more hotpluggy
things are.

The existing RDMA stuff largely relies on some sequentiality, eg
loading the RDMA module is enough to create the RDMA device, and that
more reliably happens before sysinit.target, so we can create some
predictable ordering in the system.

This is also why I have been so insistent that the only way to make
all of this work properly and reliably is to have robust kernel auto
loading.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
