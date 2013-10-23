From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 6/9] mlx5: Fix cleanup flow when DMA mapping fails
Date: Wed, 23 Oct 2013 09:53:18 +0300
Message-ID: <1382511201-7061-7-git-send-email-eli@mellanox.com>
References: <1382511201-7061-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382511201-7061-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If DMA mapping fails, the driver cleared the object that holds the previously
DMA mapped pages. Fix this by allocating a new object for the command that
reports back to firmware that pages can't be supplied.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 7b12acf..a0d0da3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -181,6 +181,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 {
 	struct mlx5_manage_pages_inbox *in;
 	struct mlx5_manage_pages_outbox out;
+	struct mlx5_manage_pages_inbox *nin;
 	struct page *page;
 	int inlen;
 	u64 addr;
@@ -247,13 +248,20 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 
 out_alloc:
 	if (notify_fail) {
-		memset(in, 0, inlen);
+		nin = kzalloc(sizeof(*nin), GFP_KERNEL);
+		if (!nin) {
+			mlx5_core_warn(dev, "allocation failed\n");
+			goto unmap;
+		}
 		memset(&out, 0, sizeof(out));
-		in->hdr.opcode = cpu_to_be16(MLX5_CMD_OP_MANAGE_PAGES);
-		in->hdr.opmod = cpu_to_be16(MLX5_PAGES_CANT_GIVE);
-		if (mlx5_cmd_exec(dev, in, sizeof(*in), &out, sizeof(out)))
-			mlx5_core_warn(dev, "\n");
+		nin->hdr.opcode = cpu_to_be16(MLX5_CMD_OP_MANAGE_PAGES);
+		nin->hdr.opmod = cpu_to_be16(MLX5_PAGES_CANT_GIVE);
+		if (mlx5_cmd_exec(dev, nin, sizeof(*nin), &out, sizeof(out)))
+			mlx5_core_warn(dev, "page notify failed\n");
+		kfree(nin);
 	}
+
+unmap:
 	for (i--; i >= 0; i--) {
 		addr = be64_to_cpu(in->pas[i]);
 		page = remove_page(dev, addr);
-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
