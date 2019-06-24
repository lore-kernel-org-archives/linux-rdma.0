From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v4 rdma-next 0/3] RDMA/qedr: Use the doorbell overflow recovery mechanism for RDMA
Date: Mon, 24 Jun 2019 13:28:06 +0300
Message-ID: <20190624102809.8793-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch series used the doorbell overflow recovery mechanism
introduced in
commit 36907cd5cd72 ("qed: Add doorbell overflow recovery mechanism")
for rdma ( RoCE and iWARP )

rdma-core pull request #493

Changes from V3:
- Remove casts from void to u8. Pointer arithmetic can be done on void
- rebase to tip of rdma-next

Changes from V2:
- Don't use long-lived kmap. Instead use user-trigger mmap for the
  doorbell recovery entries.
- Modify dpi_addr to be denoted with __iomem and avoid redundant
  casts

Changes from V1:
- call kmap to map virtual address into kernel space
- modify db_rec_delete to be void
- remove some cpu_to_le16 that were added to previous patch which are
  correct but not related to the overflow recovery mechanism. Will be
  submitted as part of a different patch


Michal Kalderon (3):
  qed*: Change dpi_addr to be denoted with __iomem
  RDMA/qedr: Add doorbell overflow recovery support
  RDMA/qedr: Add iWARP doorbell recovery support

 drivers/infiniband/hw/qedr/main.c          |   2 +-
 drivers/infiniband/hw/qedr/qedr.h          |  27 +-
 drivers/infiniband/hw/qedr/verbs.c         | 386 ++++++++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |   5 +-
 include/linux/qed/qed_rdma_if.h            |   2 +-
 include/uapi/rdma/qedr-abi.h               |  25 ++
 6 files changed, 376 insertions(+), 71 deletions(-)

-- 
2.14.5
