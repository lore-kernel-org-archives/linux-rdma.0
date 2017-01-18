From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/6] IB/umem: Indicate that process is being terminated
Date: Wed, 18 Jan 2017 16:58:08 +0200
Message-ID: <20170118145811.9136-4-leon@kernel.org>
References: <20170118145811.9136-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118145811.9136-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When process is killed while pagefault operation still in progress -
function will fail. In this specific case we don't want any warnings in
dmesg to avoid log analyzers false alerts. So we need distinct error
code for this case.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/umem_odp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 1104d36..f2fc043 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -573,7 +573,8 @@ static int ib_umem_odp_map_dma_single_page(
  * for failure.
  * An -EAGAIN error code is returned when a concurrent mmu notifier prevents
  * the function from completing its task.
- *
+ * An -ENOENT error code indicates that userspace process is being terminated
+ * and mm was already destroyed.
  * @umem: the umem to map and pin
  * @user_virt: the address from which we need to map.
  * @bcnt: the minimal number of bytes to pin and map. The mapping might be
@@ -621,7 +622,7 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
 
 	owning_mm = get_task_mm(owning_process);
 	if (owning_mm == NULL) {
-		ret = -EINVAL;
+		ret = -ENOENT;
 		goto out_put_task;
 	}
 
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
