From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB: Fix typo in udev rule documentation
Date: Mon, 28 Sep 2009 20:30:19 +0200
Message-ID: <200909282030.19481.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Lukasz Jurewicz <lukasz.jurewicz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The proper syntax for udev rules is KERNEL==... instead of KERNEL=...

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Lukasz Jurewicz <lukasz.jurewicz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/Documentation/infiniband/user_mad.txt b/Documentation/infiniband/user_mad.txt
index 744687d..8a36695 100644
--- a/Documentation/infiniband/user_mad.txt
+++ b/Documentation/infiniband/user_mad.txt
@@ -128,8 +128,8 @@ Setting IsSM Capability Bit
   To create the appropriate character device files automatically with
   udev, a rule like
 
-    KERNEL="umad*", NAME="infiniband/%k"
-    KERNEL="issm*", NAME="infiniband/%k"
+    KERNEL=="umad*", NAME="infiniband/%k"
+    KERNEL=="issm*", NAME="infiniband/%k"
 
   can be used.  This will create device nodes named
 
diff --git a/Documentation/infiniband/user_verbs.txt b/Documentation/infiniband/user_verbs.txt
index f847501..afe3f8d 100644
--- a/Documentation/infiniband/user_verbs.txt
+++ b/Documentation/infiniband/user_verbs.txt
@@ -58,7 +58,7 @@ Memory pinning
   To create the appropriate character device files automatically with
   udev, a rule like
 
-    KERNEL="uverbs*", NAME="infiniband/%k"
+    KERNEL=="uverbs*", NAME="infiniband/%k"
 
   can be used.  This will create device nodes named
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
