From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/11] IB/hfi1: Handle initial value of 0 for CCTI
 setting
Date: Mon, 06 Nov 2017 06:39:29 -0800
Message-ID: <20171106143927.27539.11851.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the driver is loaded it sets the default CCTI value to be 0. When the FM
starts and CCA is disabled the driver sets the max value to 65535 due the driver
subtracting 1 from 0 and the fact that the CCTI value is a u16.

Special case the subtraction to find the index for a 0 value.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 1277e1c..cf8dba3 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -3701,7 +3701,11 @@ static void apply_cc_state(struct hfi1_pportdata *ppd)
 
 	*new_cc_state = *old_cc_state;
 
-	new_cc_state->cct.ccti_limit = ppd->total_cct_entry - 1;
+	if (ppd->total_cct_entry)
+		new_cc_state->cct.ccti_limit = ppd->total_cct_entry - 1;
+	else
+		new_cc_state->cct.ccti_limit = 0;
+
 	memcpy(new_cc_state->cct.entries, ppd->ccti_entries,
 	       ppd->total_cct_entry * sizeof(struct ib_cc_table_entry));
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
