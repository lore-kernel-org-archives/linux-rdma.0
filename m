From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 3/4] rsockets: distribute completion queue vectors
Date: Mon, 08 Sep 2014 18:18:26 +0530
Message-ID: <33dc77c8c6006b5ac067e6c6f485df60@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, sithirug-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Change note from v2 to v3: description is changed as suggested by Bart
Date:   Mon Sep 8 14:32:18 2014 +0530

     Distribute completion vectors while creating completion queues.
     The existing mechanism always uses 0 for the completion vector.
     Mapping of a completion vector to a particular CPU core is
     decided by the smp_affinity factor that is set at the system
     level for the corresponding irq number. While driving a large
     workload this may result in bottleneck at the mapped core
     because the same core could be used for both event and task
     processing.

     A '/comp_vector' option is exposed, the value of which is a range
     or comma separated list of completion vectors.  The specified
     completion vectors are equally distributed among the created
     completion queues with each new connection picking up the
     next indexed completion vector in the list with index wrapping
     up to the beginning if the list end is reached.  If this option
     is not set, the existing mechanism prevails where in completion
     vectors are set to 0 for all the connections.

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index b70d56a..ffea0ca 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -116,6 +116,8 @@ static uint32_t def_mem = (1 << 17);
  static uint32_t def_wmem = (1 << 17);
  static uint32_t polling_time = 10;
  static uint16_t restart_onintr = 0;
+static uint16_t next_comp_vector = 0;
+static uint64_t comp_vector_mask = 0;

  /*
   * Immediate data format is determined by the upper bits
@@ -548,6 +550,37 @@ void rs_configure(void)
  		(void) fscanf(f, "%hu", &restart_onintr);
  		fclose(f);
  	}
+
+	if ((f = fopen(RS_CONF_DIR "/comp_vector", "r"))) {
+		char vbuf[256];
+		char *vptr;
+		vptr = fgets(vbuf, sizeof(vbuf), f);
+		fclose(f);
+		if (vptr) {
+			char *tok, *save, *tmp, *str, *tok2;
+			int lvect, uvect, vect;
+
+			for (str = vptr; ; str = NULL) {
+				tok = strtok_r(str, ",", &save);
+				if (tok == NULL) {
+					break;
+				}
+				if (!(tmp = strpbrk(tok, "-"))) {
+					lvect = uvect = atoi(tok);
+				} else {
+					tok2 = tmp + 1;
+					*tmp = '\0';
+					lvect = atoi(tok);
+					uvect = atoi(tok2);
+				}
+				lvect = (lvect < 0) ? 0 : ((lvect > 63) ? 63 : lvect);
+				uvect = (uvect < 0) ? 0 : ((uvect > 63) ? 63 : uvect);
+				for (vect = lvect; vect <= uvect; vect++) {
+					comp_vector_mask |= ((uint64_t)1 << vect);
+				}
+			}
+		}
+	}
  	init = 1;
  out:
  	pthread_mutex_unlock(&mut);
@@ -762,12 +795,27 @@ static int ds_init_bufs(struct ds_qp *qp)
   */
  static int rs_create_cq(struct rsocket *rs, struct rdma_cm_id *cm_id)
  {
+	int vector = 0;
+
  	cm_id->recv_cq_channel = ibv_create_comp_channel(cm_id->verbs);
  	if (!cm_id->recv_cq_channel)
  		return -1;

+	if (comp_vector_mask) {
+		int found = 0;
+		while (found == 0) {
+			if (comp_vector_mask & ((uint64_t) 1 << next_comp_vector)) {
+				found = 1;
+				vector = next_comp_vector;
+			}
+			if (++next_comp_vector == 64) {
+				next_comp_vector = 0;
+			}
+		}
+	}
+
  	cm_id->recv_cq = ibv_create_cq(cm_id->verbs, rs->sq_size + 
rs->rq_size,
-				       cm_id, cm_id->recv_cq_channel, 0);
+				       cm_id, cm_id->recv_cq_channel, vector);
  	if (!cm_id->recv_cq)
  		goto err1;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
