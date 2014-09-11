From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 3/4] rsockets: distribute completion queue vectors in a
 process specific way
Date: Thu, 11 Sep 2014 17:57:00 +0530
Message-ID: <f3fd02ac24599a689a31cec5a3815758@imap.linux.ibm.com>
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
Date:   Thu Sep 11 16:53:16 2014 +0530

     Distribute completion vectors while creating completion queues.
     The existing mechanism always uses 0 for the completion vector.
     Mapping of a completion vector to a particular CPU core is
     decided by the smp_affinity factor that is set at the system
     level for the corresponding irq number. While driving a large
     workload this may result in bottleneck at the mapped core
     because the same core could be used for both event and task
     processing.

     A '/comp_vector' option is exposed, which can contain as many
     line entries as the number of processes for which completion
     vectors should be set in a custom way.  Format of each entry
     is as follows:

         <process_name> <space> <comp_vector_list>

     where comp_vector_list is a range or comma separated list of
     completion vectors.

     Against each process, the specified completion vectors are
     equally distributed among the created completion queues with
     each new connection picking up the next indexed completion
     vector in the list with index wrapping back to the beginning
     if the end of list is reached.

     If this option is not set, the existing mechanism prevails
     where in completion vectors are set to 0 for all the
     connections.

     @
     @Sample /comp_vector configuration file
     @
     @procA 3-5,7,11
     @procB 0,6-8

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/rsocket.c b/src/rsocket.c
index b70d56a..f99d66b 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -95,6 +95,13 @@ struct rs_svc {
  	void *contexts;
  };

