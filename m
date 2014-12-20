From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: [PATCH] infiniband: hw: ipath: ipath_wc_ppc64.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:19:02 +0100
Message-ID: <1419092342-7120-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove the function ipath_unordered_wc() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_kernel.h    |    3 ---
 drivers/infiniband/hw/ipath/ipath_wc_ppc64.c  |   13 -------------
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c |   15 ---------------
 3 files changed, 31 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 6559af6..e08db70 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -908,9 +908,6 @@ void ipath_chip_cleanup(struct ipath_devdata *);
 /* clean up any chip type-specific stuff */
 void ipath_chip_done(void);
 
-/* check to see if we have to force ordering for write combining */
-int ipath_unordered_wc(void);
-
 void ipath_disarm_piobufs(struct ipath_devdata *, unsigned first,
 			  unsigned cnt);
 void ipath_cancel_sends(struct ipath_devdata *, int);
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c b/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
index 1d7bd82..1a7e20a 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
@@ -47,16 +47,3 @@ int ipath_enable_wc(struct ipath_devdata *dd)
 {
 	return 0;
 }
-
-/**
- * ipath_unordered_wc - indicate whether write combining is unordered
- *
- * Because our performance depends on our ability to do write
- * combining mmio writes in the most efficient way, we need to
- * know if we are on a processor that may reorder stores when
- * write combining.
- */
-int ipath_unordered_wc(void)
-{
-	return 1;
-}
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
index 3428acb..4ad0b93 100644
--- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
+++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
@@ -167,18 +167,3 @@ void ipath_disable_wc(struct ipath_devdata *dd)
 		dd->ipath_wc_cookie = 0; /* even on failure */
 	}
 }
-
-/**
- * ipath_unordered_wc - indicate whether write combining is ordered
- *
- * Because our performance depends on our ability to do write combining mmio
- * writes in the most efficient way, we need to know if we are on an Intel
- * or AMD x86_64 processor.  AMD x86_64 processors flush WC buffers out in
- * the order completed, and so no special flushing is required to get
- * correct ordering.  Intel processors, however, will flush write buffers
- * out in "random" orders, and so explicit ordering is needed at times.
- */
-int ipath_unordered_wc(void)
-{
-	return boot_cpu_data.x86_vendor != X86_VENDOR_AMD;
-}
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
