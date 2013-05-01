From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.10 0/4] iSER initiator updates for 3.10
Date: Wed,  1 May 2013 16:25:23 +0300
Message-ID: <1367414727-22680-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here are the iser initiator updates for the 3.10 merge window, the 
"Return error to upper layers on EAGAIN registration failures" patch 
is marked for -stable fixing a bug that went it in 3.9

Or.

Or Gerlitz (2):
  IB/iser: Return error to upper layers on EAGAIN registration failures
  IB/iser: Add support for iser CM REQ additional info

Roi Dayan (2):
  IB/iser: Add module version
  IB/iser: Move informational messages from error to info level

 drivers/infiniband/ulp/iser/iscsi_iser.c  |   24 +++++++++---------
 drivers/infiniband/ulp/iser/iscsi_iser.h  |   24 ++++++++++++++++---
 drivers/infiniband/ulp/iser/iser_memory.c |    3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c  |   36 +++++++++++++++++-----------
 4 files changed, 56 insertions(+), 31 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
