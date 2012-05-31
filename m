From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: Add SMP/QP0 usage explanation to general
 man page
Date: Thu, 31 May 2012 16:02:49 -0700
Message-ID: <20120531160249.f23247ea.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 doc/rst/infiniband-diags.8.in.rst |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/doc/rst/infiniband-diags.8.in.rst b/doc/rst/infiniband-diags.8.in.rst
index 6a86ae2..9cd4524 100644
--- a/doc/rst/infiniband-diags.8.in.rst
+++ b/doc/rst/infiniband-diags.8.in.rst
@@ -23,6 +23,18 @@ may therefore work even in unconfigured subnets.  Other, higher level
 utilities, require LID routed MAD's and to some extent SA/SM access.
 
 
+THE USE OF SMP's (QP0)
+======================
+
+Many of the tools in this package rely on the use of SMP's via QP0 to acquire
+data directly from hardware.  While this mode of operation is not technically
+in compliance with the InfiniBand specification, practical experience has found
+that this level of diagnostics is valuable when working with a fabric which is
+broken or only partially configured.  For this reason many of these tools may
+require the use of an MKey or operation from Virtual Machines may be restricted
+for security reasons.
+
+
 COMMON OPTIONS
 ==============
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
