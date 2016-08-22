From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 12/15] Combine COPYING files
Date: Mon, 22 Aug 2016 12:13:35 -0600
Message-ID: <1471889618-1605-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Provide common reference files COPYING.BSD and COPYING.GPL2, as
well as a general 'default' in COPYING

The following directories retain their existing COPYING files because
they do not conform to the Open Fabrics standard:
  - libcxgb3,libipathverbs,libnes contain an extra patent restriction
  - libhfi1verbs uses Intel BSD 3 clause license not the OpenIB.org
    2 clause license

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 COPYING                            |   6 +
 COPYING.BSD                        |  26 +++
 libnes/gpl-2.0.txt => COPYING.GPL2 |  14 +-
 libcxgb4/COPYING                   |  29 ---
 libi40iw/COPYING                   | 372 ------------------------------------
 libibcm/COPYING                    | 378 -------------------------------------
 libibumad/COPYING                  | 377 ------------------------------------
 libibverbs/COPYING                 | 378 -------------------------------------
 libmlx4/COPYING                    | 378 -------------------------------------
 libmlx5/COPYING                    | 378 -------------------------------------
 libmthca/COPYING                   | 378 -------------------------------------
 libocrdma/COPYING                  | 317 -------------------------------
 librdmacm/COPYING                  | 378 -------------------------------------
 13 files changed, 39 insertions(+), 3370 deletions(-)
 create mode 100644 COPYING
 create mode 100644 COPYING.BSD
 rename libnes/gpl-2.0.txt => COPYING.GPL2 (98%)
 delete mode 100644 libcxgb4/COPYING
 delete mode 100644 libi40iw/COPYING
 delete mode 100644 libibcm/COPYING
 delete mode 100644 libibumad/COPYING
 delete mode 100644 libibverbs/COPYING
 delete mode 100644 libmlx4/COPYING
 delete mode 100644 libmlx5/COPYING
 delete mode 100644 libmthca/COPYING
 delete mode 100644 libocrdma/COPYING
 delete mode 100644 librdmacm/COPYING

diff --git a/COPYING b/COPYING
new file mode 100644
index 000000000000..ac58180e900c
--- /dev/null
+++ b/COPYING
@@ -0,0 +1,6 @@
+Unless otherwise stated this software is available to you under a choice of
+one of two licenses.  You may choose to be licensed under the terms of the the
+OpenIB.org BSD license (see COPYING.BSD) or the GNU General Public License
+(GPL) Version 2 (see COPYING.GPL2), both included in this package.
+
+Refer to individual files for information on the copyright holders.
diff --git a/COPYING.BSD b/COPYING.BSD
new file mode 100644
index 000000000000..59b3a397a13b
--- /dev/null
+++ b/COPYING.BSD
@@ -0,0 +1,26 @@
+		       OpenIB.org BSD license
+
+Redistribution and use in source and binary forms, with or without
+modification, are permitted provided that the following conditions
+are met:
+
+  * Redistributions of source code must retain the above copyright
+    notice, this list of conditions and the following disclaimer.
+
+  * Redistributions in binary form must reproduce the above
+    copyright notice, this list of conditions and the following
+    disclaimer in the documentation and/or other materials provided
+    with the distribution.
+
+THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
+INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
+BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
+CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
+ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGE.
diff --git a/libnes/gpl-2.0.txt b/COPYING.GPL2
similarity index 98%
rename from libnes/gpl-2.0.txt
rename to COPYING.GPL2
index d511905c1647..d159169d1050 100644
--- a/libnes/gpl-2.0.txt
+++ b/COPYING.GPL2
@@ -1,12 +1,12 @@
-		    GNU GENERAL PUBLIC LICENSE
-		       Version 2, June 1991
+                    GNU GENERAL PUBLIC LICENSE
+                       Version 2, June 1991
 
  Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
-			    Preamble
+                            Preamble
 
   The licenses for most software are designed to take away your
 freedom to share and change it.  By contrast, the GNU General Public
@@ -56,7 +56,7 @@ patent must be licensed for everyone's free use or not licensed at all.
   The precise terms and conditions for copying, distribution and
 modification follow.
 
-		    GNU GENERAL PUBLIC LICENSE
+                    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
   0. This License applies to any program or other work which contains
@@ -255,7 +255,7 @@ make exceptions for this.  Our decision will be guided by the two goals
 of preserving the free status of all derivatives of our free software and
 of promoting the sharing and reuse of software generally.
 
-			    NO WARRANTY
+                            NO WARRANTY
 
   11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
 FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
@@ -277,9 +277,9 @@ YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
 PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.
 
-		     END OF TERMS AND CONDITIONS
+                     END OF TERMS AND CONDITIONS
 
-	    How to Apply These Terms to Your New Programs
+            How to Apply These Terms to Your New Programs
 
   If you develop a new program, and you want it to be of the greatest
 possible use to the public, the best way to achieve this is to make it
diff --git a/libcxgb4/COPYING b/libcxgb4/COPYING
deleted file mode 100644
index 93b666faf583..000000000000
diff --git a/libi40iw/COPYING b/libi40iw/COPYING
deleted file mode 100644
index b275c841fb59..000000000000
diff --git a/libibcm/COPYING b/libibcm/COPYING
deleted file mode 100644
index ee1a79ffabf6..000000000000
diff --git a/libibumad/COPYING b/libibumad/COPYING
deleted file mode 100644
index c7f06f69e99e..000000000000
diff --git a/libibverbs/COPYING b/libibverbs/COPYING
deleted file mode 100644
index ee1a79ffabf6..000000000000
diff --git a/libmlx4/COPYING b/libmlx4/COPYING
deleted file mode 100644
index add3d1990bc1..000000000000
diff --git a/libmlx5/COPYING b/libmlx5/COPYING
deleted file mode 100644
index add3d1990bc1..000000000000
diff --git a/libmthca/COPYING b/libmthca/COPYING
deleted file mode 100644
index ee1a79ffabf6..000000000000
diff --git a/libocrdma/COPYING b/libocrdma/COPYING
deleted file mode 100644
index 17073373403b..000000000000
diff --git a/librdmacm/COPYING b/librdmacm/COPYING
deleted file mode 100644
index 39f3831585f2..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
