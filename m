From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/4] cxgb3: Use more common logging style
Date: Thu,  9 Feb 2017 14:23:48 -0800
Message-ID: <15772862930dfd2f2e10574b86c063d781976a89.1486678686.git.joe@perches.com>
References: <cover.1486678686.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1486678686.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Convert printks to pr_<level>

Miscellanea:

o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c      | 27 ++++++------
 drivers/infiniband/hw/cxgb3/cxio_hal.h      |  9 +++-
 drivers/infiniband/hw/cxgb3/cxio_resource.c |  5 ++-
 drivers/infiniband/hw/cxgb3/iwch.c          | 13 +++---
 drivers/infiniband/hw/cxgb3/iwch_cm.c       | 66 ++++++++++++-----------------
 drivers/infiniband/hw/cxgb3/iwch_cq.c       |  7 ++-
 drivers/infiniband/hw/cxgb3/iwch_ev.c       | 11 +++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 11 ++---
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |  7 ++-
 9 files changed, 70 insertions(+), 86 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index ada2e5009c86..1ee33db2e98a 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -110,8 +110,7 @@ int cxio_hal_cq_op(struct cxio_rdev *rdev_p, struct t3_cq *cq,
 		while (!CQ_VLD_ENTRY(rptr, cq->size_log2, cqe)) {
 			udelay(1);
 			if (i++ > 1000000) {
-				printk(KERN_ERR "%s: stalled rnic\n",
-				       rdev_p->dev_name);
+				pr_err("%s: stalled rnic\n", rdev_p->dev_name);
 				return -EIO;
 			}
 		}
@@ -949,13 +948,12 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
 	err = rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, GET_EMBEDDED_INFO,
 					 &(rdev_p->fw_info));
 	if (err) {
-		printk(KERN_ERR "%s t3cdev_p(%p)->ctl returned error %d.\n",
-		     __func__, rdev_p->t3cdev_p, err);
+		pr_err("%s t3cdev_p(%p)->ctl returned error %d\n",
+		       __func__, rdev_p->t3cdev_p, err);
 		goto err1;
 	}
 	if (G_FW_VERSION_MAJOR(rdev_p->fw_info.fw_vers) != CXIO_FW_MAJ) {
-		printk(KERN_ERR MOD "fatal firmware version mismatch: "
-		       "need version %u but adapter has version %u\n",
+		pr_err("fatal firmware version mismatch: need version %u but adapter has version %u\n",
 		       CXIO_FW_MAJ,
 		       G_FW_VERSION_MAJOR(rdev_p->fw_info.fw_vers));
 		err = -EINVAL;
@@ -965,15 +963,15 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
 	err = rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, RDMA_GET_PARAMS,
 					 &(rdev_p->rnic_info));
 	if (err) {
-		printk(KERN_ERR "%s t3cdev_p(%p)->ctl returned error %d.\n",
-		     __func__, rdev_p->t3cdev_p, err);
+		pr_err("%s t3cdev_p(%p)->ctl returned error %d\n",
+		       __func__, rdev_p->t3cdev_p, err);
 		goto err1;
 	}
 	err = rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, GET_PORTS,
 				    &(rdev_p->port_info));
 	if (err) {
-		printk(KERN_ERR "%s t3cdev_p(%p)->ctl returned error %d.\n",
-		     __func__, rdev_p->t3cdev_p, err);
+		pr_err("%s t3cdev_p(%p)->ctl returned error %d\n",
+		       __func__, rdev_p->t3cdev_p, err);
 		goto err1;
 	}
 
