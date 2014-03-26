From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] RDMA/cxgb4: Add support for iWARP Port Mapper user space
 service (Version 2)
Date: Wed, 26 Mar 2014 17:08:09 -0500
Message-ID: <20140326220809.GA14716@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Add support for iWarp Port Mapper (Version 2) 

Based on original work by Vipul Pandya.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |  180 ++++++++++++++++++++++++++------
 drivers/infiniband/hw/cxgb4/device.c   |   81 ++++++++++++--
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   44 ++++++++
 3 files changed, 262 insertions(+), 43 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d286bde..65edfbc 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
+ * Copyright (c) 2009-2014 Chelsio, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -291,6 +291,12 @@ void _c4iw_free_ep(struct kref *kref)
 		dst_release(ep->dst);
 		cxgb4_l2t_release(ep->l2t);
 	}
+	if (test_bit(RELEASE_MAPINFO, &ep->com.flags)) {
+		print_addr(&ep->com, __func__, "remove_mapinfo/mapping");
+		iwpm_remove_mapinfo(&ep->com.local_addr,
+				    &ep->com.mapped_local_addr);
+		iwpm_remove_mapping(&ep->com.local_addr, RDMA_NL_C4IW);
+	}
 	kfree(ep);
 }
 
@@ -524,6 +530,38 @@ static int send_abort(struct c4iw_ep *ep, struct sk_buff *skb, gfp_t gfp)
 	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 }
 
