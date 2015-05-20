From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 00/14] IB/mad: Add support for OPA MAD processing.
Date: Wed, 20 May 2015 04:13:21 -0400
Message-ID: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
capability flag.

I am submitting this as a set of smaller patches which should be easier to
review individually but with the exception of the first patch they should be
accepted as a series.  I recognize that many of the patches could be squashed
when considering functionality only but I don't think that is easiest way to
review them.

The patch series is broken up as follows:

1 patch
  IB/mad: Clean up ib_find_send_mad

	Generalize ib_find_send_mad for both OPA and IB devices

6 patches
  IB/mad: Create an RMPP Base header
  IB/mad: Create handle_ib_smi
  IB/mad: Add helper function for smi_handle_dr_smp_send
  IB/mad: Add helper function for smi_handle_dr_smp_recv
  IB/mad: Add helper function for smi_check_forward_dr_smp
  IB/mad: Add base version to ib_create_send_mad

	Modify existing MAD code in anticipation for that code to handle both
	OPA and IB MADs but retain only the IB functionality within the patches
	themselves.


3 patches
  IB/core: Add rdma_max_mad_size helper
  IB/mad: Convert allocations from kmem_cache to kmalloc
  IB/mad: Add MAD size parameters to process_mad

	Add max MAD size to the device immutable data and convert the MAD code
	to use that value rather than the previous hard coded MAD size of 256
	bytes.  Once again these patches retain the IB functionality but do so
	by specifying a new define for their MAX MAD size.

4 patches
  IB/core: Add rdma_cap_opa_mad helper
  IB/mad: Add partial Intel OPA MAD support
  IB/mad: Add partial Intel OPA MAD support
  IB/mad: Add final OPA MAD processing

	Implement an OPA device immutable core capability flag and use it to
	process OPA MADs as appropriate.  Once again this is split up to make
	reviewing the patches easier.


Due to the large structural change of these patches vs previous submissions I
am submitting these as a new series.

The following general comments were addressed from the last "version".

Rebased to latest Dougs for-4.2 branch
	Update based on Michaels rdma_cap_* helpers and related core capability
	work.

Address Comments by Doug Ledford
	Change device MAD size error message to a WARN_ON
	Add gfp_t flags to alloc_mad_priv and pass the correct flags depending
	on the allocation site.

Address Comments by Sean Hefty
	Change alloc_mad_priv to take mad_size
	Change individual device mad size checks in process_mad to be
	WARN_ON
	create new patch which defines an ib_rmpp_hdr struct to be
	shared between IB and OPA mad defines.
	Change "jumbo" to "opa" and remove jumbo from all related
	documentation/commit messages
	Fix up comments for smi functions
	Remove cached_dev_attr patch and replace with the new immutable data



Ira Weiny (14):
  IB/mad: Clean up ib_find_send_mad
  IB/mad: Create an RMPP Base header
  IB/mad: Create handle_ib_smi
  IB/mad: Add helper function for smi_handle_dr_smp_send
  IB/mad: Add helper function for smi_handle_dr_smp_recv
  IB/mad: Add helper function for smi_check_forward_dr_smp
  IB/mad: Add base version to ib_create_send_mad
  IB/core: Add rdma_max_mad_size helper
  IB/mad: Convert allocations from kmem_cache to kmalloc
  IB/mad: Add MAD size parameters to process_mad
  IB/core: Add rdma_cap_opa_mad helper
  IB/mad: Add partial Intel OPA MAD support
  IB/mad: Add partial Intel OPA MAD support
  IB/mad: Add final OPA MAD processing

 drivers/infiniband/core/agent.c              |  22 +-
 drivers/infiniband/core/agent.h              |   3 +-
 drivers/infiniband/core/cm.c                 |   6 +-
 drivers/infiniband/core/mad.c                | 469 +++++++++++++++++++--------
 drivers/infiniband/core/mad_priv.h           |   7 +-
 drivers/infiniband/core/mad_rmpp.c           | 148 +++++----
 drivers/infiniband/core/opa_smi.h            |  78 +++++
 drivers/infiniband/core/sa_query.c           |   3 +-
 drivers/infiniband/core/smi.c                | 231 +++++++++----
 drivers/infiniband/core/sysfs.c              |   5 +-
 drivers/infiniband/core/user_mad.c           |  36 +-
 drivers/infiniband/hw/amso1100/c2_provider.c |   5 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |   5 +-
 drivers/infiniband/hw/cxgb4/provider.c       |   7 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |   4 +-
 drivers/infiniband/hw/ehca/ehca_main.c       |   2 +
 drivers/infiniband/hw/ehca/ehca_sqp.c        |   9 +-
 drivers/infiniband/hw/ipath/ipath_mad.c      |   9 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |   1 +
 drivers/infiniband/hw/ipath/ipath_verbs.h    |   3 +-
 drivers/infiniband/hw/mlx4/mad.c             |  13 +-
 drivers/infiniband/hw/mlx4/main.c            |   2 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |   3 +-
 drivers/infiniband/hw/mlx5/mad.c             |   9 +-
 drivers/infiniband/hw/mlx5/main.c            |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   3 +-
 drivers/infiniband/hw/mthca/mthca_dev.h      |   4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c      |  13 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |   9 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   2 +
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h  |   1 +
 drivers/infiniband/hw/qib/qib_iba7322.c      |   3 +-
 drivers/infiniband/hw/qib/qib_mad.c          |  12 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |   1 +
 drivers/infiniband/hw/qib/qib_verbs.h        |   3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   3 +-
 include/rdma/ib_mad.h                        |  36 +-
 include/rdma/ib_verbs.h                      |  44 ++-
 include/rdma/opa_smi.h                       | 106 ++++++
 42 files changed, 994 insertions(+), 334 deletions(-)
 create mode 100644 drivers/infiniband/core/opa_smi.h
 create mode 100644 include/rdma/opa_smi.h

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
