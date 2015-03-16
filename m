From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] infiniband-diags/rdma-ndd: Fix issues with install
Date: Mon, 16 Mar 2015 18:08:22 -0400
Message-ID: <1426543703-12841-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Debian in particular it was reported that the binary was attempting to run
from /sbin when it was installed to /usr/sbin.  This was not seen on RHEL as
RHEL defines /sbin to be a softlink to /usr/sbin.

In addition fix the /var path by using the localstatedir macro.

Reported-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 etc/rdma-ndd.init.in | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/etc/rdma-ndd.init.in b/etc/rdma-ndd.init.in
index 41747f2..24ce1bd 100644
--- a/etc/rdma-ndd.init.in
+++ b/etc/rdma-ndd.init.in
@@ -41,7 +41,9 @@
 # notice, one of the license notices in the documentation
 # and/or other materials provided with the distribution.
 
-pidfile=/var/run/rdma-ndd.pid
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+pidfile=@localstatedir@/run/rdma-ndd.pid
 
 # Source function library.
 if [[ -s /etc/init.d/functions ]]; then
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
