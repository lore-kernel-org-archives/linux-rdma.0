From: Jannik Becher <becher.jannik@gmail.com>
Subject: [PATCH] Staging: rdma: hfi1: verbs_mcast: fixed a brace coding style
 issue
Date: Sun, 21 Feb 2016 16:30:39 +0100
Message-ID: <1456068639-4745-1-git-send-email-Becher.Jannik@gmail.com>
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
To: infinipath@intel.com
Cc: linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Jannik Becher <Becher.Jannik@gmail.com>
---
 drivers/staging/rdma/hfi1/verbs_mcast.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs_mcast.c b/drivers/staging/rdma/hfi1/verbs_mcast.c
index afc6b4c..c45d4b1 100644
--- a/drivers/staging/rdma/hfi1/verbs_mcast.c
+++ b/drivers/staging/rdma/hfi1/verbs_mcast.c
@@ -140,11 +140,11 @@ struct hfi1_mcast *hfi1_mcast_find(struct hfi1_ibport *ibp, union ib_gid *mgid)
 
 		ret = memcmp(mgid->raw, mcast->mgid.raw,
 			     sizeof(union ib_gid));
-		if (ret < 0)
+		if (ret < 0) {
 			n = n->rb_left;
-		else if (ret > 0)
+		} else if (ret > 0) {
 			n = n->rb_right;
-		else {
+		} else {
 			atomic_inc(&mcast->refcount);
 			spin_unlock_irqrestore(&ibp->lock, flags);
 			goto bail;
-- 
2.5.0
