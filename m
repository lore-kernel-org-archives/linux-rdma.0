From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/6] IB/mad: Support devices taking pkey_index from the GSI QP
Date: Wed, 14 Oct 2015 11:29:42 +0300
Message-ID: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Patch 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to RDMA
CM") started checking the BTH P_Key for RDMA CM requests, and this
uncovered some issues with P_Key handling. In mlx5 the pkey_index in ib_wc
wasn't set correctly [1]. In addition, we found out that mlx5 doesn't
respect the pkey_index in ib_send_wr.ud for GSI packets. Apparently having
the pkey_index in a work request isn't required by the IBA specifications,
and so the Connect-IB and ConnectX-4 cards that mlx5 drives doesn't support
it. The result is that in kernel 4.3, RDMA CM can reject new connections
created using an mlx5 IPoIB interface that uses a non-default P_Key.

The proposed solution here is to change the ib_mad module to create
multiple UD QPs for sending GMPs, when the underlying driver doesn't
support the pkey_index in the work request. A side effect of
this change is that MADs going out with pkey_index != 0 will have a source
QP number != 1. This is allowed by the IBA specifications.

To save resources, the code creates QPs only for pkey table entries that are
non-zero. However, the code doesn't currently destroy QPs when pkey entries are
cleared. This would require reference counting on each QP to work correctly,
and we plan to do that later on.

The patchset is divided as follows. The first two patches add helper
functions and store additional info in ib_mad_qp_info to help eliminate the
depenedency on a single ib_qp pointer in ib_mad_qp_info. Patch 3 adds a
capability bit to ib_device to tell whether a device uses the pkey index
from a work request or from the QP. Patch 4 adds SRQ support to the mad
layer to allow receiving MADs designated to any QP belonging to a GSI agent
to the same queue. Patch 5 adds the bulk of the code required to create and
use multiple QPs on the same ib_mad_qp_info struct, and patch 6 adds a
P_Key change event handler to update the table when the SM changes the
available P_Keys.

[1] mlx5: Fix incorrect wc pkey_index assignment for GSI messages
http://www.spinics.net/lists/linux-rdma/msg28374.html

Regards,
Haggai

Haggai Eran (6):
  IB/mad: Use helpers to get ib_device and ib_pd from ib_mad_agent
  IB/mad: Add QP parameters to ib_mad_qp_info
  IB/core: Add capability bit to tell whether per-WR P_Key change in
    GSI is supported
  IB/mad: Use a SRQ for receiving GMPs
  IB/mad: Create multiple QPs for supporting different P_Keys
  IB/mad: P_Key change event handler

 drivers/infiniband/core/agent.c          |   4 +-
 drivers/infiniband/core/cm.c             |   5 +-
 drivers/infiniband/core/mad.c            | 528 ++++++++++++++++++++++++-------
 drivers/infiniband/core/mad_priv.h       |   9 +-
 drivers/infiniband/core/mad_rmpp.c       |   4 +-
 drivers/infiniband/core/sa_query.c       |  10 +-
 drivers/infiniband/core/user_mad.c       |   4 +-
 drivers/infiniband/hw/mlx4/mad.c         |   2 +-
 drivers/infiniband/hw/mlx5/main.c        |   1 +
 drivers/infiniband/hw/mthca/mthca_mad.c  |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c    |   2 +-
 drivers/staging/rdma/ipath/ipath_verbs.c |   1 +
 include/rdma/ib_mad.h                    |  16 +-
 include/rdma/ib_verbs.h                  |   2 +
 14 files changed, 452 insertions(+), 138 deletions(-)

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
