From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Tue, 6 May 2014 16:47:04 -0400 (EDT)
Message-ID: <43629.5026600876$1399409244@news.gmane.org>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <1980561.1785.1398958457283.JavaMail.DougALedford@Phenom> <1828884A29C6694DAF28B7E6B8A82373992F869F@ORSMSX109.amr.corp.intel.com> <alpine.DEB.2.10.1405051754260.5069@gentwo.org> <1828884A29C6694DAF28B7E6B8A82373992F899C@ORSMSX109.amr.corp.intel.com> <alpine.DEB.2.10.1405061414460.4548@gentwo.org> <53693749.64db420a.500a.ffffe917SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.10.1405061503550.5175@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1405061503550.5175-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----- Original Message -----
> On Tue, 6 May 2014, Doug Ledford wrote:
> 
> > That table only tells the NIC to listen to specific multicast
> > addresses on the wire.  This is roughly equivalent to telling
> > the SM to subscribe the port to the multicast groups it needs
> > subscribed too.  In both cases, this merely gets the packets
> > to the card.  From there, the card (or the OS as is usually the
> > case on NICs and Ethernet multicast) must redistribute the
> > packet to all queue pairs that have subscribed to the group
> > that the packet was received from.  If you were to block it at
> > the group level, then it universally effect all applications
> > that subscribed to that group, and there might well be a number
> > of applications that did not request this behavior and would
> > be rightfully confused at the card/OS not sending them their
> > multicast packets.  So, I would suggest that the blocking of
> > loopback multicast packets needs to be "opt in" for all
> > applications.  The big hammer of blocking all loopback on an
> > entire card or an entire group, while possible, should be
> > highly discouraged.  It might work with limited applications
> > that know it is being done, but it can also lead to hard to
> > diagnose problems if you add a new application into the mix
> > and it is unaware of this hammer being used and unable to
> > handle the situation.
> 
> Right the multicast blocking occurs at the socket level for regular
> networking (see IP_MULTICAST_LOOP socket options). Socket are owned
> by the application.
> 
> 
> A QP is roughly the equivalent thing at the RDMA level. So it seems
> to me
> that blocking needs to occur at the QP level and not at the multicast
> group level as suggested by Sean.

Nobody that I know of suggested that this should occur at the multicast
group level.  I suggested, and Sean agreed with, the idea that this
should  happen at multicast join time.  That means it would be on a
per queue pair, per multicast join basis.

Setting the IP_MULTICAST_LOOP on the socket effects all joins on that
socket, so this would be a slightly different API.

Right now, the IP stack is somewhat limited in that you would have
to create two different sockets and set IP_MULTICAST_LOOP differently
on the two sockets in order to have some joins reflect your data back
and some not.  You could sort of create what I'm talking about by
using the source address block, but that would block all applications
from your IP address, not just your own sent data, and so wouldn't
really work.

My original preference would have been to allow one queue pair to
have joins in either blocked or unblocked state, that way you would
only need one queue pair for both your reflected and non-reflected
joins.  But it would be easier to have a program capable of both
sockets and RDMA connections if we make the queue pairs follow the
sockets semantics here, so I'll withdraw my concerns over the current
patch (but also wouldn't object to it being done on a per queue
pair basis either, since we don't exactly follow socket semantics
either way given that the socket semantics separate the join and
the ioctl to control this behavior, so separating qp creation
and the setting of this behavior in the RDMA API seems reasonable
too).

> The 2008 patch does exactly that and allow setting the multicast
> loopback
> blocking from user space. Moreover the support is already there for
> in
> kernel users. Could we just get that 2008 patch updated and merged?
> 
> 

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
