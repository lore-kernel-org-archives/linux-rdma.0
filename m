From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 22/28] IB/srpt: Rework multi-channel support
Date: Wed,  3 Jan 2018 13:39:32 -0800
Message-ID: <20180103213938.11664-23-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Store initiator and target port ID's once per nexus instead of in each
channel data structure. This change simplifies the duplicate connection
check in srpt_cm_req_recv().

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 185 ++++++++++++++++++++++++----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  34 +++++--
 2 files changed, 159 insertions(+), 60 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d8c695135024..3a25eca81871 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1783,14 +1783,17 @@ static int srpt_disconnect_ch(struct srpt_rdma_ch *ch)
 
 static bool srpt_ch_closed(struct srpt_port *sport, struct srpt_rdma_ch *ch)
 {
+	struct srpt_nexus *nexus;
 	struct srpt_rdma_ch *ch2;
 	bool res = true;
 
 	rcu_read_lock();
-	list_for_each_entry(ch2, &sport->rch_list, list) {
-		if (ch2 == ch) {
-			res = false;
-			goto done;
+	list_for_each_entry(nexus, &sport->nexus_list, entry) {
+		list_for_each_entry(ch2, &nexus->ch_list, list) {
+			if (ch2 == ch) {
+				res = false;
+				goto done;
+			}
 		}
 	}
 done:
@@ -1826,30 +1829,78 @@ static bool srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
 	return ret == 0;
 }
 
-static void srpt_set_enabled(struct srpt_port *sport, bool enabled)
-	__must_hold(&sport->mutex)
+static void __srpt_close_all_ch(struct srpt_port *sport)
 {
+	struct srpt_nexus *nexus;
 	struct srpt_rdma_ch *ch;
 
 	lockdep_assert_held(&sport->mutex);
 
-	if (sport->enabled == enabled)
-		return;
-	sport->enabled = enabled;
-	if (sport->enabled)
-		return;
+	list_for_each_entry(nexus, &sport->nexus_list, entry) {
+		list_for_each_entry(ch, &nexus->ch_list, list) {
+			if (srpt_disconnect_ch(ch) >= 0)
+				pr_info("Closing channel %s-%d because target %s_%d has been disabled\n",
+					ch->sess_name, ch->qp->qp_num,
+					sport->sdev->device->name, sport->port);
+			srpt_close_ch(ch);
+		}
+	}
+}
+
+/*
+ * Look up (i_port_id, t_port_id) in sport->nexus_list. Create an entry if
+ * it does not yet exist.
+ */
+static struct srpt_nexus *srpt_get_nexus(struct srpt_port *sport,
+					 const u8 i_port_id[16],
+					 const u8 t_port_id[16])
+{
+	struct srpt_nexus *nexus = NULL, *tmp_nexus = NULL, *n;
 
-again:
-	list_for_each_entry(ch, &sport->rch_list, list) {
-		if (ch->sport == sport) {
-			pr_info("%s: closing channel %s-%d\n",
-				sport->sdev->device->name, ch->sess_name,
-				ch->qp->qp_num);
-			if (srpt_disconnect_ch_sync(ch))
-				goto again;
+	for (;;) {
+		mutex_lock(&sport->mutex);
+		list_for_each_entry(n, &sport->nexus_list, entry) {
+			if (memcmp(n->i_port_id, i_port_id, 16) == 0 &&
+			    memcmp(n->t_port_id, t_port_id, 16) == 0) {
+				nexus = n;
+				break;
+			}
+		}
+		if (!nexus && tmp_nexus) {
+			list_add_tail_rcu(&tmp_nexus->entry,
+					  &sport->nexus_list);
+			swap(nexus, tmp_nexus);
+		}
+		mutex_unlock(&sport->mutex);
+
+		if (nexus)
+			break;
+		tmp_nexus = kzalloc(sizeof(*nexus), GFP_KERNEL);
+		if (!tmp_nexus) {
+			nexus = ERR_PTR(-ENOMEM);
+			break;
 		}
+		init_rcu_head(&tmp_nexus->rcu);
+		INIT_LIST_HEAD(&tmp_nexus->ch_list);
+		memcpy(tmp_nexus->i_port_id, i_port_id, 16);
+		memcpy(tmp_nexus->t_port_id, t_port_id, 16);
 	}
 
+	kfree(tmp_nexus);
+
+	return nexus;
+}
+
+static void srpt_set_enabled(struct srpt_port *sport, bool enabled)
+	__must_hold(&sport->mutex)
+{
+	lockdep_assert_held(&sport->mutex);
+
+	if (sport->enabled == enabled)
+		return;
+	sport->enabled = enabled;
+	if (!enabled)
+		__srpt_close_all_ch(sport);
 }
 
 static void srpt_free_ch(struct kref *kref)
@@ -1916,11 +1967,12 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 {
 	struct srpt_device *sdev = cm_id->context;
 	struct srpt_port *sport = &sdev->port[param->port - 1];
+	struct srpt_nexus *nexus;
 	struct srp_login_req *req;
-	struct srp_login_rsp *rsp;
-	struct srp_login_rej *rej;
-	struct ib_cm_rep_param *rep_param;
-	struct srpt_rdma_ch *ch, *tmp_ch;
+	struct srp_login_rsp *rsp = NULL;
+	struct srp_login_rej *rej = NULL;
+	struct ib_cm_rep_param *rep_param = NULL;
+	struct srpt_rdma_ch *ch;
 	char *ini_guid, i_port_id[36];
 	u32 it_iu_len;
 	int i, ret = 0;
@@ -1939,6 +1991,13 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		param->port, &sport->gid,
 		be16_to_cpu(param->primary_path->pkey));
 
+	nexus = srpt_get_nexus(sport, req->initiator_port_id,
+			       req->target_port_id);
+	if (IS_ERR(nexus)) {
+		ret = PTR_ERR(nexus);
+		goto out;
+	}
+
 	rsp = kzalloc(sizeof(*rsp), GFP_KERNEL);
 	rej = kzalloc(sizeof(*rej), GFP_KERNEL);
 	rep_param = kzalloc(sizeof(*rep_param), GFP_KERNEL);
@@ -1968,29 +2027,22 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	}
 
 	if ((req->req_flags & SRP_MTCH_ACTION) == SRP_MULTICHAN_SINGLE) {
+		struct srpt_rdma_ch *ch2;
+
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_NO_CHAN;
 
 		mutex_lock(&sport->mutex);
-
-		list_for_each_entry_safe(ch, tmp_ch, &sport->rch_list, list) {
-			if (!memcmp(ch->i_port_id, req->initiator_port_id, 16)
-			    && !memcmp(ch->t_port_id, req->target_port_id, 16)
-			    && param->port == ch->sport->port
-			    && param->listen_id == ch->sport->sdev->cm_id
-			    && ch->cm_id) {
-				if (srpt_disconnect_ch(ch) < 0)
-					continue;
-				pr_info("Relogin - closed existing channel %s\n",
-					ch->sess_name);
-				rsp->rsp_flags =
-					SRP_LOGIN_RSP_MULTICHAN_TERMINATED;
-			}
+		list_for_each_entry(ch2, &nexus->ch_list, list) {
+			if (srpt_disconnect_ch(ch2) < 0)
+				continue;
+			pr_info("Relogin - closed existing channel %s\n",
+				ch2->sess_name);
+			rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_TERMINATED;
 		}
-
 		mutex_unlock(&sport->mutex);
-
-	} else
+	} else {
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_MAINTAINED;
+	}
 
 	if (*(__be64 *)req->target_port_id != cpu_to_be64(srpt_service_guid)
 	    || *(__be64 *)(req->target_port_id + 8) !=
@@ -2015,10 +2067,9 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	init_rcu_head(&ch->rcu);
 	kref_init(&ch->kref);
 	ch->pkey = be16_to_cpu(param->primary_path->pkey);
+	ch->nexus = nexus;
 	ch->zw_cqe.done = srpt_zerolength_write_done;
 	INIT_WORK(&ch->release_work, srpt_release_channel_work);
-	memcpy(ch->i_port_id, req->initiator_port_id, 16);
-	memcpy(ch->t_port_id, req->target_port_id, 16);
 	ch->sport = &sdev->port[param->port - 1];
 	ch->cm_id = cm_id;
 	cm_id->context = ch;
@@ -2080,8 +2131,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			 &param->primary_path->dgid.global.interface_id);
 	ini_guid = ch->sess_name;
 	snprintf(i_port_id, sizeof(i_port_id), "0x%016llx%016llx",
-			be64_to_cpu(*(__be64 *)ch->i_port_id),
-			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
+			be64_to_cpu(*(__be64 *)nexus->i_port_id),
+			be64_to_cpu(*(__be64 *)(nexus->i_port_id + 8)));
 
 	pr_debug("registering session %s\n", ch->sess_name);
 
@@ -2141,7 +2192,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	}
 
 	mutex_lock(&sport->mutex);
-	list_add_tail_rcu(&ch->list, &sport->rch_list);
+	list_add_tail_rcu(&ch->list, &nexus->ch_list);
 	mutex_unlock(&sport->mutex);
 
 	goto out;
@@ -2489,12 +2540,27 @@ static void srpt_refresh_port_work(struct work_struct *work)
 	srpt_refresh_port(sport);
 }
 
+static bool srpt_ch_list_empty(struct srpt_port *sport)
+{
+	struct srpt_nexus *nexus;
+	bool res = true;
+
+	rcu_read_lock();
+	list_for_each_entry(nexus, &sport->nexus_list, entry)
+		if (!list_empty(&nexus->ch_list))
+			res = false;
+	rcu_read_unlock();
+
+	return res;
+}
+
 /*
  * srpt_release_sport() - Free the channel resources associated with a target.
  */
 static int srpt_release_sport(struct srpt_port *sport)
 {
-	int res;
+	struct srpt_nexus *nexus, *next_n;
+	struct srpt_rdma_ch *ch;
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -2502,10 +2568,27 @@ static int srpt_release_sport(struct srpt_port *sport)
 	srpt_set_enabled(sport, false);
 	mutex_unlock(&sport->mutex);
 
-	res = wait_event_interruptible(sport->ch_releaseQ,
-				       list_empty_careful(&sport->rch_list));
-	if (res)
-		pr_err("%s: interrupted.\n", __func__);
+	while (wait_event_timeout(sport->ch_releaseQ,
+				  srpt_ch_list_empty(sport), 5 * HZ) <= 0) {
+		pr_info("%s_%d: waiting for session unregistration ...\n",
+			sport->sdev->device->name, sport->port);
+		rcu_read_lock();
+		list_for_each_entry(nexus, &sport->nexus_list, entry) {
+			list_for_each_entry(ch, &nexus->ch_list, list) {
+				pr_info("%s-%d: state %s\n",
+					ch->sess_name, ch->qp->qp_num,
+					get_ch_state_name(ch->state));
+			}
+		}
+		rcu_read_unlock();
+	}
+
+	mutex_lock(&sport->mutex);
+	list_for_each_entry_safe(nexus, next_n, &sport->nexus_list, entry) {
+		list_del(&nexus->entry);
+		kfree_rcu(nexus, rcu);
+	}
+	mutex_unlock(&sport->mutex);
 
 	return 0;
 }
@@ -2671,7 +2754,7 @@ static void srpt_add_one(struct ib_device *device)
 
 	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
 		sport = &sdev->port[i - 1];
-		INIT_LIST_HEAD(&sport->rch_list);
+		INIT_LIST_HEAD(&sport->nexus_list);
 		init_waitqueue_head(&sport->ch_releaseQ);
 		mutex_init(&sport->mutex);
 		sport->sdev = sdev;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 82b93e2a2efb..0ffb95cb117f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -54,6 +54,8 @@
  */
 #define SRP_SERVICE_NAME_PREFIX		"SRP.T10:"
 
+struct srpt_nexus;
+
 enum {
 	/*
 	 * SRP IOControllerProfile attributes for SRP target ports that have
@@ -240,6 +242,7 @@ enum rdma_ch_state {
 
 /**
  * struct srpt_rdma_ch - RDMA channel.
+ * @nexus:         I_T nexus this channel is associated with.
  * @cm_id:         IB CM ID associated with the channel.
  * @qp:            IB queue pair used for communicating over this channel.
  * @cq:            IB completion queue for this channel.
@@ -251,8 +254,6 @@ enum rdma_ch_state {
  * @sq_wr_avail:   number of work requests available in the send queue.
  * @sport:         pointer to the information of the HCA port used by this
  *                 channel.
- * @i_port_id:     128-bit initiator port identifier copied from SRP_LOGIN_REQ.
- * @t_port_id:     128-bit target port identifier copied from SRP_LOGIN_REQ.
  * @max_ti_iu_len: maximum target-to-initiator information unit length.
  * @req_lim:       request limit: maximum number of requests that may be sent
  *                 by the initiator without having received a response.
@@ -262,7 +263,7 @@ enum rdma_ch_state {
  * @state:         channel state. See also enum rdma_ch_state.
  * @ioctx_ring:    Send ring.
  * @ioctx_recv_ring: Receive I/O context ring.
- * @list:          Node in srpt_port.rch_list.
+ * @list:          Node in srpt_nexus.ch_list.
  * @cmd_wait_list: List of SCSI commands that arrived before the RTU event. This
  *                 list contains struct srpt_ioctx elements and is protected
  *                 against concurrent modification by the cm_id spinlock.
@@ -272,6 +273,7 @@ enum rdma_ch_state {
  * @release_work:  Allows scheduling of srpt_release_channel().
  */
 struct srpt_rdma_ch {
+	struct srpt_nexus	*nexus;
 	struct ib_cm_id		*cm_id;
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
@@ -282,8 +284,6 @@ struct srpt_rdma_ch {
 	u32			max_rsp_size;
 	atomic_t		sq_wr_avail;
 	struct srpt_port	*sport;
-	u8			i_port_id[16];
-	u8			t_port_id[16];
 	int			max_ti_iu_len;
 	atomic_t		req_lim;
 	atomic_t		req_lim_delta;
@@ -300,6 +300,22 @@ struct srpt_rdma_ch {
 	struct work_struct	release_work;
 };
 
+/**
+ * struct srpt_nexus - I_T nexus
+ * @rcu:       RCU head for this data structure.
+ * @entry:     srpt_port.nexus_list list node.
+ * @ch_list:   struct srpt_rdma_ch list. Protected by srpt_port.mutex.
+ * @i_port_id: 128-bit initiator port identifier copied from SRP_LOGIN_REQ.
+ * @t_port_id: 128-bit target port identifier copied from SRP_LOGIN_REQ.
+ */
+struct srpt_nexus {
+	struct rcu_head		rcu;
+	struct list_head	entry;
+	struct list_head	ch_list;
+	u8			i_port_id[16];
+	u8			t_port_id[16];
+};
+
 /**
  * struct srpt_port_attib - Attributes for SRPT port
  * @srp_max_rdma_size: Maximum size of SRP RDMA transfers for new connections.
@@ -332,9 +348,9 @@ struct srpt_port_attrib {
  * @port_gid_tpg:  TPG associated with target port GID.
  * @port_gid_wwn:  WWN associated with target port GID.
  * @port_attrib:   Port attributes that can be accessed through configfs.
- * @ch_releaseQ:   Enables waiting for removal from rch_list.
- * @mutex:	   Protects rch_list.
- * @rch_list:	   Channel list. See also srpt_rdma_ch.list.
+ * @ch_releaseQ:   Enables waiting for removal from nexus_list.
+ * @mutex:	   Protects nexus_list.
+ * @nexus_list:	   Nexus list. See also srpt_nexus.entry.
  */
 struct srpt_port {
 	struct srpt_device	*sdev;
@@ -354,7 +370,7 @@ struct srpt_port {
 	struct srpt_port_attrib port_attrib;
 	wait_queue_head_t	ch_releaseQ;
 	struct mutex		mutex;
-	struct list_head	rch_list;
+	struct list_head	nexus_list;
 };
 
 /**
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
