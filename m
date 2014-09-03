From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] IPoIB: Fix multiple race conditions
Date: Wed, 3 Sep 2014 09:26:04 -0700
Message-ID: <CABgxfbEz2vS2oxOfZuazJXS_PL6tN9T=evMmM=A61QguBL1-Bw@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
	<CABgxfbEGfiNGUKT4NJi1GoDRouFznxpgogDt5yr47TLfwDB7hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbEGfiNGUKT4NJi1GoDRouFznxpgogDt5yr47TLfwDB7hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Cheng, Wendy" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 15, 2014 at 3:08 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
[snip]
>>
>> Doug Ledford (8):
>>   IPoIB: Consolidate rtnl_lock tasks in workqueue
>>   IPoIB: Make the carrier_on_task race aware
>>   IPoIB: fix MCAST_FLAG_BUSY usage
>>   IPoIB: fix mcast_dev_flush/mcast_restart_task race
>>   IPoIB: change init sequence ordering
>>   IPoIB: Use dedicated workqueues per interface
>>   IPoIB: Make ipoib_mcast_stop_thread flush the workqueue
>>   IPoIB: No longer use flush as a parameter
>>
>
> IPOIB is recently added as a technology preview for Intel Xeon Phi
> (currently a PCIe card) that runs embedded Linux (named MPSS) with
> Infiniband software stacks supported via emulation drivers. One early
> feedback from users with large cluster nodes is IPOIB's power
> consumption. The root cause of the reported issue is more to do with
> how MPSS handles its DMA buffers (vs. how Linux IB stacks work) - so
> submitting the fix to upstream is not planned at this moment (unless
> folks are interested in the changes).
>
> However, since this patch set happens to be in the heart of the
> reported power issue, we would like to take a closer look to avoid
> MPSS code base deviating too much from future upstream kernel(s).
> Question, comment, and/or ack will follow sometime next week.
>

I've reviewed the patch set - the first half of the patches look good.
Patch #5,#6,#7,#8 are fine if we go for one WQ per device - will let
others do the final call.

On our system (OFED 1.5.4 based), similar deadlocks were also observed
while the power management issues were worked on. Restricted by other
issues that were specific to our platform, I took the advantage of
single IPOIB workqueue by queuing the if-up(s) and/or if-down(s) to
the work queue if one already in progress. It serialized the logic by
default. However, I would not mind one WQ per device approach and will
re-make the changes when this patch set is picked up by mainline
kernel.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
