From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 00/28] IB/srp and IB/srpt patches
Date: Wed,  3 Jan 2018 13:39:10 -0800
Message-ID: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason,

This patch series adds RDMA/CM support to the SRP initiator and target drivers
and also includes a series of bug fixes for the SRPT driver. Please consider
at least the SRPT bug fixes for kernel v4.16 since one of these fixes is a
security fix.

Thanks,

Bart.

Bart Van Assche (28):
  IB/srp: Use kstrtoull() instead of simple_strtoull()
  IB/srp: Make the path record query error message more informative
  IB/srp: Refactor srp_send_req()
  IB/srp: Add RDMA/CM support
  IB/srpt: Disable RDMA access by the initiator
  IB/srpt: Fix ACL lookup during login
  IB/srpt: Remove an unused structure member
  IB/srpt: Fix kernel-doc warnings in ib_srpt.c
  IB/srpt: Make it safe to use RCU for srpt_device.rch_list
  IB/srpt: Rework srpt_disconnect_ch_sync()
  IB/srpt: Document all structure members in ib_srpt.h
  IB/srpt: Rename a local variable, a member variable and a constant
  IB/srpt: Reduce the severity level of a log message
  IB/srpt: Verify port numbers in srpt_event_handler()
  IB/srpt: Use the IPv6 format for GIDs in log messages
  IB/srpt: Reduce frequency of receive failure messages
  IB/srpt: Introduce srpt_format_guid()
  IB/srpt: Inline srpt_get_cmd_state()
  IB/srpt: Micro-optimize I/O context state manipulation
  IB/srpt: Add P_Key support
  IB/srpt: One target per port
  IB/srpt: Rework multi-channel support
  IB/srpt: Fix login-related race conditions
  IB/srpt: Prepare RDMA/CM support
  IB/srpt: Move the code for parsing struct ib_cm_req_event_param
  IB/srpt: Fix a race condition related to wait list processing
  IB/srpt: Avoid that wait list processing triggers command reordering
  IB/srpt: Add RDMA/CM support

 drivers/infiniband/ulp/srp/ib_srp.c   |  744 ++++++++++++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h   |   41 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c | 1136 +++++++++++++++++++++------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |   88 ++-
 include/scsi/srp.h                    |   17 +
 5 files changed, 1433 insertions(+), 593 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