@@ -1003,27 +1001,26 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
 
 	err = cxio_hal_init_ctrl_qp(rdev_p);
 	if (err) {
-		printk(KERN_ERR "%s error %d initializing ctrl_qp.\n",
-		       __func__, err);
+		pr_err("%s error %d initializing ctrl_qp\n", __func__, err);
 		goto err1;
 	}
 	err = cxio_hal_init_resource(rdev_p, cxio_num_stags(rdev_p), 0,
 				     0, T3_MAX_NUM_QP, T3_MAX_NUM_CQ,
 				     T3_MAX_NUM_PD);
 	if (err) {
-		printk(KERN_ERR "%s error %d initializing hal resources.\n",
+		pr_err("%s error %d initializing hal resources\n",
 		       __func__, err);
 		goto err2;
 	}
 	err = cxio_hal_pblpool_create(rdev_p);
 	if (err) {
-		printk(KERN_ERR "%s error %d initializing pbl mem pool.\n",
+		pr_err("%s error %d initializing pbl mem pool\n",
 		       __func__, err);
 		goto err3;
 	}
 	err = cxio_hal_rqtpool_create(rdev_p);
 	if (err) {
-		printk(KERN_ERR "%s error %d initializing rqt mem pool.\n",
+		pr_err("%s error %d initializing rqt mem pool\n",
 		       __func__, err);
 		goto err4;
 	}
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index 78fbe9ffe7f0..115c0e3a5df5 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -196,8 +196,13 @@ int cxio_poll_cq(struct t3_wq *wq, struct t3_cq *cq, struct t3_cqe *cqe,
 		     u8 *cqe_flushed, u64 *cookie, u32 *credit);
 int iwch_cxgb3_ofld_send(struct t3cdev *tdev, struct sk_buff *skb);
 
-#define MOD "iw_cxgb3: "
-#define PDBG(fmt, args...) pr_debug(MOD fmt, ## args)
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define PDBG(fmt, args...) pr_debug(fmt, ## args)
 
 #ifdef DEBUG
 void cxio_dump_tpt(struct cxio_rdev *rev, u32 stag);
diff --git a/drivers/infiniband/hw/cxgb3/cxio_resource.c b/drivers/infiniband/hw/cxgb3/cxio_resource.c
index c40088ecf9f3..a826ed165696 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -285,8 +285,9 @@ int cxio_hal_pblpool_create(struct cxio_rdev *rdev_p)
 			PDBG("%s failed to add PBL chunk (%x/%x)\n",
 			     __func__, pbl_start, pbl_chunk);
 			if (pbl_chunk <= 1024 << MIN_PBL_SHIFT) {
-				printk(KERN_WARNING MOD "%s: Failed to add all PBL chunks (%x/%x)\n",
-				       __func__, pbl_start, rdev_p->rnic_info.pbl_top - pbl_start);
+				pr_warn("%s: Failed to add all PBL chunks (%x/%x)\n",
+					__func__, pbl_start,
+					rdev_p->rnic_info.pbl_top - pbl_start);
 				return 0;
 			}
 			pbl_chunk >>= 1;
diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index b3e11329801d..ba55010ace5c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -146,11 +146,10 @@ static void open_rnic_dev(struct t3cdev *tdev)
 	struct iwch_dev *rnicp;
 
 	PDBG("%s t3cdev %p\n", __func__,  tdev);
-	printk_once(KERN_INFO MOD "Chelsio T3 RDMA Driver - version %s\n",
-		       DRV_VERSION);
+	pr_info_once("Chelsio T3 RDMA Driver - version %s\n", DRV_VERSION);
 	rnicp = (struct iwch_dev *)ib_alloc_device(sizeof(*rnicp));
 	if (!rnicp) {
-		printk(KERN_ERR MOD "Cannot allocate ib device\n");
+		pr_err("Cannot allocate ib device\n");
 		return;
 	}
 	rnicp->rdev.ulp = rnicp;
@@ -160,7 +159,7 @@ static void open_rnic_dev(struct t3cdev *tdev)
 
 	if (cxio_rdev_open(&rnicp->rdev)) {
 		mutex_unlock(&dev_mutex);
-		printk(KERN_ERR MOD "Unable to open CXIO rdev\n");
+		pr_err("Unable to open CXIO rdev\n");
 		ib_dealloc_device(&rnicp->ibdev);
 		return;
 	}
@@ -171,11 +170,11 @@ static void open_rnic_dev(struct t3cdev *tdev)
 	mutex_unlock(&dev_mutex);
 
 	if (iwch_register_device(rnicp)) {
-		printk(KERN_ERR MOD "Unable to register device\n");
+		pr_err("Unable to register device\n");
 		close_rnic_dev(tdev);
 	}
-	printk(KERN_INFO MOD "Initialized device %s\n",
-	       pci_name(rnicp->rdev.rnic_info.pdev));
+	pr_info("Initialized device %s\n",
+		pci_name(rnicp->rdev.rnic_info.pdev));
 	return;
 }
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 65ee64400deb..4461619329ad 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -367,7 +367,7 @@ static void arp_failure_discard(struct t3cdev *dev, struct sk_buff *skb)
  */
 static void act_open_req_arp_failure(struct t3cdev *dev, struct sk_buff *skb)
 {
-	printk(KERN_ERR MOD "ARP failure during connect\n");
+	pr_err("ARP failure during connect\n");
 	kfree_skb(skb);
 }
 
@@ -392,7 +392,7 @@ static int send_halfclose(struct iwch_ep *ep, gfp_t gfp)
 	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(NULL, sizeof(*req), gfp);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - failed to alloc skb\n", __func__);
+		pr_err("%s - failed to alloc skb\n", __func__);
 		return -ENOMEM;
 	}
 	skb->priority = CPL_PRIORITY_DATA;
@@ -411,8 +411,7 @@ static int send_abort(struct iwch_ep *ep, struct sk_buff *skb, gfp_t gfp)
 	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(skb, sizeof(*req), gfp);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - failed to alloc skb.\n",
-		       __func__);
+		pr_err("%s - failed to alloc skb\n", __func__);
 		return -ENOMEM;
 	}
 	skb->priority = CPL_PRIORITY_DATA;
