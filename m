From: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/ipath: Convert use of __constant_<foo> to <foo>
Date: Tue, 16 Jun 2015 17:13:05 +0530
Message-ID: <20150616114305.GA6350@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In little endian cases, the macros be16_to_cpu and cpu_to_be64
unfolds to __swab{16,64} which provides special case for constants.
In big endian cases, __constant_be16_to_cpu and be16_to_cpu
expand directly to the same expression. The same applies for
__constant_cpu_to_be64 and cpu_to_be64.

So, replace __constant_be16_to_cpu with be16_to_cpu and
__constant_cpu_to_be64 with cpu_to_be64, with the goal of getting
rid of the definition of __constant_be16_to_cpu and
__constant_cpu_to_be64 completely.

Signed-off-by: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 44ea939..5da33ec 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -2023,9 +2023,9 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 
 	spin_lock_init(&idev->qp_table.lock);
 	spin_lock_init(&idev->lk_table.lock);
-	idev->sm_lid = __constant_be16_to_cpu(IB_LID_PERMISSIVE);
+	idev->sm_lid = be16_to_cpu(IB_LID_PERMISSIVE);
 	/* Set the prefix to the default value (see ch. 4.1.1) */
-	idev->gid_prefix = __constant_cpu_to_be64(0xfe80000000000000ULL);
+	idev->gid_prefix = cpu_to_be64(0xfe80000000000000ULL);
 
 	ret = ipath_init_qp_table(idev, ib_ipath_qp_table_size);
 	if (ret)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