+/*
+ * c4iw_form_pm_msg - Form a port mapper message with mapping info
+ */
+static void c4iw_form_pm_msg(struct c4iw_ep *ep,
+				struct iwpm_sa_data *pm_msg)
+{
+	memcpy(&pm_msg->loc_addr, &ep->com.local_addr,
+		sizeof(ep->com.local_addr));
+	memcpy(&pm_msg->rem_addr, &ep->com.remote_addr,
+		sizeof(ep->com.remote_addr));
+}
+
+/*
+ * c4iw_form_reg_msg - Form a port mapper message with dev info
+ */
+static void c4iw_form_reg_msg(struct c4iw_dev *dev,
+				struct iwpm_dev_data *pm_msg)
+{
+	memcpy(pm_msg->dev_name, dev->ibdev.name, IWPM_DEVNAME_SIZE);
+	memcpy(pm_msg->if_name, dev->rdev.lldi.ports[0]->name,
+				IWPM_IFNAME_SIZE);
+}
+
+static void c4iw_record_pm_msg(struct c4iw_ep *ep,
+			struct iwpm_sa_data *pm_msg)
+{
+	memcpy(&ep->com.mapped_local_addr, &pm_msg->mapped_loc_addr,
+		sizeof(ep->com.mapped_local_addr));
+	memcpy(&ep->com.mapped_remote_addr, &pm_msg->mapped_rem_addr,
+		sizeof(ep->com.mapped_remote_addr));
+}
+
 static int send_connect(struct c4iw_ep *ep)
 {
 	struct cpl_act_open_req *req;
@@ -542,10 +580,14 @@ static int send_connect(struct c4iw_ep *ep)
 	int sizev6 = is_t4(ep->com.dev->rdev.lldi.adapter_type) ?
 				sizeof(struct cpl_act_open_req6) :
 				sizeof(struct cpl_t5_act_open_req6);
-	struct sockaddr_in *la = (struct sockaddr_in *)&ep->com.local_addr;
-	struct sockaddr_in *ra = (struct sockaddr_in *)&ep->com.remote_addr;
-	struct sockaddr_in6 *la6 = (struct sockaddr_in6 *)&ep->com.local_addr;
-	struct sockaddr_in6 *ra6 = (struct sockaddr_in6 *)&ep->com.remote_addr;
+	struct sockaddr_in *la = (struct sockaddr_in *)
+				 &ep->com.mapped_local_addr;
+	struct sockaddr_in *ra = (struct sockaddr_in *)
+				 &ep->com.mapped_remote_addr;
+	struct sockaddr_in6 *la6 = (struct sockaddr_in6 *)
+				   &ep->com.mapped_local_addr;
+	struct sockaddr_in6 *ra6 = (struct sockaddr_in6 *)
+				   &ep->com.mapped_remote_addr;
 
 	wrlen = (ep->com.remote_addr.ss_family == AF_INET) ?
 			roundup(sizev4, 16) :
@@ -1593,10 +1635,10 @@ static void send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
 	req->le.filter = cpu_to_be32(cxgb4_select_ntuple(
 				     ep->com.dev->rdev.lldi.ports[0],
 				     ep->l2t));
-	sin = (struct sockaddr_in *)&ep->com.local_addr;
+	sin = (struct sockaddr_in *)&ep->com.mapped_local_addr;
 	req->le.lport = sin->sin_port;
 	req->le.u.ipv4.lip = sin->sin_addr.s_addr;
-	sin = (struct sockaddr_in *)&ep->com.remote_addr;
+	sin = (struct sockaddr_in *)&ep->com.mapped_remote_addr;
 	req->le.pport = sin->sin_port;
 	req->le.u.ipv4.pip = sin->sin_addr.s_addr;
 	req->tcb.t_state_to_astid =
@@ -1827,10 +1869,10 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct sockaddr_in6 *ra6;
 
 	ep = lookup_atid(t, atid);
-	la = (struct sockaddr_in *)&ep->com.local_addr;
-	ra = (struct sockaddr_in *)&ep->com.remote_addr;
-	la6 = (struct sockaddr_in6 *)&ep->com.local_addr;
-	ra6 = (struct sockaddr_in6 *)&ep->com.remote_addr;
+	la = (struct sockaddr_in *)&ep->com.mapped_local_addr;
+	ra = (struct sockaddr_in *)&ep->com.mapped_remote_addr;
+	la6 = (struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+	ra6 = (struct sockaddr_in6 *)&ep->com.mapped_remote_addr;
 
 	PDBG("%s ep %p atid %u status %u errno %d\n", __func__, ep, atid,
 	     status, status2errno(status));
@@ -2682,13 +2724,15 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct c4iw_dev *dev = to_c4iw_dev(cm_id->device);
 	struct c4iw_ep *ep;
 	int err = 0;
-	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
-	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->remote_addr;
-	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)&cm_id->local_addr;
-	struct sockaddr_in6 *raddr6 = (struct sockaddr_in6 *)
-				      &cm_id->remote_addr;
+	struct sockaddr_in *laddr;
+	struct sockaddr_in *raddr;
+	struct sockaddr_in6 *laddr6;
+	struct sockaddr_in6 *raddr6;
+	struct iwpm_dev_data pm_reg_msg;
+	struct iwpm_sa_data pm_msg;
 	__u8 *ra;
 	int iptype;
+	int iwpm_err = 0;
 
 	if ((conn_param->ord > c4iw_max_read_depth) ||
 	    (conn_param->ird > c4iw_max_read_depth)) {
@@ -2719,7 +2763,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (!ep->com.qp) {
 		PDBG("%s qpn 0x%x not found!\n", __func__, conn_param->qpn);
 		err = -EINVAL;
-		goto fail2;
+		goto fail1;
 	}
 	ref_qp(ep);
 	PDBG("%s qpn 0x%x qp %p cm_id %p\n", __func__, conn_param->qpn,
@@ -2732,10 +2776,50 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (ep->atid == -1) {
 		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __func__);
 		err = -ENOMEM;
-		goto fail2;
+		goto fail1;
 	}
 	insert_handle(dev, &dev->atid_idr, ep, ep->atid);
 
+	memcpy(&ep->com.local_addr, &cm_id->local_addr,
+	       sizeof(ep->com.local_addr));
+	memcpy(&ep->com.remote_addr, &cm_id->remote_addr,
+	       sizeof(ep->com.remote_addr));
+
+	/* No port mapper available, go with the specified peer information */
+	memcpy(&ep->com.mapped_local_addr, &cm_id->local_addr,
+	       sizeof(ep->com.mapped_local_addr));
+	memcpy(&ep->com.mapped_remote_addr, &cm_id->remote_addr,
+	       sizeof(ep->com.mapped_remote_addr));
+
+	c4iw_form_reg_msg(dev, &pm_reg_msg);
+	iwpm_err = iwpm_register_pid(&pm_reg_msg, RDMA_NL_C4IW);
+	if (iwpm_err) {
+		PDBG("%s: Port Mapper reg pid fail (err = %d).\n",
+			__func__, iwpm_err);
+	}
+	if (iwpm_valid_pid() && !iwpm_err) {
+		c4iw_form_pm_msg(ep, &pm_msg);
+		iwpm_err = iwpm_add_and_query_mapping(&pm_msg, RDMA_NL_C4IW);
+		if (iwpm_err)
+			PDBG("%s: Port Mapper query fail (err = %d).\n",
+				__func__, iwpm_err);
+		else
+			c4iw_record_pm_msg(ep, &pm_msg);
+	}
+	if (iwpm_create_mapinfo(&ep->com.local_addr,
+				&ep->com.mapped_local_addr, RDMA_NL_C4IW)) {
+		iwpm_remove_mapping(&ep->com.local_addr, RDMA_NL_C4IW);
+		err = -ENOMEM;
+		goto fail1;
+	}
+	print_addr(&ep->com, __func__, "add_query/create_mapinfo");
+	set_bit(RELEASE_MAPINFO, &ep->com.flags);
+
+	laddr = (struct sockaddr_in *)&ep->com.mapped_local_addr;
+	raddr = (struct sockaddr_in *)&ep->com.mapped_remote_addr;
+	laddr6 = (struct sockaddr_in6 *)&ep->com.mapped_local_addr;
+	raddr6 = (struct sockaddr_in6 *) &ep->com.mapped_remote_addr;
+
 	if (cm_id->remote_addr.ss_family == AF_INET) {
 		iptype = 4;
 		ra = (__u8 *)&raddr->sin_addr;
@@ -2746,7 +2830,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		if ((__force int)raddr->sin_addr.s_addr == INADDR_ANY) {
 			err = pick_local_ipaddrs(dev, cm_id);
 			if (err)
-				goto fail2;
+				goto fail1;
 		}
 
 		/* find a route */
@@ -2766,7 +2850,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		if (ipv6_addr_type(&raddr6->sin6_addr) == IPV6_ADDR_ANY) {
 			err = pick_local_ip6addrs(dev, cm_id);
 			if (err)
-				goto fail2;
+				goto fail1;
 		}
 
 		/* find a route */
@@ -2782,13 +2866,13 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (!ep->dst) {
 		printk(KERN_ERR MOD "%s - cannot find route.\n", __func__);
 		err = -EHOSTUNREACH;
-		goto fail3;
+		goto fail2;
 	}
 
 	err = import_ep(ep, iptype, ra, ep->dst, ep->com.dev, true);
 	if (err) {
 		printk(KERN_ERR MOD "%s - cannot alloc l2e.\n", __func__);
-		goto fail4;
+		goto fail3;
 	}
 
 	PDBG("%s txq_idx %u tx_chan %u smac_idx %u rss_qid %u l2t_idx %u\n",
@@ -2797,10 +2881,6 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	state_set(&ep->com, CONNECTING);
 	ep->tos = 0;
-	memcpy(&ep->com.local_addr, &cm_id->local_addr,
-	       sizeof(ep->com.local_addr));
-	memcpy(&ep->com.remote_addr, &cm_id->remote_addr,
-	       sizeof(ep->com.remote_addr));
 
 	/* send connect request to rnic */
 	err = send_connect(ep);
@@ -2808,12 +2888,12 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		goto out;
 
 	cxgb4_l2t_release(ep->l2t);
-fail4:
-	dst_release(ep->dst);
 fail3:
+	dst_release(ep->dst);
+fail2:
 	remove_handle(ep->com.dev, &ep->com.dev->atid_idr, ep->atid);
 	cxgb4_free_atid(ep->com.dev->rdev.lldi.tids, ep->atid);
-fail2:
+fail1:
 	cm_id->rem_ref(cm_id);
 	c4iw_put_ep(&ep->com);
 out:
@@ -2823,7 +2903,8 @@ out:
 static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 {
 	int err;
-	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&ep->com.local_addr;
+	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)
+				    &ep->com.mapped_local_addr;
 
 	c4iw_init_wr_wait(&ep->com.wr_wait);
 	err = cxgb4_create_server6(ep->com.dev->rdev.lldi.ports[0],
@@ -2844,7 +2925,8 @@ static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 static int create_server4(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 {
 	int err;
-	struct sockaddr_in *sin = (struct sockaddr_in *)&ep->com.local_addr;
+	struct sockaddr_in *sin = (struct sockaddr_in *)
+				  &ep->com.mapped_local_addr;
 
 	if (dev->rdev.lldi.enable_fw_ofld_conn) {
 		do {
@@ -2879,6 +2961,9 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 	int err = 0;
 	struct c4iw_dev *dev = to_c4iw_dev(cm_id->device);
 	struct c4iw_listen_ep *ep;
+	struct iwpm_dev_data pm_reg_msg;
+	struct iwpm_sa_data pm_msg;
+	int iwpm_err = 0;
 
 	might_sleep();
 
@@ -2913,6 +2998,37 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		goto fail2;
 	}
 	insert_handle(dev, &dev->stid_idr, ep, ep->stid);
+
+	/* No port mapper available, go with the specified info */
+	memcpy(&ep->com.mapped_local_addr, &cm_id->local_addr,
+	       sizeof(ep->com.mapped_local_addr));
+
+	c4iw_form_reg_msg(dev, &pm_reg_msg);
+	iwpm_err = iwpm_register_pid(&pm_reg_msg, RDMA_NL_C4IW);
+	if (iwpm_err) {
+		PDBG("%s: Port Mapper reg pid fail (err = %d).\n",
+			__func__, iwpm_err);
+	}
+	if (iwpm_valid_pid() && !iwpm_err) {
+		memcpy(&pm_msg.loc_addr, &ep->com.local_addr,
+				sizeof(ep->com.local_addr));
+		iwpm_err = iwpm_add_mapping(&pm_msg, RDMA_NL_C4IW);
+		if (iwpm_err)
+			PDBG("%s: Port Mapper query fail (err = %d).\n",
+				__func__, iwpm_err);
+		else
+			memcpy(&ep->com.mapped_local_addr,
+				&pm_msg.mapped_loc_addr,
+				sizeof(ep->com.mapped_local_addr));
+	}
+	if (iwpm_create_mapinfo(&ep->com.local_addr,
+				&ep->com.mapped_local_addr, RDMA_NL_C4IW)) {
+		err = -ENOMEM;
+		goto fail3;
+	}
+	print_addr(&ep->com, __func__, "add_mapping/create_mapinfo");
+
+	set_bit(RELEASE_MAPINFO, &ep->com.flags);
 	state_set(&ep->com, LISTEN);
 	if (ep->com.local_addr.ss_family == AF_INET)
 		err = create_server4(dev, ep);
@@ -2922,6 +3038,8 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		cm_id->provider_data = ep;
 		goto out;
 	}
+
+fail3:
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid,
 			ep->com.local_addr.ss_family);
 fail2:
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 4a03385..87eca63 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -73,6 +73,16 @@ struct c4iw_debugfs_data {
 	int pos;
 };
 
+/* registered cxgb4 netlink callbacks */
+static struct ibnl_client_cbs c4iw_nl_cb_table[] = {
+	[RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
+	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
+	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
+	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = iwpm_mapping_error_cb},
+	[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb},
+	[RDMA_NL_IWPM_MAPINFO_NUM] = {.dump = iwpm_ack_mapping_info_cb}
+};
+
 static int count_idrs(int id, void *p, void *data)
 {
 	int *countp = data;
@@ -109,35 +119,49 @@ static int dump_qp(int id, void *p, void *data)
 				&qp->ep->com.local_addr;
 			struct sockaddr_in *rsin = (struct sockaddr_in *)
 				&qp->ep->com.remote_addr;
+			struct sockaddr_in *mapped_lsin = (struct sockaddr_in *)
+				&qp->ep->com.mapped_local_addr;
+			struct sockaddr_in *mapped_rsin = (struct sockaddr_in *)
+				&qp->ep->com.mapped_remote_addr;
 
 			cc = snprintf(qpd->buf + qpd->pos, space,
 				      "rc qp sq id %u rq id %u state %u "
 				      "onchip %u ep tid %u state %u "
-				      "%pI4:%u->%pI4:%u\n",
+				      "%pI4:%u/%u->%pI4:%u/%u\n",
 				      qp->wq.sq.qid, qp->wq.rq.qid,
 				      (int)qp->attr.state,
 				      qp->wq.sq.flags & T4_SQ_ONCHIP,
 				      qp->ep->hwtid, (int)qp->ep->com.state,
 				      &lsin->sin_addr, ntohs(lsin->sin_port),
-				      &rsin->sin_addr, ntohs(rsin->sin_port));
+				      ntohs(mapped_lsin->sin_port),
+				      &rsin->sin_addr, ntohs(rsin->sin_port),
+				      ntohs(mapped_rsin->sin_port));
 		} else {
 			struct sockaddr_in6 *lsin6 = (struct sockaddr_in6 *)
 				&qp->ep->com.local_addr;
 			struct sockaddr_in6 *rsin6 = (struct sockaddr_in6 *)
 				&qp->ep->com.remote_addr;
+			struct sockaddr_in6 *mapped_lsin6 =
+				(struct sockaddr_in6 *)
+				&qp->ep->com.mapped_local_addr;
+			struct sockaddr_in6 *mapped_rsin6 =
+				(struct sockaddr_in6 *)
+				&qp->ep->com.mapped_remote_addr;
 
 			cc = snprintf(qpd->buf + qpd->pos, space,
 				      "rc qp sq id %u rq id %u state %u "
 				      "onchip %u ep tid %u state %u "
-				      "%pI6:%u->%pI6:%u\n",
+				      "%pI6:%u/%u->%pI6:%u/%u\n",
 				      qp->wq.sq.qid, qp->wq.rq.qid,
 				      (int)qp->attr.state,
 				      qp->wq.sq.flags & T4_SQ_ONCHIP,
 				      qp->ep->hwtid, (int)qp->ep->com.state,
 				      &lsin6->sin6_addr,
 				      ntohs(lsin6->sin6_port),
+				      ntohs(mapped_lsin6->sin6_port),
 				      &rsin6->sin6_addr,
-				      ntohs(rsin6->sin6_port));
+				      ntohs(rsin6->sin6_port),
+				      ntohs(mapped_rsin6->sin6_port));
 		}
 	} else
 		cc = snprintf(qpd->buf + qpd->pos, space,
@@ -381,31 +405,43 @@ static int dump_ep(int id, void *p, void *data)
 			&ep->com.local_addr;
 		struct sockaddr_in *rsin = (struct sockaddr_in *)
 			&ep->com.remote_addr;
+		struct sockaddr_in *mapped_lsin = (struct sockaddr_in *)
+			&ep->com.mapped_local_addr;
+		struct sockaddr_in *mapped_rsin = (struct sockaddr_in *)
+			&ep->com.mapped_remote_addr;
 
 		cc = snprintf(epd->buf + epd->pos, space,
 			      "ep %p cm_id %p qp %p state %d flags 0x%lx "
 			      "history 0x%lx hwtid %d atid %d "
-			      "%pI4:%d <-> %pI4:%d\n",
+			      "%pI4:%d/%d <-> %pI4:%d/%d\n",
 			      ep, ep->com.cm_id, ep->com.qp,
 			      (int)ep->com.state, ep->com.flags,
 			      ep->com.history, ep->hwtid, ep->atid,
 			      &lsin->sin_addr, ntohs(lsin->sin_port),
-			      &rsin->sin_addr, ntohs(rsin->sin_port));
+			      ntohs(mapped_lsin->sin_port),
+			      &rsin->sin_addr, ntohs(rsin->sin_port),
+			      ntohs(mapped_rsin->sin_port));
 	} else {
 		struct sockaddr_in6 *lsin6 = (struct sockaddr_in6 *)
 			&ep->com.local_addr;
 		struct sockaddr_in6 *rsin6 = (struct sockaddr_in6 *)
 			&ep->com.remote_addr;
+		struct sockaddr_in6 *mapped_lsin6 = (struct sockaddr_in6 *)
+			&ep->com.mapped_local_addr;
+		struct sockaddr_in6 *mapped_rsin6 = (struct sockaddr_in6 *)
+			&ep->com.mapped_remote_addr;
 
 		cc = snprintf(epd->buf + epd->pos, space,
 			      "ep %p cm_id %p qp %p state %d flags 0x%lx "
 			      "history 0x%lx hwtid %d atid %d "
-			      "%pI6:%d <-> %pI6:%d\n",
+			      "%pI6:%d/%d <-> %pI6:%d/%d\n",
 			      ep, ep->com.cm_id, ep->com.qp,
 			      (int)ep->com.state, ep->com.flags,
 			      ep->com.history, ep->hwtid, ep->atid,
 			      &lsin6->sin6_addr, ntohs(lsin6->sin6_port),
-			      &rsin6->sin6_addr, ntohs(rsin6->sin6_port));
+			      ntohs(mapped_lsin6->sin6_port),
+			      &rsin6->sin6_addr, ntohs(rsin6->sin6_port),
+			      ntohs(mapped_rsin6->sin6_port));
 	}
 	if (cc < space)
 		epd->pos += cc;
@@ -426,23 +462,29 @@ static int dump_listen_ep(int id, void *p, void *data)
 	if (ep->com.local_addr.ss_family == AF_INET) {
 		struct sockaddr_in *lsin = (struct sockaddr_in *)
 			&ep->com.local_addr;
+		struct sockaddr_in *mapped_lsin = (struct sockaddr_in *)
+			&ep->com.mapped_local_addr;
 
 		cc = snprintf(epd->buf + epd->pos, space,
 			      "ep %p cm_id %p state %d flags 0x%lx stid %d "
-			      "backlog %d %pI4:%d\n",
+			      "backlog %d %pI4:%d/%d\n",
 			      ep, ep->com.cm_id, (int)ep->com.state,
 			      ep->com.flags, ep->stid, ep->backlog,
-			      &lsin->sin_addr, ntohs(lsin->sin_port));
+			      &lsin->sin_addr, ntohs(lsin->sin_port),
+			      ntohs(mapped_lsin->sin_port));
 	} else {
 		struct sockaddr_in6 *lsin6 = (struct sockaddr_in6 *)
 			&ep->com.local_addr;
+		struct sockaddr_in6 *mapped_lsin6 = (struct sockaddr_in6 *)
+			&ep->com.mapped_local_addr;
 
 		cc = snprintf(epd->buf + epd->pos, space,
 			      "ep %p cm_id %p state %d flags 0x%lx stid %d "
-			      "backlog %d %pI6:%d\n",
+			      "backlog %d %pI6:%d/%d\n",
 			      ep, ep->com.cm_id, (int)ep->com.state,
 			      ep->com.flags, ep->stid, ep->backlog,
-			      &lsin6->sin6_addr, ntohs(lsin6->sin6_port));
+			      &lsin6->sin6_addr, ntohs(lsin6->sin6_port),
+			      ntohs(mapped_lsin6->sin6_port));
 	}
 	if (cc < space)
 		epd->pos += cc;
