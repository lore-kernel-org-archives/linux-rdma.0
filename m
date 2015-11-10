From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Tue, 10 Nov 2015 05:41:47 -0800
Message-ID: <20151110134147.GA12814@infradead.org>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
 <1447156270.7089.3.camel@opteya.com>
 <5641E4C9.7000206@talpey.com>
 <5641E644.7080101@mellanox.com>
 <20151110130648.GA10682@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110130648.GA10682-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

FYI, this is the API I'd aim for (only SRP and no HW driver converted
yet):

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 0e21367..7ea695c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1484,14 +1484,15 @@ EXPORT_SYMBOL(ib_check_mr_status);
 int ib_map_mr_sg(struct ib_mr *mr,
 		 struct scatterlist *sg,
 		 int sg_nents,
-		 unsigned int page_size)
+		 unsigned int page_size,
+		 unsigned int flags)
 {
 	if (unlikely(!mr->device->map_mr_sg))
 		return -ENOSYS;
 
 	mr->page_size = page_size;
 
-	return mr->device->map_mr_sg(mr, sg, sg_nents);
+	return mr->device->map_mr_sg(mr, sg, sg_nents, flags);
 }
 EXPORT_SYMBOL(ib_map_mr_sg);
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 62b6cba..d77a5b4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1314,7 +1314,6 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	struct srp_target_port *target = ch->target;
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct ib_send_wr *bad_wr;
-	struct ib_reg_wr wr;
 	struct srp_fr_desc *desc;
 	u32 rkey;
 	int n, err;
@@ -1342,20 +1341,17 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	ib_update_fast_reg_key(desc->mr, rkey);
 
 	n = ib_map_mr_sg(desc->mr, state->sg, state->sg_nents,
-			 dev->mr_page_size);
+			 dev->mr_page_size,
+			 /*
+			  * XXX: add a bool write argument to this function,
+			  * so that we only need to open up the required
+			  * permissions.
+			  */
+			 IB_MR_REMOTE | IB_MR_RDMA_READ | IB_MR_RDMA_WRITE);
 	if (unlikely(n < 0))
 		return n;
 
-	wr.wr.next = NULL;
-	wr.wr.opcode = IB_WR_REG_MR;
-	wr.wr.wr_id = FAST_REG_WR_ID_MASK;
-	wr.wr.num_sge = 0;
-	wr.wr.send_flags = 0;
-	wr.mr = desc->mr;
-	wr.key = desc->mr->rkey;
-	wr.access = (IB_ACCESS_LOCAL_WRITE |
-		     IB_ACCESS_REMOTE_READ |
-		     IB_ACCESS_REMOTE_WRITE);
+	desc->mr->wr.wr_id = FAST_REG_WR_ID_MASK;
 
 	*state->fr.next++ = desc;
 	state->nmdesc++;
@@ -1363,7 +1359,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	srp_map_desc(state, desc->mr->iova,
 		     desc->mr->length, desc->mr->rkey);
 
-	err = ib_post_send(ch->qp, &wr.wr, &bad_wr);
+	err = ib_post_send(ch->qp, &desc->mr->wr, &bad_wr);
 	if (unlikely(err))
 		return err;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 83d6ee8..b168b3a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1105,18 +1105,6 @@ static inline struct ib_ud_wr *ud_wr(struct ib_send_wr *wr)
 	return container_of(wr, struct ib_ud_wr, wr);
 }
 
-struct ib_reg_wr {
-	struct ib_send_wr	wr;
-	struct ib_mr		*mr;
-	u32			key;
-	int			access;
-};
-
-static inline struct ib_reg_wr *reg_wr(struct ib_send_wr *wr)
-{
-	return container_of(wr, struct ib_reg_wr, wr);
-}
-
 struct ib_bind_mw_wr {
 	struct ib_send_wr	wr;
 	struct ib_mw		*mw;
@@ -1314,7 +1302,18 @@ struct ib_qp {
 	enum ib_qp_type		qp_type;
 };
 
+enum ib_mr_flags {
+	/* scope: either remote or local */
+	IB_MR_REMOTE,
+	IB_MR_LOCAL,
+
+	/* direction: one or both can be ORed into the scope above */
+	IB_MR_RDMA_READ		= (1 << 10),
+	IB_MR_RDMA_WRITE	= (1 << 11)
+};
+
 struct ib_mr {
+	struct ib_send_wr  wr;
 	struct ib_device  *device;
 	struct ib_pd	  *pd;
 	struct ib_uobject *uobject;
@@ -1326,6 +1325,11 @@ struct ib_mr {
 	atomic_t	   usecnt; /* count number of MWs */
 };
 
+static inline struct ib_mr *wr_to_mr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_mr, wr);
+}
+
 struct ib_mw {
 	struct ib_device	*device;
 	struct ib_pd		*pd;
@@ -1706,7 +1710,8 @@ struct ib_device {
 					       u32 max_num_sg);
 	int                        (*map_mr_sg)(struct ib_mr *mr,
 						struct scatterlist *sg,
-						int sg_nents);
+						int sg_nents,
+						unsigned int flags);
 	int                        (*rereg_phys_mr)(struct ib_mr *mr,
 						    int mr_rereg_mask,
 						    struct ib_pd *pd,
@@ -3022,17 +3027,19 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev, u8 port,
 int ib_map_mr_sg(struct ib_mr *mr,
 		 struct scatterlist *sg,
 		 int sg_nents,
-		 unsigned int page_size);
+		 unsigned int page_size,
+		 unsigned int flags);
 
 static inline int
 ib_map_mr_sg_zbva(struct ib_mr *mr,
 		  struct scatterlist *sg,
 		  int sg_nents,
-		  unsigned int page_size)
+		  unsigned int page_size,
+		  unsigned int flags)
 {
 	int n;
 
-	n = ib_map_mr_sg(mr, sg, sg_nents, page_size);
+	n = ib_map_mr_sg(mr, sg, sg_nents, page_size, flags);
 	mr->iova = 0;
 
 	return n;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
