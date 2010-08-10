From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 0/3 v4] IB/srp: Add SRP_CRED_REQ support
Date: Tue, 10 Aug 2010 20:32:55 +0200
Message-ID: <201008102032.55576.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series of three patches adds SRP_CRED_REQ support in ib_srp, which is a
feature defined in the SRP (draft) standard.

Changes in v4 compared to v3:
- Dropped the fourth patch since it has been merged.
- Introduced the symbolic constant SRP_TSK_MGMT_RSV, which represents the
  number of slots reserved in the tx ring for SRP task management requests.
- One slot of the transmit ring buffer is now reserved for sending
  SRP_TSK_MGMT requests.
- The BUILD_BUG_ON_NOT_POWER_OF_2() macro is now used to verify whether
  SRP_RQ_MASK and SRP_SQ_MASK really are bitmasks.
- Rearranged function order such that no new forward declarations have to be
  introduced in the second patch.
- Eliminated the srp_target_port.tx_req and tx_rsp variables.
- Removed the SRP_OP_RSP flag.
- Added a source code comment that explains why can_queue must be less than
  req_lim.

Changes in v3 compared to v2:
- Corrected completion queue size from SRP_REQ_SQ_SIZE (63) into
  SRP_SQ_SIZE (64).
- Merged the two functions __srp_get_tx_req_iu() and __srp_get_tx_rsp_iu()
  into a single function __srp_get_tx_iu().
- Removed __attribute__((packed)) from the structure definitions added in
  include/scsi/srp.h because it was superfluous.
- Modified descriptions of patches 1/4, 2/4 and 3/4.

Changes in v2 compared to v1:
- Split the big patch into multiple patches, which makes reviewing easier.
- Instead of defining separate queues for transmitting requests and responses,
  a single queue is now used.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
