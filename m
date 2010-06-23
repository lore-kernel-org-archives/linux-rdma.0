From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 1/3] RDMA/cxgb4: derive smac_idx from port viid.
Date: Wed, 23 Jun 2010 10:07:59 -0500
Message-ID: <4C22234F.4020500@opengridcomputing.com>
References: <20100623150055.22155.17833.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100623150055.22155.17833.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

Please ignore these 3 patches.  I forgot to run checkpatch on them and 
they need some cleanup.

I'll re-submit as "v2" of the series.

Sorry for the noise.

Steve.


Steve Wise wrote:
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>
>  drivers/infiniband/hw/cxgb4/cm.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f75108f..8c9b483 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -1373,7 +1373,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
>  				    pdev, 0);
>  		mtu = pdev->mtu;
>  		tx_chan = cxgb4_port_chan(pdev);
> -		smac_idx = tx_chan << 1;
> +		smac_idx = (cxgb4_port_viid(pdev) & 0x7F) << 1;
>  		step = dev->rdev.lldi.ntxq / dev->rdev.lldi.nchan;
>  		txq_idx = cxgb4_port_idx(pdev) * step;
>  		step = dev->rdev.lldi.nrxq / dev->rdev.lldi.nchan;
> @@ -1384,7 +1384,7 @@ static int pass_accept_req(struct c4iw_dev *dev, struct sk_buff *skb)
>  					dst->neighbour->dev, 0);
>  		mtu = dst_mtu(dst);
>  		tx_chan = cxgb4_port_chan(dst->neighbour->dev);
> -		smac_idx = tx_chan << 1;
> +		smac_idx = (cxgb4_port_viid(dst->neighbour->dev) & 0x7F) << 1;
>  		step = dev->rdev.lldi.ntxq / dev->rdev.lldi.nchan;
>  		txq_idx = cxgb4_port_idx(dst->neighbour->dev) * step;
>  		step = dev->rdev.lldi.nrxq / dev->rdev.lldi.nchan;
> @@ -1951,7 +1951,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>  					pdev, 0);
>  		ep->mtu = pdev->mtu;
>  		ep->tx_chan = cxgb4_port_chan(pdev);
> -		ep->smac_idx = ep->tx_chan << 1;
> +		ep->smac_idx = (cxgb4_port_viid(pdev) & 0x7F) << 1;
>  		step = ep->com.dev->rdev.lldi.ntxq /
>  		       ep->com.dev->rdev.lldi.nchan;
>  		ep->txq_idx = cxgb4_port_idx(pdev) * step;
> @@ -1966,7 +1966,8 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>  					ep->dst->neighbour->dev, 0);
>  		ep->mtu = dst_mtu(ep->dst);
>  		ep->tx_chan = cxgb4_port_chan(ep->dst->neighbour->dev);
> -		ep->smac_idx = ep->tx_chan << 1;
> +		ep->smac_idx = (cxgb4_port_viid(ep->dst->neighbour->dev) &
> +				0x7F) << 1;
>  		step = ep->com.dev->rdev.lldi.ntxq /
>  		       ep->com.dev->rdev.lldi.nchan;
>  		ep->txq_idx = cxgb4_port_idx(ep->dst->neighbour->dev) * step;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
