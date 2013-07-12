From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/3 opensm] Fix test scenario in cl_event_wheel
Date: Fri, 12 Jul 2013 09:31:01 -0400
Message-ID: <51E00515.4050009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The testing code is missing complib init/destroy functions and use
incorrect callback function prototype.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 complib/cl_event_wheel.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/complib/cl_event_wheel.c b/complib/cl_event_wheel.c
index d3caa03..21d1ed1 100644
--- a/complib/cl_event_wheel.c
+++ b/complib/cl_event_wheel.c
@@ -503,7 +503,7 @@ void __cl_event_wheel_dump(IN cl_event_wheel_t * const p_event_wheel)
 
 /* The callback for aging event */
 /* We assume we pass a text context */
-void __test_event_aging(uint64_t key, void *context)
+static uint64_t __test_event_aging(uint64_t key, uint32_t num_regs, void *context)
 {
 	printf("*****************************************************\n");
 	printf("Aged key: 0x%" PRIx64 " Context:%s\n", key, (char *)context);
@@ -514,6 +514,9 @@ int main()
 	cl_event_wheel_t event_wheel;
 	/*  uint64_t key; */
 
+	/* init complib */
+	complib_init();
+
 	/* construct */
 	cl_event_wheel_construct(&event_wheel);
 
@@ -560,6 +563,8 @@ int main()
 	/* destroy */
 	cl_event_wheel_destroy(&event_wheel);
 
+	complib_exit();
+
 	return (0);
 }
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
