From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: dapltest: server info devicename is not large
 enough for dapl_name storage
Date: Wed, 19 May 2010 16:31:28 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7013610@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Server info device name is a 80 char array but the dapl device name
that is copied is 256 bytes. Increase started_server.devicename definition.
Chalk one up for windows SDK OACR (auto code review).

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 test/dapltest/include/dapl_server_info.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/test/dapltest/include/dapl_server_info.h b/test/dapltest/include/dapl_server_info.h
index de038c5..898f9cc 100644
--- a/test/dapltest/include/dapl_server_info.h
+++ b/test/dapltest/include/dapl_server_info.h
@@ -37,7 +37,7 @@
 
 struct started_server
 {
-    char            devicename[80];
+    char            devicename[256];
     struct started_server *next;
 };
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
