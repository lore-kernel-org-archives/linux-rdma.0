From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/3] mlx5: Optimize post_send barriers
Date: Mon, 13 Mar 2017 16:53:49 +0200
Message-ID: <1489416829-15467-4-git-send-email-yishaih@mellanox.com>
References: <1489416829-15467-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489416829-15467-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In ARCH(s) that spinlock() serves also as SFENCE prevent
an another explicit SFENCE. (e.g. X86).

To prevent an extra 'if' to know whether lock is really taken and it's
not a single threaded application encapsulates the mlx5_single_threaded
flag as part of bf->need_lock.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c | 2 +-
 providers/mlx5/qp.c   | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 87c85df..eeaf5ac 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -524,7 +524,7 @@ static int get_num_low_lat_uuars(int tot_uuars)
  */
 static int need_uuar_lock(struct mlx5_context *ctx, int uuarn)
 {
-	if (uuarn == 0)
+	if (uuarn == 0 || mlx5_single_threaded)
 		return 0;
 
 	if (uuarn >= (ctx->tot_uuars - ctx->low_lat_uuars) * 2)
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index de68b1c..1d5a2f9 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -930,11 +930,11 @@ out:
 
 		/* Make sure that the doorbell write happens before the memcpy
 		 * to WC memory below */
-		mmio_wc_start();
-
 		ctx = to_mctx(ibqp->context);
 		if (bf->need_lock)
-			mlx5_spin_lock(&bf->lock);
+			mmio_wc_spinlock(&bf->lock.lock);
+		else
+			mmio_wc_start();
 
 		if (!ctx->shut_up_bf && nreq == 1 && bf->uuarn &&
 		    (inl || ctx->prefer_bf) && size > 1 &&
@@ -953,6 +953,7 @@ out:
 		 * writes doorbell 2, and it's write is flushed earlier. Since
 		 * the mmio_flush_writes is CPU local, this will result in the HCA seeing
 		 * doorbell 2, followed by doorbell 1.
+		 * Flush before toggling bf_offset to be latency oriented.
 		 */
 		mmio_flush_writes();
 		bf->offset ^= bf->buf_size;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
