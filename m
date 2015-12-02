From: ira.weiny@intel.com
Subject: [PATCH 4/5] staging/rdma/hfi1: Detect SDMA transmission error early
Date: Wed,  2 Dec 2015 15:56:26 -0500
Message-ID: <1449089787-7258-5-git-send-email-ira.weiny@intel.com>
References: <1449089787-7258-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449089787-7258-1-git-send-email-ira.weiny@intel.com>
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
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, Mitko Haralanov <mitko.haralanov@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov@intel.com>

It is possible for an SDMA transmission error to happen
during the processing of an user SDMA transfer. In that
case it is better to detect it early and abort any further
attempts to send more packets.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
---
 drivers/staging/rdma/hfi1/user_sdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 060c2200757d..3033df5596f3 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -782,6 +782,12 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 
 	pq = req->pq;
 
+	/* If tx completion has reported an error, we are done. */
+	if (test_bit(SDMA_REQ_HAS_ERROR, &req->flags)) {
+		set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
+		return -EFAULT;
+	}
+
 	/*
 	 * Check if we might have sent the entire request already
 	 */
-- 
1.8.2
