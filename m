From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] opensm/complib use portable macro syntax
Date: Fri, 21 May 2010 09:45:03 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E192562EBBAE9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use portable macro argument syntax.

signed-of-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/complib/cl_event_wheel.c b/opensm/complib/cl_event_wheel.c
index ef6d598..eb894a6 100644
--- a/opensm/complib/cl_event_wheel.c
+++ b/opensm/complib/cl_event_wheel.c
@@ -42,7 +42,7 @@
 #include <complib/cl_event_wheel.h>
 #include <complib/cl_debug.h>

-#define CL_DBG(fmt, arg...)
+#define CL_DBG(fmt, ...)

 static cl_status_t __event_will_age_before(IN const cl_list_item_t *
                                           const p_list_item, IN void *context)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
