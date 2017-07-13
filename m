From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Thu, 13 Jul 2017 12:37:37 -0600
Message-ID: <20170713183737.GF11069@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170713075116.GA11233@infradead.org>
 <20170713172035.GB11069@obsidianresearch.com>
 <1499968325.2740.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499968325.2740.12.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 05:52:06PM +0000, Bart Van Assche wrote:
> On Thu, 2017-07-13 at 11:20 -0600, Jason Gunthorpe wrote:
> > On Thu, Jul 13, 2017 at 12:51:16AM -0700, Christoph Hellwig wrote:
> > > >  			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
> > > > -				wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> > > > -						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> > > > -						(get_cqe_l3_hdr_type(cqe) ==
> > > > -						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> > > > -						IBV_WC_IP_CSUM_OK_SHIFT;
> > > > +				wc->wc_flags |=
> > > > +				    ((bool)(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> > > > +				     (bool)(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> > > > +				     (get_cqe_l3_hdr_type(cqe) ==
> > > > +				      MLX5_CQE_L3_HDR_TYPE_IPV4))
> > > > +				    << IBV_WC_IP_CSUM_OK_SHIFT;
> > > 
> > > Meh.  This code is complete crap.  Please factor it out into a little
> > > helper that mere humans can read first.  And then replace the odd ^ used
> > > as && with proper if constructs and all should make much more sense.
> > 
> > As far as I could make out, this ugly thing is designed like this for
> > performance.
> 
> Hello Jason,
> 
> How about using an expression like the below to avoid that branches get inserted
> for testing the MLX5_CQE_L4_OK and MLX5_CQE_L3_OK flags?
> 
> (cqe->hds_ip_ext & (MLX5_CQE_L4_OK | MLX5_CQE_L3_OK)) == MLX5_CQE_L4_OK | MLX5_CQE_L3_OK

Yes, thanks, that seems a reasonable middle ground:

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index b845127de937d0..0a6274e6878d3c 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -182,6 +182,15 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 	return err;
 }
 
+/* Returns IBV_WC_IP_CSUM_OK or 0 */
+static inline int get_csum_ok(struct mlx5_cqe64 *cqe)
+{
+	return (((cqe->hds_ip_ext & (MLX5_CQE_L4_OK | MLX5_CQE_L3_OK)) ==
+		 (MLX5_CQE_L4_OK | MLX5_CQE_L3_OK)) &
+		(get_cqe_l3_hdr_type(cqe) == MLX5_CQE_L3_HDR_TYPE_IPV4))
+	       << IBV_WC_IP_CSUM_OK_SHIFT;
+}
+
 static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 				   struct mlx5_resource *cur_rsc, struct mlx5_srq *srq)
 {
@@ -206,12 +215,7 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		if (likely(cur_rsc->type == MLX5_RSC_TYPE_QP)) {
 			wq = &qp->rq;
 			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
-				wc->wc_flags |=
-				    ((bool)(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
-				     (bool)(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
-				     (get_cqe_l3_hdr_type(cqe) ==
-				      MLX5_CQE_L3_HDR_TYPE_IPV4))
-				    << IBV_WC_IP_CSUM_OK_SHIFT;
+				wc->wc_flags |= get_csum_ok(cqe);
 		} else {
 			wq = &(rsc_to_mrwq(cur_rsc)->rq);
 		}
@@ -1106,11 +1110,7 @@ static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 	int wc_flags = 0;
 
 	if (cq->flags & MLX5_CQ_FLAGS_RX_CSUM_VALID)
-		wc_flags = ((bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
-			    (bool)(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
-			    (get_cqe_l3_hdr_type(cq->cqe64) ==
-			     MLX5_CQE_L3_HDR_TYPE_IPV4))
-			   << IBV_WC_IP_CSUM_OK_SHIFT;
+		wc_flags = get_csum_ok(cq->cqe64);
 
 	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
 	case MLX5_CQE_RESP_WR_IMM:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
