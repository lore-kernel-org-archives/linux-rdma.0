From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 3/3] iwpmd: Suppress expected kernel message
Date: Mon, 24 Jul 2017 16:26:44 -0600
Message-ID: <1500935204-6505-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500935204-6505-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RMDA_NL_RSVD was obsoleted a long time ago, but user space still
uses it to support old kernels. Avoid logging:

 ib_core:ibnl_rcv_msg: Index 3 wasn't found in client list

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/iwcm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 51585a8e467a56..16d0c9f9ca4701 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1181,6 +1181,12 @@ static int __init iw_cm_init(void)
 	if (ret)
 		pr_err("iw_cm: couldn't register netlink callbacks\n");
 
+
+	/* Old iwpmds still use this legacy ID, provide a kernel side for it
+	 * that always returns EINVAL
+	 */
+	ibnl_add_client(RDMA_NL_RSVD, 0, NULL);
+
 	iwcm_wq = alloc_ordered_workqueue("iw_cm_wq", WQ_MEM_RECLAIM);
 	if (!iwcm_wq)
 		return -ENOMEM;
@@ -1200,6 +1206,7 @@ static void __exit iw_cm_cleanup(void)
 {
 	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
+	ibnl_remove_client(RDMA_NL_RSVD);
 	ibnl_remove_client(RDMA_NL_IWCM);
 	iwpm_exit(RDMA_NL_IWCM);
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
