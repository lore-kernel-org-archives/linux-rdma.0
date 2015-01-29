From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 0/4] IB core fixes 29-Jan-2015
Date: Thu, 29 Jan 2015 11:14:27 +0200
Message-ID: <1422522871-11216-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sending V1 as the wrong instance was sent for patch #2 (Gerrit hardows)

Hi Roland,

This is a batch with IB core fixes, please apply for 3.20

The patch that deals with PSN touches the HW drivers b/c we added the 
qp attributes provided by the ULP as a param to the ib_modify_qp_is_ok() 
IB core helper.

Also, there's a pending CMA patch we sent for 3.19 and was approved
by Sean, please pick it too "RDMA/CMA: Mark IPv4 addresses correctly 
when the listener is IPv6" https://patchwork.kernel.org/patch/5298971/

Or.

Ilya Nelkenbaum (1):
  IB/core: When marshaling ucma path from user-space, clear unused fields

Majd Dibbiny (2):
  IB/core: Check mad_agent in ib_unregister_mad_agent before dereferencing it
  IB/core: Make sure that the PSN does not overflow

Moshe Lazer (1):
  IB/core: Fix deadlock on uverbs modify_qp error flow

 drivers/infiniband/core/cma.c               |    6 +++---
 drivers/infiniband/core/mad.c               |    4 ++++
 drivers/infiniband/core/ucma.c              |    3 +++
 drivers/infiniband/core/uverbs_cmd.c        |   13 +++++++------
 drivers/infiniband/core/verbs.c             |   10 ++++++++--
 drivers/infiniband/hw/ehca/ehca_qp.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_qp.c      |    2 +-
 drivers/infiniband/hw/mlx4/qp.c             |    6 +++---
 drivers/infiniband/hw/mlx5/qp.c             |    4 ++--
 drivers/infiniband/hw/mthca/mthca_qp.c      |    4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    7 ++++---
 drivers/infiniband/hw/qib/qib_qp.c          |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |    4 ++--
 include/rdma/ib_verbs.h                     |    7 ++++---
 14 files changed, 45 insertions(+), 29 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
