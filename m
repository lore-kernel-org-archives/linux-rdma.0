From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [patch 7/8] NES - ib_post_send fixes
Date: Tue, 24 Nov 2009 11:36:49 -0600
Message-ID: <4B0C19B1.8030304@systemfabricworks.com>
References: <20091124043323.927819053@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091124043323.927819053-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_send()'s bad_wr. Stop processing the wor request
queue when an error is detected.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Index: linux-2.6.31/drivers/infiniband/hw/nes/nes_verbs.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/nes/nes_verbs.c	2009-11-23 
21:10:53.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/nes/nes_verbs.c	2009-11-23 
21:12:37.000000000 -0600
@@ -3386,8 +3386,10 @@
  	wqe_count = 0;
  	total_payload_length = 0;

-	if (nesqp->ibqp_state > IB_QPS_RTS)
-		return -EINVAL;
+	if (nesqp->ibqp_state > IB_QPS_RTS) {
+		err = -EINVAL;
+		goto out;
+	}

  	spin_lock_irqsave(&nesqp->lock, flags);

@@ -3498,6 +3500,9 @@
  					break;
  			}

+		if (err)
+			break;
+
  		if (ib_wr->send_flags & IB_SEND_SIGNALED) {
  			wqe_misc |= NES_IWARP_SQ_WQE_SIGNALED_COMPL;
  		}
@@ -3522,6 +3527,7 @@

  	spin_unlock_irqrestore(&nesqp->lock, flags);

+out:
  	if (err)
  		*bad_wr = ib_wr;
  	return err;

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
