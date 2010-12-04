From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: cq: mixup of errno and the -1 return from poll
 in dapls_wait_comp_channel
Date: Fri, 3 Dec 2010 16:09:34 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011C4D956C@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

call should return errno and not status returned from poll.

Signed-off-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 dapl/openib_common/cq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_common/cq.c b/dapl/openib_common/cq.c
index c36a766..f475d1d 100644
--- a/dapl/openib_common/cq.c
+++ b/dapl/openib_common/cq.c
@@ -296,7 +296,7 @@ dapls_wait_comp_channel(IN struct ibv_comp_channel *channel, IN uint32_t timeout
 	else if (status == 0)
 		return ETIMEDOUT;
 	else
-		return status;
+		return errno;
 }
 #endif
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
