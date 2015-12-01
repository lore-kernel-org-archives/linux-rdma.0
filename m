From: Jubin John <jubin.john@intel.com>
Subject: [PATCH v2 00/17] Driver cleanup and misc fixes series 3
Date: Tue,  1 Dec 2015 15:38:09 -0500
Message-ID: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

Changes in v2:
	- Added more information in commit messages of patches 01, 02
	  03, 04, 05, 07 and 09
	- Fixed driver name to hfi1 in subject line of patch 06
	- Refreshed patch 10 on top of staging-next
	- Dropped patch 18 (staging/rdma/hfi1: Workaround
	  CONFIG_SDMA_VERBOSITY timing issue) from series

Andrea Lowe (1):
  staging/rdma/hfi1: Adding counter resolutions for DataPortCounters

Dean Luick (10):
  staging/rdma/hfi1: Support alternate firmware names
  staging/rdma/hfi1: Decode CNP opcode
  staging/rdma/hfi1: Add aeth name syndrome decode
  staging/rdma/hfi1: Add one-time LCB reset
  staging/rdma/hfi1: Extend quiet timeout
  staging/rdma/hfi1: Add a credit push on diagpkt allocate fail
  staging/rdma/hfi1: Correctly limit VLs against SDMA engines
  staging/rdma/hfi1: Unexpected link up pkey values are not an error
  staging/rdma/hfi1: remove SPC freeze error messages
  staging/rdma/hfi1: unknown frame messages are not errors

Edward Mascarenhas (1):
  staging/rdma/hfi1: Clean up comments

Harish Chegondi (2):
  staging/rdma/hfi1: Destroy workqueues if hfi1_register_ib_device()
    call returns error
  staging/rdma/hfi1: Consider VL15 MTU also when calculating the
    maximum VL MTU

Ira Weiny (1):
  staging/rdma/hfi1: Fix Xmit Wait calculation

Joel Rosenzweig (1):
  staging/rdma/hfi1: Adds software counters for bitfields within
    various error status fields

Kaike Wan (1):
  staging/rdma/hfi1: Fix qp.h comments

 drivers/staging/rdma/hfi1/chip.c           | 3248 +++++++++++++++++++++++++++-
 drivers/staging/rdma/hfi1/chip.h           |  270 +++
 drivers/staging/rdma/hfi1/chip_registers.h |    3 +
 drivers/staging/rdma/hfi1/diag.c           |    8 +
 drivers/staging/rdma/hfi1/driver.c         |    2 +-
 drivers/staging/rdma/hfi1/firmware.c       |  189 ++-
 drivers/staging/rdma/hfi1/hfi.h            |   40 +-
 drivers/staging/rdma/hfi1/init.c           |    9 +-
 drivers/staging/rdma/hfi1/mad.c            |   70 +-
 drivers/staging/rdma/hfi1/pcie.c           |    2 +-
 drivers/staging/rdma/hfi1/qp.h             |    8 +-
 drivers/staging/rdma/hfi1/trace.c          |   29 +-
 drivers/staging/rdma/hfi1/trace.h          |    3 +-
 drivers/staging/rdma/hfi1/ud.c             |    2 +-
 14 files changed, 3795 insertions(+), 88 deletions(-)
