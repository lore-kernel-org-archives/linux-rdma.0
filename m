From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] staging/rdma/hfi1: Fix reporting of LED status in
 Get(LedInfo) and Get(PortInfo)
Date: Fri, 26 Feb 2016 13:33:28 -0800
Message-ID: <20160226213328.16535.27782.stgit@scvm10.sc.intel.com>
References: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160226213022.16535.8149.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The LedInfo SMA attribute is redefined to control the LED beaconing
state machine instead of the LED directly. In accordance, we now
return the state of LED beaconing, represented by whether the beaconing
timer is active, instead of the state of the LED itself for SMA queries
Get(LedInfo) and Get(PortInfo). While we are at it, we fix the beaconing
timer control code so that the state of the timer is accurately updated.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |   13 +++++++++++--
 drivers/staging/rdma/hfi1/mad.c    |   24 +++++++++++++++++++-----
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 76ed5f7..4581864 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -1169,6 +1169,12 @@ void shutdown_led_override(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 
+	/*
+	 * This pairs with the memory barrier implied by the atomic_dec in
+	 * hfi1_set_led_override to ensure that we read the correct state of
+	 * LED beaconing represented by led_override_timer_active
+	 */
+	smp_mb();
 	if (atomic_read(&ppd->led_override_timer_active)) {
 		del_timer_sync(&ppd->led_override_timer);
 		atomic_set(&ppd->led_override_timer_active, 0);
@@ -1199,11 +1205,14 @@ static void run_led_override(unsigned long opaque)
 	 * don't re-fire the timer if user asked for it to be off; we let
 	 * it fire one more time after they turn it off to simplify
 	 */
-	if (ppd->led_override_vals[0] || ppd->led_override_vals[1])
+	if (ppd->led_override_vals[0] || ppd->led_override_vals[1]) {
 		mod_timer(&ppd->led_override_timer, jiffies + timeout);
-	else
+	} else {
 		/* Hand control of the LED to the DC for normal operation */
 		write_csr(dd, DCC_CFG_LED_CNTRL, 0);
+		/* Record that we did not re-fire the timer */
+		atomic_dec(&ppd->led_override_timer_active);
+	}
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 78931fc..5925798 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -516,6 +516,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	struct opa_port_info *pi = (struct opa_port_info *)data;
 	u8 mtu;
 	u8 credit_rate;
+	u8 is_beaconing_active;
 	u32 state;
 	u32 num_ports = OPA_AM_NPORT(am);
 	u32 start_of_sm_config = OPA_AM_START_SM_CFG(am);
@@ -581,6 +582,14 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	pi->port_states.ledenable_offlinereason = ppd->neighbor_normal << 4;
 	pi->port_states.ledenable_offlinereason |=
 		ppd->is_sm_config_started << 5;
+	/*
+	 * This pairs with the memory barrier implied by the atomic_dec in
+	 * hfi1_set_led_override to ensure that we read the correct state of
+	 * LED beaconing represented by led_override_timer_active
+	 */
+	smp_mb();
+	is_beaconing_active = !!atomic_read(&ppd->led_override_timer_active);
+	pi->port_states.ledenable_offlinereason |= is_beaconing_active << 6;
 	pi->port_states.ledenable_offlinereason |=
 		ppd->offline_disabled_reason;
 #else
@@ -3578,19 +3587,24 @@ static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 				   u32 *resp_len)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct hfi1_pportdata *ppd = dd->pport;
 	struct opa_led_info *p = (struct opa_led_info *)data;
 	u32 nport = OPA_AM_NPORT(am);
-	u64 reg;
+	u32 is_beaconing_active;
 
 	if (nport != 1) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	reg = read_csr(dd, DCC_CFG_LED_CNTRL);
-	if ((reg & DCC_CFG_LED_CNTRL_LED_CNTRL_SMASK) &&
-	    ((reg & DCC_CFG_LED_CNTRL_LED_SW_BLINK_RATE_SMASK) == 0xf))
-		p->rsvd_led_mask = cpu_to_be32(OPA_LED_MASK);
+	/*
+	 * This pairs with the memory barrier implied by the atomic_dec in
+	 * hfi1_set_led_override to ensure that we read the correct state of
+	 * LED beaconing represented by led_override_timer_active
+	 */
+	smp_mb();
+	is_beaconing_active = !!atomic_read(&ppd->led_override_timer_active);
+	p->rsvd_led_mask = cpu_to_be32(is_beaconing_active << OPA_LED_SHIFT);
 
 	if (resp_len)
 		*resp_len += sizeof(struct opa_led_info);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
