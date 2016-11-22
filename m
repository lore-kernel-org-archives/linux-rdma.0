From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 00/11] IB/core: Add 32 bit LID support
Date: Tue, 22 Nov 2016 14:38:41 -0500
Message-ID: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OPA devices can support more than 48K LIDs in the fabric. A node with a LID
greater than 0xbfff is called an 'extended lid'. In order to support verbs with
extended LIDs it is necessary to modify some of the RDMA data structures where
LIDs are currently only 16 bits in length.

This patch series follows on what was presented at the OFA Workshop.  Rather
than breaking the current UABI we propose to extend the LID address space by
sending a 'special' GID value down the verbs stack that has the 32-bit LID
programmed in it. By having a means to differentiate a regular GID from our
'special' GID, the underlying OPA device driver is able to retrieve the 32-bit
LIDs from the GID fields instead of picking them up from the 16 bit lid fields.

Internal to the kernel data structures such as struct ib_wc, struct
ib_port_attr and related ones have been modified to use 32 bit LID fields.
These changes are specific to the kernel and do not break the current UABI.


Node <-> SM interaction in getting extended LID information
----------------------------------------------------------------------------
1. Source application determines the GID of the destination through standard
   means and send a pathrecord query to the SM.
2. SM (which is OPA specific) recognizes that one or more nodes in the
   pathrecord request uses extended LIDs.
3. SM issues a pathrecord response. The SGID and DGID fields in the pathrecord
   response is the specially formulated GID.
4. Additionally, SM sets the hoplimit field of the pathrecord to 1.
5. Source receives the response and can determine the actual LID of the
   destination, if needed, from the response.

Source Node <-> Destination Node interaction in using extended LID information
-------------------------------------------------------------------------------
1. Source uses the pathrecord response from the SM to create an address handle
   to the destination (either at user or kernel space).
2. Since hoplimit field in the pathrecord is > 0, GRH fields are enabled in the
   address handle.
3. Address handle information is now passed down through the RDMA stack and
   reaches the driver.
4. Driver looks at the GRH fields in the address handle and determines that the
   GID in the GRH is actually a special GID.
5. Driver retrieves LID from GID field and uses 16B packets to send data
   on the wire.
6. Driver at the receiving side determines that a GRH needs to be added to the
   address handle before passing it on to the destination application.
7. Destination now receives the packet and can send back the response using the
   same address handle information.

There are some obvious limitations with this scheme:
----------------------------------------------------
1. Multicast packets which always need a GRH cannot use this scheme.
   Essentially multicast LIDs cannot be extended.
2. Subnet routed packets which also need a GRH cannot fully use this scheme.
   Specifically the LID of the router itself cannot be extended.
   The actual destination can still be extended.
3. Applications will need to use pathrecords to get destination address
   information. Any other out-of-band mechanisms are not guaranteed to work.
4. As an extension to 3, applications that 'validate' pathrecord responses need
   to be careful not to treat 0 LID field as an error condition.

Changes from V1:
1. Increase ah_attr.dlid from 16 to 32 bits

Dasaratharaman Chandramouli (9):
  IB/core: Add rdma_cap_opa_ah to expose opa address handles
  IB/core: Change port_attr.sm_lid from 16 to 32 bits
  IB/core: Change ah_attr.dlid from 16 to 32 bits
  IB/core: Change port_attr.lid size from 16 to 32 bits
  IB/mad: Change slid in RMPP recv from 16 to 32 bits
  IB/SA: Program extended LID in SM Address handle
  IB/IPoIB: Retrieve 32 bit LIDs from path records when running on OPA
    devices
  IB/IPoIB: Modify ipoib_get_net_dev_by_params to lookup gid table
  IB/srpt: Increase lid and sm_lid to 32 bits

Don Hiatt (2):
  IB/core: Change wc.slid from 16 to 32 bits
  IB/mad: Ensure DR MADs are correctly specified when using OPA devices

 drivers/infiniband/core/cm.c              |   4 +-
 drivers/infiniband/core/mad.c             | 104 ++++++++++++++++++++++++++----
 drivers/infiniband/core/mad_rmpp.c        |   2 +-
 drivers/infiniband/core/sa_query.c        |   8 ++-
 drivers/infiniband/core/user_mad.c        |   2 +-
 drivers/infiniband/core/uverbs_cmd.c      |  23 +++++--
 drivers/infiniband/core/uverbs_marshall.c |   2 +-
 drivers/infiniband/hw/hfi1/driver.c       |   4 +-
 drivers/infiniband/hw/hfi1/mad.c          |   2 +-
 drivers/infiniband/hw/hfi1/rc.c           |   2 +-
 drivers/infiniband/hw/hfi1/ruc.c          |  19 +++---
 drivers/infiniband/hw/hfi1/ud.c           |  10 +--
 drivers/infiniband/hw/hfi1/verbs.c        |   4 +-
 drivers/infiniband/hw/mlx4/ah.c           |   2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c   |   2 +-
 drivers/infiniband/hw/mlx4/mad.c          |   8 +--
 drivers/infiniband/hw/mlx4/qp.c           |   2 +-
 drivers/infiniband/hw/mlx5/ah.c           |   2 +-
 drivers/infiniband/hw/mlx5/mad.c          |   2 +-
 drivers/infiniband/hw/mthca/mthca_av.c    |   2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c   |   4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c   |   4 +-
 drivers/infiniband/hw/mthca/mthca_qp.c    |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c  |   2 +-
 drivers/infiniband/hw/qib/qib_rc.c        |   2 +-
 drivers/infiniband/hw/qib/qib_ruc.c       |   9 +--
 drivers/infiniband/hw/qib/qib_ud.c        |   8 +--
 drivers/infiniband/sw/rdmavt/cq.c         |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h      |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  11 ++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  63 +++++++++++++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h     |   4 +-
 include/rdma/ib_verbs.h                   |  29 +++++++--
 include/rdma/opa_addr.h                   |  68 +++++++++++++++++++
 34 files changed, 340 insertions(+), 78 deletions(-)
 create mode 100644 include/rdma/opa_addr.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
