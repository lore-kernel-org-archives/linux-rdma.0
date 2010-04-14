From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ummunotify: fix umn-test build
Date: Wed, 14 Apr 2010 09:43:41 -0700
Message-ID: <20100414094341.ba69842d.randy.dunlap@oracle.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1271053337-7121-1-git-send-email-ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Add ummunotify.h to Kbuild list for export to userspace,
fixing 27 build errors in umn-test.c when O=builddir is used.

Signed-off-by: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

maybe another item to add to SubmitChecklist :(


--- lnx-2634-rc4.orig/include/linux/Kbuild
+++ lnx-2634-rc4/include/linux/Kbuild
@@ -163,6 +163,7 @@ header-y += tipc_config.h
 header-y += toshiba.h
 header-y += udf_fs_i.h
 header-y += ultrasound.h
+header-y += ummunotify.h
 header-y += un.h
 header-y += utime.h
 header-y += veth.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
