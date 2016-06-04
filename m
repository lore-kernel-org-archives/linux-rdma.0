From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 04/10] IB/mlx5: Limit query HCA clock
Date: Sat,  4 Jun 2016 15:15:31 +0300
Message-ID: <1465042537-26129-5-git-send-email-leon@kernel.org>
References: <1465042537-26129-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042537-26129-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When PAGE_SIZE is larger then 4K, the user shouldn't be able to query
the HCA core clock. This counter is within 4KB boundary and the
user-space shall not read information that's after this boundary.

Fixes: b368d7cb8ceb7 ('IB/mlx5: Add hca_core_clock_offset to...')
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8845f4b..05036db 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -991,7 +991,14 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (field_avail(typeof(resp), cqe_version, udata->outlen))
 		resp.response_length += sizeof(resp.cqe_version);
 
-	if (field_avail(typeof(resp), hca_core_clock_offset, udata->outlen)) {
+	/*
+	 * We don't want to expose information from the PCI bar that is located
+	 * after 4096 bytes, so if the arch only supports larger pages, let's
+	 * pretend we don't support reading the HCA's core clock. This is also
+	 * forced by mmap function.
+	 */
+	if (PAGE_SIZE <= 4096 &&
+	    field_avail(typeof(resp), hca_core_clock_offset, udata->outlen)) {
 		resp.comp_mask |=
 			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET;
 		resp.hca_core_clock_offset =
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
