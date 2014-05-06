From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Tue, 6 May 2014 15:08:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1405061503550.5175@gentwo.org>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <53619638.48ae0e0a.2e40.ffffec09SMTPIN_ADDED_BROKEN@mx.google.com> <5361E5C7.5030805@mellanox.com> <1980561.1785.1398958457283.JavaMail.DougALedford@Phenom> <1828884A29C6694DAF28B7E6B8A82373992F869F@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.10.1405051754260.5069@gentwo.org> <1828884A29C6694DAF28B7E6B8A82373992F899C@ORSMSX109.amr.corp.intel.com> <alpine.DEB.2.10.1405061414460.4548@gentwo.org> <53693749.64db420a.500a.ffffe917SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53693749.64db420a.500a.ffffe917SMTPIN_ADDED_BROKEN-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 6 May 2014, Doug Ledford wrote:

> That table only tells the NIC to listen to specific multicast
> addresses on the wire.  This is roughly equivalent to telling
> the SM to subscribe the port to the multicast groups it needs
> subscribed too.  In both cases, this merely gets the packets
> to the card.  From there, the card (or the OS as is usually the
> case on NICs and Ethernet multicast) must redistribute the
> packet to all queue pairs that have subscribed to the group
> that the packet was received from.  If you were to block it at
> the group level, then it universally effect all applications
> that subscribed to that group, and there might well be a number
> of applications that did not request this behavior and would
> be rightfully confused at the card/OS not sending them their
> multicast packets.  So, I would suggest that the blocking of
> loopback multicast packets needs to be "opt in" for all
> applications.  The big hammer of blocking all loopback on an
> entire card or an entire group, while possible, should be
> highly discouraged.  It might work with limited applications
> that know it is being done, but it can also lead to hard to
> diagnose problems if you add a new application into the mix
> and it is unaware of this hammer being used and unable to
> handle the situation.

Right the multicast blocking occurs at the socket level for regular
networking (see IP_MULTICAST_LOOP socket options). Socket are owned
by the application.


A QP is roughly the equivalent thing at the RDMA level. So it seems to me
that blocking needs to occur at the QP level and not at the multicast
group level as suggested by Sean.

The 2008 patch does exactly that and allow setting the multicast loopback
blocking from user space. Moreover the support is already there for in
kernel users. Could we just get that 2008 patch updated and merged?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
