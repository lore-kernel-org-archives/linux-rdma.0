From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/{ipoib,iser}: Consistent print format of vendor error
Date: Tue, 26 Sep 2017 10:06:08 +0300
Message-ID: <20170926070608.GB5825@yuvallap>
References: <20170905150919.12631-1-yuval.shaia@oracle.com>
 <a88fddbb-cbf7-33b3-45de-c25900a8bd9b@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a88fddbb-cbf7-33b3-45de-c25900a8bd9b-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ajaykumar Hotchandani <ajaykumar.hotchandani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 06, 2017 at 07:21:48AM +0300, Roi Dayan wrote:
> 
> 
> On 05/09/2017 18:09, Yuval Shaia wrote:
> > Vendor error print should be consistent across protocols to avoid any
> > confusion.
> > This patch corrects that.
> > 
> > Suggested-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Ajaykumar Hotchandani <ajaykumar.hotchandani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Acked-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >   drivers/infiniband/ulp/ipoib/ipoib_cm.c  | 10 +++++-----
> >   drivers/infiniband/ulp/ipoib/ipoib_ib.c  |  8 ++++----
> >   drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
> >   3 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > index 14b62f7472b4..fd302ba78869 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> > @@ -594,9 +594,9 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
> >   	skb = rx_ring[wr_id].skb;
> >   	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> > -		ipoib_dbg(priv, "cm recv error "
> > -			   "(status=%d, wrid=%d vend_err %x)\n",
> > -			   wc->status, wr_id, wc->vendor_err);
> > +		ipoib_dbg(priv,
> > +			  "cm recv error (status=%d, wrid=%d vend_err 0x%x)\n",
> > +			  wc->status, wr_id, wc->vendor_err);
> >   		++dev->stats.rx_dropped;
> >   		if (has_srq)
> >   			goto repost;
> > @@ -824,10 +824,10 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
> >   		struct ipoib_neigh *neigh;
> >   		if (wc->status != IB_WC_RNR_RETRY_EXC_ERR)
> > -			ipoib_warn(priv, "failed cm send event (status=%d, wrid=%d vend_err %x)\n",
> > +			ipoib_warn(priv, "failed cm send event (status=%d, wrid=%d vend_err 0x%x)\n",
> >   				   wc->status, wr_id, wc->vendor_err);
> >   		else
> > -			ipoib_dbg(priv, "failed cm send event (status=%d, wrid=%d vend_err %x)\n",
> > +			ipoib_dbg(priv, "failed cm send event (status=%d, wrid=%d vend_err 0x%x)\n",
> >   				  wc->status, wr_id, wc->vendor_err);
> >   		spin_lock_irqsave(&priv->lock, flags);
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > index 2e075377242e..eb62f9d29103 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> > @@ -192,8 +192,8 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
> >   	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> >   		if (wc->status != IB_WC_WR_FLUSH_ERR)
> > -			ipoib_warn(priv, "failed recv event "
> > -				   "(status=%d, wrid=%d vend_err %x)\n",
> > +			ipoib_warn(priv,
> > +				   "failed recv event (status=%d, wrid=%d vend_err 0x%x)\n",
> >   				   wc->status, wr_id, wc->vendor_err);
> >   		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[wr_id].mapping);
> >   		dev_kfree_skb_any(skb);
> > @@ -414,8 +414,8 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
> >   	if (wc->status != IB_WC_SUCCESS &&
> >   	    wc->status != IB_WC_WR_FLUSH_ERR) {
> >   		struct ipoib_qp_state_validate *qp_work;
> > -		ipoib_warn(priv, "failed send event "
> > -			   "(status=%d, wrid=%d vend_err %x)\n",
> > +		ipoib_warn(priv,
> > +			   "failed send event (status=%d, wrid=%d vend_err 0x%x)\n",
> >   			   wc->status, wr_id, wc->vendor_err);
> >   		qp_work = kzalloc(sizeof(*qp_work), GFP_ATOMIC);
> >   		if (!qp_work)
> > diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> > index 55a73b0ed4c6..fe58abcf65a2 100644
> > --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> > +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> > @@ -1146,7 +1146,7 @@ void iser_err_comp(struct ib_wc *wc, const char *type)
> >   	if (wc->status != IB_WC_WR_FLUSH_ERR) {
> >   		struct iser_conn *iser_conn = to_iser_conn(wc->qp->qp_context);
> > -		iser_err("%s failure: %s (%d) vend_err %x\n", type,
> > +		iser_err("%s failure: %s (%d) vend_err 0x%x\n", type,
> >   			 ib_wc_status_msg(wc->status), wc->status,
> >   			 wc->vendor_err);
> > 
> 
> Acked-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks,
Will appreciate your review for v1 as well.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
