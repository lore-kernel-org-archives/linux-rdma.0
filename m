From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: ucm: configure the recv channel FD to
 non-blocking
Date: Fri, 3 Dec 2010 15:32:50 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011C4D94F4@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 6882c58..a628a78 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -497,6 +497,7 @@ static int ucm_service_create(IN DAPL_HCA *hca)
     	tp->rch = ibv_create_comp_channel(hca->ib_hca_handle);
 	if (!tp->rch) 
 		goto bail;
+	dapls_config_comp_channel(tp->rch);
 
 	tp->scq = ibv_create_cq(hca->ib_hca_handle, tp->cqe, hca, NULL, 0);
 	if (!tp->scq) 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
