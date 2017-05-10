From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 0/8] Add OPA extended LID support
Date: Wed, 10 May 2017 19:22:48 -0400
Message-ID: <1494458576-6816-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series primarily increases sizes of variables that hold
lid values from 16 to 32 bits. Additionally, its add a check in
the IB mad stack to verify a properly formatted MAD when OPA
extended LIDs are used.

The patches are origanized as follows:

* Patch 1 converts an OPA ah_attr to an IB ah_attr when
  copying from kernel to user. Since OPA ah_attr is only defined
  in the kernel, the function takes care of adding OPA GIDs
  that contain the extended LID before copying to user.
* Patch 2 increases the lid and sm_lid variables in srpt
  to 32 bits.
* Patch 3 increases the local_lid variable in IPoIB to 32
  bits.
* Patch 4 increases the slid variable in MAD RMPP to 32 bits.
* Patch 5 increaes the lid field in struct ib_port_attr from
  16 to 32 bits.
* Patch 6 increases the sm_lid field in struct ib_port_attr
  from 16 to 32 bits.
* Patch 7 increases the slid field in struct ib_wc from 16
  to 32 bits.
* Patch 8 adds a check in IB mad to ensure a MAD payload is
  properly formatted when using extended LIDs.

Dasaratharaman Chandramouli (6):
  IB/core: Convert ah_attr from OPA to IB when copying to user
  IB/srpt: Increase lid and sm_lid to 32 bits
  IB/IPoIB: Increase local_lid to 32 bits
  IB/mad: Change slid in RMPP recv from 16 to 32 bits
  IB/core: Change port_attr.lid size from 16 to 32 bits
  IB/core: Change port_attr.sm_lid from 16 to 32 bits

Don Hiatt (2):
  IB/core: Change wc.slid from 16 to 32 bits
  IB/mad: Ensure DR MADs are correctly specified when using OPA devices

 drivers/infiniband/core/cm.c              |   4 +-
 drivers/infiniband/core/core_priv.h       |   1 +
 drivers/infiniband/core/mad.c             | 107 ++++++++++++++++++++++++++----
 drivers/infiniband/core/mad_rmpp.c        |   2 +-
 drivers/infiniband/core/ucm.c             |   2 +-
 drivers/infiniband/core/ucma.c            |  10 +--
 drivers/infiniband/core/user_mad.c        |   2 +-
 drivers/infiniband/core/uverbs_cmd.c      |  20 ++++--
 drivers/infiniband/core/uverbs_marshall.c |  41 ++++++++++--
 drivers/infiniband/hw/hfi1/mad.c          |   2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c   |   2 +-
 drivers/infiniband/hw/mlx4/mad.c          |   8 +--
 drivers/infiniband/hw/mlx5/mad.c          |   2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c   |   4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c   |   4 +-
 drivers/infiniband/sw/rdmavt/cq.c         |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h      |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h     |   4 +-
 include/rdma/ib_marshall.h                |   6 +-
 include/rdma/ib_verbs.h                   |   6 +-
 include/rdma/opa_addr.h                   |   3 +-
 21 files changed, 182 insertions(+), 52 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
