From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/4] iSER initiator updates for 3.16
Date: Thu, 22 May 2014 11:00:17 +0300
Message-ID: <1400745621-9978-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patchset address several resiliency issues in the area of
connection establishment and teardown (especially in error flows).

Patch #1 introduces a re-design of iSER connection management done
by Ariel and Sagi. It comes to solve few error-flow hangs/oops's 
we've seen in regression testing under various failure schemes, and
make things simpler.

Patch #2 Addresses a racy state transition.

Following that comes a patch that fixes some prints and a bump to the 
driver version.

Or.

Ariel Nahum (2):
  IB/iser: Simplify connection management
  IB/iser: Fix a possible race in iser connection states transition

Or Gerlitz (1):
  IB/iser: Bump version to 1.4

Roi Dayan (1):
  IB/iser: Add missing newlines to logging messages

 drivers/infiniband/ulp/iser/iscsi_iser.c |  105 +++++++++++++++++------------
 drivers/infiniband/ulp/iser/iscsi_iser.h |   10 ++-
 drivers/infiniband/ulp/iser/iser_verbs.c |   89 +++++++++++--------------
 3 files changed, 106 insertions(+), 98 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
