From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/8] IB/srp bug fixes
Date: Fri, 10 Feb 2017 15:56:03 -0800
Message-ID: <20170210235611.3243-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

The patches in this series are the initiator patches I came up with while
testing the SRP initiator and target drivers. Please consider these patches
for inclusion in the upstream kernel.

Sorry for sending these patches so close to the merge window. If this means
that it's too late to include these patches in the first kernel v4.11 pull
request that's fine with me.

Bart Van Assche (8):
  IB/srp: Avoid that duplicate responses trigger a kernel bug
  IB/srp: Fix race conditions related to task management
  IB/srp: Document locking conventions
  IB/srp: Make a diagnostic message more informative
  IB/srp: Improve an error path
  IB/srp: Use the IB_DEVICE_SG_GAPS_REG HCA feature if supported
  IB/core: Add support for draining IB_POLL_DIRECT completion queues
  IB/srp: Drain the send queue before destroying a QP

 drivers/infiniband/core/verbs.c     |  35 +++++-----
 drivers/infiniband/ulp/srp/ib_srp.c | 129 ++++++++++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |   1 +
 3 files changed, 103 insertions(+), 62 deletions(-)

-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
