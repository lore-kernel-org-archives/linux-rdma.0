From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Tue, 6 Oct 2015 23:54:17 +0300
Message-ID: <CAJ3xEMhsr5uRLZ=Ur56TOpZy5XT3UbK=M1kcgjt=zx_x3HNcSQ@mail.gmail.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
	<CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
	<560AD75A.7080700@redhat.com>
	<CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A@mail.gmail.com>
	<5613F145.3040204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5613F145.3040204-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 6, 2015 at 7:05 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I'll have some sort of answer for that soon.  I spent the better part of
> last week, and what time I worked on the weekend, plus all day yesterday
> on the internal infrastructure here at Red Hat.  We're experiencing some
> growing pains in our cluster and some downtime as a result that keeps me
> from being able to test code effectively.  I wouldn't be surprised if it
> takes another day or two to get it completely sorted out (or sorted as
> best I can, some things are out of my control).  Then I have to see if
> any of the currently posted fixes for 4.3rc that I haven't grabbed yet
> resolve the iSER issue I'm seeing, then I'll move on to for-next processing.

Doug,

>From my experience with VPI (IB/RoCE) clusters, librdmacm/rping is the
answer... namely -- if you have **rping** up and running over kernel X
for both IB and RoCE, things aren't in such a bad state. If you want
to go deeper, have it working over IB non-default partition and
Ethernet VLAN.

Also, for IB multicast, mckey with IPoIB port space, iperf multicast
over IPoIB would tell you how things are.

So all to all, sans SRIOV, it should take you whole 20m to figure out
if something is really DOA over IB/RoCE HW and I believe iWARP too
(rping) - makes sense?

What we do know that needs fixing for 4.3-rc

--> RoCE, you need the patch re-posted by Haggai few hours ago
"IB/cma: Accept connection without a valid netdev on RoCE" -- without
it, RoCE isn't working.

--> **mlx5** devices and no-default IB pkeys, Haggai and Co are
working on a fix since this isn't working since 4.3-rc1. I told them
we need it till rc5.5 (i.e few days before rc6 and if not, will have
to revert some 4.3-rc1 bits.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
