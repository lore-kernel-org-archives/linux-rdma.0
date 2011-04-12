From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [ibsim] increase max nodes and switches to support similation of
	larger fabrics
Date: Tue, 12 Apr 2011 10:25:45 -0700
Message-ID: <1302629145.21002.12.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tKBeLaYc8r4GWqf49u5v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-tKBeLaYc8r4GWqf49u5v
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The maximum number of nodes and switches allowed by ibsim was too small
for some of our larger fabrics, so I increased the size.

Longer term, there shouldn't be a fixed size for these and the arrays
should grow in size as needed, however I'll leave that for another day.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-tKBeLaYc8r4GWqf49u5v
Content-Disposition: attachment; filename*0=0001-increase-max-nodes-and-switches-to-support-similatio.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-increase-max-nodes-and-switches-to-support-similatio.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 11 Apr 2011 14:56:27 -0700
Subject: [PATCH] increase max nodes and switches to support similation of
	larger fabrics
Message-Id: <1302629081.21002.10.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ibsim/sim.h b/ibsim/sim.h
index 5a8a92f..a4d68bf 100644
--- a/ibsim/sim.h
+++ b/ibsim/sim.h
@@ -37,8 +37,8 @@
 
 #include <infiniband/mad.h>
 
-#define MAXNETNODES	2048
-#define MAXNETSWITCHS	256
+#define MAXNETNODES	8192
+#define MAXNETSWITCHS	1024
 #define MAXNETPORTS	(MAXNETSWITCHS*36+MAXNETNODES*2)
 #define MAXNETALIASES	MAXNETPORTS
 
-- 
1.7.1


--=-tKBeLaYc8r4GWqf49u5v--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
