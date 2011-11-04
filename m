From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Fri,  4 Nov 2011 11:26:41 -0700
Message-ID: <1320431201-29880-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few more 3.2 merge window changes:

 - a panic fix for the qib hardware driver
 - a couple of cleanups to iSER's use of the DMA mapping API
 - a fix to mthca that reduces memory use a bit

Mike Marciniszyn (1):
      IB/qib: Fix panic in RC error flushing logic

Or Gerlitz (2):
      IB/iser: Use separate buffers for the login request/response
      IB/iser: DMA unmap TX bufs used for iSCSI/iSER headers

Roland Dreier (2):
      IB/mthca: Fix buddy->num_free allocation size
      Merge branches 'iser', 'mthca' and 'qib' into for-next

 drivers/infiniband/hw/mthca/mthca_mr.c       |    2 +-
 drivers/infiniband/hw/qib/qib_rc.c           |   10 ++-----
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   11 ++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    4 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   31 ++++++++++++++++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c     |   33 ++++++++++++++++++++-----
 6 files changed, 64 insertions(+), 27 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
