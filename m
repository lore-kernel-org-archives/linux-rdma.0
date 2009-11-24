From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [patch 8/8] NES - ib_post_recv fixes
Date: Tue, 24 Nov 2009 11:36:56 -0600
Message-ID: <4B0C19B8.8010807@systemfabricworks.com>
References: <20091124043323.927819053@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091124043323.927819053-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_recv()'s bad_wr.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Index: linux-2.6.31/drivers/infiniband/hw/nes/nes_verbs.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/nes/nes_verbs.c	2009-11-23 
21:59:04.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/nes/nes_verbs.c	2009-11-23 
21:59:05.000000000 -0600
@@ -3554,8 +3554,10 @@
  	u32 counter;
  	u32 total_payload_length;

-	if (nesqp->ibqp_state > IB_QPS_RTS)
-		return -EINVAL;
+	if (nesqp->ibqp_state > IB_QPS_RTS) {
+		err = -EINVAL;
+		goto out;
+	}

  	spin_lock_irqsave(&nesqp->lock, flags);

@@ -3618,6 +3620,7 @@

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
