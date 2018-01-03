From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 21/28] IB/srpt: One target per port
Date: Wed,  3 Jan 2018 13:39:31 -0800
Message-ID: <20180103213938.11664-22-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In multipathing setups where a target system is equipped with
dual-port HCAs it is useful to have one connection per target port
instead of one connection per target HCA. Hence move the connection
list (rch_list) from struct srpt_device into struct srpt_port.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 102 +++++++++++++++++-----------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  20 +++----
 2 files changed, 62 insertions(+), 60 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index eeeb47739e9a..d8c695135024 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1781,13 +1781,13 @@ static int srpt_disconnect_ch(struct srpt_rdma_ch *ch)
 	return ret;
 }
 
-static bool srpt_ch_closed(struct srpt_device *sdev, struct srpt_rdma_ch *ch)
+static bool srpt_ch_closed(struct srpt_port *sport, struct srpt_rdma_ch *ch)
 {
 	struct srpt_rdma_ch *ch2;
 	bool res = true;
 
 	rcu_read_lock();
-	list_for_each_entry(ch2, &sdev->rch_list, list) {
+	list_for_each_entry(ch2, &sport->rch_list, list) {
 		if (ch2 == ch) {
 			res = false;
 			goto done;
@@ -1806,33 +1806,32 @@ static bool srpt_ch_closed(struct srpt_device *sdev, struct srpt_rdma_ch *ch)
 static bool srpt_disconnect_ch_sync(struct srpt_rdma_ch *ch)
 	__must_hold(&sdev->mutex)
 {
-	struct srpt_device *sdev = ch->sport->sdev;
+	struct srpt_port *sport = ch->sport;
 	int ret;
 
-	lockdep_assert_held(&sdev->mutex);
+	lockdep_assert_held(&sport->mutex);
 
 	pr_debug("ch %s-%d state %d\n", ch->sess_name, ch->qp->qp_num,
 		 ch->state);
 
 	ret = srpt_disconnect_ch(ch);
-	mutex_unlock(&sdev->mutex);
+	mutex_unlock(&sport->mutex);
 
-	while (wait_event_timeout(sdev->ch_releaseQ, srpt_ch_closed(sdev, ch),
+	while (wait_event_timeout(sport->ch_releaseQ, srpt_ch_closed(sport, ch),
 				  5 * HZ) == 0)
 		pr_info("%s(%s-%d state %d): still waiting ...\n", __func__,
 			ch->sess_name, ch->qp->qp_num, ch->state);
 
-	mutex_lock(&sdev->mutex);
+	mutex_lock(&sport->mutex);
 	return ret == 0;
 }
 
 static void srpt_set_enabled(struct srpt_port *sport, bool enabled)
-	__must_hold(&sdev->mutex)
+	__must_hold(&sport->mutex)
 {
-	struct srpt_device *sdev = sport->sdev;
 	struct srpt_rdma_ch *ch;
 
-	lockdep_assert_held(&sdev->mutex);
+	lockdep_assert_held(&sport->mutex);
 
 	if (sport->enabled == enabled)
 		return;
@@ -1841,10 +1840,10 @@ static void srpt_set_enabled(struct srpt_port *sport, bool enabled)
 		return;
 
 again:
-	list_for_each_entry(ch, &sdev->rch_list, list) {
+	list_for_each_entry(ch, &sport->rch_list, list) {
 		if (ch->sport == sport) {
 			pr_info("%s: closing channel %s-%d\n",
-				sdev->device->name, ch->sess_name,
+				sport->sdev->device->name, ch->sess_name,
 				ch->qp->qp_num);
 			if (srpt_disconnect_ch_sync(ch))
 				goto again;
@@ -1864,6 +1863,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 {
 	struct srpt_rdma_ch *ch;
 	struct srpt_device *sdev;
+	struct srpt_port *sport;
 	struct se_session *se_sess;
 
 	ch = container_of(w, struct srpt_rdma_ch, release_work);
@@ -1894,11 +1894,12 @@ static void srpt_release_channel_work(struct work_struct *w)
 			     sdev, ch->rq_size,
 			     srp_max_req_size, DMA_FROM_DEVICE);
 
-	mutex_lock(&sdev->mutex);
+	sport = ch->sport;
+	mutex_lock(&sport->mutex);
 	list_del_init(&ch->list);
-	mutex_unlock(&sdev->mutex);
+	mutex_unlock(&sport->mutex);
 
-	wake_up(&sdev->ch_releaseQ);
+	wake_up(&sport->ch_releaseQ);
 
 	kref_put(&ch->kref, srpt_free_ch);
 }
@@ -1920,6 +1921,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srp_login_rej *rej;
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
+	char *ini_guid, i_port_id[36];
 	u32 it_iu_len;
 	int i, ret = 0;
 
@@ -1968,9 +1970,9 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if ((req->req_flags & SRP_MTCH_ACTION) == SRP_MULTICHAN_SINGLE) {
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_NO_CHAN;
 
-		mutex_lock(&sdev->mutex);
+		mutex_lock(&sport->mutex);
 
-		list_for_each_entry_safe(ch, tmp_ch, &sdev->rch_list, list) {
+		list_for_each_entry_safe(ch, tmp_ch, &sport->rch_list, list) {
 			if (!memcmp(ch->i_port_id, req->initiator_port_id, 16)
 			    && !memcmp(ch->t_port_id, req->target_port_id, 16)
 			    && param->port == ch->sport->port
@@ -1985,7 +1987,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			}
 		}
 
-		mutex_unlock(&sdev->mutex);
+		mutex_unlock(&sport->mutex);
 
 	} else
 		rsp->rsp_flags = SRP_LOGIN_RSP_MULTICHAN_MAINTAINED;
@@ -2074,9 +2076,10 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto destroy_ib;
 	}
 
-	srpt_format_guid(ch->ini_guid, sizeof(ch->ini_guid),
+	srpt_format_guid(ch->sess_name, sizeof(ch->sess_name),
 			 &param->primary_path->dgid.global.interface_id);
-	snprintf(ch->sess_name, sizeof(ch->sess_name), "0x%016llx%016llx",
+	ini_guid = ch->sess_name;
+	snprintf(i_port_id, sizeof(i_port_id), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)ch->i_port_id),
 			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
 
@@ -2084,17 +2087,17 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 
 	if (sport->port_guid_tpg.se_tpg_wwn)
 		ch->sess = target_alloc_session(&sport->port_guid_tpg, 0, 0,
-						TARGET_PROT_NORMAL,
-						ch->ini_guid, ch, NULL);
+						TARGET_PROT_NORMAL, ini_guid,
+						ch, NULL);
 	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
 		ch->sess = target_alloc_session(&sport->port_gid_tpg, 0, 0,
-					TARGET_PROT_NORMAL, ch->sess_name, ch,
+					TARGET_PROT_NORMAL, i_port_id, ch,
 					NULL);
 	/* Retry without leading "0x" */
 	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
 		ch->sess = target_alloc_session(&sport->port_gid_tpg, 0, 0,
 						TARGET_PROT_NORMAL,
-						ch->sess_name + 2, ch, NULL);
+						i_port_id + 2, ch, NULL);
 	if (IS_ERR_OR_NULL(ch->sess)) {
 		pr_info("Rejected login because no ACL has been configured yet for initiator %s.\n",
 			ch->sess_name);
@@ -2137,9 +2140,9 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto release_channel;
 	}
 
-	mutex_lock(&sdev->mutex);
-	list_add_tail_rcu(&ch->list, &sdev->rch_list);
-	mutex_unlock(&sdev->mutex);
+	mutex_lock(&sport->mutex);
+	list_add_tail_rcu(&ch->list, &sport->rch_list);
+	mutex_unlock(&sport->mutex);
 
 	goto out;
 
@@ -2487,23 +2490,20 @@ static void srpt_refresh_port_work(struct work_struct *work)
 }
 
 /*
- * srpt_release_sdev() - Free the channel resources associated with a target.
+ * srpt_release_sport() - Free the channel resources associated with a target.
  */
-static int srpt_release_sdev(struct srpt_device *sdev)
+static int srpt_release_sport(struct srpt_port *sport)
 {
-	int i, res;
+	int res;
 
 	WARN_ON_ONCE(irqs_disabled());
 
-	BUG_ON(!sdev);
-
-	mutex_lock(&sdev->mutex);
-	for (i = 0; i < ARRAY_SIZE(sdev->port); i++)
-		srpt_set_enabled(&sdev->port[i], false);
-	mutex_unlock(&sdev->mutex);
+	mutex_lock(&sport->mutex);
+	srpt_set_enabled(sport, false);
+	mutex_unlock(&sport->mutex);
 
-	res = wait_event_interruptible(sdev->ch_releaseQ,
-				       list_empty_careful(&sdev->rch_list));
+	res = wait_event_interruptible(sport->ch_releaseQ,
+				       list_empty_careful(&sport->rch_list));
 	if (res)
 		pr_err("%s: interrupted.\n", __func__);
 
@@ -2630,9 +2630,7 @@ static void srpt_add_one(struct ib_device *device)
 		goto err;
 
 	sdev->device = device;
-	INIT_LIST_HEAD(&sdev->rch_list);
-	init_waitqueue_head(&sdev->ch_releaseQ);
-	mutex_init(&sdev->mutex);
+	mutex_init(&sdev->sdev_mutex);
 
 	sdev->pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(sdev->pd))
@@ -2673,6 +2671,9 @@ static void srpt_add_one(struct ib_device *device)
 
 	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
 		sport = &sdev->port[i - 1];
+		INIT_LIST_HEAD(&sport->rch_list);
+		init_waitqueue_head(&sport->ch_releaseQ);
+		mutex_init(&sport->mutex);
 		sport->sdev = sdev;
 		sport->port = i;
 		sport->port_attrib.srp_max_rdma_size = DEFAULT_MAX_RDMA_SIZE;
@@ -2743,7 +2744,9 @@ static void srpt_remove_one(struct ib_device *device, void *client_data)
 	spin_lock(&srpt_dev_lock);
 	list_del(&sdev->list);
 	spin_unlock(&srpt_dev_lock);
-	srpt_release_sdev(sdev);
+
+	for (i = 0; i < sdev->device->phys_port_cnt; i++)
+		srpt_release_sport(&sdev->port[i]);
 
 	srpt_free_srq(sdev);
 
@@ -2828,11 +2831,11 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 static void srpt_close_session(struct se_session *se_sess)
 {
 	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
-	struct srpt_device *sdev = ch->sport->sdev;
+	struct srpt_port *sport = ch->sport;
 
-	mutex_lock(&sdev->mutex);
+	mutex_lock(&sport->mutex);
 	srpt_disconnect_ch_sync(ch);
-	mutex_unlock(&sdev->mutex);
+	mutex_unlock(&sport->mutex);
 }
 
 /*
@@ -3056,7 +3059,7 @@ static ssize_t srpt_tpg_attrib_use_srq_store(struct config_item *item,
 	if (val != !!val)
 		return -EINVAL;
 
-	ret = mutex_lock_interruptible(&sdev->mutex);
+	ret = mutex_lock_interruptible(&sdev->sdev_mutex);
 	if (ret < 0)
 		return ret;
 	enabled = sport->enabled;
@@ -3065,7 +3068,7 @@ static ssize_t srpt_tpg_attrib_use_srq_store(struct config_item *item,
 	sport->port_attrib.use_srq = val;
 	srpt_use_srq(sdev, sport->port_attrib.use_srq);
 	srpt_set_enabled(sport, enabled);
-	mutex_unlock(&sdev->mutex);
+	mutex_unlock(&sdev->sdev_mutex);
 
 	return count;
 }
@@ -3096,7 +3099,6 @@ static ssize_t srpt_tpg_enable_store(struct config_item *item,
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
 	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
-	struct srpt_device *sdev = sport->sdev;
 	unsigned long tmp;
         int ret;
 
@@ -3111,9 +3113,9 @@ static ssize_t srpt_tpg_enable_store(struct config_item *item,
 		return -EINVAL;
 	}
 
-	mutex_lock(&sdev->mutex);
+	mutex_lock(&sport->mutex);
 	srpt_set_enabled(sport, tmp);
-	mutex_unlock(&sdev->mutex);
+	mutex_unlock(&sport->mutex);
 
 	return count;
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index dd44e51fa167..82b93e2a2efb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -262,14 +262,13 @@ enum rdma_ch_state {
  * @state:         channel state. See also enum rdma_ch_state.
  * @ioctx_ring:    Send ring.
  * @ioctx_recv_ring: Receive I/O context ring.
- * @list:          Node for insertion in the srpt_device.rch_list list.
+ * @list:          Node in srpt_port.rch_list.
  * @cmd_wait_list: List of SCSI commands that arrived before the RTU event. This
  *                 list contains struct srpt_ioctx elements and is protected
  *                 against concurrent modification by the cm_id spinlock.
  * @pkey:          P_Key of the IB partition for this SRP channel.
  * @sess:          Session information associated with this SRP channel.
  * @sess_name:     Session name.
- * @ini_guid:      Initiator port GUID.
  * @release_work:  Allows scheduling of srpt_release_channel().
  */
 struct srpt_rdma_ch {
@@ -297,8 +296,7 @@ struct srpt_rdma_ch {
 	struct list_head	cmd_wait_list;
 	uint16_t		pkey;
 	struct se_session	*sess;
-	u8			sess_name[36];
-	u8			ini_guid[24];
+	u8			sess_name[24];
 	struct work_struct	release_work;
 };
 
@@ -334,6 +332,9 @@ struct srpt_port_attrib {
  * @port_gid_tpg:  TPG associated with target port GID.
  * @port_gid_wwn:  WWN associated with target port GID.
  * @port_attrib:   Port attributes that can be accessed through configfs.
+ * @ch_releaseQ:   Enables waiting for removal from rch_list.
+ * @mutex:	   Protects rch_list.
+ * @rch_list:	   Channel list. See also srpt_rdma_ch.list.
  */
 struct srpt_port {
 	struct srpt_device	*sdev;
@@ -351,6 +352,9 @@ struct srpt_port {
 	struct se_portal_group	port_gid_tpg;
 	struct se_wwn		port_gid_wwn;
 	struct srpt_port_attrib port_attrib;
+	wait_queue_head_t	ch_releaseQ;
+	struct mutex		mutex;
+	struct list_head	rch_list;
 };
 
 /**
@@ -361,11 +365,9 @@ struct srpt_port {
  * @srq:           Per-HCA SRQ (shared receive queue).
  * @cm_id:         Connection identifier.
  * @srq_size:      SRQ size.
+ * @sdev_mutex:	   Serializes use_srq changes.
  * @use_srq:       Whether or not to use SRQ.
  * @ioctx_ring:    Per-HCA SRQ.
- * @rch_list:      Per-device channel list -- see also srpt_rdma_ch.list.
- * @ch_releaseQ:   Enables waiting for removal from rch_list.
- * @mutex:         Protects rch_list.
  * @port:          Information about the ports owned by this HCA.
  * @event_handler: Per-HCA asynchronous IB event handler.
  * @list:          Node in srpt_dev_list.
@@ -377,11 +379,9 @@ struct srpt_device {
 	struct ib_srq		*srq;
 	struct ib_cm_id		*cm_id;
 	int			srq_size;
+	struct mutex		sdev_mutex;
 	bool			use_srq;
 	struct srpt_recv_ioctx	**ioctx_ring;
-	struct list_head	rch_list;
-	wait_queue_head_t	ch_releaseQ;
-	struct mutex		mutex;
 	struct srpt_port	port[2];
 	struct ib_event_handler	event_handler;
 	struct list_head	list;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
