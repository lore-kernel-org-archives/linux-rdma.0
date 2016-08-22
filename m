From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 13/15] Consolidate the .gitignore files
Date: Mon, 22 Aug 2016 12:13:36 -0600
Message-ID: <1471889618-1605-14-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove auto* stuff in the sub directories and replace it with one
copy of cmake stuff in the top level.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 .gitignore                     | 29 +++++++++++++++++++
 libhfi1verbs/.gitignore        | 18 ------------
 libibverbs/.gitignore          | 24 ----------------
 libibverbs/examples/.gitignore | 10 -------
 libibverbs/src/.gitignore      |  3 --
 libipathverbs/.gitignore       | 22 ---------------
 libmlx4/.gitignore             | 17 -----------
 libmlx4/src/.gitignore         |  3 --
 libmlx5/.gitignore             | 33 ----------------------
 libmlx5/src/.gitignore         |  3 --
 libmthca/.gitignore            | 17 -----------
 libmthca/src/.gitignore        |  3 --
 librdmacm/.gitignore           | 64 ------------------------------------------
 librdmacm/examples/.gitignore  | 23 ---------------
 librdmacm/src/.gitignore       |  9 ------
 15 files changed, 29 insertions(+), 249 deletions(-)
 create mode 100644 .gitignore
 delete mode 100644 libhfi1verbs/.gitignore
 delete mode 100644 libibverbs/.gitignore
 delete mode 100644 libibverbs/examples/.gitignore
 delete mode 100644 libibverbs/src/.gitignore
 delete mode 100644 libipathverbs/.gitignore
 delete mode 100644 libmlx4/.gitignore
 delete mode 100644 libmlx4/src/.gitignore
 delete mode 100644 libmlx5/.gitignore
 delete mode 100644 libmlx5/src/.gitignore
 delete mode 100644 libmthca/.gitignore
 delete mode 100644 libmthca/src/.gitignore
 delete mode 100644 librdmacm/.gitignore
 delete mode 100644 librdmacm/examples/.gitignore
 delete mode 100644 librdmacm/src/.gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 000000000000..65cf06d22efa
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,29 @@
+# CMake
+cmake_install.cmake
+CMakeFiles
+CMakeCache.txt
+lib*.a
+/bin/**
+/lib/**
+/include/**
+/.ninja*
+*.ninja
+Makefile
+
+# Tags
+TAGS
+.TAGS
+!TAGS/
+tags
+.tags
+!tags/
+gtags.files
+GTAGS
+GRTAGS
+GPATH
+
+# cscope
+cscope.files
+cscope.out
+cscope.in.out
+cscope.po.out
diff --git a/libhfi1verbs/.gitignore b/libhfi1verbs/.gitignore
deleted file mode 100644
index 1fd7e821926c..000000000000
diff --git a/libibverbs/.gitignore b/libibverbs/.gitignore
deleted file mode 100644
index 9fb29eae8cd4..000000000000
diff --git a/libibverbs/examples/.gitignore b/libibverbs/examples/.gitignore
deleted file mode 100644
index ebecbdc0cf56..000000000000
diff --git a/libibverbs/src/.gitignore b/libibverbs/src/.gitignore
deleted file mode 100644
index 7297cbb20ade..000000000000
diff --git a/libipathverbs/.gitignore b/libipathverbs/.gitignore
deleted file mode 100644
index 007a003f6e53..000000000000
diff --git a/libmlx4/.gitignore b/libmlx4/.gitignore
deleted file mode 100644
index 4c45b0912563..000000000000
diff --git a/libmlx4/src/.gitignore b/libmlx4/src/.gitignore
deleted file mode 100644
index 7297cbb20ade..000000000000
diff --git a/libmlx5/.gitignore b/libmlx5/.gitignore
deleted file mode 100644
index 7878db2d068e..000000000000
diff --git a/libmlx5/src/.gitignore b/libmlx5/src/.gitignore
deleted file mode 100644
index 7297cbb20ade..000000000000
diff --git a/libmthca/.gitignore b/libmthca/.gitignore
deleted file mode 100644
index 43f0908f1de0..000000000000
diff --git a/libmthca/src/.gitignore b/libmthca/src/.gitignore
deleted file mode 100644
index 7297cbb20ade..000000000000
diff --git a/librdmacm/.gitignore b/librdmacm/.gitignore
deleted file mode 100644
index cea1f714f199..000000000000
diff --git a/librdmacm/examples/.gitignore b/librdmacm/examples/.gitignore
deleted file mode 100644
index ce9156d4a97f..000000000000
diff --git a/librdmacm/src/.gitignore b/librdmacm/src/.gitignore
deleted file mode 100644
index 139417a24de1..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
