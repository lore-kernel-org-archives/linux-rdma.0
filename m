From: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] osmtest - code cleanup: remove Windows specific items.
Date: Wed, 4 Nov 2009 12:34:04 -0800
Message-ID: <53DFB8C213D246138BE8D3793204CE12@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Remove #ifdef WIN32, #else & #endif. Just use PATH_MAX.

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/osmtest/include/osmtest_base.h b/opensm/osmtest/include/osmtest_base.h
index cda3a31..6c980a3 100644
--- a/opensm/osmtest/include/osmtest_base.h
+++ b/opensm/osmtest/include/osmtest_base.h
@@ -48,11 +48,7 @@
 #endif
 
 #define OSMTEST_MAX_LINE_LEN	120
-#ifdef WIN32
-#define OSMTEST_FILE_PATH_MAX	4096
-#else
 #define OSMTEST_FILE_PATH_MAX	PATH_MAX
-#endif
 
 #define STRESS_SMALL_RMPP_THR 100000
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
