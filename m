From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 11/22] staging/rdma/hfi1: Fix port bounce issues with 0.22 DC firmware
Date: Mon, 19 Oct 2015 22:11:26 -0400
Message-ID: <1445307097-8244-12-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The DC firmware overwrites the enable_lane_tx register and does not update it
on a host request to go to Poll. This causes an infinite loop through the LNI
state machine if a link width downgrade occurs. This patch re-sets the
enable_lane_tx register to all 4 lanes.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 3c48294abd20..0be37e9430af 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5417,6 +5417,8 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 		if (ppd->link_speed_enabled & OPA_LINK_SPEED_12_5G)
 			ppd->local_tx_rate |= 1;
 	}
+
+	enable_lane_tx = 0xF; /* enable all four lanes */
 	ret = write_tx_settings(dd, enable_lane_tx, tx_polarity_inversion,
 		     rx_polarity_inversion, ppd->local_tx_rate);
 	if (ret != HCMD_SUCCESS)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
