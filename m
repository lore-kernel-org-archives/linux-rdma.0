From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V4 0/5] iSER support for iWARP
Date: Thu, 02 Jul 2015 10:16:03 -0500
Message-ID: <20150702151508.12946.29133.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: roid@mellanox.com, linux-rdma@vger.kernel.org, sagig@mellanox.com, infinipath@intel.com, target-devel@vger.kernel.org, eli@mellanox.com, ogerlitz@mellanox.com
List-Id: linux-rdma@vger.kernel.org

The following series implements support for iWARP transports in the iSER
initiator and target.  This is based on Doug's k.o/for-4.2 branch.

I've tested this on cxgb4 and mlx4 hardware.

Changes since V3:

Fixed commit messages based on feedback.

iser: adjust max_sectors

isert: split into 2 patches

isert: always set REMOTE_WRITE for dma mrs

Changes since V2:

The transport independent work is removed from this series and will
be submitted in a subsequent series.  This V3 series now enables iWARP
using existing core services.

Changes since V1:

Introduce and use transport-independent RDMA core services for allocating
DMA MRs and computing fast register access flags.

Correctly set the device max_sge_rd capability in several rdma device
drivers.

isert: use device capability max_sge_rd for the read sge depth.

isert: change max_sge to max_write_sge in struct isert_conn.

---

Sagi Grimberg (1):
      mlx4, mlx5, mthca: Expose max_sge_rd correctly

Steve Wise (4):
      ipath,qib: Expose max_sge_rd correctly
      RDMA/iser: Limit sg tablesize and max_sectors to device fastreg max depth
      RDMA/isert: Set REMOTE_WRITE on DMA MRs to support iWARP devices
      RDMA/isert: Limit read depth based on the device max_sge_rd capability


 drivers/infiniband/hw/ipath/ipath_verbs.c    |    1 +
 drivers/infiniband/hw/mlx4/main.c            |    1 +
 drivers/infiniband/hw/mlx5/main.c            |    1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |    1 +
 drivers/infiniband/hw/qib/qib_verbs.c        |    1 +
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    9 +++++++
 drivers/infiniband/ulp/isert/ib_isert.c      |   34 +++++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h      |    3 ++
 8 files changed, 41 insertions(+), 10 deletions(-)

--
Steve.
