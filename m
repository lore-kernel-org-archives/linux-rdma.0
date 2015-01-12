From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 00/20] IB/mad: Add support for Intel Omni-Path Architecture (OPA) MAD processing.
Date: Mon, 12 Jan 2015 12:10:52 -0500
Message-ID: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

3) Add support for creating and processing a new OPA MAD Base Version


Notes regarding changes from the RFC patches:

I did a series of tests using kmalloc vs kmem_cache.  This includes running SA,
PM, and SM Traffic with both OpenSM and OPA MADs.  I have been unable to
determine any performance difference in using kmalloc vs kmem_cache.

As Roland suggested the use of kmalloc makes device specific MAD sizes much
easier to deal with so this series removes the kmem_cache and uses the common
kmalloc calls for both IB and OPA devices.

Changes based on feedback from the RFC patches:

	Rebased to latest Rolands for-next (3.18)
	Convert from kmem_cache to kmalloc for receive buffers
		remove unneeded jumbo_mad_private structure
	Add device attribute caching and avoid caching of device flags in the
		MAD code
	Add "mad_size" device attribute
		Use mad_size in all recv MAD buffer allocations
	Remove IB_DEVICE_JUMBO_MAD_SUPPORT and internal MAD
		"supports_jumbo_mads" flag in favor of an
		IB_DEVICE_OPA_MAD_SUPPORT flag
	Added a new device_cap_flags2 field (device_cap_flags was "full" in 3.18)
	Limit the use of struct ib_mad to places where the data is actually an
		IB MAD, common processing functions can use ib_mad_hdr.

	rename commit messages to "IB/*" rather than "ib/*"
	reorder the patch series to put general refactoring and
		pre-patches first.
	Fix MLX5 compile


Ira Weiny (20):
  IB/mad: Rename is_data_mad to is_rmpp_data_mad
  IB/core: Cache device attributes for use by upper level drivers
  IB/mad: Change validate_mad signature to take ib_mad_hdr rather than
    ib_mad
  IB/mad: Change ib_response_mad signature to take ib_mad_hdr rather
    than ib_mad
  IB/mad: Change cast in rcv_has_same_class
  IB/core: Add mad_size to ib_device_attr
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
  IB/mad: Add registration check for Intel Omni-Path Architecture MADs
  IB/mad: Implement support for Intel Omni-Path Architecture base
    version MADs in ib_create_send_mad
  IB/mad: Implement Intel Omni-Path Architecture SMP processing
  IB/mad: Implement Intel Omni-Path Architecture MAD processing

 drivers/infiniband/core/agent.c              |   25 +-
 drivers/infiniband/core/agent.h              |    2 +-
 drivers/infiniband/core/cm.c                 |    6 +-
 drivers/infiniband/core/device.c             |    2 +
 drivers/infiniband/core/mad.c                |  521 +++++++++++++++++---------
 drivers/infiniband/core/mad_priv.h           |    9 +-
 drivers/infiniband/core/mad_rmpp.c           |  142 ++++----
 drivers/infiniband/core/opa_smi.h            |   78 ++++
 drivers/infiniband/core/sa_query.c           |    3 +-
 drivers/infiniband/core/smi.c                |  231 ++++++++----
 drivers/infiniband/core/smi.h                |    6 +
 drivers/infiniband/core/sysfs.c              |    5 +-
 drivers/infiniband/core/user_mad.c           |   42 ++-
 drivers/infiniband/hw/amso1100/c2_provider.c |    5 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c     |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    6 +-
 drivers/infiniband/hw/cxgb4/provider.c       |    8 +-
 drivers/infiniband/hw/ehca/ehca_hca.c        |    2 +
 drivers/infiniband/hw/ehca/ehca_sqp.c        |    8 +-
 drivers/infiniband/hw/ipath/ipath_mad.c      |    8 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs.h    |    3 +-
 drivers/infiniband/hw/mlx4/mad.c             |   12 +-
 drivers/infiniband/hw/mlx4/main.c            |    1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |    3 +-
 drivers/infiniband/hw/mlx5/mad.c             |    8 +-
 drivers/infiniband/hw/mlx5/main.c            |    1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |    3 +-
 drivers/infiniband/hw/mthca/mthca_dev.h      |    4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c      |   12 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +
 drivers/infiniband/hw/nes/nes_verbs.c        |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |    3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    1 +
 drivers/infiniband/hw/qib/qib_iba7322.c      |    3 +-
 drivers/infiniband/hw/qib/qib_mad.c          |   11 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |    1 +
 drivers/infiniband/hw/qib/qib_verbs.h        |    3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    1 +
 drivers/infiniband/ulp/srpt/ib_srpt.c        |    3 +-
 include/rdma/ib_mad.h                        |   38 ++-
 include/rdma/ib_verbs.h                      |   15 +-
 include/rdma/opa_smi.h                       |  106 ++++++
 43 files changed, 987 insertions(+), 362 deletions(-)
 create mode 100644 drivers/infiniband/core/opa_smi.h
 create mode 100644 include/rdma/opa_smi.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
