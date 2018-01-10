From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] iscsi_iser: Re-enable 'iser_pi_guard' module parameter
Date: Wed, 10 Jan 2018 10:07:36 +0100
Message-ID: <1515575256-9949-1-git-send-email-hare@suse.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, Steve Schremmer <sschremm-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The module parameter 'iser_pi_guard' has been disabled by commit
5bb6e543d2a7d58 ("IB/iser: DIX update"), but the functionality
to select the guard algorithm is still required.

Fixes: 5bb6e543d2a7d58 ("IB/iser: DIX update")
Signed-off-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Cc: Steve Schremmer <sschremm-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 19624e0..34c4d0a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -649,8 +649,10 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 			u32 sig_caps = ib_conn->device->ib_device->attrs.sig_prot_cap;
 
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
-			scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP |
-						   SHOST_DIX_GUARD_CRC);
+			if (iser_pi_guard)
+				scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP);
+			else
+				scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
 		}
 
 		if (iscsi_host_add(shost,
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
