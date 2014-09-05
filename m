From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 4/4] rsockets: acknowledge completion queue events in batch
Date: Fri, 05 Sep 2014 18:53:11 +0530
Message-ID: <c144abfe27bd0bf36ff1e3c9c912d7c3@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

     Expose '/unackcqe_default' variable so completion event
     acknowledgment can be done in batch instead of singles
     to minimize locking overheads.

     The default value of this variable is 1 so the existing
     functionality is preserved.  Having a higher value delays
     acknowledging until the specified limit is reached for
     retrieved completion events.

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index ffea0ca..3c39da7 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -118,6 +118,7 @@ static uint32_t polling_time = 10;
  static uint16_t restart_onintr = 0;
  static uint16_t next_comp_vector = 0;
  static uint64_t comp_vector_mask = 0;
+static uint32_t def_unackcqe = 1;

  /*
   * Immediate data format is determined by the upper bits
@@ -384,6 +385,7 @@ struct rsocket {
  	dlist_entry	  iomap_list;
  	dlist_entry	  iomap_queue;
  	int		  iomap_pending;
+	int	      unackcqe;
  };

  #define DS_UDP_TAG 0x55555555
@@ -581,6 +583,14 @@ void rs_configure(void)
  			}
  		}
  	}
+
+	if ((f = fopen(RS_CONF_DIR "/unackcqe_default", "r"))) {
+		(void) fscanf(f, "%u", &def_unackcqe);
+		fclose(f);
+		if (def_unackcqe < 1) {
+			def_unackcqe = 1;
+		}
+	}
  	init = 1;
  out:
  	pthread_mutex_unlock(&mut);
@@ -638,6 +648,7 @@ static struct rsocket *rs_alloc(struct rsocket 
*inherited_rs, int type)
  			rs->target_iomap_size = def_iomap_size;
  		}
  	}
+	rs->unackcqe = 0;
  	fastlock_init(&rs->slock);
  	fastlock_init(&rs->rlock);
  	fastlock_init(&rs->cq_lock);
@@ -1044,8 +1055,11 @@ static void rs_free(struct rsocket *rs)

  	if (rs->cm_id) {
  		rs_free_iomappings(rs);
-		if (rs->cm_id->qp)
+		if (rs->cm_id->qp) {
+			if (rs->unackcqe > 0)
+				ibv_ack_cq_events(rs->cm_id->recv_cq, rs->unackcqe);
  			rdma_destroy_qp(rs->cm_id);
+		}
  		rdma_destroy_id(rs->cm_id);
  	}

@@ -2026,7 +2040,11 @@ static int rs_get_cq_event(struct rsocket *rs)
  resume_get_cq_event:
  	ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, &context);
  	if (!ret) {
-		ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
+		rs->unackcqe += 1;
+		if (rs->unackcqe == def_unackcqe) {
+			ibv_ack_cq_events(rs->cm_id->recv_cq, rs->unackcqe);
+			rs->unackcqe = 0;
+		}
  		rs->cq_armed = 0;
  	} else if (restart_onintr == 1 && errno == EINTR) {
  		errno = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
