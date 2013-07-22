From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH, RFC] mlx4: Avoid that mlx4_cmd_wait() contributes to the
 system load
Date: Mon, 22 Jul 2013 17:23:12 +0200
Message-ID: <51ED4E60.30203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that kernel threads running mlx4_cmd_wait() contribute to the
system load by setting the task state to TASK_INTERRUPTIBLE instead
of TASK_UNINTERRUPTIBLE while waiting. This patch reduces the load
average from about 0.5 to about 0.0 on an idle system with one mlx4
HCA and no IB cables connected.

Note: I'm posting this patch as an RFC since it involves a behavior
change (a signal sent to a worker thread that is waiting for a
command to finish causes the command to fail) and since I'm not sure
this behavior change is acceptable.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 299d018..fb7f7fa 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -559,8 +559,8 @@ static int mlx4_cmd_wait(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
 	mlx4_cmd_post(dev, in_param, out_param ? *out_param : 0,
 		      in_modifier, op_modifier, op, context->token, 1);
 
-	if (!wait_for_completion_timeout(&context->done,
-					 msecs_to_jiffies(timeout))) {
+	if (wait_for_completion_interruptible_timeout(&context->done,
+					 msecs_to_jiffies(timeout)) <= 0) {
 		mlx4_warn(dev, "command 0x%x timed out (go bit not cleared)\n",
 			  op);
 		err = -EBUSY;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
