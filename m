From: Dan aloni <alonid-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] ib: mlx4 map fix for large hugetlb areas
Date: Mon, 6 Jun 2011 14:29:53 +0300
Message-ID: <20110606112953.GA20154@alonid-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Julian Satran <julians-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When an application tries to map a large area of hugetlb pages, the
mlx4 code rightfully reachs handle_hugetlb_user_mr(). This function
uses an intermediate allocation in order to pass the list of big pages
to mlx4_write_mtt(), however that this allocation, when passing over
for example, 128GB of hugetlb memory (63365 pages), maps to 65536*8
bytes of memory, which is not supported by kmalloc() under various
kernel configurations.

It would be prudent to use vmalloc() here.

NOTE: core_umem will still hold 1GB of descriptors for mapping 128GB
of memory, even though it's hugetlb. This needs to be optimized as
well.

Signed-off-by: Dan Aloni <alonid-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index e6c096c..59f2909 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -140,7 +140,7 @@ static int handle_hugetlb_user_mr(struct ib_pd *pd, struct mlx4_ib_mr *mr,
 	int off = start & (HPAGE_SIZE - 1);
 
 	n = DIV_ROUND_UP(off + umem->length, HPAGE_SIZE);
-	arr = kmalloc(n * sizeof *arr, GFP_KERNEL);
+	arr = vmalloc(n * sizeof *arr);
 	if (!arr)
 		return -ENOMEM;
 
@@ -178,7 +178,7 @@ static int handle_hugetlb_user_mr(struct ib_pd *pd, struct mlx4_ib_mr *mr,
 	err = mlx4_write_mtt(dev->dev, &mr->mmr.mtt, 0, n, arr);
 
 out:
-	kfree(arr);
+	vfree(arr);
 	return err;
 #else
 	return -ENOSYS;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
