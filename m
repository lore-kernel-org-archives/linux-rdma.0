From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 23:38:23 -0600
Message-ID: <20150611053823.GA22369@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
 <55769561.8000300@mellanox.com>
 <5577FAFB.8020205@mellanox.com>
 <20150610150010.GA11243@obsidianresearch.com>
 <557852EE.5030107@mellanox.com>
 <20150610184954.GA26404@obsidianresearch.com>
 <1433984788.71666.78.camel@redhat.com>
 <20150611035727.GA16599@obsidianresearch.com>
 <1433998199.71666.144.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433998199.71666.144.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 12:49:59AM -0400, Doug Ledford wrote:

> fact that the mlx4 driver and the ocrdma driver had their own gid
> management code, there were some distinct differences between the two.
> The gid at index 0 never matched up in my testing for example.  One
> supported bonding, the other didn't.  Even if you tried to limit things
> to a cleanup, you would still end up altering behavior of both drivers
> just because the cleanup would have to merge the two implementations and
> the result would be different than either one of them.

This is very interesting detail, I would be very happy to see the user
visible functional changes to ocrdma listed in it's commit message.

I always understood that ocrdma would have some change, at least from
bonding, my 'no functional change' litmus test was that mlx4 operation
doesn't have a change. My expectation is the current v5 achieves that?

> I get the impression that a lot of the extra is scalability changes for
> perceived need (probably due to upcoming namespace/container additions).
> But, just to be fair, the entire mlx4 gid code was -500 lines and
> included bonding support.  The base gid code addition was +500 for the
> gid table, +600 for the table population functions, +170 for default
> gids, +290 for bonding support, and +140 lines to hook it into the
> existing cache routines.  While part of this might be would seem to be
> the over-designed locking, part of it is probably exactly as Matan said,
> code growth due to generalization and standardization.

Line count is such a funny metric.. It is very, very hard to write
succinct code, and I have no magic wand to shrink this particular
patch set down further. I suspect it could be made smaller, but that
would require more study than I care to employ :)

I feel line count is a hopeless avenue to argue, but also a red flag.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