@@ -438,8 +437,7 @@ static int send_connect(struct iwch_ep *ep)
 
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - failed to alloc skb.\n",
-		       __func__);
+		pr_err("%s - failed to alloc skb\n", __func__);
 		return -ENOMEM;
 	}
 	mtu_idx = find_best_mtu(T3C_DATA(ep->com.tdev), dst_mtu(ep->dst));
@@ -544,7 +542,7 @@ static int send_mpa_reject(struct iwch_ep *ep, const void *pdata, u8 plen)
 
 	skb = get_skb(NULL, mpalen + sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - cannot alloc skb!\n", __func__);
+		pr_err("%s - cannot alloc skb!\n", __func__);
 		return -ENOMEM;
 	}
 	skb_reserve(skb, sizeof(*req));
@@ -593,7 +591,7 @@ static int send_mpa_reply(struct iwch_ep *ep, const void *pdata, u8 plen)
 
 	skb = get_skb(NULL, mpalen + sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - cannot alloc skb!\n", __func__);
+		pr_err("%s - cannot alloc skb!\n", __func__);
 		return -ENOMEM;
 	}
 	skb->priority = CPL_PRIORITY_DATA;
@@ -798,7 +796,7 @@ static int update_rx_credits(struct iwch_ep *ep, u32 credits)
 	PDBG("%s ep %p credits %u\n", __func__, ep, credits);
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "update_rx_credits - cannot alloc skb!\n");
+		pr_err("update_rx_credits - cannot alloc skb!\n");
 		return 0;
 	}
 
