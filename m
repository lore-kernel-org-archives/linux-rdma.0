From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Mon, 29 Jan 2018 20:34:36 -0700
Message-ID: <20180130033436.GA17053@ziepe.ca>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128210520.GK23869@ziepe.ca>
 <1517256713.27592.241.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517256713.27592.241.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 29, 2018 at 03:11:53PM -0500, Doug Ledford wrote:
> On Sun, 2018-01-28 at 14:05 -0700, Jason Gunthorpe wrote:
> > On Sun, Jan 28, 2018 at 11:17:17AM +0200, Leon Romanovsky wrote:
> > 
> > > The original goal of this series was to allow ability to view connection
> > > (QP) information about running processes, however I used this opportunity and
> > > created common infrastructure to track and report various resources. The report
> > > part is implemented in netlink (nldev), but smart ULPs can now create
> > > advanced usage models based on device utilization.
> > > 
> > > The current implementation relies on one lock per-object per-device, so
> > > creation/destroying of various objects (CQ, PD, e.t.c) on various or the
> > > same devices doesn't interfere each with another.
> > > 
> > > The data protection is performed with SRCU and its reader-writer model
> > > ensures that resource won't be destroyed till readers will finish their
> > > work.
> > 
> > Well, this cover letter isn't quite right anymore.. but no matter.
> > 
> > My small comments aside it looks OK to me.
> 
> Likewise.  I'm happy with it at this point.

Okay, I fixed up the small things and applied the patches to for-next

Leon: Please validate I didn't screw it up. Here is the diff against
what you sent:

- Success path on the main execution flow, not under an if
- constify static structure
- Remove confusing comment about locking, ib_enum_all_devs
  obtains locks to iterate its list and rdma_restrack_count holds
  res->rwsem so everything is accounted for directly without
  trickyness
- Speeling
- Remove extra lock in rdma_restrack_del
- Restore pd = NULL in ib_create_xrc_qp. This scraed me a bit, xrc is
  wonky. But ib_create_xrc_q is only called in cases where
  rdma_restrack_add is not added, so keeping things as-they-are should
  not impact restrack. If restrack needs the pd for a XRC someday it
  should get it from qp->real_qp
- Remove SET/NEW/DEL cargo cult, please send a patch for rest?

Branch is here:

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-for-next

Still unhappy with the kref-as-not-a-kref.

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 3dcacf220e5e7e..c4560d84dfaebd 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -310,21 +310,21 @@ static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
 	struct ib_qp *qp;
 
 	qp = dev->create_qp(pd, attr, udata);
-	if (!IS_ERR(qp)) {
-		qp->device = dev;
-		qp->pd	   = pd;
-		/*
-		 * We don't track XRC QPs for now, because they don't have PD
-		 * and more importantly they are created internaly by driver,
-		 * see mlx5 create_dev_resources() as an example.
-		 */
-		if (attr->qp_type < IB_QPT_XRC_INI) {
-			qp->res.type = RDMA_RESTRACK_QP;
-			rdma_restrack_add(&qp->res);
-		} else {
-			qp->res.valid = false;
-		}
-	}
+	if (IS_ERR(qp))
+		return qp;
+
+	qp->device = dev;
+	qp->pd = pd;
+	/*
+	 * We don't track XRC QPs for now, because they don't have PD
+	 * and more importantly they are created internaly by driver,
+	 * see mlx5 create_dev_resources() as an example.
+	 */
+	if (attr->qp_type < IB_QPT_XRC_INI) {
+		qp->res.type = RDMA_RESTRACK_QP;
+		rdma_restrack_add(&qp->res);
+	} else
+		qp->res.valid = false;
 
 	return qp;
 }
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 421d5fa6a81731..fa8655e3b3edfe 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -178,7 +178,7 @@ static int fill_res_info_entry(struct sk_buff *msg,
 
 static int fill_res_info(struct sk_buff *msg, struct ib_device *device)
 {
-	static const char *names[RDMA_RESTRACK_MAX] = {
+	static const char * const names[RDMA_RESTRACK_MAX] = {
 		[RDMA_RESTRACK_PD] = "pd",
 		[RDMA_RESTRACK_CQ] = "cq",
 		[RDMA_RESTRACK_QP] = "qp",
@@ -553,10 +553,6 @@ static int _nldev_res_get_dumpit(struct ib_device *device,
 static int nldev_res_get_dumpit(struct sk_buff *skb,
 				struct netlink_callback *cb)
 {
-	/*
-	 * There is no need to take lock, because
-	 * we are relying on ib_core's lists_rwsem
-	 */
 	return ib_enum_all_devs(_nldev_res_get_dumpit, skb, cb);
 }
 
@@ -627,8 +623,8 @@ static int nldev_res_get_qp_dumpit(struct sk_buff *skb,
 		    (!rdma_is_kernel_res(res) &&
 		     task_active_pid_ns(current) != task_active_pid_ns(res->task)))
 			/*
-			 * 1. Kernel QPs should be visible in init namsapce only
-			 * 2. Preent only QPs visible in the current namespace
+			 * 1. Kernel QPs should be visible in init namspace only
+			 * 2. Present only QPs visible in the current namespace
 			 */
 			goto next;
 
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 351b6940f6dc17..857637bf46da27 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -150,9 +150,7 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 	if (!dev)
 		return;
 
-	down_read(&dev->res.rwsem);
 	rdma_restrack_put(res);
-	up_read(&dev->res.rwsem);
 
 	wait_for_completion(&res->comp);
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a98a3e8412f810..16ebc6372c31ab 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -849,6 +849,7 @@ static struct ib_qp *ib_create_xrc_qp(struct ib_qp *qp,
 
 	qp->event_handler = __ib_shared_qp_event_handler;
 	qp->qp_context = qp;
+	qp->pd = NULL;
 	qp->send_cq = qp->recv_cq = NULL;
 	qp->srq = NULL;
 	qp->xrcd = qp_init_attr->xrcd;
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 23bef401598208..17e59bec169ec0 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -237,14 +237,8 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_PORT_DEL,
 
 	RDMA_NLDEV_CMD_RES_GET, /* can dump */
-	RDMA_NLDEV_CMD_RES_SET,
-	RDMA_NLDEV_CMD_RES_NEW,
-	RDMA_NLDEV_CMD_RES_DEL,
 
 	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */
-	RDMA_NLDEV_CMD_RES_QP_SET,
-	RDMA_NLDEV_CMD_RES_QP_NEW,
-	RDMA_NLDEV_CMD_RES_QP_DEL,
 
 	RDMA_NLDEV_NUM_OPS
 };
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
