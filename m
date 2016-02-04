From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCHv2] staging: rdma: use setup_timer() api
Date: Thu, 4 Feb 2016 13:28:09 +0000
Message-ID: <20160204132919.GA25760@IND12F0122>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <14547E0CC47694488D1A716C497EB439-NhzUejbdEhGcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hari Prasath Gujulan Elango <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>

Replace the timer API's to initialize a timer & then assign the callback
function by the setup_timer() API.

Signed-off-by: Hari Prasath Gujulan Elango <hgujulan-Vi+0cqmPEYlBDgjK7y7TUQ@public.gmane.org>
---
	v2: Unwanted text present in the commit comments
sections.Removed them
---
 drivers/staging/rdma/ehca/ehca_main.c | 3 +--
 drivers/staging/rdma/hfi1/verbs.c     | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/ehca/ehca_main.c b/drivers/staging/rdma/ehca/ehca_main.c
index 832f22f..e545712 100644
--- a/drivers/staging/rdma/ehca/ehca_main.c
+++ b/drivers/staging/rdma/ehca/ehca_main.c
@@ -1073,8 +1073,7 @@ static int __init ehca_module_init(void)
 		ehca_gen_err("WARNING!!!");
 		ehca_gen_err("It is possible to lose interrupts.");
 	} else {
-		init_timer(&poll_eqs_timer);
-		poll_eqs_timer.function = ehca_poll_eqs;
+		setup_timer(&poll_eqs_timer, ehca_poll_eqs, 0UL);
 		poll_eqs_timer.expires = jiffies + HZ;
 		add_timer(&poll_eqs_timer);
 	}
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 09b8d41..769388d 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1926,8 +1926,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
 	spin_lock_init(&dev->n_mcast_grps_lock);
-	init_timer(&dev->mem_timer);
-	dev->mem_timer.function = mem_timer;
+	setup_timer(&dev->mem_timer, mem_timer, 0UL);
 	dev->mem_timer.data = (unsigned long) dev;
 
 	/*
-- 
1.9.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
