From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 00/14] IB/mad: Add support for OPA MAD processing.
Date: Sat,  6 Jun 2015 14:38:21 -0400
Message-ID: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following patch series modifies the kernel MAD processing (ib_mad/ib_umad)
and related interfaces to send and receive Intel Omni-Path Architecture MADs on
devices which support them.

OPA MADs share the same common header with IBTA MADs which allows us to share
most of the MAD processing code.

In addition to supporting some IBTA management classes, OPA devices use MADs
with lengths up to 2K.  These MADs increase the performance of management
traffic on OPA fabrics.

Devices report their support of OPA MADs through the new immutable data
capability flag and immutable max mad size.

Changes from V1:
================

Remove patch:
	IB/mad: Create an RMPP Base header

Add new patch:
	IB/mad cleanup: Clean up function params -- find_mad_agent

Address comments from Jason about the idea of a flex array for struct ib_mad:
	ib_mad does not really allocate struct ib_mads.  Rather it allocates
	ib_mad_private objects.  This is where the flex array was more
	appropriate.  So this series changes struct ib_mad_private to end in a
	flex array to store MAD data.  Casts are used where appropriate to
	IB/OPA mad structures or headers.

Minor updates:
	Clean up commit messages
	Fix/add const and bool usage
	Remove inline qualifiers (let complier handle inline)
	Add additional Immutable data checks
	Change WARN_ON to BUG_ON in drivers
	Add out_mad_pkey_index to process_mad in order to maintain the
	"constness" of the struct ib_wc parameter.


Ira Weiny (14):
  IB/mad cleanup: Clean up function params -- find_mad_agent
  IB/mad cleanup: Generalize processing of MAD data
  IB/mad: Split IB SMI handling from MAD Recv handler
  IB/mad: Create a generic helper for DR SMP Send processing
  IB/mad: Create a generic helper for DR SMP Recv processing
  IB/mad: Create a generic helper for DR forwarding checks
  IB/mad: Support alternate Base Versions when creating MADs
  IB/core: Add ability for drivers to report an alternate MAD size.
  IB/mad: Convert allocations from kmem_cache to kzalloc
  IB/mad: Add support for additional MAD info to/from drivers
  IB/core: Add OPA MAD core capability flag
  IB/mad: Add partial Intel OPA MAD support
  IB/mad: Add partial Intel OPA MAD support
  IB/mad: Add final OPA MAD processing

 drivers/infiniband/core/agent.c              |  15 +-
 drivers/infiniband/core/agent.h              |   4 +-
 drivers/infiniband/core/cm.c                 |   6 +-
 drivers/infiniband/core/device.c             |  11 +
 drivers/infiniband/core/mad.c                | 541 +++++++++++++++++++--------
 drivers/infiniband/core/mad_priv.h           |  11 +-
 drivers/infiniband/core/mad_rmpp.c           |  33 +-
 drivers/infiniband/core/opa_smi.h            |  78 ++++
 drivers/infiniband/core/sa_query.c           |   3 +-
 drivers/infiniband/core/smi.c                | 228 +++++++----
 drivers/infiniband/core/sysfs.c              |   7 +-
 drivers/infiniband/core/user_mad.c           |  20 +-
 drivers/infiniband/hw/amso1100/c2_provider.c |   6 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |   6 +-
 drivers/infiniband/hw/cxgb4/provider.c       |   7 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |   5 +-
 drivers/infiniband/hw/ehca/ehca_main.c       |   2 +
 drivers/infiniband/hw/ehca/ehca_sqp.c        |   9 +-
 drivers/infiniband/hw/ipath/ipath_mad.c      |   9 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |   1 +
 drivers/infiniband/hw/ipath/ipath_verbs.h    |   4 +-
 drivers/infiniband/hw/mlx4/mad.c             |  13 +-
 drivers/infiniband/hw/mlx4/main.c            |   2 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |   4 +-
 drivers/infiniband/hw/mlx5/mad.c             |   9 +-
 drivers/infiniband/hw/mlx5/main.c            |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   4 +-
 drivers/infiniband/hw/mthca/mthca_dev.h      |   5 +-
 drivers/infiniband/hw/mthca/mthca_mad.c      |  13 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |   9 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   2 +
 drivers/infiniband/hw/qib/qib_iba7322.c      |   3 +-
 drivers/infiniband/hw/qib/qib_mad.c          |  12 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |   1 +
 drivers/infiniband/hw/qib/qib_verbs.h        |   4 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   3 +-
 include/rdma/ib_mad.h                        |  37 +-
 include/rdma/ib_verbs.h                      |  55 ++-
 include/rdma/opa_smi.h                       | 106 ++++++
 42 files changed, 997 insertions(+), 301 deletions(-)
 create mode 100644 drivers/infiniband/core/opa_smi.h
 create mode 100644 include/rdma/opa_smi.h

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
