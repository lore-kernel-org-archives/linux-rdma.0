From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 0/5] IB/usnic: Revamp usnic_fwd.h
Date: Thu,  9 Jan 2014 14:48:05 -0800
Message-ID: <1389307690-11493-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Depends on "[PATCH v1 for-next] IB/usnic: Bug fixes" series.

usNIC device's networking/forwarding state is being kept on
usnic_ib_dev and usnic_fwd_dev.  This patch moves all of the
forwarding/networking state to usnic_fwd_dev.  With new states,
comes a revamped usnic_fwd.h interface.  All of the usnic code
is ported to the new usnic_fwd.h interface.

V1 changes:
Use lockdep_assert instead of spin_is_locked(...

Upinder Malhi (5):
  IB/usnic: Add struct usnic_transport_spec
  IB/usnic: Push all forwarding state to usnic_fwd.[hc]
  IB/usnic: Port over main.c and verbs.c to the usnic_fwd.h
  IB/usnic: Port over usnic_ib_qp_grp.[hc] to new usnic_fwd.h
  IB/usnic: Port over sysfs to new usnic_fwd.h

 drivers/infiniband/hw/usnic/usnic_abi.h       |   9 +
 drivers/infiniband/hw/usnic/usnic_fwd.c       | 269 ++++++++++++--------
 drivers/infiniband/hw/usnic/usnic_fwd.h       |  68 +++--
 drivers/infiniband/hw/usnic/usnic_ib.h        |   3 -
 drivers/infiniband/hw/usnic/usnic_ib_main.c   |  38 +--
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 347 +++++++++++++++++---------
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h |  24 +-
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c  |  10 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  |  37 +--
 9 files changed, 512 insertions(+), 293 deletions(-)

--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
