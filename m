From: Tziporet Koren <tziporet@mellanox.com>
Subject: RE: [GIT PULL] please pull infiniband.git
Date: Mon, 25 Jun 2012 14:11:25 +0000
Message-ID: <CD250C48050CFB4D95E78C95F2FDDD6E869F46C8@MTLDAG02.mtl.com>
References: <1340539753-19165-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1340539753-19165-1-git-send-email-roland@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland

Can you updated us on status of review of our mlx4 SRIOV IB submission?

Thanks
Tziporet

-----Original Message-----
From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Roland Dreier
Sent: Sunday, June 24, 2012 5:11 AM
To: Linus Torvalds
Cc: linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-fixes

----------------------------------------------------------------

InfiniBand/RDMA fixes for 3.5-rc:
 - Fixes to new ocrdma driver
 - Typo in test in CMA

----------------------------------------------------------------
Dan Carpenter (1):
      RDMA/ocrdma: Fix off by one in ocrdma_query_gid()

Mahesh Vardhamanaiah (2):
      RDMA/ocrdma: Correct reported max queue sizes
      RDMA/ocrdma: Correct queue SGE calculation

Parav Pandit (2):
      RDMA/ocrdma: Fixed GID table for vlan and events
      RDMA/ocrdma: Fixed RQ error CQE polling

Roland Dreier (1):
      Merge branches 'cma' and 'ocrdma' into for-linus

Sean Hefty (1):
      RDMA/cma: QP type check on received REQs should be AND not OR

 drivers/infiniband/core/cma.c               |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   18 ++++----
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   63 +++++++++++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    5 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   12 ++---
 6 files changed, 55 insertions(+), 46 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
