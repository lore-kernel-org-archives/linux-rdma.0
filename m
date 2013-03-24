From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv2] ibverbs: add a new IBV_ACCESS_GIFT option
Date: Sun, 24 Mar 2013 17:45:52 +0200
Message-ID: <20130324154552.GA16346@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

At the moment registering an MR breaks COW.  If the application does not
care that adapter sees stale data (for example, it tracks writes
reregisters and resends), it can use a new IBV_ACCESS_GIFT flag to
prevent registration from breaking COW.

The semantics are similar to that of SPLICE_F_GIFT thus the name.

Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

This is compiled but untested. Michael, could you please try
this patch (together with the kernel patch I'm sending separately)
and report whether setting this flag unbreaks overcommit for you?

 include/infiniband/verbs.h | 3 ++-
 man/ibv_reg_mr.3           | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6acfc81..3290ec9 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -290,7 +290,8 @@ enum ibv_access_flags {
 	IBV_ACCESS_REMOTE_WRITE		= (1<<1),
 	IBV_ACCESS_REMOTE_READ		= (1<<2),
 	IBV_ACCESS_REMOTE_ATOMIC	= (1<<3),
-	IBV_ACCESS_MW_BIND		= (1<<4)
+	IBV_ACCESS_MW_BIND		= (1<<4),
+	IBV_ACCESS_GIFT			= (1<<6)
 };
 
 struct ibv_pd {
diff --git a/man/ibv_reg_mr.3 b/man/ibv_reg_mr.3
index 7723771..3c302f0 100644
--- a/man/ibv_reg_mr.3
+++ b/man/ibv_reg_mr.3
@@ -34,6 +34,8 @@ describes the desired memory protection attributes; it is either 0 or the bitwis
 .B IBV_ACCESS_REMOTE_ATOMIC\fR Enable Remote Atomic Operation Access (if supported)
 .TP
 .B IBV_ACCESS_MW_BIND\fR       Enable Memory Window Binding
+.TP
+.B IBV_ACCESS_GIFT\fR          This memory is a gift to the adapter: if memory is modified after registration, the local version and data seen by the adapter through this region rkey may differ
 .PP
 If
 .B IBV_ACCESS_REMOTE_WRITE
@@ -43,6 +45,9 @@ is set, then
 .B IBV_ACCESS_LOCAL_WRITE
 must be set too.
 .PP
+.B IBV_ACCESS_GIFT
+is only legal with remote or local read access.
+.PP
 Local read access is always enabled for the MR.
 .PP
 .B ibv_dereg_mr()
-- 
MST
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
