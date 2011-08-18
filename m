From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 18 Aug 2011 08:54:48 -0700
Message-ID: <1313682888-5108-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes:
 - Fix for crash on boot in IPoIB from Bernd Schubert
 - Two iSER bugs from Or Gerlitz

Bernd Schubert (1):
      IPoIB: Fix possible NULL dereference in ipoib_start_xmit()

Or Gerlitz (2):
      IBiser: Fix wrong mask when sizeof (dma_addr_t) > sizeof (unsigned long)
      IB/iser: Support iSCSI PDU padding

Roland Dreier (1):
      Merge branches 'ipoib' and 'iser' into for-next

 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    8 +++++---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   10 +++++++---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
