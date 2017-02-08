From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 24/27] IB/hfi1: Do not set physical link state if DC is in
 the shutdown state
Date: Wed, 08 Feb 2017 05:28:13 -0800
Message-ID: <20170208132812.16442.24244.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If the DC is in shutdown state, the set link state function will return
an error.  Since this is not a failure in this state, make sure to
only call set link state if the DC is on.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 6e6a04b..59b4f7d 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10514,16 +10514,18 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			ppd->remote_link_down_reason = 0;
 		}
 
-		ret1 = set_physical_link_state(dd, PLS_DISABLED);
-		if (ret1 != HCMD_SUCCESS) {
-			dd_dev_err(dd,
-				   "Failed to transition to Disabled link state, return 0x%x\n",
-				   ret1);
-			ret = -EINVAL;
-			break;
+		if (!dd->dc_shutdown) {
+			ret1 = set_physical_link_state(dd, PLS_DISABLED);
+			if (ret1 != HCMD_SUCCESS) {
+				dd_dev_err(dd,
+					   "Failed to transition to Disabled link state, return 0x%x\n",
+					   ret1);
+				ret = -EINVAL;
+				break;
+			}
+			dc_shutdown(dd);
 		}
 		ppd->host_link_state = HLS_DN_DISABLE;
-		dc_shutdown(dd);
 		break;
 	case HLS_DN_OFFLINE:
 		if (ppd->host_link_state == HLS_DN_DISABLE)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
