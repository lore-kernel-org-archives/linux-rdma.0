From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 49/54] staging/rdma/hfi1: Remove unused variable nsbr
Date: Wed, 03 Feb 2016 14:37:32 -0800
Message-ID: <20160203223729.5923.97150.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove unused nsbr count from PCIe Gen3 code

Reviewed-by: Stuart Summers <john.s.summers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/pcie.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 3d0c2e2..5642d85 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -955,7 +955,6 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	uint default_pset;
 	u16 target_vector, target_speed;
 	u16 lnkctl2, vendor;
-	u8 nsbr = 1;
 	u8 div;
 	const u8 (*eq)[3];
 	int return_error = 0;
@@ -989,12 +988,6 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	}
 
 	/*
-	 * A0 needs an additional SBR
-	 */
-	if (is_ax(dd))
-		nsbr++;
-
-	/*
 	 * Do the Gen3 transition.  Steps are those of the PCIe Gen3
 	 * recipe.
 	 */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
