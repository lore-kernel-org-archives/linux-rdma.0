From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 17/23] umad: Replace .nl with .sp in man pages
Date: Wed, 21 Sep 2016 16:08:43 -0600
Message-ID: <1474495729-17604-18-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Debian's Lintian remarks:

W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_ca.3.gz 11: warning: macro `nl' not defined
W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_port.3.gz 11: warning: macro `nl' not defined
W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_init.3.gz 11: warning: macro `nl' not defined

We use .sp in other the man pages to separate function signatures, follow
that practice consistently.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/man/umad_get_ca.3   | 2 +-
 libibumad/man/umad_get_port.3 | 2 +-
 libibumad/man/umad_init.3     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libibumad/man/umad_get_ca.3 b/libibumad/man/umad_get_ca.3
index 2f5fd1a71420..8de61d06d6d3 100644
--- a/libibumad/man/umad_get_ca.3
+++ b/libibumad/man/umad_get_ca.3
@@ -8,7 +8,7 @@ umad_get_ca, umad_release_ca \- get and release InfiniBand device port attribute
 .B #include <infiniband/umad.h>
 .sp
 .BI "int umad_get_ca(char " "*ca_name" ", umad_ca_t " "*ca" );
-.nl
+.sp
 .BI "int umad_release_ca(umad_ca_t " "*ca" );
 .fi
 .SH "DESCRIPTION"
diff --git a/libibumad/man/umad_get_port.3 b/libibumad/man/umad_get_port.3
index 863afa7f8286..8dfa1d61933f 100644
--- a/libibumad/man/umad_get_port.3
+++ b/libibumad/man/umad_get_port.3
@@ -8,7 +8,7 @@ umad_get_port, umad_release_port \- open and close an InfiniBand port
 .B #include <infiniband/umad.h>
 .sp
 .BI "int umad_get_port(char " "*ca_name" ", int " "portnum" ", umad_port_t " "*port" );
-.nl
+.sp
 .BI "int umad_release_port(umad_port_t " "*port" );
 .fi
 .SH "DESCRIPTION"
diff --git a/libibumad/man/umad_init.3 b/libibumad/man/umad_init.3
index a8108773c09f..4c22d927d8ec 100644
--- a/libibumad/man/umad_init.3
+++ b/libibumad/man/umad_init.3
@@ -8,7 +8,7 @@ umad_init, umad_done \- perform library initialization and finalization
 .B #include <infiniband/umad.h>
 .sp
 .BI "int umad_init(void);
-.nl
+.sp
 .BI "int umad_done(void);
 .fi
 .SH "DESCRIPTION"
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
