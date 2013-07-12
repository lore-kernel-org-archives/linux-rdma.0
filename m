From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3 opensm] complib/cl_event_wheel.c: Add print of num_regs
 in cl_event_wheel_dump
Date: Fri, 12 Jul 2013 09:31:14 -0400
Message-ID: <51E00522.3060204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

num_regs is important information in debug mode.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 complib/cl_event_wheel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/complib/cl_event_wheel.c b/complib/cl_event_wheel.c
index 901ef8e..365804e 100644
--- a/complib/cl_event_wheel.c
+++ b/complib/cl_event_wheel.c
@@ -238,8 +238,8 @@ void cl_event_wheel_dump(IN cl_event_wheel_t * const p_event_wheel)
 		    PARENT_STRUCT(p_list_item, cl_event_wheel_reg_info_t,
 				  list_item);
 		CL_DBG("cl_event_wheel_dump: Found event key:<0x%"
-		       PRIx64 ">, aging time:%" PRIu64 "\n",
-		       p_event->key, p_event->aging_time);
+		       PRIx64 ">, num_regs:%d, aging time:%" PRIu64 "\n",
+		       p_event->key, p_event->num_regs, p_event->aging_time);
 		p_list_item = cl_qlist_next(p_list_item);
 	}
 }
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
