From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Add check for libpthread during configure
Date: Wed, 15 Dec 2010 11:19:21 -0800
Message-ID: <ada39pyhmiu.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add a check for libpthread during librdmacm configure.  This will add
libpthread to the list of libraries that librdmacm is linked to.
Currently librdmacm gets libpthread implicitly through libibverbs, but
this breaks when using a linker that does not implicitly link with such
dependencies; eg the new gold linker is such a linker:

<http://wiki.debian.org/qa.debian.org/FTBFS#A2009-11-02Packagesfailingbecausebinutils-gold.2BAC8-indirectlinking>

Addresses: http://bugs.debian.org/555380
Addresses: https://bugs.launchpad.net/ubuntu/+source/librdmacm/+bug/687983

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 configure.in |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index d4ae89f..ea10985 100644
--- a/configure.in
+++ b/configure.in
@@ -45,6 +45,8 @@ AC_C_CONST
 AC_CHECK_SIZEOF(long)
 
 dnl Checks for libraries
+AC_CHECK_LIB(pthread, pthread_mutex_init, [],
+    AC_MSG_ERROR([pthread_mutex_init() not found.  librdmacm requires libpthread.]))
 if test "$disable_libcheck" != "yes"; then
 AC_CHECK_LIB(ibverbs, ibv_get_device_list, [],
     AC_MSG_ERROR([ibv_get_device_list() not found.  librdmacm requires libibverbs.]))
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