@@ -1065,8 +1063,7 @@ static int rx_data(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	case MPA_REP_SENT:
 		break;
 	default:
-		printk(KERN_ERR MOD "%s Unexpected streaming data."
-		       " ep %p state %d tid %d\n",
+		pr_err("%s Unexpected streaming data. ep %p state %d tid %d\n",
 		       __func__, ep, state_read(&ep->com), ep->hwtid);
 
 		/*
@@ -1159,8 +1156,7 @@ static int abort_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		release = 1;
 		break;
 	default:
-		printk(KERN_ERR "%s ep %p state %d\n",
-		     __func__, ep, ep->com.state);
+		pr_err("%s ep %p state %d\n", __func__, ep, ep->com.state);
 		break;
 	}
 	spin_unlock_irqrestore(&ep->com.lock, flags);
@@ -1205,7 +1201,7 @@ static int listen_start(struct iwch_listen_ep *ep)
 	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "t3c_listen_start failed to alloc skb!\n");
+		pr_err("t3c_listen_start failed to alloc skb!\n");
 		return -ENOMEM;
 	}
 
@@ -1247,7 +1243,7 @@ static int listen_stop(struct iwch_listen_ep *ep)
 	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - failed to alloc skb\n", __func__);
+		pr_err("%s - failed to alloc skb\n", __func__);
 		return -ENOMEM;
 	}
 	req = (struct cpl_close_listserv_req *) skb_put(skb, sizeof(*req));
@@ -1350,8 +1346,7 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	PDBG("%s parent ep %p tid %u\n", __func__, parent_ep, hwtid);
 
 	if (state_read(&parent_ep->com) != LISTEN) {
-		printk(KERN_ERR "%s - listening ep not in LISTEN\n",
-		       __func__);
+		pr_err("%s - listening ep not in LISTEN\n", __func__);
 		goto reject;
 	}
 
@@ -1361,8 +1356,7 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	tim.mac_addr = req->dst_mac;
 	tim.vlan_tag = ntohs(req->vlan_tag);
 	if (tdev->ctl(tdev, GET_IFF_FROM_MAC, &tim) < 0 || !tim.dev) {
-		printk(KERN_ERR "%s bad dst mac %pM\n",
-			__func__, req->dst_mac);
+		pr_err("%s bad dst mac %pM\n", __func__, req->dst_mac);
 		goto reject;
 	}
 
@@ -1373,22 +1367,19 @@ static int pass_accept_req(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 			req->local_port,
 			req->peer_port, G_PASS_OPEN_TOS(ntohl(req->tos_tid)));
 	if (!rt) {
-		printk(KERN_ERR MOD "%s - failed to find dst entry!\n",
-		       __func__);
+		pr_err("%s - failed to find dst entry!\n", __func__);
 		goto reject;
 	}
 	dst = &rt->dst;
 	l2t = t3_l2t_get(tdev, dst, NULL, &req->peer_ip);
 	if (!l2t) {
-		printk(KERN_ERR MOD "%s - failed to allocate l2t entry!\n",
-		       __func__);
+		pr_err("%s - failed to allocate l2t entry!\n", __func__);
 		dst_release(dst);
 		goto reject;
 	}
 	child_ep = alloc_ep(sizeof(*child_ep), GFP_KERNEL);
 	if (!child_ep) {
-		printk(KERN_ERR MOD "%s - failed to allocate ep entry!\n",
-		       __func__);
+		pr_err("%s - failed to allocate ep entry!\n", __func__);
 		l2t_release(tdev, l2t);
 		dst_release(dst);
 		goto reject;
@@ -1595,9 +1586,7 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 				     ep->com.qp, IWCH_QP_ATTR_NEXT_STATE,
 				     &attrs, 1);
 			if (ret)
-				printk(KERN_ERR MOD
-				       "%s - qp <- error failed!\n",
-				       __func__);
+				pr_err("%s - qp <- error failed!\n", __func__);
 		}
 		peer_abort_upcall(ep);
 		break;
@@ -1620,8 +1609,7 @@ static int peer_abort(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 
 	rpl_skb = get_skb(skb, sizeof(*rpl), GFP_KERNEL);
 	if (!rpl_skb) {
-		printk(KERN_ERR MOD "%s - cannot allocate skb!\n",
-		       __func__);
+		pr_err("%s - cannot allocate skb!\n", __func__);
 		release = 1;
 		goto out;
 	}
@@ -1719,7 +1707,7 @@ static int ec_status(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	if (rep->status) {
 		struct iwch_qp_attributes attrs;
 
-		printk(KERN_ERR MOD "%s BAD CLOSE - Aborting tid %u\n",
+		pr_err("%s BAD CLOSE - Aborting tid %u\n",
 		       __func__, ep->hwtid);
 		stop_ep_timer(ep);
 		attrs.next_state = IWCH_QP_STATE_ERROR;
@@ -1907,7 +1895,7 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	ep = alloc_ep(sizeof(*ep), GFP_KERNEL);
 	if (!ep) {
-		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __func__);
+		pr_err("%s - cannot alloc ep\n", __func__);
 		err = -ENOMEM;
 		goto out;
 	}
@@ -1936,7 +1924,7 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	 */
 	ep->atid = cxgb3_alloc_atid(h->rdev.t3cdev_p, &t3c_client, ep);
 	if (ep->atid == -1) {
-		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __func__);
+		pr_err("%s - cannot alloc atid\n", __func__);
 		err = -ENOMEM;
 		goto fail2;
 	}
@@ -1946,7 +1934,7 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 			raddr->sin_addr.s_addr, laddr->sin_port,
 			raddr->sin_port, IPTOS_LOWDELAY);
 	if (!rt) {
-		printk(KERN_ERR MOD "%s - cannot find route.\n", __func__);
+		pr_err("%s - cannot find route\n", __func__);
 		err = -EHOSTUNREACH;
 		goto fail3;
 	}
@@ -1954,7 +1942,7 @@ int iwch_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	ep->l2t = t3_l2t_get(ep->com.tdev, ep->dst, NULL,
 			     &raddr->sin_addr.s_addr);
 	if (!ep->l2t) {
-		printk(KERN_ERR MOD "%s - cannot alloc l2e.\n", __func__);
+		pr_err("%s - cannot alloc l2e\n", __func__);
 		err = -ENOMEM;
 		goto fail4;
 	}
@@ -1999,7 +1987,7 @@ int iwch_create_listen(struct iw_cm_id *cm_id, int backlog)
 
 	ep = alloc_ep(sizeof(*ep), GFP_KERNEL);
 	if (!ep) {
-		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __func__);
+		pr_err("%s - cannot alloc ep\n", __func__);
 		err = -ENOMEM;
 		goto fail1;
 	}
