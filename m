From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [patch 1/8] Ammasso - ib_post_send fix
Date: Tue, 24 Nov 2009 11:36:33 -0600
Message-ID: <4B0C19A1.1050008@systemfabricworks.com>
References: <20091124043323.927819053@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091124043323.927819053-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_send()'s bad_wr.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Index: linux-2.6.31/drivers/infiniband/hw/amso1100/c2_qp.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/amso1100/c2_qp.c	2009-11-23 
20:22:19.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/amso1100/c2_qp.c	2009-11-23 
20:25:55.000000000 -0600
@@ -798,8 +798,10 @@
  	u8 actual_sge_count;
  	u32 msg_size;

-	if (qp->state > IB_QPS_RTS)
-		return -EINVAL;
+	if (qp->state > IB_QPS_RTS) {
+		err = -EINVAL;
+		goto out;
+	}

  	while (ib_wr) {

@@ -930,6 +932,7 @@
  		ib_wr = ib_wr->next;
  	}

+out:
  	if (err)
  		*bad_wr = ib_wr;
  	return err;

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