@@ -672,6 +714,7 @@ static void c4iw_dealloc(struct uld_ctx *ctx)
 	idr_destroy(&ctx->dev->atid_idr);
 	iounmap(ctx->dev->rdev.oc_mw_kva);
 	ib_dealloc_device(&ctx->dev->ibdev);
+	iwpm_exit(RDMA_NL_C4IW);
 	ctx->dev = NULL;
 }
 
@@ -756,6 +799,14 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 					c4iw_debugfs_root);
 		setup_debugfs(devp);
 	}
+
+	ret = iwpm_init(RDMA_NL_C4IW);
+	if (ret) {
+		pr_err("port mapper initialization failed with %d\n", ret);
+		ib_dealloc_device(&devp->ibdev);
+		return ERR_PTR(ret);
+	}
+
 	return devp;
 }
 
@@ -1210,6 +1261,11 @@ static int __init c4iw_init_module(void)
 		printk(KERN_WARNING MOD
 		       "could not create debugfs entry, continuing\n");
 
+	if (ibnl_add_client(RDMA_NL_C4IW, RDMA_NL_IWPM_NUM_OPS,
+			    c4iw_nl_cb_table))
+		pr_err("%s[%u]: Failed to add netlink callback\n"
+		       , __func__, __LINE__);
+
 	cxgb4_register_uld(CXGB4_ULD_RDMA, &c4iw_uld_info);
 
 	return 0;
