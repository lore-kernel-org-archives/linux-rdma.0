From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: common: dapl_event_str function missing 2 IB
 extended events
Date: Wed, 19 May 2010 10:02:44 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7012F0C@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Add all IB extended events in event string print function

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_evd_util.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index 14a10c7..cb3eb1b 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -96,6 +96,10 @@ char *dapl_event_str(IN DAT_EVENT_NUMBER event_num)
 		 DAT_IB_EXTENSION_RANGE_BASE + 1},
 		{"DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED",
 		 DAT_IB_EXTENSION_RANGE_BASE + 2},
+		{"DAT_IB_UD_CONNECTION_REJECT_EVENT",
+		 DAT_IB_EXTENSION_RANGE_BASE + 3},
+		{"DAT_IB_UD_CONNECTION_ERROR_EVENT",
+		 DAT_IB_EXTENSION_RANGE_BASE + 4},
 		{"DAT_IW_EXTENSION_RANGE_BASE", DAT_IW_EXTENSION_RANGE_BASE},
 #endif				/* DAT_EXTENSIONS */
 		{NULL, 0},
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
