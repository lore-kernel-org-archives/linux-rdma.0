From: ira.weiny@intel.com
Subject: [PATCH v3 03/13] staging/rdma/hfi1: diag.c fix logical continuations
Date: Wed,  2 Dec 2015 00:43:28 -0500
Message-ID: <1449035018-26396-4-git-send-email-ira.weiny@intel.com>
References: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
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

Place logical operators at the end of the previous line when using a multi-line
statement.  Found by checkpatch --strict

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 1d9faad7662f..ca833e9a4f15 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -530,9 +530,9 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 		 * NOTE: PRC_FILL_ERR is at best informational and cannot
 		 * be depended on.
 		 */
-		if (!ret && (((wait->code & PRC_STATUS_ERR)
-				|| (wait->code & PRC_FILL_ERR)
-				|| (wait->code & PRC_SC_DISABLE))))
+		if (!ret && (((wait->code & PRC_STATUS_ERR) ||
+			      (wait->code & PRC_FILL_ERR) ||
+			      (wait->code & PRC_SC_DISABLE))))
 			ret = -EIO;
 
 		put_diagpkt_wait(wait);	/* finished with the structure */
-- 
1.8.2
