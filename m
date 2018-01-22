From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v5 0/3] IB/srp patches for kernel v4.16
Date: Mon, 22 Jan 2018 14:27:10 -0800
Message-ID: <20180122222713.13197-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason and Doug,

The patches in this series add RDMA/CM support to the SRP initiator and also
add a debug option. Please consider these patches for kernel v4.16.

Thanks,

Bart.

Changes compared to v4:
- Left out the patches that have already been queued for kernel v4.16.
- Added Greg's ack to patch 1/3.
- Added a third patch that adds the starget_can_queue login option.

Changes compared to v3:
- Moved a kobj_ns_drop() call inside an if-statement to keep the grab and put
  ns calls balanced.

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

Bart Van Assche (3):
  kobject: Export kobj_ns_grab_current() and kobj_ns_drop()
  IB/srp: Add RDMA/CM support
  IB/srp: Add target_can_queue login parameter

 drivers/infiniband/ulp/srp/ib_srp.c | 723 ++++++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srp/ib_srp.h |  43 ++-
 include/scsi/srp.h                  |  17 +
 lib/kobject.c                       |   2 +
 4 files changed, 631 insertions(+), 154 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
