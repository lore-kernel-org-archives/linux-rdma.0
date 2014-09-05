From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 2/4] rsockets: retry for completion events upon
 interruption
Date: Fri, 05 Sep 2014 18:44:20 +0530
Message-ID: <66c7c361d03a72de6a216fd1d6ffa0bc@imap.linux.ibm.com>
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

     While waiting for a completion queue event, rsocket's logic by 
default
     bails out when interrupted.  Because of this, on the passive side
     ongoing connection establishments are abruptly terminated without
     fully accepting the incoming connection requests.

     The solution is to modify the completion event waiting logic to 
ensure
     that it retries for the event upon interruption instead of returning
     with an error.  This behavior is gated by a runtime parameter
     'restart_onintr' with the associated configuration file so it does
     not affect in any way the rest of rsocket applications.

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index 78261dc..b70d56a 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -115,6 +115,7 @@ static uint16_t def_rqsize = 384;
  static uint32_t def_mem = (1 << 17);
  static uint32_t def_wmem = (1 << 17);
  static uint32_t polling_time = 10;
+static uint16_t restart_onintr = 0;

  /*
   * Immediate data format is determined by the upper bits
@@ -542,6 +543,11 @@ void rs_configure(void)
  		def_iomap_size = (uint8_t) rs_value_to_scale(
  			(uint16_t) rs_scale_to_value(def_iomap_size, 8), 8);
  	}
+
+	if ((f = fopen(RS_CONF_DIR "/restart_onintr", "r"))) {
+		(void) fscanf(f, "%hu", &restart_onintr);
+		fclose(f);
+	}
  	init = 1;
  out:
  	pthread_mutex_unlock(&mut);
@@ -1969,10 +1975,14 @@ static int rs_get_cq_event(struct rsocket *rs)
  	if (!rs->cq_armed)
  		return 0;

+resume_get_cq_event:
  	ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, &context);
  	if (!ret) {
  		ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
  		rs->cq_armed = 0;
+	} else if (restart_onintr == 1 && errno == EINTR) {
+		errno = 0;
+		goto resume_get_cq_event;
  	} else if (errno != EAGAIN) {
  		rs->state = rs_error;
  	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
