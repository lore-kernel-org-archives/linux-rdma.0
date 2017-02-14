From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 0/8] IB/srp bug fixes
Date: Tue, 14 Feb 2017 10:56:28 -0800
Message-ID: <20170214185636.29250-1-bart.vanassche@sandisk.com>
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

The changes compared to the previous version of this series are:
- Left out the "Use the IB_DEVICE_SG_GAPS_REG HCA feature if supported" patch.
- Added a patch to stop using memory regions with gaps since Laurence ran
  into an issue with these memory regions that cannot be explained by
  analzying the SRP initiator code only.
- Addressed Leon's comments about patch "Avoid that duplicate responses
  trigger a kernel bug" and "Add support for draining IB_POLL_DIRECT
  completion queues".

The patches in this series are:

Bart Van Assche (8):
  IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
  IB/srp: Avoid that duplicate responses trigger a kernel bug
  IB/srp: Fix race conditions related to task management
  IB/srp: Document locking conventions
  IB/srp: Make a diagnostic message more informative
  IB/srp: Improve an error path
  IB/core: Add support for draining IB_POLL_DIRECT completion queues
  IB/srp: Drain the send queue before destroying a QP

 drivers/infiniband/core/cq.c        |  4 +-
 drivers/infiniband/core/verbs.c     | 35 ++++++--------
 drivers/infiniband/ulp/srp/ib_srp.c | 92 ++++++++++++++++++++++++-------------
 drivers/infiniband/ulp/srp/ib_srp.h |  1 +
 4 files changed, 77 insertions(+), 55 deletions(-)

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
