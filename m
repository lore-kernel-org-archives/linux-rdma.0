From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 0/6] dev attr cleanup (less is more)
Date: Thu, 17 Dec 2015 15:18:54 +0200
Message-ID: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OK, Doug, this is my suggestion for the dev attr cleanup -- it 
has the advantages of leaving the attrs on a well defined location, 
a field in the IB device, the ability to  get that through smaller 
patches, avoid touching any of the HW drivers, etc.

Note that in uverbs there's one spot where udata is involved 
(the extended query device call) so we keep the ib_query_device 
call there.

I used hunks from Christoph's work and mentioned that in the 
change-logs. This can turn to be his signature, if he wants to.

Or.

Ira Weiny (1):
  IB/core: Save the device attributes on the device structure

Or Gerlitz (5):
  IB/core: Avoid calling ib_query_device when possible
  IB/ulps: Avoid calling ib_query_device
  net/rds: Avoid calling ib_query_device
  xprtrdma: Avoid calling ib_query_device
  staging/o2iblnd: Avoid calling ib_query_device

 drivers/infiniband/core/cm.c                       | 12 +-----
 drivers/infiniband/core/cma.c                      |  8 ----
 drivers/infiniband/core/device.c                   |  6 +++
 drivers/infiniband/core/fmr_pool.c                 | 20 +--------
 drivers/infiniband/core/sysfs.c                    | 14 ++-----
 drivers/infiniband/core/uverbs_cmd.c               | 23 ++---------
 drivers/infiniband/core/verbs.c                    |  8 +---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            | 19 +++------
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       | 14 +++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 21 +---------
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |  2 -
 drivers/infiniband/ulp/iser/iser_memory.c          |  9 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c           | 38 ++++++++---------
 drivers/infiniband/ulp/isert/ib_isert.c            | 47 +++++++--------------
 drivers/infiniband/ulp/isert/ib_isert.h            |  1 -
 drivers/infiniband/ulp/srp/ib_srp.c                | 32 ++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.c              | 15 +++----
 drivers/infiniband/ulp/srpt/ib_srpt.h              |  3 --
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    | 21 +---------
 include/rdma/ib_verbs.h                            |  1 +
 net/rds/ib.c                                       | 34 +++++----------
 net/rds/iw.c                                       | 23 +++--------
 net/sunrpc/xprtrdma/frwr_ops.c                     |  7 ++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c           | 48 +++++++++-------------
 net/sunrpc/xprtrdma/verbs.c                        | 24 ++++-------
 net/sunrpc/xprtrdma/xprt_rdma.h                    |  1 -
 27 files changed, 129 insertions(+), 326 deletions(-)

-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
