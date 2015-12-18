From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 1/3] staging/rdma/hfi1: Remove incorrect link credit check
Date: Thu, 17 Dec 2015 19:24:13 -0500
Message-ID: <1450398255-10346-1-git-send-email-jubin.john@intel.com>
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

From: Dean Luick <dean.luick@intel.com>

Remove an invalid sanity check that compares the local link
credits with the peer link credits.  The two have no dependency
on each other.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index dc69159..78a5f08 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -7267,8 +7267,7 @@ static int set_buffer_control(struct hfi1_devdata *dd,
 		new_bc->vl[i].shared = 0;
 	}
 	new_total += be16_to_cpu(new_bc->overall_shared_limit);
-	if (new_total > (u32)dd->link_credits)
-		return -EINVAL;
+
 	/* fetch the current values */
 	get_buffer_control(dd, &cur_bc, &cur_total);
 
-- 
1.7.1
