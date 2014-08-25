From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V5 2/2] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Mon, 25 Aug 2014 12:33:25 -0600
Message-ID: <20140825183325.GC1298@obsidianresearch.com>
References: <1408517381-17523-1-git-send-email-matanb@mellanox.com>
 <1408517381-17523-3-git-send-email-matanb@mellanox.com>
 <20140820170142.GC12605@obsidianresearch.com>
 <53F9EDCD.9060105@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53F9EDCD.9060105-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 24, 2014 at 04:51:09PM +0300, Matan Barak wrote:

> Do you refer to flowinfo?
> If so, it isn't initialized, but should be.
> 0 should be good enough, so I'll memset the whole struct.

K
 
> >What does this comment refer to? MACs should never be parsed out of
> >IPv6 addresses.
> 
> GID0 should always be valid, even if no IPv4 and IPv6 are configured.
> IPv6 link-local and multicast addresses should be parsed from the
> IPv6 address.

Might want to just clarify this is dealing with a GID, not a IPv6
address - they are not interchangable terms. I'm not sure how you are
getting a GID from a neigh though?

> >>+	timer_fd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK | TFD_CLOEXEC);
> >>+	if (-1 == timer_fd) {
> >>+		print_err("Couldn't create timer\n");
> >>+		return timer_fd;
> >>+	}
> >
> >The use of timerfd will impact the minimum OS version, have you
> >checked this is OK? Does RHEL5 still work?

> It was added in linux v2.6.25. I think that an API that's more than
> 6.5 years old is valid.

RHEL5 is using 2.6.18 as their base kernel. You should at least
consult with the OFED people to determine if this is a problem for
them.

 > 
> >>+	while (1) {
> >>+		FD_ZERO(&fdset);
> >>+		FD_SET(fd, &fdset);
> >>+		FD_SET(timer_fd, &fdset);
> >>+
> >>+		/* wait for an incoming message on the netlink socket */
> >>+		ret = select(nfds, &fdset, NULL, NULL, NULL);
> >
> >poll is a better choice here, it would also be fairly simple to remove
> >timerfd by using the timeout arg.
>
> The purpose is to have a timeout on the whole process and not per loop.

Yes, I know - it is not too hard to use poll to do that, you need to
call clock_gettime(CLOCK_MONOTONIC) to compute the relative timeout.
 
> >>+					if (sendto(sock_fd, buff, sizeof(buff),
> >>+						   0, &addr_dst.sktaddr.s,
> >>+						   addr_dst.len) < 0)
> >>+						print_err("Failed to send "
> >>+							  "packet while waiting"
> >>+							  " for
> >>events\n");
> >
> >If the earlier sendto needs to be protected by a loop looking at
> >EADDRNOTAVAIL then so does this one.
> >
> 
> If the sendto failed, we would just retry it in the next loop.

Except the error handing flow is a bit different depending on
EADDRNOTAVAIL.

> >I'm also not sure all this looping and complexity is needed... Why
> >override the kernel timers for ND?
> >
> >I would think you'd check the ND table, if there is no good entry then
> >do the send, and then watch the ND table for a FAILED/REACHABLE
> >result. The kernel timers will always transition through INCOMPLETE to
> >one of those terminal states.
> >
> >No need for more timers and retry and things, the kernel already retried.
> 
> Watching just for the ND event is problematic.
> If the user sent a packet just after we looked at the ND and before
> we waited for an event, we would probably just fail without finding
> any neighbor. 

Hmm, I don't think there is a race like that.

You start listening for ND updates, send your packet, and wait for a
transition into FAILED or REACHABLE. Whenever you send a packet a
FAILED entry will transition back to INCOMPLETE.

If someone else already has sent a packet then you start in the
INCOMPLETE state, and are still waiting to transition to FAILED or
REACHABLE.

> Regarding the retries, because we use UD and switches could
> sometimes take a few seconds to learn the network, I chose to do a
> few reties before giving up.

The kernel already has retires and timers for ND.

> >>+
> >>+	last_status = __sync_fetch_and_or(
> >>+			&neigh_handler->neigh_status,
> >>+			GET_NEIGH_STATUS_IN_PROCESS);
> >
> >Is there a thread running around in here someplace?
> >
> >Callina raw gcc intrinsic like this should really be avoided,
> >especially since this isn't a performance path. Use pthreads.
> >
> 
> The current implementation is synchronous.
> For the usage of the neigh.c entry function, those guards could be deleted.

K

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
