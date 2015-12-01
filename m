From: ira.weiny@intel.com
Subject: [PATCH v4 0/2] staging/rdma/hfi1: set Gen 3 half-swing for integrated
 devices.
Date: Tue,  1 Dec 2015 14:47:55 -0500
Message-ID: <1448999277-22972-1-git-send-email-ira.weiny@intel.com>
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

From: Ira Weiny <ira.weiny@intel.com>

This was a single patch before.  The change to dev_dbg required a precursor
patch to add the dd_dev_dbg which is consistent with the other dev_* macros
which automatically use struct hfi1_devdata.

Dean Luick (1):
  staging/rdma/hfi1: set Gen3 half-swing for integrated devices

Ira Weiny (1):
  staging/rdma/hf1: add dd_dev_dbg

 drivers/staging/rdma/hfi1/chip_registers.h | 11 ++++
 drivers/staging/rdma/hfi1/hfi.h            |  4 ++
 drivers/staging/rdma/hfi1/pcie.c           | 82 ++++++++++++++++++++++++++++--
 3 files changed, 93 insertions(+), 4 deletions(-)

-- 
1.8.2
