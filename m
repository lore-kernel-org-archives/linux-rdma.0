From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/2] Driver cleanup and misc fixes series 3
Date: Mon, 21 Dec 2015 21:57:43 -0500
Message-ID: <1450753065-29754-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches were part of series:
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-December/082248.html
but did not apply cleanly to the staging-testing branch.

Refreshed the remaining 2 patches against the latest staging-testing.

Changes in v2:
	- Added more information in commit messages of patches 01, 02
	  03, 04, 05, 07 and 09
	- Fixed driver name to hfi1 in subject line of patch 06
	- Refreshed patch 10 on top of staging-next
	- Dropped patch 18 (staging/rdma/hfi1: Workaround
	  CONFIG_SDMA_VERBOSITY timing issue) from series

Changes in v3:
	- Refreshed remaining 2 patches against latest staging-testing

Edward Mascarenhas (1):
  staging/rdma/hfi1: Clean up comments

Ira Weiny (1):
  staging/rdma/hfi1: Fix Xmit Wait calculation

 drivers/staging/rdma/hfi1/chip.c   |    1 -
 drivers/staging/rdma/hfi1/driver.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h    |    4 ++--
 drivers/staging/rdma/hfi1/mad.c    |   33 ++++++++++++++++++++-------------
 drivers/staging/rdma/hfi1/pcie.c   |    2 +-
 drivers/staging/rdma/hfi1/ud.c     |    2 +-
 6 files changed, 25 insertions(+), 19 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
