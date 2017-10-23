From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/7] Ib/hfi1: Return actual operational VLs in port
 info query
Date: Mon, 23 Oct 2017 06:05:53 -0700
Message-ID: <20171023130550.21191.48614.stgit@scvm10.sc.intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023125327.21191.31462.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

__subn_get_opa_portinfo stores value returned by hfi1_get_ib_cfg() as
operational vls. hfi1_get_ib_cfg() returns vls_operational field in
hfi1_pportdata. The problem with this is that the value is always equal
to vls_supported field in hfi1_pportdata.

The logic to calculate operational_vls is to set value passed by FM
(in  __subn_set_opa_portinfo routine). If no value is passed then
default value is stored in operational_vls.

Field actual_vls_operational is calculated on the basis of buffer
control table. Hence, modifying hfi1_get_ib_cfg() to return
actual_operational_vls when used with HFI1_IB_CFG_OP_VLS parameter

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 3a642ea..1702264 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9967,7 +9967,7 @@ int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which)
 		goto unimplemented;
 
 	case HFI1_IB_CFG_OP_VLS:
-		val = ppd->vls_operational;
+		val = ppd->actual_vls_operational;
 		break;
 	case HFI1_IB_CFG_VL_HIGH_CAP: /* VL arb high priority table size */
 		val = VL_ARB_HIGH_PRIO_TABLE_SIZE;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
