From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/5 RFC] IB/mad: Add kernel trace to umad/mad
Date: Thu,  1 Oct 2015 00:51:24 -0400
Message-ID: <1443675089-11786-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This has mild testing and still has some FIXMEs etc.  I'm submitting to help
decide if we wish to remove the MAD snooping infrastructure.

I believe this to be a more efficient debugging mechanism as it is most always
available (if debugfs is available) and should have limited performance impact
when off.


Ira Weiny (5):
  IB/MAD: add send path trace points
  IB/MAD: add recv path trace point
  IB/MAD Add agent trace points
  IB/mad: Add umad trace points
  IB/mad: Add SMP tracing

 drivers/infiniband/core/mad.c      |  72 +++++++
 drivers/infiniband/core/user_mad.c |   5 +
 include/trace/events/ib_mad.h      | 385 +++++++++++++++++++++++++++++++++++++
 include/trace/events/ib_umad.h     | 312 ++++++++++++++++++++++++++++++
 4 files changed, 774 insertions(+)
 create mode 100644 include/trace/events/ib_mad.h
 create mode 100644 include/trace/events/ib_umad.h

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
