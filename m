From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 0/5 v6] IB/srp: Patches for 2.6.37
Date: Sun, 22 Aug 2010 18:56:02 +0200
Message-ID: <201008221856.02894.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series of five patches adds SRP_CRED_REQ and SRP_AER_REQ support in
ib_srp, implements a small performance optimization and introduces the macro
list_first_entry().

Changes in v6 compared to v5:
- Changed the title of this patch series to reflect better the purpose of the
  patch series.
- Merged the functions __srp_post_send_iu(), __srp_post_send_req() and
  __srp_post_send_rsp() back into a single function called __srp_post_send().
- Split the patch that adds SRP_CRED_REQ support again in two patches: one
  with the new functionality and one that rearranges the function definition
  order.
- Response processing: avoided a double switch on the response opcode.
- Renamed some of the newly introduced constants and datatypes.
- Updated patch descriptions and source code comments.

Changes in v5 compared to v4:
- Added support for processing the SRP_AER_REQ information unit.
- Introduced a new symbolic name, SRP_NORMAL_REQ_SQ_SIZE, that represents the
  maximum number of requests that may be queued by the SCSI mid-layer.
- Changed transmit ring overflow check back to that of v3 (removed "- rsv"
  again).
- Reduced the size of the srp_target_port.req_ring array by one element such
  that its size again matches the maximum number of requests that can be
  queued by the SCSI mid-layer.
- Moved BUILD_BUG_ON_NOT_POWER_OF_2() statements to the module initialization
  function.
- Updated patch descriptions.

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
