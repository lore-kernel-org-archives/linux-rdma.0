From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/8] iSER initiator updates for 3.17
Date: Thu, 31 Jul 2014 13:27:43 +0300
Message-ID: <1406802471-23359-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Batch of updates from the storage folks -- stability issues, functionality 
(IPv6 support, proper rdma responder resources advertizement) enhacement and
cleanups.

Or.

Ariel Nahum (3):
  IB/iser: Seperate iser_conn and iscsi_endpoint storage space
  IB/iser: Protect iser state machine with a mutex
  IB/iser: Replace connection waitqueue with completion object

Roi Dayan (3):
  IB/iser: Support IPv6 address family
  IB/iser: Add TIMEWAIT_EXIT event handling
  IB/iser: Clarify a duplicate counters check

Sagi Grimberg (2):
  IB/iser: Fix responder resources advertizement
  IB/iser: Remove redundant return code in iser_free_ib_conn_res()

 drivers/infiniband/ulp/iser/iscsi_iser.c |   47 +++++++----
 drivers/infiniband/ulp/iser/iscsi_iser.h |    8 +-
 drivers/infiniband/ulp/iser/iser_verbs.c |  128 +++++++++++++++++++----------
 3 files changed, 120 insertions(+), 63 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
