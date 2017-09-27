From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1 for-next] IB/{ipoib,iser}: Consistent print format of
 vendor error
Date: Wed, 27 Sep 2017 12:53:45 +0000
Message-ID: <F3529576D8E232409F431C309E29399336CDB055@CRSMSX102.amr.corp.intel.com>
References: <20170926070458.7138-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926070458.7138-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Yuval Shaia' <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.cha>
Cc: Ajaykumar Hotchandani <ajaykumar.hotchandani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Vendor error print should be consistent across protocols to avoid any
> confusion.
> This patch corrects that.
> 
> Suggested-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ajaykumar Hotchandani <ajaykumar.hotchandani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Acked-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Acked-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> v0 -> v1:
> 	* Adjust to latest for-next (based on the accepted commit af3c79beff48
> 	  ("IB/ipoib: Suppress the retry related completion errors").
> 	* Accept Sagi Grimberg's comment re formatting (%#x).
> 	* Add Sagi Grimberg's and Roi Dayan's a-b
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c  | 10 +++++-----
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c  |  8 ++++----
>  drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 7774654c2ccb..64b784eca626 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -594,9 +594,9 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev,
> struct ib_wc *wc)
>  	skb = rx_ring[wr_id].skb;
> 
>  	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> -		ipoib_dbg(priv, "cm recv error "
> -			   "(status=%d, wrid=%d vend_err %x)\n",
> -			   wc->status, wr_id, wc->vendor_err);
> +		ipoib_dbg(priv,
> +			  "cm recv error (status=%d, wrid=%d vend_err 0x%#x)\n",
			                                                                               ^^^^^
Typo? Please use either '0x%x' or '%#x' .
The latter format was suggested by Sagi Grimberg earlier.
Thanks.
> +			  wc->status, wr_id, wc->vendor_err);
>  		++dev->stats.rx_dropped;
>  		if (has_srq)
>  			goto repost;
> @@ -829,11 +829,11 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev,
> struct ib_wc *wc)
>  		if (wc->status == IB_WC_RNR_RETRY_EXC_ERR ||
>  		    wc->status == IB_WC_RETRY_EXC_ERR)
>  			ipoib_dbg(priv,
> -				  "%s: failed cm send event (status=%d, wrid=%d
> vend_err 0x%x)\n",
> +				  "%s: failed cm send event (status=%d, wrid=%d
> vend_err 0x%#x)\n",
>  				   __func__, wc->status, wr_id, wc->vendor_err);
>  		else
>  			ipoib_warn(priv,
> -				    "%s: failed cm send event (status=%d, wrid=%d
> vend_err 0x%x)\n",
> +				    "%s: failed cm send event (status=%d, wrid=%d
> vend_err 0x%#x)\n",
>  				   __func__, wc->status, wr_id, wc->vendor_err);
> 
>  		spin_lock_irqsave(&priv->lock, flags);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 2e075377242e..4895a755c823 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -192,8 +192,8 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev,
> struct ib_wc *wc)
> 
>  	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>  		if (wc->status != IB_WC_WR_FLUSH_ERR)
> -			ipoib_warn(priv, "failed recv event "
> -				   "(status=%d, wrid=%d vend_err %x)\n",
> +			ipoib_warn(priv,
> +				   "failed recv event (status=%d, wrid=%d vend_err
> 0x%#x)\n",

Same here (please see above comment)

>  				   wc->status, wr_id, wc->vendor_err);
>  		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[wr_id].mapping);
>  		dev_kfree_skb_any(skb);
> @@ -414,8 +414,8 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev,
> struct ib_wc *wc)
>  	if (wc->status != IB_WC_SUCCESS &&
>  	    wc->status != IB_WC_WR_FLUSH_ERR) {
>  		struct ipoib_qp_state_validate *qp_work;
> -		ipoib_warn(priv, "failed send event "
> -			   "(status=%d, wrid=%d vend_err %x)\n",
> +		ipoib_warn(priv,
> +			   "failed send event (status=%d, wrid=%d vend_err
> 0x%#x)\n",

Same here (please see above comment)

>  			   wc->status, wr_id, wc->vendor_err);
>  		qp_work = kzalloc(sizeof(*qp_work), GFP_ATOMIC);
>  		if (!qp_work)
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c
> b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 55a73b0ed4c6..f4524761b7bb 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -1146,7 +1146,7 @@ void iser_err_comp(struct ib_wc *wc, const char *type)
>  	if (wc->status != IB_WC_WR_FLUSH_ERR) {
>  		struct iser_conn *iser_conn = to_iser_conn(wc->qp->qp_context);
> 
> -		iser_err("%s failure: %s (%d) vend_err %x\n", type,
> +		iser_err("%s failure: %s (%d) vend_err 0x%#x\n", type,

Same here (please see above comment)

>  			 ib_wc_status_msg(wc->status), wc->status,
>  			 wc->vendor_err);
> 
> --
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
