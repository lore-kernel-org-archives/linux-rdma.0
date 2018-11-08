From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 10/10] IB/mlx5: Improve ODP debugging messages
Date: Thu,  8 Nov 2018 21:10:17 +0200
Message-ID: <20181108191017.21891-11-leon@kernel.org>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Add and modify debug messages to ODP related error flows.
In that context, return code EAGAIN is considered less severe and print
level for it is set debug instead of warn.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/umem_odp.c | 14 ++++++++++++--
 drivers/infiniband/hw/mlx5/odp.c   |  4 ++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 2b4c5e7dd5a1..e334480b56bf 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -655,8 +655,13 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 				flags, local_page_list, NULL, NULL);
 		up_read(&owning_mm->mmap_sem);

-		if (npages < 0)
+		if (npages < 0) {
+			if (npages != -EAGAIN)
+				pr_warn("fail to get %zu user pages with error %d\n", gup_num_pages, npages);
+			else
+				pr_debug("fail to get %zu user pages with error %d\n", gup_num_pages, npages);
 			break;
+		}

 		bcnt -= min_t(size_t, npages << PAGE_SHIFT, bcnt);
 		mutex_lock(&umem_odp->umem_mutex);
@@ -674,8 +679,13 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 			ret = ib_umem_odp_map_dma_single_page(
 					umem_odp, k, local_page_list[j],
 					access_mask, current_seq);
-			if (ret < 0)
+			if (ret < 0) {
+				if (ret != -EAGAIN)
+					pr_warn("ib_umem_odp_map_dma_single_page failed with error %d\n", ret);
+				else
+					pr_debug("ib_umem_odp_map_dma_single_page failed with error %d\n", ret);
 				break;
+			}

 			p = page_to_phys(local_page_list[j]);
 			k++;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 0c4f469cdd5b..7bca1592d811 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -665,8 +665,8 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 			if (!wait_for_completion_timeout(
 					&odp->notifier_completion,
 					timeout)) {
-				mlx5_ib_warn(dev, "timeout waiting for mmu notifier. seq %d against %d\n",
-					     current_seq, odp->notifiers_seq);
+				mlx5_ib_warn(dev, "timeout waiting for mmu notifier. seq %d against %d. notifiers_count=%d\n",
+					     current_seq, odp->notifiers_seq, odp->notifiers_count);
 			}
 		} else {
 			/* The MR is being killed, kill the QP as well. */
