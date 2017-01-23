From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] qedr: remove CQ spinlock from RDMA CM completion
 handlers
Date: Mon, 23 Jan 2017 21:13:13 +0200
Message-ID: <20170123191313.GB6005@mtr-leonro.local>
References: <1485185187-18689-1-git-send-email-Ram.Amrani@qlogic.com>
 <1485185187-18689-4-git-send-email-Ram.Amrani@qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485185187-18689-4-git-send-email-Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 23, 2017 at 05:26:25PM +0200, Ram Amrani wrote:
> From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>
> There is only a single event queue that triggers the completion
> events for the RDMA CM and it is being processed serially. This means
> that inherently there can no parallelism of CQ completion handler.
> Hence the lock is redundant.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/qedr/qedr_cm.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Don't you need to remove this lock from struct qedr_cq too?

>
> diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
> index 63890eb..00361f3 100644
> --- a/drivers/infiniband/hw/qedr/qedr_cm.c
> +++ b/drivers/infiniband/hw/qedr/qedr_cm.c
> @@ -87,11 +87,8 @@ void qedr_ll2_tx_cb(void *_qdev, struct qed_roce_ll2_packet *pkt)
>  	qedr_inc_sw_gsi_cons(&qp->sq);
>  	spin_unlock_irqrestore(&qp->q_lock, flags);
>
> -	if (cq->ibcq.comp_handler) {
> -		spin_lock_irqsave(&cq->comp_handler_lock, flags);
> +	if (cq->ibcq.comp_handler)
>  		(*cq->ibcq.comp_handler) (&cq->ibcq, cq->ibcq.cq_context);
> -		spin_unlock_irqrestore(&cq->comp_handler_lock, flags);
> -	}
>  }
>
>  void qedr_ll2_rx_cb(void *_dev, struct qed_roce_ll2_packet *pkt,
> @@ -113,11 +110,8 @@ void qedr_ll2_rx_cb(void *_dev, struct qed_roce_ll2_packet *pkt,
>
>  	spin_unlock_irqrestore(&qp->q_lock, flags);
>
> -	if (cq->ibcq.comp_handler) {
> -		spin_lock_irqsave(&cq->comp_handler_lock, flags);
> +	if (cq->ibcq.comp_handler)
>  		(*cq->ibcq.comp_handler) (&cq->ibcq, cq->ibcq.cq_context);
> -		spin_unlock_irqrestore(&cq->comp_handler_lock, flags);
> -	}
>  }
>
>  static void qedr_destroy_gsi_cq(struct qedr_dev *dev,
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliGVckACgkQ5GN7iDZy
WKf6YQ//f8XZlcjvtdaYF2XpN9CRVqqbcZphA2iYj7GEZNPRa/bxlOy/SalJGnFS
vPRc/hLRDSQb5Q0xd497dxMduzPRzo4Lho1E89FXz22oyPPDo0s6kDcP3prhj4m1
LGpSaX10c2K56ySy4LPKoSCYhJBgZHjX6zIJRVWGle6foNu/YSJTyw3DvyYu9t8U
cnPrEY+cJ8OaXbDes0eRCNGVcaK+8XAy99+OaXD/N84kvxCcBveq8ZGIlIc3ua3k
Sjlaq5+WtGX/F7UyfWDCQ7HL1ZwwORXCuOk2J7zmJ8b1Nm1vjHt4AEPfqO0pmyBt
sjzT/JwjHi0aZjSdKsdaXnVjXYg63+8cW4ARuROfLQIOeGq2aGJenDatvqDQRpVZ
eq0mswNBvVRUKJk1n3B9/1ievJ7GlDJ7rvkXnTWqqBf9p1oHJlqMhTffIiIRFzxH
HAcupnKA1VoiIs9/fs7czumOCOTB8ayZAKjyM6U3EhyqolhCj0BtUtIAk1bBaTUf
7tHKiOVFyKExAP1BdDt7BIzkdPaZkLLySylPYSj+m2ZuzcKNo9BEj2bTYGgT7tPU
aK9PvjheyCXnnoFNPGXEinKtIu0YDiE5fTC9MVk8qzZNEZgZ8livHVJNX3OotB/e
yyhxNX/NLDTipze4wpn2bkSyl3eXiy66PmBJ3cjShbraky6onQs=
=ad+v
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