+struct rs_cv_entry {
+	char *name;
+	int16_t *vec;
+	int16_t nvec;
+	int16_t idx;
+};
+
  static struct pollfd *udp_svc_fds;
  static void *udp_svc_run(void *arg);
  static struct rs_svc udp_svc = {
@@ -116,6 +123,9 @@ static uint32_t def_mem = (1 << 17);
  static uint32_t def_wmem = (1 << 17);
  static uint32_t polling_time = 10;
  static uint16_t restart_onintr = 0;
+static struct rs_cv_entry *cvent;
+static int16_t ncvent;
+static int16_t comp_vector_avail;

  /*
   * Immediate data format is determined by the upper bits
@@ -484,6 +494,148 @@ static int rs_scale_to_value(int value, int bits)
  	       value : (value & ~(1 << (bits - 1))) << bits;
  }

+/* retrieve next completion vector in the specified list
+ * for the current process
+ */
+static int rs_get_comp_vector(void)
+{
+	int i;
+
+	for (i = 0; i < ncvent; i++) {
+		if (strncmp(cvent[i].name, program_invocation_short_name,
+				strlen(cvent[i].name)) == 0) {
+			break;
+		}
+	}
+	if (i < ncvent) {
+		int16_t nvec;
+
+		nvec = cvent[i].nvec;
+		if (nvec > 0) {
+			int16_t idx, vec;
+
+			idx = cvent[i].idx;
+			vec = cvent[i].vec[idx];
+			idx += 1;
+			idx %= nvec;
+			cvent[i].idx = idx;
+			return (int) vec;
+		}
+	}
+	return 0;
+}
+
+/* free the completion vector entries */
+static void rs_free_cvent(void)
+{
+	int i;
+
+	if (cvent) {
+		for (i = 0; i < ncvent; i++) {
+			if (cvent[i].name) {
+				free(cvent[i].name);
+			}
+			if (cvent[i].vec) {
+				free(cvent[i].vec);
+			}
+		}
+		free(cvent);
+	}
+}
+
+/* scan completion vector configuration file
+ * and store entries in global record
+ */
+static int rs_scan_comp_vector(void)
+{
+	FILE *fp;
+	char line[256];
+	char *lp, *str1, *saveptr1, *tok1;
+	int ret = 0, i;
+
+	fp = fopen(RS_CONF_DIR "/comp_vector", "r");
+	if (fp == NULL) {
+		return -1;
+	}
+
+	while ((lp = fgets(line, sizeof(line), fp)) != NULL) {
+		/* alloc new comp vector entry  to hold retrieved fields */
+		cvent = (struct rs_cv_entry *) realloc(cvent, (ncvent + 1) * 
sizeof(struct rs_cv_entry));
+		if (!cvent) {
+			ret = -1;
+			goto scan_cv_done;
+		}
+		memset(cvent + ncvent, '\0', sizeof(struct rs_cv_entry));
+
+		/* line ==> tokens */
+		for (i = 1, str1 = lp; ; i++, str1 = NULL) {
+			tok1 = strtok_r(str1, " \t", &saveptr1);
+			if (tok1 == NULL) {
+				break;
+			}
+
+			/* 1st field - process name */
+			if (i == 1) {
+				cvent[ncvent].name = (char *) malloc(strlen(tok1) + 1);
+				if (!cvent[ncvent].name) {
+					ret = -1;
+					goto scan_cv_done;
+				}
+				memcpy(cvent[ncvent].name, tok1, strlen(tok1) + 1);
+				continue;
+			}
+
+			/* 2nd field - comp vector */
+			if (i == 2) {
+				char *str2, *saveptr2, *tok2, *tok3, *tmp;
+				int16_t n, lvec, uvec, vec, nvec;
+
+				for (str2 = tok1; ; str2 = NULL) {
+					tok2 = strtok_r(str2, ",", &saveptr2);
+					if (tok2 == NULL) {
+						break;
+					}
+					if (!(tmp = strpbrk(tok2, "-"))) {
+						lvec = uvec = (int16_t) atoi(tok2);
+					} else {
+						tok3 = tmp + 1;
+						*tmp = '\0';
+						lvec = (int16_t) atoi(tok2);
+						uvec = (int16_t) atoi(tok3);
+					}
+					if (lvec < 0) {
+						lvec = 0;
+					}
+					if (uvec < 0) {
+						uvec = 0;
+					}
+					if (uvec < lvec) {
+						uvec = lvec;
+					}
+					nvec = cvent[ncvent].nvec;
+					/* alloc storage for new vectors */
+					cvent[ncvent].vec = (int16_t *) realloc(cvent[ncvent].vec,
+											(nvec + (uvec - lvec) + 1) * sizeof(int16_t));
+					if (!cvent[ncvent].vec) {
+						ret = -1;
+						goto scan_cv_done;
+					}
+					/* update vector store */
+					for (n = 0, vec = lvec; vec <= uvec; n++, vec++) {
+						cvent[ncvent].vec[nvec + n] = vec;
+					}
+					cvent[ncvent].nvec += (uvec - lvec) + 1;
+				}
+				break;
+			}
+		}
+		ncvent += 1;
+	}
+scan_cv_done:
+	fclose(fp);
+	return ret;
+}
+
  void rs_configure(void)
  {
  	FILE *f;
@@ -548,6 +700,15 @@ void rs_configure(void)
  		(void) fscanf(f, "%hu", &restart_onintr);
  		fclose(f);
  	}
+
+	if (rs_scan_comp_vector() == 0) {
+		comp_vector_avail = 1;
+	}
+
+	if (cvent) {
+		atexit(rs_free_cvent);
+	}
+
  	init = 1;
  out:
  	pthread_mutex_unlock(&mut);
@@ -762,12 +923,18 @@ static int ds_init_bufs(struct ds_qp *qp)
   */
  static int rs_create_cq(struct rsocket *rs, struct rdma_cm_id *cm_id)
  {
+	int vector = 0;
+
  	cm_id->recv_cq_channel = ibv_create_comp_channel(cm_id->verbs);
  	if (!cm_id->recv_cq_channel)
  		return -1;

+	if (comp_vector_avail) {
+		vector = rs_get_comp_vector();
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
