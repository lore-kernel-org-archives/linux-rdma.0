From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/6] staging/rdma/hfi1: Driver cleanup and misc fixes
Date: Mon, 21 Dec 2015 21:56:13 -0500
Message-ID: <1450752979-29650-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These patches were part of patch series:
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2015-November/081566.html
but did not apply cleanly to the staging-testing branch.

Refreshed the remaining 6 patches against the latest staging-testing.

Changes in v2:
	- 01/13: Updated commit message with more information about changes in patch
	- 04/13: Updated patch subject with "hfi1" instead of "hfi"
	- 07/13: Refreshed patch based on new hfi patches in staging-next
	- 12/13: Changed logic based on Dan's suggestions in
		 http://marc.info/?l=linux-driver-devel&m=144723149431368&w=2
Changes in v3:
	- Refreshed remaining 6 patches against latest staging-testing

Dean Luick (1):
  staging/rdma/hfi1: Remove unneeded variable index

Harish Chegondi (1):
  staging/rdma/hfi1: Move s_sde to the read mostly portion of the
    hfi1_qp structure

Jubin John (2):
  staging/rdma/hfi1: Use BIT macro
  staging/rdma/hfi1: Change default krcvqs

Mark F. Brown (1):
  staging/rdma/hfi1: change krcvqs module parameter type from byte to
    uint

Vennila Megavannan (1):
  staging/rdma/hfi1: adding per SDMA engine stats to hfistats

 drivers/staging/rdma/hfi1/chip.c           |  127 +++++++++++++++++++++++++---
 drivers/staging/rdma/hfi1/chip.h           |   53 +++++++-----
 drivers/staging/rdma/hfi1/chip_registers.h |    1 +
 drivers/staging/rdma/hfi1/common.h         |    4 +-
 drivers/staging/rdma/hfi1/hfi.h            |   25 +++---
 drivers/staging/rdma/hfi1/init.c           |    6 +-
 drivers/staging/rdma/hfi1/mad.c            |    4 +-
 drivers/staging/rdma/hfi1/qp.h             |    2 +-
 drivers/staging/rdma/hfi1/qsfp.h           |   10 +-
 drivers/staging/rdma/hfi1/sdma.c           |   17 +++-
 drivers/staging/rdma/hfi1/sdma.h           |    7 ++
 drivers/staging/rdma/hfi1/verbs.h          |    2 +-
 12 files changed, 189 insertions(+), 69 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
