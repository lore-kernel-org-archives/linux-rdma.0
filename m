From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/13] IB/hfi1: Remove unused variable from devdata
Date: Sun, 25 Sep 2016 07:42:16 -0700
Message-ID: <20160925144213.10261.79086.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We no longer use an error tasklet. Remove it from the hfi1_devdata
structure.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 52ffd11..5711620 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1061,8 +1061,6 @@ struct hfi1_devdata {
 	u8 psxmitwait_supported;
 	/* cycle length of PS* counters in HW (in picoseconds) */
 	u16 psxmitwait_check_rate;
-	/* high volume overflow errors deferred to tasklet */
-	struct tasklet_struct error_tasklet;
 
 	/* MSI-X information */
 	struct hfi1_msix_entry *msix_entries;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
