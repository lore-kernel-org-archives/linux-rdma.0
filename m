From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Generic logging helpers
Date: Mon, 11 May 2015 17:10:54 +0300
Message-ID: <1431353456-3862-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This small set adds some meaningful verbosity to some
of the core/rdma_cm enumerated events. Its useful to
see the meaning of the opcodes instead of revisiting the
code for every new status/event that left our brain cache.


Changes from v1:
- Changed helper names ib_wc_status_msg and rdma_event_msg
- Cast input arguments to protect string buffer access
- Add svcrdma to the party

Changes from v0 (RFC):
- Moved string arrays to .c files
- Changed string helpers from macros to exported functions
- Aligned rds to generic helpers as well

Sagi Grimberg (2):
  IB/core, cma: Nice log-friendly string helpers
  ulps: Align several ULPs to use core/rdma_cm logging helpers

 drivers/infiniband/core/cma.c            |   26 +++++++++
 drivers/infiniband/core/verbs.c          |   61 ++++++++++++++++++++
 drivers/infiniband/ulp/iser/iser_verbs.c |   26 +++++---
 drivers/infiniband/ulp/isert/ib_isert.c  |   19 ++++--
 drivers/infiniband/ulp/srp/ib_srp.c      |   15 +++--
 include/rdma/ib_verbs.h                  |    4 +
 include/rdma/rdma_cm.h                   |    2 +
 net/rds/af_rds.c                         |    9 ---
 net/rds/ib.h                             |    1 -
 net/rds/ib_cm.c                          |   36 +-----------
 net/rds/ib_recv.c                        |    4 +-
 net/rds/ib_send.c                        |   38 +------------
 net/rds/rdma_transport.c                 |   34 +----------
 net/rds/rds.h                            |    1 -
 net/sunrpc/xprtrdma/frwr_ops.c           |    4 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   29 ++++++----
 net/sunrpc/xprtrdma/verbs.c              |   90 ++----------------------------
 17 files changed, 165 insertions(+), 234 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
