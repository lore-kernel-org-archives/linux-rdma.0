From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 0/6] IB/usnic: usNIC UDP Support
Date: Thu,  9 Jan 2014 14:48:13 -0800
Message-ID: <1389307699-11545-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Depends on "[PATCH v2 for-next] IB/usnic: Revamp usnic_fwd.h" series.

This set of patches add UDP transport support on usNIC. Libusnic,
a libibverbs driver, allocates a UDP socket in the kernel via the
userspace socket API at ibv_create_qp time.  Then, the socket file
descriptor is pushed down to usnic_verbs.ko via ibv_create_qp_cmd.
Usnic_verbs bumps up the reference count on the socket, creates the qp,
and programs the forwarding classifier in the NIC to forward UDP traffic on
the socket fd, to the associated qp.  The forwarding classifier entry is
released whenever the qp is destroyed.  The reference count on the socket
is decremented after the forwarding classifier entry has been released.

The socket reference count is incremented in the first place to cover this
case: A malicious user returns the UDP port to the kernel but does not
destroy the qp or the associated forwarding entry in the NIC. Subsequently,
the kernel may give the UDP port to another application, but because
of the classifier entry in the NIC, the former user of the UDP port continues
to receive the traffic.  Increasing the reference count on the socket
guarantees that the socket will not go back to the kernel's free pool until
both the application closes the socket and the forwarding entry in the NIC
has been deleted.

V1 changes:
Use lockdep_assert instead of spin_is_locked(...
Add RDMA_TRANSPORT_USNIC_UDP as a new transport instead of renaming RDMA_TRANSPORT_USNIC

Upinder Malhi (6):
  IB/usnic: Update ABI and Version file for UDP support
  IB/usnic: Add UDP support to usnic_fwd.[hc]
  IB:usnic: Add UDP support to usnic_transport.[hc]
  IB/usnic: Add UDP support in u*verbs.c, u*main.c and u*util.h
  IB/usnic: Add UDP support in usnic_ib_qp_grp.[hc]
  IB/core: Add RDMA_TRANSPORT_USNIC_UDP

 drivers/infiniband/core/verbs.c                 |  3 +-
 drivers/infiniband/hw/usnic/usnic.h             |  4 +-
 drivers/infiniband/hw/usnic/usnic_abi.h         | 12 +++-
 drivers/infiniband/hw/usnic/usnic_common_util.h | 17 +++++
 drivers/infiniband/hw/usnic/usnic_fwd.c         | 54 ++++++++++++++
 drivers/infiniband/hw/usnic/usnic_fwd.h         | 21 ++++++
 drivers/infiniband/hw/usnic/usnic_ib_main.c     | 84 +++++++++++++++++++++-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c   | 88 +++++++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h   | 11 +++
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c    | 44 +++++++++---
 drivers/infiniband/hw/usnic/usnic_transport.c   | 93 +++++++++++++++++++++++--
 drivers/infiniband/hw/usnic/usnic_transport.h   | 19 +++++
 include/rdma/ib_verbs.h                         |  3 +-
 13 files changed, 431 insertions(+), 22 deletions(-)

--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
