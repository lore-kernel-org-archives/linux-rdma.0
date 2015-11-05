From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] staging/rdma/hfi1: Delete unnecessary checks before two
 function calls
Date: Thu, 5 Nov 2015 09:10:47 +0100
Message-ID: <563B0F07.3090301@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Doug Ledford <dledford@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 5 Nov 2015 08:41:00 +0100

The functions "sc_return_credits" and "vfree" perform also input
parameter validation. Thus the tests around their calls are not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/rdma/hfi1/file_ops.c  | 2 +-
 drivers/staging/rdma/hfi1/user_sdma.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index aae9826..204d1d0 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -313,7 +313,7 @@ static ssize_t hfi1_file_write(struct file *fp, const char __user *data,
 	case HFI1_CMD_SDMA_STATUS_UPD:
 		break;
 	case HFI1_CMD_CREDIT_UPD:
-		if (uctxt && uctxt->sc)
+		if (uctxt)
 			sc_return_credits(uctxt->sc);
 		break;
 	case HFI1_CMD_TID_UPDATE:
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 36c838d..45f3797 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -473,8 +473,7 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 		fd->pq = NULL;
 	}
 	if (fd->cq) {
-		if (fd->cq->comps)
-			vfree(fd->cq->comps);
+		vfree(fd->cq->comps);
 		kfree(fd->cq);
 		fd->cq = NULL;
 	}
-- 
2.6.2
