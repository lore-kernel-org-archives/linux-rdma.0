From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] IPoIB: Fix multiple race conditions
Date: Fri, 15 Aug 2014 15:08:08 -0700
Message-ID: <CABgxfbEGfiNGUKT4NJi1GoDRouFznxpgogDt5yr47TLfwDB7hA@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Cheng, Wendy" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
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
>     ifconfig ib0 up
>     ifconfig ib0 down
>     echo "Pass $pass"
>     let pass++
> done
>
> This usually fails within 10 to 20 passes, although I did have a lucky
> run make it to 300 or so.  If you happen to have a P_Key child interface,
> it fails even quicker.
>
[snip]
>
> Doug Ledford (8):
>   IPoIB: Consolidate rtnl_lock tasks in workqueue
>   IPoIB: Make the carrier_on_task race aware
>   IPoIB: fix MCAST_FLAG_BUSY usage
>   IPoIB: fix mcast_dev_flush/mcast_restart_task race
>   IPoIB: change init sequence ordering
>   IPoIB: Use dedicated workqueues per interface
>   IPoIB: Make ipoib_mcast_stop_thread flush the workqueue
>   IPoIB: No longer use flush as a parameter
>

IPOIB is recently added as a technology preview for Intel Xeon Phi
(currently a PCIe card) that runs embedded Linux (named MPSS) with
Infiniband software stacks supported via emulation drivers. One early
feedback from users with large cluster nodes is IPOIB's power
consumption. The root cause of the reported issue is more to do with
how MPSS handles its DMA buffers (vs. how Linux IB stacks work) - so
submitting the fix to upstream is not planned at this moment (unless
folks are interested in the changes).

However, since this patch set happens to be in the heart of the
reported power issue, we would like to take a closer look to avoid
MPSS code base deviating too much from future upstream kernel(s).
Question, comment, and/or ack will follow sometime next week.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
