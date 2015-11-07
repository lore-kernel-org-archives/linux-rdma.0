From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND 00/11] staging/rdma/hfi1: Miscellaneous Fixes
Date: Fri,  6 Nov 2015 20:06:55 -0500
Message-ID: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Resending these previously sent hfi1 driver patches as a series, instead
of individual patches, based on feedback about order of patch application
from a friendly patch-bot of Greg KH.


Dean Luick (3):
  staging/rdma/hfi1: Always download SBus firmware
  staging/rdma/hfi1: Select only devices with active links
  staging/rdma/hfi1: use one-shot LCB write

Easwar Hariharan (1):
  staging/rdma/hfi1: Clear the QSFP reset that is asserted on FLR

Ignacio Hernandez (1):
  staging/rdma/hfi1: Remove spurious error messages

Ira Weiny (1):
  staging/rdma/hfi1: Eliminate WARN_ON when VL is invalid

Jareer Abdel-Qader (1):
  staging/rdma/hfi1: Disable thermal polling before sensor
    initialization

Mark F. Brown (1):
  staging/rdma/hfi1: Workaround to prevent corruption during packet
    delivery

Sebastian Sanchez (2):
  staging/rdma/hfi1: Convert dd_dev_info() to hfi1_cdbg() in process
    startup
  staging/rdma/hfi1: Fix for opaportconfig ledon by not checking for
    portNum

Vennila Megavannan (1):
  staging/rdma/hfi1: Enable WFR PCIe extended tags from the driver

 drivers/staging/rdma/hfi1/chip.c     |   79 ++++++++++++++++++++++++++--------
 drivers/staging/rdma/hfi1/chip.h     |    1 +
 drivers/staging/rdma/hfi1/driver.c   |   26 ++++++------
 drivers/staging/rdma/hfi1/file_ops.c |   31 ++++++++++---
 drivers/staging/rdma/hfi1/firmware.c |    2 +-
 drivers/staging/rdma/hfi1/hfi.h      |    4 ++
 drivers/staging/rdma/hfi1/init.c     |   59 ++++++++++++++++++++------
 drivers/staging/rdma/hfi1/mad.c      |    4 +-
 drivers/staging/rdma/hfi1/pcie.c     |   24 +++++-----
 drivers/staging/rdma/hfi1/pio.c      |   19 ++++----
 drivers/staging/rdma/hfi1/sdma.c     |   12 ++++-
 11 files changed, 183 insertions(+), 78 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
