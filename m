From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/8] IPoIB: Fix multiple race conditions
Date: Wed, 3 Sep 2014 16:52:20 +0300
Message-ID: <54071D14.9040404@mellanox.com>
References: <cover.1407885724.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/13/2014 2:38 AM, Doug Ledford wrote:
> Locking of multicast joins/leaves in the IPoIB layer have been problematic
> for a while.  There have been recent changes to try and make things better,
> including these changes:
>
> bea1e22 IPoIB: Fix use-after-free of multicast object
> a9c8ba5 IPoIB: Fix usage of uninitialized multicast objects
>
> Unfortunately, the following test still fails (miserably) on a plain
> upstream kernel:
>
> pass=0
> ifdown ib0
> while true; do
>      ifconfig ib0 up
>      ifconfig ib0 down
>      echo "Pass $pass"
>      let pass++
> done
>
> This usually fails within 10 to 20 passes, although I did have a lucky
> run make it to 300 or so.  If you happen to have a P_Key child interface,
> it fails even quicker.

Hi Doug,

Thanks for looking on that. I wasn't aware we're doing so badly... I 
checked here and the plan is that Erez Shitrit from Mellanox will also 
be providing feedback on the series.

Anyway, just to make sure we're on the same page, people agree that 
picking such series is too heavy for post merge window, right? so we are 
talking on 3.18, agree?

Or.

>
> In tracking down the rtnl deadlock in the multicast code, I ended up
> re-designing the flag usage and clean up just the race conditions in
> the various tasks.  Even that wasn't enough to resolve the issue entirely
> though, as if you ran the test above on multiple interfaces simultaneously,
> it could still deadlock.  So in the end I re-did the workqueue usage too
> so that we now use a workqueue per device (and that includes P_Key devices
> have dedicated workqueues) as well as one global workqueue that does
> nothing but flush tasks.  This turns out to be a much more elegant way
> of handling the workqueues and in fact enabled me to remove all of the
> klunky passing around of flush parameters to tell various functions not
> to flush the workqueue if it would deadlock the workqueue we are running
> from.
>
> Here is my test setup:
>
> 2 InfiniBand physical fabrics: ib0 and ib1
> 2 P_Keys on each fabric: default and 0x8002 on ib0 and 0x8003 on ib1
> 4 total IPoIB devices that I have named mlx4_ib0, mlx4_ib0.8002,
>    mlx4_ib1, and mlx4_ib1.8003
>
> In order to test my final patch set, I logged into my test machine on
> four different virtual terminals, I used ifdown on all of the above
> interfaces to get things in a consistent state, and then I ran the above
> loop, one per terminal per interface simultaneously.
>
> It's worth noting here that when you ifconfig a base interface up, it
> automatically brings up the child interface too, so the ifconfig mlx4_ib0
> up is in fact racing with both ups and downs of mlx4_ib0.8002.  The same
> is true for the mlx4_ib1 interface and its child.  With my patch set in
> place, these loops are currently running without a problem and have passed
> 15,000 up/down cycles per interface.
>
> Doug Ledford (8):
>    IPoIB: Consolidate rtnl_lock tasks in workqueue
>    IPoIB: Make the carrier_on_task race aware
>    IPoIB: fix MCAST_FLAG_BUSY usage
>    IPoIB: fix mcast_dev_flush/mcast_restart_task race
>    IPoIB: change init sequence ordering
>    IPoIB: Use dedicated workqueues per interface
>    IPoIB: Make ipoib_mcast_stop_thread flush the workqueue
>    IPoIB: No longer use flush as a parameter
>
>   drivers/infiniband/ulp/ipoib/ipoib.h           |  19 +-
>   drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  18 +-
>   drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  27 ++-
>   drivers/infiniband/ulp/ipoib/ipoib_main.c      |  49 +++--
>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 239 ++++++++++++++++---------
>   drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  22 ++-
>   6 files changed, 240 insertions(+), 134 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
