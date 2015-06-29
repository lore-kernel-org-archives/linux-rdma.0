From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V2 0/5] iSER support for iWARP
Date: Mon, 29 Jun 2015 16:36:03 -0500
Message-ID: <20150629213332.4188.87551.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following series implements support for iWARP transports in the iSER
initiator and target.  This is based on Doug's k.o/for-4.2 branch.

I've tested this on cxgb4 and mlx4 hardware.

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
      RDMA/core: transport-independent access flags
      RDMA/iser: support iWARP devices
      RDMA/isert: support iWARP devices


 drivers/infiniband/core/verbs.c              |   30 ++++++++
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    1 
 drivers/infiniband/hw/mlx4/main.c            |    1 
 drivers/infiniband/hw/mlx5/main.c            |    1 
 drivers/infiniband/hw/mthca/mthca_provider.c |    1 
 drivers/infiniband/hw/qib/qib_verbs.c        |    1 
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    7 ++
 drivers/infiniband/ulp/iser/iser_memory.c    |    7 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |    7 +-
 drivers/infiniband/ulp/isert/ib_isert.c      |   33 ++++++--
 drivers/infiniband/ulp/isert/ib_isert.h      |    3 +
 include/rdma/ib_verbs.h                      |  101 ++++++++++++++++++++++++++
 12 files changed, 174 insertions(+), 19 deletions(-)

--
Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
