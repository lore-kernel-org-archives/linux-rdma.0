From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 00/16] iser initiator updates for 3.19
Date: Sun,  7 Dec 2014 16:09:51 +0200
Message-ID: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

This set applies on top of Linus tree + the 3.18 fixes which you 
didn't pick up (http://marc.info/?l=linux-rdma&m=141448976230915&w=2).

The 1st patch, from the Emulex folks allows to run iser over their HW 
and ocrdma driver, which is nice addition to the support matrix for iser.

Next are few general error flow  fixes, Nit cleanups, IO path 
optimizations and finally DIX update to align with the block 
layer 3.18 changes on that area (see http://marc.info/?l=linux-scsi&m=140925423210073&w=2)

Sagi and Or.

Ariel Nahum (2):
  IB/iser: Collapse cleanup and disconnect handlers
  IB/iser: Fix possible NULL derefernce ib_conn->device in session_create

Max Gurtovoy (1):
  IB/iser: Fix possible SQ overflow

Minh Tran (1):
  IB/iser: Re-adjust CQ and QP send ring sizes to HW limits

Or Gerlitz (1):
  IB/iser: Bump version to 1.5

Sagi Grimberg (11):
  IB/iser: Fix catas error flow hang
  IB/iser: Decrement CQ's active QPs accounting when QP creation fails
  IB/iser: Fix sparse warnings
  IB/iser: Fix race between iser connection teardown and scsi TMFs
  IB/iser: Terminate connection before cleaning inflight tasks
  IB/iser: Centralize memory region invalidation to a function
  IB/iser: Remove redundant is_mr indicator
  IB/iser: Use more completion queues
  IB/iser: Micro-optimize iser logging
  IB/iser: Micro-optimize iser_handle_wc
  IB/iser: DIX update

 drivers/infiniband/ulp/iser/iscsi_iser.c     |  104 +++++++++++++++++++-------
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   30 ++++----
 drivers/infiniband/ulp/iser/iser_initiator.c |    6 +-
 drivers/infiniband/ulp/iser/iser_memory.c    |  102 ++++++++-----------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |   91 ++++++++++++++++-------
 5 files changed, 193 insertions(+), 140 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
