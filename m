From: ira.weiny@intel.com
Subject: [PATCH 4/8] staging/rdma/hfi1: remove unneeded goto done
Date: Wed, 11 Nov 2015 00:43:05 -0500
Message-ID: <1447220589-9067-5-git-send-email-ira.weiny@intel.com>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
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
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

This goto done is followed by an if (ret) break in the outer switch clause.  It
is unnecessary.

Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 2bb857b2a103..556a47591989 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1053,7 +1053,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 				break;
 			default:
 				ret = -EINVAL;
-				goto done;
 			}
 			ret = set_link_state(ppd, dev_state);
 			break;
@@ -1201,7 +1200,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		ret = -ENOTTY;
 		break;
 	}
-done:
+
 	spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 	return ret;
 }
-- 
1.8.2
