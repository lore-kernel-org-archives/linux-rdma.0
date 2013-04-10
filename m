From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] Fixes to the mlx4 kernel XRC implementaion
Date: Wed, 10 Apr 2013 17:26:45 +0300
Message-ID: <1365604008-22455-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Roland, Sean, everyone!

This patch series fixes the following two issues Shlomo stepped on
while experimenting with the kernel XRC code:

1. Calling an uninitalized XRC TGT QP event handler. QP envent handler 
is optional, the current code calls the event handelr for XRC TGT QP 
unconditionaly, fix that.

2. In the CQ polling code, when the QP is of type XRC TGT the srq field in the
QP has no meaning since an XRC TGT QP can redirect to more than one XRC SRQ. 
The XRC SRQ need to be retrived using the information form the XRCETH. 

Or.

Shlomo Pongratz (3):
  IB/core: Verify that QP handler is valid before dispatching events
  net/mlx4_core: Implement srq object lookup from srqn
  IB/mlx4: Fetch XRC SRQ in the CQ polling code

 drivers/infiniband/core/verbs.c          |    3 ++-
 drivers/infiniband/hw/mlx4/cq.c          |   21 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/srq.c |   15 +++++++++++++++
 include/linux/mlx4/srq.h                 |    2 ++
 4 files changed, 40 insertions(+), 1 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
