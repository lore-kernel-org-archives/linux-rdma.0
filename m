From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/7] IB/hfi1: Correct unnecessary acquisition of HW
 mutex
Date: Mon, 09 Oct 2017 12:38:04 -0700
Message-ID: <20171009193801.6965.7420.stgit@scvm10.sc.intel.com>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009161736.6965.75352.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Avoid acquiring already acquired hardware mutex and releasing
the unacquired one as these are redundant operations.
Add printouts for such situations to help detect potential errors
within the driver.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/firmware.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index b10781d..148a2c7 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1424,7 +1424,14 @@ int acquire_hw_mutex(struct hfi1_devdata *dd)
 	unsigned long timeout;
 	int try = 0;
 	u8 mask = 1 << dd->hfi1_id;
-	u8 user;
+	u8 user = (u8)read_csr(dd, ASIC_CFG_MUTEX);
+
+	if (user == mask) {
+		dd_dev_info(dd,
+			    "Hardware mutex already acquired, mutex mask %u\n",
+			    (u32)mask);
+		return 0;
+	}
 
 retry:
 	timeout = msecs_to_jiffies(HM_TIMEOUT) + jiffies;
@@ -1455,7 +1462,15 @@ int acquire_hw_mutex(struct hfi1_devdata *dd)
 
 void release_hw_mutex(struct hfi1_devdata *dd)
 {
-	write_csr(dd, ASIC_CFG_MUTEX, 0);
+	u8 mask = 1 << dd->hfi1_id;
+	u8 user = (u8)read_csr(dd, ASIC_CFG_MUTEX);
+
+	if (user != mask)
+		dd_dev_warn(dd,
+			    "Unable to release hardware mutex, mutex mask %u, my mask %u\n",
+			    (u32)user, (u32)mask);
+	else
+		write_csr(dd, ASIC_CFG_MUTEX, 0);
 }
 
 /* return the given resource bit(s) as a mask for the given HFI */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
