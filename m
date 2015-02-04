From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v4 00/19] IB/mad: Add support for Intel Omni-Path Architecture (OPA) MAD processing.
Date: Wed,  4 Feb 2015 18:29:26 -0500
Message-ID: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following patch series modifies the kernel MAD processing (ib_mad/ib_umad)
and related interfaces to send and receive Intel Omni-Path Architecture MADs on
devices which support them.

In addition to supporting some IBTA management classes, OPA devices use MADs
with lengths up to 2K.  These "jumbo" MADs increase the performance of
management traffic.

To distinguish IBTA MADs from OPA MADs a new Base Version is introduced.  The
new format shares the same common header with IBTA MADs which allows us to
share most of the MAD processing code when dealing with the new Base Version.


The patch series is broken into 3 main areas.

1) Add the ability for devices to indicate MAD size.
   modify the MAD code to use this MAD size

2) Enhance the interface to the device agents to support larger and variable
   length MADs.

3) Add capability bit to indicate support for OPA MADs

4) Add support for creating and processing OPA MADs


Changes for V4:

	Rebased to latest Rolands for-next branch (3.19-rc4)
	Fixed compile issue in ehca driver found with 0-day build.


Ira Weiny (19):
  IB/mad: Rename is_data_mad to is_rmpp_data_mad
  IB/core: Cache device attributes for use by upper level drivers
  IB/mad: Change validate_mad signature to take ib_mad_hdr rather than
    ib_mad
  IB/mad: Change ib_response_mad signature to take ib_mad_hdr rather
    than ib_mad
  IB/mad: Change cast in rcv_has_same_class
  IB/core: Add max_mad_size to ib_device_attr
  IB/mad: Convert ib_mad_private allocations from kmem_cache to kmalloc
  IB/mad: Add helper function for smi_handle_dr_smp_send
  IB/mad: Add helper function for smi_handle_dr_smp_recv
  IB/mad: Add helper function for smi_check_forward_dr_smp
  IB/mad: Add helper function for SMI processing
  IB/mad: Add MAD size parameters to process_mad
  IB/mad: Add base version parameter to ib_create_send_mad
  IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device cap flag
  IB/mad: Create jumbo_mad data structures
  IB/mad: Add Intel Omni-Path Architecture defines
  IB/mad: Implement support for Intel Omni-Path Architecture base
    version MADs in ib_create_send_mad
  IB/mad: Implement Intel Omni-Path Architecture SMP processing
  IB/mad: Implement Intel Omni-Path Architecture MAD processing

 drivers/infiniband/core/agent.c              |  26 +-
 drivers/infiniband/core/agent.h              |   3 +-
 drivers/infiniband/core/cm.c                 |   6 +-
 drivers/infiniband/core/device.c             |   2 +
 drivers/infiniband/core/mad.c                | 519 ++++++++++++++++++---------
 drivers/infiniband/core/mad_priv.h           |   7 +-
 drivers/infiniband/core/mad_rmpp.c           | 144 ++++----
 drivers/infiniband/core/opa_smi.h            |  78 ++++
 drivers/infiniband/core/sa_query.c           |   3 +-
 drivers/infiniband/core/smi.c                | 231 ++++++++----
 drivers/infiniband/core/smi.h                |   6 +
 drivers/infiniband/core/sysfs.c              |   5 +-
 drivers/infiniband/core/user_mad.c           |  38 +-
 drivers/infiniband/hw/amso1100/c2_provider.c |   5 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c     |   1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |   6 +-
 drivers/infiniband/hw/cxgb4/provider.c       |   8 +-
 drivers/infiniband/hw/ehca/ehca_hca.c        |   3 +
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |   4 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c        |   8 +-
 drivers/infiniband/hw/ipath/ipath_mad.c      |   8 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |   1 +
 drivers/infiniband/hw/ipath/ipath_verbs.h    |   3 +-
 drivers/infiniband/hw/mlx4/mad.c             |  12 +-
 drivers/infiniband/hw/mlx4/main.c            |   1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |   3 +-
 drivers/infiniband/hw/mlx5/mad.c             |   8 +-
 drivers/infiniband/hw/mlx5/main.c            |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   3 +-
 drivers/infiniband/hw/mthca/mthca_dev.h      |   4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c      |  12 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |   2 +
 drivers/infiniband/hw/nes/nes_verbs.c        |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   1 +
 drivers/infiniband/hw/qib/qib_iba7322.c      |   3 +-
 drivers/infiniband/hw/qib/qib_mad.c          |  11 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |   1 +
 drivers/infiniband/hw/qib/qib_verbs.h        |   3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   2 +
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   3 +-
 include/rdma/ib_mad.h                        |  40 ++-
 include/rdma/ib_verbs.h                      |  15 +-
 include/rdma/opa_smi.h                       | 106 ++++++
 45 files changed, 999 insertions(+), 357 deletions(-)
 create mode 100644 drivers/infiniband/core/opa_smi.h
 create mode 100644 include/rdma/opa_smi.h

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
