From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 0/4] Enhance IB CM to support OPA extended LIDs
Date: Wed, 10 May 2017 19:23:14 -0400
Message-ID: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series adds enhancements to support extended LIDs in the
IB CM protocol. The core idea is to trasmit extended LIDs as OPA GIDs
on the wire in the primary_local_gid, primary_remote_gid,
alternate_local_gid and alternate_remote_gid fields of a CM request.
On the receiving side, the extended LID is retrieved from these
gids when processing the connection request.

The patches are organized as follows:

* Patch 1 converts an OPA path record to an IB path record before
  placing GIDs from the path record onto a CM reqeust message. If the
  OPA path records were to contain exteded LIDs, the converted IB path
  record would contain OPA GIDs in the SGID and DGID fields.
* Patch 2 creates OPA path records when handling a connection request
  if the request contained OPA GIDs.
* Patch 3 'extracts' the OPA extended LIDs from the GID fields when
  handling the connection request
* Patch 4 changes the sgid parameter back to an IB GID when handing
  a request thereby ensuring that underlying handers of the CM request
  message such as IPoIB continue to work when it compares an incoming
  GID with the GID assign to its interface.

Please note that these patches apply on top of the previously submmitted
patch set with subject: "[PATCH rdma-next 0/8] Add OPA extended LID support"

Dasaratharaman Chandramouli (4):
  IB/CM: Convert OPA Path record to IB during CM request
  IB/CM: Create appropriate path records when handling CM request
  IB/CM: Set appropriate slid and dlid when handling CM request
  IB/CM: Change sgid to IB GID when handling CM request

 drivers/infiniband/core/cm.c | 184 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 152 insertions(+), 32 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
