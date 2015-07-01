From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V3 0/4] iSER support for iWARP
Date: Wed, 01 Jul 2015 11:30:37 -0500
Message-ID: <20150701162936.6501.45512.stgit@build.ogc.int>
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

Steve Wise (3):
      ipath,qib: Expose max_sge_rd correctly
      RDMA/iser: limit sg tablesize to device fastreg max depth
      RDMA/isert: Support iWARP transport


 drivers/infiniband/hw/ipath/ipath_verbs.c    |    1 
 drivers/infiniband/hw/mlx4/main.c            |    1 
 drivers/infiniband/hw/mlx5/main.c            |    1 
 drivers/infiniband/hw/mthca/mthca_provider.c |    1 
 drivers/infiniband/hw/qib/qib_verbs.c        |    1 
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    7 +++
 drivers/infiniband/ulp/isert/ib_isert.c      |   54 ++++++++++++++++++++++----
 drivers/infiniband/ulp/isert/ib_isert.h      |    3 +
 8 files changed, 59 insertions(+), 10 deletions(-)

--
Steve.
