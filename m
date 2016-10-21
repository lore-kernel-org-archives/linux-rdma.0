From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] build: Fix build script to use correct cmake cmd
Date: Fri, 21 Oct 2016 10:27:28 -0700
Message-ID: <20161021172728.27367.86783.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The build script does not use the variable it sets up for cmake. Fix it
so it does.

Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 build.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/build.sh b/build.sh
index 9006030..10518d8 100755
--- a/build.sh
+++ b/build.sh
@@ -23,9 +23,9 @@ fi
 cd "$BUILDDIR"
 
 if [ "x$NINJA" == "x" ]; then
-    cmake ..
+    $CMAKE ..
     make
 else
-    cmake -GNinja ..
+    $CMAKE -GNinja ..
     $NINJA
 fi

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
