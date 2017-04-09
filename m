From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/20] IB/hfi1: Convert %Lx to %llx
Date: Sun, 09 Apr 2017 10:17:12 -0700
Message-ID: <20170409171711.10579.68675.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

According to checkpatch %Lx is not standard C so remove it and use the
suggested %llx.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pcie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 0829fce..e39e01b 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -583,7 +583,7 @@ static void tune_pcie_caps(struct hfi1_devdata *dd)
 		if (words == ~0ULL)
 			ret = PCI_ERS_RESULT_NEED_RESET;
 		dd_dev_info(dd,
-			    "HFI1 mmio_enabled function called, read wordscntr %Lx, returning %d\n",
+			    "HFI1 mmio_enabled function called, read wordscntr %llx, returning %d\n",
 			    words, ret);
 	}
 	return  ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
