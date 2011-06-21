From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 21 Jun 2011 09:18:06 -0700
Message-ID: <1308673086-7125-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes for the cxgb4 and qib hardware device drivers.

Mitko Haralanov (1):
      IB/qib: Ensure that LOS and DFE are being turned off

Roland Dreier (1):
      Merge branches 'cxgb4' and 'qib' into for-next

Steve Wise (3):
      RDMA/cxgb4: Don't exceed hw IQ depth limit for user CQs
      RDMA/cxgb4: Don't truncate MR lengths
      RDMA/cxgb4: Couple of abort fixes

 drivers/infiniband/hw/cxgb4/cm.c        |   46 +++++++++++++++++++++++++------
 drivers/infiniband/hw/cxgb4/cq.c        |    4 +++
 drivers/infiniband/hw/cxgb4/mem.c       |    2 +-
 drivers/infiniband/hw/cxgb4/qp.c        |    5 +---
 drivers/infiniband/hw/qib/qib_iba7322.c |   25 ++++++++++++-----
 drivers/infiniband/hw/qib/qib_intr.c    |    6 +++-
 6 files changed, 66 insertions(+), 22 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
