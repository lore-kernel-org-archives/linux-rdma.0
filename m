From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/8] IB/hfi1: Document phys port state bits not
 used in IB
Date: Sun, 13 Aug 2017 08:08:28 -0700
Message-ID: <20170813150827.23208.83131.stgit@scvm10.sc.intel.com>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813150659.23208.66243.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brent Rothermel <brent.r.rothermel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Todd Rimmer <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A couple bits are used by OPA for link physical state that are not present
as part of InfiniBand. Add a short blurb what those states mean and removed
an unused state.

Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Todd Rimmer <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Brent Rothermel <brent.r.rothermel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/opa_compat.h |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/opa_compat.h b/drivers/infiniband/hw/hfi1/opa_compat.h
index 6ef3c1c..774215b 100644
--- a/drivers/infiniband/hw/hfi1/opa_compat.h
+++ b/drivers/infiniband/hw/hfi1/opa_compat.h
@@ -84,7 +84,8 @@ static inline u8 port_states_to_phys_state(struct opa_port_states *ps)
 /*
  * OPA port physical states
  * IB Volume 1, Table 146 PortInfo/IB Volume 2 Section 5.4.2(1) PortPhysState
- * values.
+ * values are the same in OmniPath Architecture. OPA leverages some of the same
+ * concepts as InfiniBand, but has a few other states as well.
  *
  * When writing, only values 0-3 are valid, other values are ignored.
  * When reading, 0 is reserved.
@@ -92,6 +93,8 @@ static inline u8 port_states_to_phys_state(struct opa_port_states *ps)
  * Returned by the ibphys_portstate() routine.
  */
 enum opa_port_phys_state {
+	/* Values 0-7 have the same meaning in OPA as in InfiniBand. */
+
 	IB_PORTPHYSSTATE_NOP = 0,
 	/* 1 is reserved */
 	IB_PORTPHYSSTATE_POLLING = 2,
@@ -101,9 +104,23 @@ enum opa_port_phys_state {
 	IB_PORTPHYSSTATE_LINK_ERROR_RECOVERY = 6,
 	IB_PORTPHYSSTATE_PHY_TEST = 7,
 	/* 8 is reserved */
+
+	/*
+	 * Offline: Port is quiet (transmitters disabled) due to lack of
+	 * physical media, unsupported media, or transition between link up
+	 * and next link up attempt
+	 */
 	OPA_PORTPHYSSTATE_OFFLINE = 9,
-	OPA_PORTPHYSSTATE_GANGED = 10,
+
+	/* 10 is reserved */
+
+	/*
+	 * Phy_Test: Specific test patterns are transmitted, and receiver BER
+	 * can be monitored. This facilitates signal integrity testing for the
+	 * physical layer of the port.
+	 */
 	OPA_PORTPHYSSTATE_TEST = 11,
+
 	OPA_PORTPHYSSTATE_MAX = 11,
 	/* values 12-15 are reserved/ignored */
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
