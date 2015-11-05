From: Jubin John <jubin.john@intel.com>
Subject: [PATCH] staging/rdma/hfi1: Fix for opaportconfig ledon by not
 checking for portNum
Date: Thu,  5 Nov 2015 18:53:26 -0500
Message-ID: <1446767606-26654-1-git-send-email-jubin.john@intel.com>
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

From: Sebastian Sanchez <sebastian.sanchez@intel.com>

opaportconfig ledon fails with error message due to port
number being checked in the attr modifier. This change
removes the check for the port number in AttrMod, so the
P field is ignored.

Reviewed-by: Easwar Hariharan <easwar.hariharan@intel.com>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/mad.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 32f7037..a122565 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -3458,7 +3458,7 @@ static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 	u32 nport = OPA_AM_NPORT(am);
 	u64 reg;
 
-	if (nport != 1 || OPA_AM_PORTNUM(am)) {
+	if (nport != 1) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
@@ -3483,7 +3483,7 @@ static int __subn_set_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 	u32 nport = OPA_AM_NPORT(am);
 	int on = !!(be32_to_cpu(p->rsvd_led_mask) & OPA_LED_MASK);
 
-	if (nport != 1 || OPA_AM_PORTNUM(am)) {
+	if (nport != 1) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
-- 
1.7.1
