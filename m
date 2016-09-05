From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 14/28] rdmacm: Control symbol export from librspreload
Date: Mon,  5 Sep 2016 15:08:04 -0600
Message-ID: <1473109698-31408-15-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since librspreload is a LD_PRELOAD library it should only export
symbols it intends to override. The following internal symbols were
leaking out:

 getenv_options
 idm_clear
 idm_set
 idx_insert
 idx_remove
 idx_replace
 set_rsocket_options

The simplest way to fix this is with a map file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/Makefile.am          |  5 ++++-
 librdmacm/src/librspreload.map | 33 +++++++++++++++++++++++++++++++++
 librdmacm/src/preload.c        |  4 ++--
 3 files changed, 39 insertions(+), 3 deletions(-)
 create mode 100644 librdmacm/src/librspreload.map

diff --git a/librdmacm/Makefile.am b/librdmacm/Makefile.am
index 84af01a14b4b..edfb36bb4149 100644
--- a/librdmacm/Makefile.am
+++ b/librdmacm/Makefile.am
@@ -23,7 +23,10 @@ src_librdmacm_la_LDFLAGS = -version-info 1 -export-dynamic \
 src_librdmacm_la_DEPENDENCIES =  $(srcdir)/src/librdmacm.map
 
 src_librspreload_la_SOURCES = src/preload.c src/indexer.c
-src_librspreload_la_LDFLAGS = -version-info 1 -export-dynamic
+src_librspreload_la_LDFLAGS = -version-info 1
+if HAVE_LD_VERSION_SCRIPT
+    src_librspreload_la_LDFLAGS += -Wl,--version-script=$(srcdir)/src/librspreload.map
+endif
 src_librspreload_la_LIBADD = $(top_builddir)/src/librdmacm.la
 
 bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey \
diff --git a/librdmacm/src/librspreload.map b/librdmacm/src/librspreload.map
new file mode 100644
index 000000000000..67ecf33b8203
--- /dev/null
+++ b/librdmacm/src/librspreload.map
@@ -0,0 +1,33 @@
+{
+        /* FIXME: It is probably not a great idea to not tag these with the
+	   proper symbol version from glibc, at least if glibc ever changes
+	   the signature this will go sideways.. */
+	global:
+		accept;
+		bind;
+		close;
+		connect;
+		dup2;
+		fcntl;
+		getpeername;
+		getsockname;
+		getsockopt;
+		listen;
+		poll;
+		read;
+		readv;
+		recv;
+		recvfrom;
+		recvmsg;
+		select;
+		send;
+		sendfile;
+		sendmsg;
+		sendto;
+		setsockopt;
+		shutdown;
+		socket;
+		write;
+		writev;
+	local: *;
+};
diff --git a/librdmacm/src/preload.c b/librdmacm/src/preload.c
index a0bc1cfbd7a5..2a90f79b226c 100644
--- a/librdmacm/src/preload.c
+++ b/librdmacm/src/preload.c
@@ -356,7 +356,7 @@ static enum fd_type fd_close(int index, int *fd)
 	return type;
 }
 
-void getenv_options(void)
+static void getenv_options(void)
 {
 	char *var;
 
@@ -521,7 +521,7 @@ err:
 /*
  * Use defaults on failure.
  */
-void set_rsocket_options(int rsocket)
+static void set_rsocket_options(int rsocket)
 {
 	if (sq_size)
 		rsetsockopt(rsocket, SOL_RDMA, RDMA_SQSIZE, &sq_size, sizeof sq_size);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
