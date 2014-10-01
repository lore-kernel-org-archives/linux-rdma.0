From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 00/21] iSER initiator updates for 3.18
Date: Wed,  1 Oct 2014 14:01:56 +0300
Message-ID: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series from Sagi, Ariel and Roi consists of:

- Last batch of iser control plane stability fixes (patches 1-10)
     Mainly in the area of combinations of multi-connections concurrent
     establishment and/or teardown and/or device removal and/or iscsid killed.

- Various performance enhancements (patches 11-16) done through the 
  engine warming towards the MQ work
     Remove atomic manipulation in the hot path
     Optimize cq polling
     Use single CQ for TX and RX and suppress most of the send completions.

- Sone nit fixes and kernel-doc fixes (patches 17-21)

It should be applied on "Signature feature update" Sagi posted (now formally
an upstream maintainer..) a short while ago for 3.18 (and you agreed to take).

In 3.18 we happily mark iSER's 20'th upstream anniversary (2.6.18..3.18),
and we're really excited for the challenge of going over 2M IOPS (current 
IO rate for single initiator) to whatever many million IOPS we can do with MQ.

Or and the team.

Ariel Nahum (3):
  IB/iser: Unbind at conn_stop stage
  IB/iser: Use iser_warn instead of BUG_ON in iser_conn_release
  IB/iser: change iscsi_conn_stop log level to info

Or Gerlitz (1):
  IB/iser: Bump version, add maintainer

Roi Dayan (1):
  IB/iser: Remove unused variables and dead code

Sagi Grimberg (16):
  IB/iser: Rename ib_conn -> iser_conn
  IB/iser: Re-introduce ib_conn
  IB/iser: Extend iser_free_ib_conn_res
  IB/iser: Fix DEVICE REMOVAL handling in the absence of iscsi daemon
  IB/iser: Don't bound release_work completions timeouts
  IB/iser: Protect tasks cleanup in case IB device was already released
  IB/iser: Signal iSCSI layer that transport is broken in error completions
  IB/iser: Centralize iser completion contexts
  IB/iser: Use internal polling budget to avoid possible live-lock
  IB/iser: Use single CQ for RX and TX
  IB/iser: Use beacon to indicate all completions were consumed
  IB/iser: Optimize completion polling
  IB/iser: Suppress scsi command send completions
  IB/iser: Nit - add space after __func__ in iser logging
  IB/iser: Add/Fix kernel doc style descriptions in iscsi_iser.h
  IB/iser: Fix/add kernel-doc style description in iscsi_iser.c

 MAINTAINERS                                  |    1 +
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  309 +++++++++---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  408 +++++++++++-----
 drivers/infiniband/ulp/iser/iser_initiator.c |  198 ++++----
 drivers/infiniband/ulp/iser/iser_memory.c    |   20 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |  667 ++++++++++++++------------
 6 files changed, 1016 insertions(+), 587 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
