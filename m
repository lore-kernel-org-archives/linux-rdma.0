From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 07/17] verbs: Remove -fno-strict-aliasing
Date: Thu,  6 Oct 2016 14:51:33 -0600
Message-ID: <1475787103-13283-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Debian and SuSE have both shipped without adding -fno-strict-aliasing,
and the upstream source did not have this flag until
678f7fa7dde82 ("Makefile.am: Don't allow strict aliasing by default").

Thus we can infer that strict aliasing is tested and works.

Avoid the one warning this causes with a simple coding change.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/examples/CMakeLists.txt | 2 --
 libibverbs/examples/pingpong.c     | 9 ++++++---
 libibverbs/src/CMakeLists.txt      | 2 --
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/libibverbs/examples/CMakeLists.txt b/libibverbs/examples/CMakeLists.txt
index 76e333bd0106..dc4c4978daa3 100644
--- a/libibverbs/examples/CMakeLists.txt
+++ b/libibverbs/examples/CMakeLists.txt
@@ -1,5 +1,3 @@
-set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
-
 # Shared example files
 add_library(ibverbs_tools STATIC
   pingpong.c
diff --git a/libibverbs/examples/pingpong.c b/libibverbs/examples/pingpong.c
index f6a50e9c62aa..1d5028e699a7 100644
--- a/libibverbs/examples/pingpong.c
+++ b/libibverbs/examples/pingpong.c
@@ -59,19 +59,22 @@ void wire_gid_to_gid(const char *wgid, union ibv_gid *gid)
 	char tmp[9];
 	uint32_t v32;
 	int i;
+	uint32_t tmp_gid[4];
 
 	for (tmp[8] = 0, i = 0; i < 4; ++i) {
 		memcpy(tmp, wgid + i * 8, 8);
 		sscanf(tmp, "%x", &v32);
-		*(uint32_t *)(&gid->raw[i * 4]) = ntohl(v32);
+		tmp_gid[i] = ntohl(v32);
 	}
+	memcpy(gid, tmp_gid, sizeof(*gid));
 }
 
 void gid_to_wire_gid(const union ibv_gid *gid, char wgid[])
 {
+	uint32_t tmp_gid[4];
 	int i;
 
+	memcpy(tmp_gid, gid, sizeof(tmp_gid));
 	for (i = 0; i < 4; ++i)
-		sprintf(&wgid[i * 8], "%08x",
-			htonl(*(uint32_t *)(gid->raw + i * 4)));
+		sprintf(&wgid[i * 8], "%08x", htonl(tmp_gid[i]));
 }
diff --git a/libibverbs/src/CMakeLists.txt b/libibverbs/src/CMakeLists.txt
index 6989f7730c5e..fb69037b869b 100644
--- a/libibverbs/src/CMakeLists.txt
+++ b/libibverbs/src/CMakeLists.txt
@@ -1,5 +1,3 @@
-set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${NO_STRICT_ALIASING_FLAGS}")
-
 publish_headers(infiniband
   ../include/infiniband/arch.h
   ../include/infiniband/driver.h
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
