From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 1/3] IB/hfi1: Validate fault injection opcode user
 input
Date: Fri, 07 Jun 2019 08:25:25 -0400
Message-ID: <20190607122525.158478.61319.stgit@awfm-01.aw.intel.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

The opcode range for fault injection from user should be validated
before it is applied to the fault->opcodes[] bitmap to avoid
out-of-bound error. In addition, this patch also simplifies the code
by using the BIT macro.

Fixes: a74d5307caba ("IB/hfi1: Rework fault injection machinery")
Cc: <stable@vger.kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/fault.c |    5 +++++
 drivers/infiniband/hw/hfi1/fault.h |    6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index 3fd3315..13ba291 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -153,6 +153,7 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 		char *dash;
 		unsigned long range_start, range_end, i;
 		bool remove = false;
+		unsigned long bound = BIT(BITS_PER_BYTE);
 
 		end = strchr(ptr, ',');
 		if (end)
@@ -178,6 +179,10 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 				    BITS_PER_BYTE);
 			break;
 		}
+		/* Check the inputs */
+		if (range_start >= bound || range_end >= bound)
+			break;
+
 		for (i = range_start; i <= range_end; i++) {
 			if (remove)
 				clear_bit(i, fault->opcodes);
diff --git a/drivers/infiniband/hw/hfi1/fault.h b/drivers/infiniband/hw/hfi1/fault.h
index a833827..c61035c 100644
--- a/drivers/infiniband/hw/hfi1/fault.h
+++ b/drivers/infiniband/hw/hfi1/fault.h
@@ -60,13 +60,13 @@
 struct fault {
 	struct fault_attr attr;
 	struct dentry *dir;
-	u64 n_rxfaults[(1U << BITS_PER_BYTE)];
-	u64 n_txfaults[(1U << BITS_PER_BYTE)];
+	u64 n_rxfaults[BIT(BITS_PER_BYTE)];
+	u64 n_txfaults[BIT(BITS_PER_BYTE)];
 	u64 fault_skip;
 	u64 skip;
 	u64 fault_skip_usec;
 	unsigned long skip_usec;
-	unsigned long opcodes[(1U << BITS_PER_BYTE) / BITS_PER_LONG];
+	unsigned long opcodes[BIT(BITS_PER_BYTE) / BITS_PER_LONG];
 	bool enable;
 	bool suppress_err;
 	bool opcode;
