From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 18 Sep 2015 12:01:44 -0400
Message-ID: <1442592104-125721-1-git-send-email-dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

The new hfi1 driver in staging/rdma has had a number of fixup patches
since being added to the tree.  This is the first batch of those fixes.

The following changes since commit 447e9a4d27484175a84daaa8e03d35c650f443b7:

  IB/ehca: Deprecate driver, move to staging, schedule deletion (2015-09-11 18:13:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git tags/for-linus

for you to fetch changes up to e116a64fab650aed3d7b9b4db0b59c07f361bc9f:

  IB/hfi: Properly set permissions for user device files (2015-09-18 11:28:47 -0400)

----------------------------------------------------------------
Changes for 4.3-rc1

- Batch of minor fixups to the new hfi1 driver

----------------------------------------------------------------
Dan Carpenter (6):
      IB/hfi1: fix copy_to/from_user() error handling
      IB/hfi1: checking for NULL instead of IS_ERR
      IB/hfi1: fix a locking bug
      IB/hfi1: info leak in get_ctxt_info()
      IB/hfi1: clean up some defines
      IB/hfi1: mask vs shift confusion

Ira Weiny (2):
      IB/hfi1: fix pstateinfo from returning improperly byteswapped value
      IB/hfi: Properly set permissions for user device files

Mike Marciniszyn (1):
      IB/hfi1: fix sdma_descq_cnt parameter parsing

 drivers/staging/rdma/hfi1/chip.c     |  4 +--
 drivers/staging/rdma/hfi1/device.c   | 54 ++++++++++++++++++++++++++++++++----
 drivers/staging/rdma/hfi1/device.h   |  3 +-
 drivers/staging/rdma/hfi1/diag.c     | 36 ++++++++++++------------
 drivers/staging/rdma/hfi1/file_ops.c | 10 +++++--
 drivers/staging/rdma/hfi1/mad.c      |  4 +--
 drivers/staging/rdma/hfi1/sdma.c     |  6 ++--
 drivers/staging/rdma/hfi1/sdma.h     | 36 ++++++++++++------------
 drivers/staging/rdma/hfi1/verbs.c    |  8 ++++--
 include/rdma/opa_port_info.h         |  4 +--
 10 files changed, 107 insertions(+), 58 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
