From: ira.weiny@intel.com
Subject: [PATCH v4 1/2] staging/rdma/hf1: add dd_dev_dbg
Date: Tue,  1 Dec 2015 14:47:56 -0500
Message-ID: <1448999277-22972-2-git-send-email-ira.weiny@intel.com>
References: <1448999277-22972-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1448999277-22972-1-git-send-email-ira.weiny@intel.com>
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

To be used in future patches add dd_dev_dbg.  dd_* functions properly decode
the hfi1_devdata structure used throughout the driver

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/hfi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 54ed6b36c1a7..f33167c2d1f7 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1758,6 +1758,10 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 	dev_info(&(dd)->pcidev->dev, "%s: " fmt, \
 			get_unit_name((dd)->unit), ##__VA_ARGS__)
 
+#define dd_dev_dbg(dd, fmt, ...) \
+	dev_dbg(&(dd)->pcidev->dev, "%s: " fmt, \
+		get_unit_name((dd)->unit), ##__VA_ARGS__)
+
 #define hfi1_dev_porterr(dd, port, fmt, ...) \
 	dev_err(&(dd)->pcidev->dev, "%s: IB%u:%u " fmt, \
 			get_unit_name((dd)->unit), (dd)->unit, (port), \
-- 
1.8.2
