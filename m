From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 6/9] mlx5: Add support for dynamic UAR allocation
Date: Mon, 25 Dec 2017 15:56:58 +0200
Message-ID: <1514210221-10466-7-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds support to dynamically allocate a UAR by introducing a
new mmap command to be issued with the mlx5 kernel driver.

The allocated UAR will be managed by the mlx5 user space driver and its
internal BF registers will be used upon allocating an ibv_thread_domain.

To enable allocating more than 256 UARs the page index is encoded in an
extra one byte just after the command byte.

This functionality will be used in downstream patches from this series.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c | 13 ++++++++++---
 providers/mlx5/mlx5.h | 11 ++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 4c872c8..bdad9ba 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -782,7 +782,12 @@ static off_t get_uar_mmap_offset(int idx, int page_size, int command)
 	off_t offset = 0;
 
 	set_command(command, &offset);
-	set_index(idx, &offset);
+
+	if (command == MLX5_MMAP_ALLOC_WC &&
+	    idx >= (1 << MLX5_IB_MMAP_CMD_SHIFT))
+		set_extended_index(idx, &offset);
+	else
+		set_index(idx, &offset);
 
 	return offset * page_size;
 }
@@ -793,8 +798,8 @@ static off_t uar_type_to_cmd(int uar_type)
 		MLX5_MMAP_GET_REGULAR_PAGES_CMD;
 }
 
-static void *mlx5_mmap(struct mlx5_uar_info *uar, int index,
-		       int cmd_fd, int page_size, int uar_type)
+void *mlx5_mmap(struct mlx5_uar_info *uar, int index, int cmd_fd, int page_size,
+		int uar_type)
 {
 	off_t offset;
 
@@ -813,6 +818,8 @@ static void *mlx5_mmap(struct mlx5_uar_info *uar, int index,
 	 * MLX5_MMAP_GET_NC_PAGES_CMD mmap command.
 	 */
 	offset = get_uar_mmap_offset(index, page_size,
+				     (uar_type == MLX5_UAR_TYPE_REGULAR_DYN) ?
+				     MLX5_MMAP_ALLOC_WC :
 				     MLX5_MMAP_GET_REGULAR_PAGES_CMD);
 	uar->reg = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED,
 			cmd_fd, offset);
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 8d5d193..7a9434b 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -58,7 +58,8 @@ enum {
 
 enum {
 	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1,
-	MLX5_MMAP_GET_CORE_CLOCK_CMD    = 5
+	MLX5_MMAP_GET_CORE_CLOCK_CMD    = 5,
+	MLX5_MMAP_ALLOC_WC		= 6,
 };
 
 enum {
@@ -222,6 +223,7 @@ struct mlx5_spinlock {
 enum mlx5_uar_type {
 	MLX5_UAR_TYPE_REGULAR,
 	MLX5_UAR_TYPE_NC,
+	MLX5_UAR_TYPE_REGULAR_DYN,
 };
 
 struct mlx5_uar_info {
@@ -800,6 +802,8 @@ struct ibv_pd *mlx5_alloc_parent_domain(struct ibv_context *context,
 					struct ibv_parent_domain_init_attr *attr);
 
 
+void *mlx5_mmap(struct mlx5_uar_info *uar, int index,
+		int cmd_fd, int page_size, int uar_type);
 static inline void *mlx5_find_uidx(struct mlx5_context *ctx, uint32_t uidx)
 {
 	int tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
@@ -873,6 +877,11 @@ static inline void set_index(int index, off_t *offset)
 	set_arg(index, offset);
 }
 
+static inline void set_extended_index(int index, off_t *offset)
+{
+	*offset |= (index & 0xff) | ((index >> 8) << 16);
+}
+
 static inline uint8_t calc_sig(void *wqe, int size)
 {
 	int i;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
