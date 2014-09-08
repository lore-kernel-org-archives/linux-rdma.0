From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 4/4] rsockets: acknowledge completion queue events in batch
Date: Mon, 08 Sep 2014 18:21:38 +0530
Message-ID: <c34f0dcd116683c05c7c1836c381a09f@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, sithirug-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Author: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Change note from v2 to v3: eliminated setting through option as 
suggested by Sean
Date:   Mon Sep 8 15:38:54 2014 +0530

     Perform completion event acknowledgments in batches instead
     of individually to minimze locking overheads.  Size of the
     completion queue decides the size of a batch.

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index ffea0ca..d201e0a 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -384,6 +384,7 @@ struct rsocket {
  	dlist_entry	  iomap_list;
  	dlist_entry	  iomap_queue;
  	int		  iomap_pending;
+	int	      unack_cqe;
  };

  #define DS_UDP_TAG 0x55555555
@@ -638,6 +639,7 @@ static struct rsocket *rs_alloc(struct rsocket 
*inherited_rs, int type)
  			rs->target_iomap_size = def_iomap_size;
  		}
  	}
+	rs->unack_cqe = 0;
  	fastlock_init(&rs->slock);
  	fastlock_init(&rs->rlock);
  	fastlock_init(&rs->cq_lock);
@@ -1044,8 +1046,11 @@ static void rs_free(struct rsocket *rs)

  	if (rs->cm_id) {
  		rs_free_iomappings(rs);
-		if (rs->cm_id->qp)
+		if (rs->cm_id->qp) {
+			if (rs->unack_cqe > 0)
+				ibv_ack_cq_events(rs->cm_id->recv_cq, rs->unack_cqe);
  			rdma_destroy_qp(rs->cm_id);
+		}
  		rdma_destroy_id(rs->cm_id);
  	}

@@ -2026,7 +2031,11 @@ static int rs_get_cq_event(struct rsocket *rs)
  resume_get_cq_event:
  	ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, &context);
  	if (!ret) {
-		ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
+		rs->unack_cqe += 1;
+		if (rs->unack_cqe == rs->sq_size + rs->rq_size) {
+			ibv_ack_cq_events(rs->cm_id->recv_cq, rs->unack_cqe);
+			rs->unack_cqe = 0;
+		}
  		rs->cq_armed = 0;
  	} else if (restart_onintr == 1 && errno == EINTR) {
  		errno = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
