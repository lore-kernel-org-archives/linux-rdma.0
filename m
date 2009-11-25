From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [patch 5/8] ehca - ib_post_recv fixes, Updated
Date: Wed, 25 Nov 2009 10:45:07 -0600
Message-ID: <4B0D5F13.7040705@systemfabricworks.com>
References: <20091125023315.027350384@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091125023315.027350384-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Always set ib_post_recv()'s bad_wr.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Index: linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c
===================================================================
--- linux-2.6.31.orig/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-11-24 
19:49:19.000000000 -0600
+++ linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-11-24 
20:02:53.000000000 -0600
@@ -507,7 +507,6 @@
  			      struct ib_recv_wr *recv_wr,
  			      struct ib_recv_wr **bad_recv_wr)
  {
-	struct ib_recv_wr *cur_recv_wr;
  	struct ehca_wqe *wqe_p;
  	int wqe_cnt = 0;
  	int ret = 0;
@@ -518,27 +517,23 @@
  	if (unlikely(!HAS_RQ(my_qp))) {
  		ehca_err(dev, "QP has no RQ  ehca_qp=%p qp_num=%x ext_type=%d",
  			 my_qp, my_qp->real_qp_num, my_qp->ext_type);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
  	}

  	/* LOCK the QUEUE */
  	spin_lock_irqsave(&my_qp->spinlock_r, flags);

-	/* loop processes list of send reqs */
-	for (cur_recv_wr = recv_wr; cur_recv_wr != NULL;
-	     cur_recv_wr = cur_recv_wr->next) {
+	/* loop processes list of recv reqs */
+	while(recv_wr) {
  		u64 start_offset = my_qp->ipz_rqueue.current_q_offset;
  		/* get pointer next to free WQE */
  		wqe_p = ipz_qeit_get_inc(&my_qp->ipz_rqueue);
  		if (unlikely(!wqe_p)) {
  			/* too many posted work requests: queue overflow */
-			if (bad_recv_wr)
-				*bad_recv_wr = cur_recv_wr;
-			if (wqe_cnt == 0) {
-				ret = -ENOMEM;
-				ehca_err(dev, "Too many posted WQEs "
-					 "qp_num=%x", my_qp->real_qp_num);
-			}
+			ret = -ENOMEM;
+			ehca_err(dev, "Too many posted WQEs "
+				"qp_num=%x", my_qp->real_qp_num);
  			goto post_recv_exit0;
  		}
  		/*
@@ -548,7 +543,7 @@
  		rq_map_idx = start_offset / my_qp->ipz_rqueue.qe_size;

  		/* write a RECV WQE into the QUEUE */
-		ret = ehca_write_rwqe(&my_qp->ipz_rqueue, wqe_p, cur_recv_wr,
+		ret = ehca_write_rwqe(&my_qp->ipz_rqueue, wqe_p, recv_wr,
  				rq_map_idx);
  		/*
  		 * if something failed,
@@ -556,22 +551,20 @@
  		 */
  		if (unlikely(ret)) {
  			my_qp->ipz_rqueue.current_q_offset = start_offset;
-			*bad_recv_wr = cur_recv_wr;
-			if (wqe_cnt == 0) {
-				ret = -EINVAL;
-				ehca_err(dev, "Could not write WQE "
-					 "qp_num=%x", my_qp->real_qp_num);
-			}
+			ret = -EINVAL;
+			ehca_err(dev, "Could not write WQE "
+				"qp_num=%x", my_qp->real_qp_num);
  			goto post_recv_exit0;
  		}

  		qmap_entry = &my_qp->rq_map.map[rq_map_idx];
-		qmap_entry->app_wr_id = get_app_wr_id(cur_recv_wr->wr_id);
+		qmap_entry->app_wr_id = get_app_wr_id(recv_wr->wr_id);
  		qmap_entry->reported = 0;
  		qmap_entry->cqe_req = 1;

  		wqe_cnt++;
-	} /* eof for cur_recv_wr */
+		recv_wr = recv_wr->next;
+	} /* eof for recv_wr */

  post_recv_exit0:
  	iosync(); /* serialize GAL register access */
@@ -580,6 +573,11 @@
  	    ehca_dbg(dev, "ehca_qp=%p qp_num=%x wqe_cnt=%d ret=%i",
  		     my_qp, my_qp->real_qp_num, wqe_cnt, ret);
  	spin_unlock_irqrestore(&my_qp->spinlock_r, flags);
+
+out:
+	if (ret)
+		*bad_recv_wr = recv_wr;
+
  	return ret;
  }

@@ -593,6 +591,7 @@
  	if (unlikely(my_qp->state == IB_QPS_RESET)) {
  		ehca_err(qp->device, "Invalid QP state  qp_state=%d qpn=%x",
  			 my_qp->state, qp->qp_num);
+		*bad_recv_wr = recv_wr;
  		return -EINVAL;
  	}


-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
