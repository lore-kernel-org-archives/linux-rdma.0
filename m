From: Roland Dreier <roland@kernel.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Tue,  7 Feb 2012 09:34:28 -0800
Message-ID: <1328636068-25497-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ib-srpt-fixes

This will get a few small cleanups and fixes for the srpt fabric
driver.  The driver is new for 3.3 so it makes sense to get this in
before the first release.

----------------------------------------------------------------
Cleanups and error path fixes for the new SRP (SCSI RDMA protocol) target.

----------------------------------------------------------------
Dan Carpenter (1):
      IB/srpt: Fix ERR_PTR() vs. NULL checking confusion

Jesper Juhl (2):
      IB/srpt: Remove unneeded <linux/version.h> include
      IB/srpt: Don't return freed pointer from srpt_alloc_ioctx_ring()

Roland Dreier (2):
      IB/srpt: Use DEFINE_SPINLOCK()/LIST_HEAD()
      IB/srpt: Use ARRAY_SIZE() instead of open-coding

 drivers/infiniband/ulp/srpt/ib_srpt.c |   17 +++++++----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 -
 2 files changed, 7 insertions(+), 11 deletions(-)