@@ -1227,6 +1283,7 @@ static void __exit c4iw_exit_module(void)
 	}
 	mutex_unlock(&dev_mutex);
 	cxgb4_unregister_uld(CXGB4_ULD_RDMA);
+	ibnl_remove_client(RDMA_NL_C4IW);
 	c4iw_cm_term();
 	debugfs_remove_recursive(c4iw_debugfs_root);
 }
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 23eaeab..7d9580a 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -52,6 +52,8 @@
 
 #include <rdma/ib_verbs.h>
 #include <rdma/iw_cm.h>
+#include <rdma/rdma_netlink.h>
+#include <rdma/iw_portmap.h>
 
 #include "cxgb4.h"
 #include "cxgb4_uld.h"
@@ -718,6 +720,7 @@ enum c4iw_ep_flags {
 	CLOSE_SENT		= 3,
 	TIMEOUT                 = 4,
 	QP_REFERENCED           = 5,
+	RELEASE_MAPINFO		= 6,
 };
 
 enum c4iw_ep_history {
@@ -754,6 +757,8 @@ struct c4iw_ep_common {
 	struct mutex mutex;
 	struct sockaddr_storage local_addr;
 	struct sockaddr_storage remote_addr;
+	struct sockaddr_storage mapped_local_addr;
+	struct sockaddr_storage mapped_remote_addr;
 	struct c4iw_wr_wait wr_wait;
 	unsigned long flags;
 	unsigned long history;
@@ -797,6 +802,45 @@ struct c4iw_ep {
 	unsigned int retry_count;
 };
 
+static inline void print_addr(struct c4iw_ep_common *epc, const char *func,
+			      const char *msg)
+{
+
+#define SINA(a) (&(((struct sockaddr_in *)(a))->sin_addr.s_addr))
+#define SINP(a) htons(((struct sockaddr_in *)(a))->sin_port)
+#define SIN6A(a) (&(((struct sockaddr_in6 *)(a))->sin6_addr))
+#define SIN6P(a) htons(((struct sockaddr_in6 *)(a))->sin6_port)
+
+	if (c4iw_debug) {
+		switch (epc->local_addr.ss_family) {
+		case AF_INET:
+			PDBG("%s %s %pI4:%u/%u <-> %pI4:%u/%u\n",
+			     func, msg, SINA(&epc->local_addr),
+			     SINP(&epc->local_addr),
+			     SINP(&epc->mapped_local_addr),
+			     SINA(&epc->remote_addr),
+			     SINP(&epc->remote_addr),
+			     SINP(&epc->mapped_remote_addr));
+			break;
+		case AF_INET6:
+			PDBG("%s %s %pI6:%u/%u <-> %pI6:%u/%u\n",
+			     func, msg, SIN6A(&epc->local_addr),
+			     SIN6P(&epc->local_addr),
+			     SIN6P(&epc->mapped_local_addr),
+			     SIN6A(&epc->remote_addr),
+			     SIN6P(&epc->remote_addr),
+			     SIN6P(&epc->mapped_remote_addr));
+			break;
+		default:
+			break;
+		}
+	}
+#undef SINA
+#undef SINP
+#undef SIN6A
+#undef SIN6P
+}
+
 static inline struct c4iw_ep *to_ep(struct iw_cm_id *cm_id)
 {
 	return cm_id->provider_data;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
