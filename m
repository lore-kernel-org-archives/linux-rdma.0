From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 0/3] Enhance IB CM to support OPA extended LIDs
Date: Mon,  5 Jun 2017 14:20:00 -0400
Message-ID: <1496686803-51338-1-git-send-email-don.hiatt@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series adds enhancements to support extended LIDs in the
IB CM protocol. The core idea is to trasmit extended LIDs as OPA GIDs
on the wire in the primary_local_gid, primary_remote_gid,
alternate_local_gid and alternate_remote_gid fields of a CM request.
On the receiving side, the extended LID is retrieved from these
gids when processing the connection request.

Changes from v1:
---------------
* Replace 'IB/CM: Convert OPA Path record to IB during CM request'
  with Patch 1 to add OPA path record support to CM.
* Remove 'IB/CM: Change sgid to IB GID when handling CM request'
  as it is no longer need with the introduction of Patch 1.

The patches are organized as follows:

* Patch 1 adds OPA path record support to the Connection Manager.
* Patch 2 creates OPA path records when handling a connection request
  if the request contained OPA GIDs.
* Patch 3 'extracts' the OPA extended LIDs from the GID fields when
  handling the connection request

Please note that these patches apply on top of the previously submmitted
patch set with subject: "[PATCH rdma-next 0/8] Add OPA extended LID support"

Dasaratharaman Chandramouli (2):
  IB/CM: Create appropriate path records when handling CM request
  IB/CM: Set appropriate slid and dlid when handling CM request

Don Hiatt (1):
  IB/CM: Add OPA Path record support to CM

 drivers/infiniband/core/cm.c | 156 +++++++++++++++++++++++++++++++++++--------
 include/rdma/opa_addr.h      |  18 +++++
 2 files changed, 148 insertions(+), 26 deletions(-)

-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
