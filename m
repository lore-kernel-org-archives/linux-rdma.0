From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow
Date: Thu, 15 Jan 2015 09:19:39 +0000
Message-ID: <DBXPR05MB067182B666A7F24EE23DC8ADB64E0@DBXPR05MB0671.eurprd05.prod.outlook.com>
References: <cover.1421264928.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421264928.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Thank you for the quick response.

Now I can see 2 issues, that I want to draw your attention to:

1. if there is a mcg that the driver failed to join, the mc_task enters to endless loop of re-queue, and the log will be full with the next messages:
[682560.569826] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.580136] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.590364] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.600504] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.610627] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.620769] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.631082] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.640835] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
[682560.651033] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.660758] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
[682560.670923] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.680676] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
[682560.690898] ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting sendonly join
[682560.700630] ib0: sendonly multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22

around 100 times a sec.

2. IPv6 still doesn't work for me, at the same case where it is not the first mcg in the list.

Thanks, Erez

-----Original Message-----
From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org] 
Sent: Wednesday, January 14, 2015 9:53 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai; Eyal Perry; Erez Shitrit; Or Gerlitz; Doug Ledford
Subject: [PATCH V3 FIX For-3.19 0/3] IB/ipoib: Fix multicast join flow

This patch series fixes the multicast join behavior problems introduced by my previous patchset.  In particular, the original code did not use the send only join code from the multicast thread context, and so it did not need to restart the multicast thread.  After my previous patchset, it does get called from the thread context, and so the send only join completion areas need to restart the join thread but they don't.  This patchset makes them do so.  It then adds in some cleanups for restarting the thread, and fixes the fact that one delayed join holds up the entire list of joins.

v3: Resend because the last send didn't register in patchworks properly
    (because the subject-prefix was not on all of the emails, only the
    first) and because the Cc: list didn't not pass from cover letter
    to patches

v2: Added two new patches, the first creates a helper to restart the
    multicast join thread and also adds using it in the two places where
    it should have been used but wasn't, the second allows the joins to
    proceed around a delayed join instead of stalling everything.

v1: Addressed the usage of the IPOIB_MCAST_RUN flag

Doug Ledford (3):
  IB/ipoib: Fix failed multicast joins/sends
  IB/ipoib: Add a helper to restart the multicast task
  IB/ipoib: make delayed tasks not hold up everything

 drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 94 ++++++++++++++++++--------
 2 files changed, 66 insertions(+), 29 deletions(-)

--
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
