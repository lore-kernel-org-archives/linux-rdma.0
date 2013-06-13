From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] ibnetdiscover: Add missing -f option to manpage
Date: Thu, 13 Jun 2013 14:26:34 -0700
Message-ID: <1371158794.13124.175.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 doc/man/ibnetdiscover.8.in     |    3 +++
 doc/rst/ibnetdiscover.8.in.rst |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/doc/man/ibnetdiscover.8.in b/doc/man/ibnetdiscover.8.in
index 18c353d..0c3d8a4 100644
--- a/doc/man/ibnetdiscover.8.in
+++ b/doc/man/ibnetdiscover.8.in
@@ -62,6 +62,9 @@ List of connected routers
 \fB\-s, \-\-show\fP
 Show progress information during discovery.
 .sp
+\fB\-f, \-\-full\fP
+Show full information (ports\(aq speed and width)
+.sp
 \fB\-p, \-\-ports\fP
 Obtain a ports report which is a
 list of connected ports with relevant information (like LID, portnum,
diff --git a/doc/rst/ibnetdiscover.8.in.rst b/doc/rst/ibnetdiscover.8.in.rst
index 08aad73..f68db31 100644
--- a/doc/rst/ibnetdiscover.8.in.rst
+++ b/doc/rst/ibnetdiscover.8.in.rst
@@ -49,6 +49,9 @@ List of connected routers
 **-s, --show**
 Show progress information during discovery.
 
+**-f, --full**
+Show full information (ports' speed and width)
+
 **-p, --ports**
 Obtain a ports report which is a
 list of connected ports with relevant information (like LID, portnum,
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
