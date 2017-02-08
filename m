From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/27] IB/hfi1: Use static CTLE with Preset 6 for integrated
 HFIs
Date: Wed, 08 Feb 2017 05:26:14 -0800
Message-ID: <20170208132613.16442.25700.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

After extended testing, it was found that the previous PCIe Gen
3 recipe, which used adaptive CTLE with Preset 4, could cause an
NMI/Surprise Link Down in about 1 in 100 to 1 in 1000 power cycles on
some platforms. New EV data combined with extensive empirical data
indicates that the new recipe should use static CTLE with Preset 6 for
all integrated silicon SKUs.

Fixes: c3f8de0b334c ("IB/hfi1: Add static PCIe Gen3 CTLE tuning")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index ebd941f..0829fce 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -663,12 +663,12 @@ static void tune_pcie_caps(struct hfi1_devdata *dd)
 
 #define UNSET_PSET 255
 #define DEFAULT_DISCRETE_PSET 2	/* discrete HFI */
-#define DEFAULT_MCP_PSET 4	/* MCP HFI */
+#define DEFAULT_MCP_PSET 6	/* MCP HFI */
 static uint pcie_pset = UNSET_PSET;
 module_param(pcie_pset, uint, S_IRUGO);
 MODULE_PARM_DESC(pcie_pset, "PCIe Eq Pset value to use, range is 0-10");
 
-static uint pcie_ctle = 1; /* discrete on, integrated off */
+static uint pcie_ctle = 3; /* discrete on, integrated on */
 module_param(pcie_ctle, uint, S_IRUGO);
 MODULE_PARM_DESC(pcie_ctle, "PCIe static CTLE mode, bit 0 - discrete on/off, bit 1 - integrated on/off");
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