@@ -2016,7 +2004,7 @@ int iwch_create_listen(struct iw_cm_id *cm_id, int backlog)
 	 */
 	ep->stid = cxgb3_alloc_stid(h->rdev.t3cdev_p, &t3c_client, ep);
 	if (ep->stid == -1) {
-		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __func__);
+		pr_err("%s - cannot alloc atid\n", __func__);
 		err = -ENOMEM;
 		goto fail2;
 	}
@@ -2225,8 +2213,8 @@ static int set_tcb_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	struct cpl_set_tcb_rpl *rpl = cplhdr(skb);
 
 	if (rpl->status != CPL_ERR_NONE) {
-		printk(KERN_ERR MOD "Unexpected SET_TCB_RPL status %u "
-		       "for tid %u\n", rpl->status, GET_TID(rpl));
+		pr_err("Unexpected SET_TCB_RPL status %u for tid %u\n",
+		       rpl->status, GET_TID(rpl));
 	}
 	return CPL_RET_BUF_DONE;
 }
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cq.c b/drivers/infiniband/hw/cxgb3/iwch_cq.c
index 97fbfd2c298e..e97120378d63 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cq.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cq.c
@@ -122,8 +122,7 @@ static int iwch_poll_cq_one(struct iwch_dev *rhp, struct iwch_cq *chp,
 			wc->opcode = IB_WC_REG_MR;
 			break;
 		default:
-			printk(KERN_ERR MOD "Unexpected opcode %d "
-			       "in the CQE received for QPID=0x%0x\n",
+			pr_err("Unexpected opcode %d in the CQE received for QPID=0x%0x\n",
 			       CQE_OPCODE(cqe), CQE_QPID(cqe));
 			ret = -EINVAL;
 			goto out;
@@ -177,8 +176,8 @@ static int iwch_poll_cq_one(struct iwch_dev *rhp, struct iwch_cq *chp,
 			wc->status = IB_WC_WR_FLUSH_ERR;
 			break;
 		default:
-			printk(KERN_ERR MOD "Unexpected cqe_status 0x%x for "
-			       "QPID=0x%0x\n", CQE_STATUS(cqe), CQE_QPID(cqe));
+			pr_err("Unexpected cqe_status 0x%x for QPID=0x%0x\n",
+			       CQE_STATUS(cqe), CQE_QPID(cqe));
 			ret = -EINVAL;
 		}
 	}
diff --git a/drivers/infiniband/hw/cxgb3/iwch_ev.c b/drivers/infiniband/hw/cxgb3/iwch_ev.c
index abcc9e76962b..e8ecaeff2745 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_ev.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_ev.c
@@ -52,7 +52,7 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	qhp = get_qhp(rnicp, CQE_QPID(rsp_msg->cqe));
 
 	if (!qhp) {
-		printk(KERN_ERR "%s unaffiliated error 0x%x qpid 0x%x\n",
+		pr_err("%s unaffiliated error 0x%x qpid 0x%x\n",
 		       __func__, CQE_STATUS(rsp_msg->cqe),
 		       CQE_QPID(rsp_msg->cqe));
 		spin_unlock(&rnicp->lock);
@@ -68,8 +68,8 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 		return;
 	}
 
-	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
-	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __func__,
+	pr_err("%s - AE qpid 0x%x opcode %d status 0x%x type %d wrid.hi 0x%x wrid.lo 0x%x\n",
+	       __func__,
 	       CQE_QPID(rsp_msg->cqe), CQE_OPCODE(rsp_msg->cqe),
 	       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
 	       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
@@ -117,8 +117,7 @@ void iwch_ev_dispatch(struct cxio_rdev *rdev_p, struct sk_buff *skb)
 	chp = get_chp(rnicp, cqid);
 	qhp = get_qhp(rnicp, CQE_QPID(rsp_msg->cqe));
 	if (!chp || !qhp) {
-		printk(KERN_ERR MOD "BAD AE cqid 0x%x qpid 0x%x opcode %d "
-		       "status 0x%x type %d wrid.hi 0x%x wrid.lo 0x%x \n",
+		pr_err("BAD AE cqid 0x%x qpid 0x%x opcode %d status 0x%x type %d wrid.hi 0x%x wrid.lo 0x%x\n",
 		       cqid, CQE_QPID(rsp_msg->cqe),
 		       CQE_OPCODE(rsp_msg->cqe), CQE_STATUS(rsp_msg->cqe),
 		       CQE_TYPE(rsp_msg->cqe), CQE_WRID_HI(rsp_msg->cqe),
@@ -218,7 +217,7 @@ void iwch_ev_dispatch(struct cxio_rdev *rdev_p, struct sk_buff *skb)
 		break;
 
 	default:
-		printk(KERN_ERR MOD "Unknown T3 status 0x%x QPID 0x%x\n",
+		pr_err("Unknown T3 status 0x%x QPID 0x%x\n",
 		       CQE_STATUS(rsp_msg->cqe), qhp->wq.qpid);
 		post_qp_event(rnicp, chp, rsp_msg, IB_EVENT_QP_FATAL, 1);
 		break;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 48649f93258a..ce7408ae7e6c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -227,8 +227,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev,
 		mm->addr = virt_to_phys(chp->cq.queue);
 		if (udata->outlen < sizeof uresp) {
 			if (!warned++)
-				printk(KERN_WARNING MOD "Warning - "
-				       "downlevel libcxgb3 (non-fatal).\n");
+				pr_warn("Warning - downlevel libcxgb3 (non-fatal)\n");
 			mm->len = PAGE_ALIGN((1UL << uresp.size_log2) *
 					     sizeof(struct t3_cqe));
 			resplen = sizeof(struct iwch_create_cq_resp_v0);
@@ -306,8 +305,7 @@ static int iwch_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata)
 	oldcq.cqid = newcq.cqid;
 	ret = cxio_destroy_cq(&chp->rhp->rdev, &oldcq);
 	if (ret) {
-		printk(KERN_ERR MOD "%s - cxio_destroy_cq failed %d\n",
-			__func__, ret);
+		pr_err("%s - cxio_destroy_cq failed %d\n", __func__, ret);
 	}
 
 	/* add user hooks here */
@@ -346,8 +344,7 @@ static int iwch_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 	err = cxio_hal_cq_op(&rhp->rdev, &chp->cq, cq_op, 0);
 	spin_unlock_irqrestore(&chp->lock, flag);
 	if (err < 0)
-		printk(KERN_ERR MOD "Error %d rearming CQID 0x%x\n", err,
-		       chp->cq.cqid);
+		pr_err("Error %d rearming CQID 0x%x\n", err, chp->cq.cqid);
 	if (err > 0 && !(flags & IB_CQ_REPORT_MISSED_EVENTS))
 		err = 0;
 	return err;
@@ -493,7 +490,7 @@ static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
 	 * T3 only supports 32 bits of size.
 	 */
 	if (sizeof(phys_addr_t) > 4) {
-		pr_warn_once(MOD "Cannot support dma_mrs on this platform.\n");
+		pr_warn_once("Cannot support dma_mrs on this platform\n");
 		return ERR_PTR(-ENOTSUPP);
 	}
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index a9194db7f9b8..405a96b1d215 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -667,7 +667,7 @@ int iwch_post_zb_read(struct iwch_ep *ep)
 	PDBG("%s enter\n", __func__);
 	skb = alloc_skb(40, GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR "%s cannot send zb_read!!\n", __func__);
+		pr_err("%s cannot send zb_read!!\n", __func__);
 		return -ENOMEM;
 	}
 	wqe = (union t3_wr *)skb_put(skb, sizeof(struct t3_rdma_read_wr));
@@ -699,7 +699,7 @@ int iwch_post_terminate(struct iwch_qp *qhp, struct respQ_msg_t *rsp_msg)
 	PDBG("%s %d\n", __func__, __LINE__);
 	skb = alloc_skb(40, GFP_ATOMIC);
 	if (!skb) {
-		printk(KERN_ERR "%s cannot send TERMINATE!\n", __func__);
+		pr_err("%s cannot send TERMINATE!\n", __func__);
 		return -ENOMEM;
 	}
 	wqe = (union t3_wr *)skb_put(skb, 40);
@@ -1034,8 +1034,7 @@ int iwch_modify_qp(struct iwch_dev *rhp, struct iwch_qp *qhp,
 		goto err;
 		break;
 	default:
-		printk(KERN_ERR "%s in a bad state %d\n",
-		       __func__, qhp->attr.state);
+		pr_err("%s in a bad state %d\n", __func__, qhp->attr.state);
 		ret = -EINVAL;
 		goto err;
 		break;
-- 
2.10.0.rc2.1.g053435c
