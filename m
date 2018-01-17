From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 00/14] IB/srpt: Add RDMA/CM support
Date: Tue, 16 Jan 2018 16:14:04 -0800
Message-ID: <20180117001418.7852-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason and Doug,

This patch series not only adds RDMA/CM support to the SRP target driver but
also fixes a number of race conditions in that driver.

The RDMA/CM listener port number has to be specified as an ib_srpt kernel
module parameter. The default value for that parameter is zero which means
that RDMA/CM support is disabled.

Note: since this patch series uses the srp_login_req_rdma structure that was
introduced by the IB/srp RDMA/CM patch series, this series depends on the
IB/srp RDMA/CM patch series.

This patch series, just like v4 of the IB/srp RDMA/CM patch series, passes
Laurence Oberman's tests.

Please consider this patch series for inclusion in the upstream kernel.

Thanks,

Bart.

Changes compared to v1:
- Added patch "Fix a race condition related to wait list processing".
- Fixed the size of the character arrays used to store the initiator port ID
  and session name. This fixes a login failure that was reported by Laurence
  Oberman.

Bart Van Assche (14):
  IB/srpt: Make it safe to use RCU for srpt_device.rch_list
  IB/srpt: Rework srpt_disconnect_ch_sync()
  IB/srpt: Add P_Key support
  IB/srpt: One target per port
  IB/srpt: Use the source GID as session name
  IB/srpt: Rework multi-channel support
  IB/srpt: Simplify srpt_close_session()
  IB/srpt: Log all zero-length writes and completions
  IB/srpt: Fix login-related race conditions
  IB/srpt: Fix a race condition related to wait list processing
  IB/srpt: Avoid that wait list processing triggers command reordering
  IB/srpt: Prepare RDMA/CM support
  IB/srpt: Move the code for parsing struct ib_cm_req_event_param
  IB/srpt: Add RDMA/CM support

 drivers/infiniband/ulp/srpt/ib_srpt.c | 953 +++++++++++++++++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  66 ++-
 2 files changed, 706 insertions(+), 313 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
