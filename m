From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND V2 for-next 0/5] IB core fixes 29-Jan-2015
Date: Thu,  5 Feb 2015 13:35:39 +0200
Message-ID: <1423136144-12784-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

-- resent due to Gerrit IDs that were left by mistake, sorry for spamming you over

Hi Roland,

This is a batch with small IB core fixes, please apply for 3.20

There's one fix which touches few HW drivers to make sure
they invoke ib_unregister_mad_agent() only for valid cases
in their error flows.

There's a pending CMA patch we sent for 3.19 and was approved
by Sean, please pick it too "RDMA/CMA: Mark IPv4 addresses correctly 
when the listener is IPv6" https://patchwork.kernel.org/patch/5298971/

Majs and Or.

Ilya Nelkenbaum (1):
  IB/core: When marshaling ucma path from user-space, clear unused fields

Majd Dibbiny (3):
  IB/core: Fixes in ib_sa_add_one error flow
  IB/core: Call ib_unregister_mad_agent() only for valid agents
  IB/core: Make sure that the PSN does not overflow

Moshe Lazer (1):
  IB/core: Fix deadlock on uverbs modify_qp error flow

 drivers/infiniband/core/cma.c           |    1 +
 drivers/infiniband/core/sa_query.c      |   10 +++++++---
 drivers/infiniband/core/ucma.c          |    3 +++
 drivers/infiniband/core/uverbs_cmd.c    |   13 +++++++------
 drivers/infiniband/hw/mlx4/mad.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c |    2 +-
 drivers/infiniband/hw/qib/qib_mad.c     |    2 +-
 7 files changed, 21 insertions(+), 12 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
