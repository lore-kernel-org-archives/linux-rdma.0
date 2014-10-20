From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Minor patches previous missed
Date: Mon, 20 Oct 2014 19:24:51 -0400
Message-ID: <cover.1413847199.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The first is a resend of the find_cached_pkey usage.  Since I never
a valid technical argument for not using the cache function in our last
interaction, and as most people agree that having two distinct code paths
that do the same thing for no good reason doubles maintenance and
debugging burdens, I'll keep submitting it until there is an alternative
or it is accepted.

The second is a rework of the patch I did before for the ib_srpt printks
to match what you requested (usage of pr_* functions instead of fixing 
up printks).

Bart Van Assche (1):
  IB/srp: Use P_Key cache for P_Key lookups

Doug Ledford (1):
  ib_srpt: convert printk's to pr_* functions

 drivers/infiniband/ulp/srp/ib_srp.c   |   9 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c | 188 ++++++++++++++++------------------
 2 files changed, 96 insertions(+), 101 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
