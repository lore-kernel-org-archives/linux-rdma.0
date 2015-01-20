From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for multicast
 handling
Date: Tue, 20 Jan 2015 18:16:38 +0200
Message-ID: <54BE7F66.4070404@dev.mellanox.co.il>
References: <cover.1421725318.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421725318.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/20/2015 5:58 AM, Doug Ledford wrote:
> These patches are to resolve issues created by my previous patch set.
> While that set worked fine in my testing, there were problems with
> multicast joins after the initial set of joins had completed.  Since my
> testing relied upon the normal set of multicast joins that happen
> when the interface is first brought up, I missed those problems.
>
> Symptoms vary from failure to send packets due to a failed join, to
> loss of connectivity after a subnet manager restart, to failure
> to properly release multicast groups on shutdown resulting in hangs
> when the mlx4 driver attempts to unload itself via its reboot
> notifier handler.
>
> This set of patches has passed a number of tests above and beyond my
> original tests.  As suggested by Or Gerlitz I added IPv6 and IPv4
> multicast tests.  I also added both subnet manager restarts and
> manual shutdown/restart of individual ports at the switch in order to
> ensure that the ENETRESET path was properly tested.  I included
> testing, then a subnet manager restart, then a quiescent period for
> caches to expire, then restarting testing to make sure that arp and
> neighbor discovery work after the subnet manager restart.
>
> All in all, I have not been able to trip the multicast joins up any
> longer.
>
> Additionally, the original impetus for my first 8 patch set was that
> it was simply too easy to break the IPoIB subsystem with this simple
> loop:
>
> while true; do
>      ifconfig ib0 up
>      ifconfig ib0 down
> done
>
> Just to be safe, I made sure this problem did not resurface.
>
> Roland, the 3.19-rc code is broken.  We either need to revert my
> original patchset, or grab these, but I would not recommend leaving
> it as it currently stands.
>
> Doug Ledford (7):
>    IB/ipoib: Fix failed multicast joins/sends
>    IB/ipoib: Add a helper to restart the multicast task
>    IB/ipoib: make delayed tasks not hold up everything
>    IB/ipoib: Handle -ENETRESET properly in our callback
>    IB/ipoib: don't restart our thread on ENETRESET
>    IB/ipoib: remove unneeded locks
>    IB/ipoib: fix race between mcast_dev_flush and mcast_join
>
>   drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 204 +++++++++++++++----------
>   2 files changed, 121 insertions(+), 84 deletions(-)
>
Hi Doug,

After trying your V4 patch series, I can tell that first, the endless 
scheduling of
the mcast task is indeed over, but still, the multicast functionality in 
ipoib is unstable.

I see that there are times that ping6 works good, and sometimes it 
doesn't, to
make it clear I always use the link-local address assigned by the stack 
to the
IPoIB device, see [1] below for how I run it.

I also see that send-only mcast stops working from time to time, see [2] 
below
for how I run this. I can narrow the problem to be on the sender 
(client) side,
since I work with a peer node which has well functioning IPoIB multicast 
code.

One more phenomena, that in some cases I can see that the driver (after the
mcast_debug_level is set) prints endless message:
"ib0: no address vector, but multicast join already started"

One practical solution here would be to revert the offending commit 3.19-rc1
016d9fb "IPoIB: fix MCAST_FLAG_BUSY usage".

Thanks, Erez

1] IPv6 ping

$ ping6 fe80::202:c903:9f:3b0a -I ib0
where the IPv6 address is the one displayed by "ip addr show dev ib0" on 
the remote node

[2] IPv4 multicast

# server
$ route add -net 224.0.0.0 netmask 240.0.0.0 dev ib0
$ netserver

# client
$ route add -net 224.0.0.0 netmask 240.0.0.0 dev ib0
$ netperf -H 11.134.33.1 -t omni -- -H 225.5.5.4 -T udp -R 1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
