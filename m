From: Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ib_ehca: fix compile failure on ppc64
Date: Mon, 27 Feb 2012 17:02:56 -0500
Message-ID: <20120227220255.GE29211@redacted.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm getting compile failures building this driver, which I narrowed down
to the ilog2 call in ehca_get_max_hwpage_size...

ERROR: ".____ilog2_NaN" [drivers/infiniband/hw/ehca/ib_ehca.ko]
undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

The use of shca->hca_cap_mr_pgsize is confusing the compiler, and
resulting in the __builtin_constant_p in ilog2 going insane.

I tried making it take the u32 pgsize as an argument and the expansion
of shca->_pgsize in the caller, but that failed as well. Adding a
temporary variable as below got it building again though (as did
replacing the ilog2 with fls(x) - 1.)

With this patch in place, the driver compiles on my GCC 4.6.2 here.

Signed-off-by: Kyle McMartin <kmcmarti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -112,7 +112,8 @@ static u32 ehca_encode_hwpage_size(u32 pgsize)
 
 static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
 {
-	return 1UL << ilog2(shca->hca_cap_mr_pgsize);
+	u32 pgsize = shca->hca_cap_mr_pgsize;
+	return 1UL << ilog2(pgsize);
 }
 
 static struct ehca_mr *ehca_mr_new(void)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
