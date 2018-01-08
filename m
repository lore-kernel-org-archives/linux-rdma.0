From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v3 0/5] IB/srp: Add RDMA/CM support
Date: Mon,  8 Jan 2018 15:14:31 -0800
Message-ID: <20180108231436.19750-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason and Doug,

The five patches in this series add RDMA/CM support to the SRP
initiator. Please consider these patches for kernel v4.16.

Thanks,

Bart.

Changes compared to v2:
- Added a patch that exports kobj_ns_grab_current() and kobj_ns_drop().
- Made the rdma_create_id() call also use the namespace of the process that
  triggered SRP login. Added kobj_ns_grab_current() and kobj_ns_drop() calls
  to the SRP initiator to ensure that that network namespace exists at least
  as long as the SRP channel that is using it.

Changes compared to v1:
- Use the network namespace of the process that writes into the SRP sysfs login
  attribute in rdma_create_id() and inet_pton_with_scope() calls.
- Removed an irrelevant part from the RDMA/CM patch description.

Bart Van Assche (5):
  kobject: Export kobj_ns_grab_current() and kobj_ns_drop()
  IB/srp: Use kstrtoull() instead of simple_strtoull()
  IB/srp: Make the path record query error message more informative
  IB/srp: Refactor srp_send_req()
  IB/srp: Add RDMA/CM support

 drivers/infiniband/ulp/srp/ib_srp.c | 760 ++++++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |  42 +-
 include/scsi/srp.h                  |  17 +
 lib/kobject.c                       |   2 +
 4 files changed, 653 insertions(+), 168 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
