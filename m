From: Frank Zago <frank-6OywahBdSro@public.gmane.org>
Subject: [patch 6/6] RDMA/amso1100 - ib_post_recv fix
Date: Wed, 02 Dec 2009 20:36:24 -0600
Message-ID: <4B172428.1010902@zago.net>
References: <20091203023350.646158428@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091203023350.646158428-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_recv()'s bad_wr when an error occurred.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_qp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.31/drivers/infiniband/hw/amso1100/c2_qp.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/amso1100/c2_qp.c	2009-12-02
19:23:17.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/amso1100/c2_qp.c	2009-12-02
19:23:23.000000000 -0600
@@ -947,8 +947,10 @@
 	unsigned long lock_flags;
 	int err = 0;

-	if (qp->state > IB_QPS_RTS)
-		return -EINVAL;
+	if (qp->state > IB_QPS_RTS) {
+		err = -EINVAL;
+		goto out;
+	}

 	/*
 	 * Try and post each work request
@@ -1001,6 +1003,7 @@
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
