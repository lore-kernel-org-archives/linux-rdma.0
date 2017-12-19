From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 for-rc 5/8] RDMA/vmw_pvrdma: Use refcount_t instead of
 atomic_t
Date: Tue, 19 Dec 2017 07:32:01 +0200
Message-ID: <20171219053201.GG18894@mtr-leonro.local>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171214002402.GA16082@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214002402.GA16082-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 13, 2017 at 04:24:12PM -0800, Bryan Tan wrote:
> refcount_t is the preferred type for refcounts. Change the
> QP and CQ refcnt fields to use refcount_t.
>
> Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  4 ++--
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c   |  6 +++---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 15 ++++++---------
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   |  6 +++---
>  4 files changed, 14 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> index 63bc2ef..07d287e 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> @@ -93,7 +93,7 @@ struct pvrdma_cq {
>  	struct pvrdma_page_dir pdir;
>  	u32 cq_handle;
>  	bool is_kernel;
> -	atomic_t refcnt;
> +	refcount_t refcnt;
>  	wait_queue_head_t wait;
>  };
>
> @@ -196,7 +196,7 @@ struct pvrdma_qp {
>  	u8 state;
>  	bool is_kernel;
>  	struct mutex mutex; /* QP state mutex. */
> -	atomic_t refcnt;
> +	refcount_t refcnt;
>  	wait_queue_head_t wait;
>  };
>
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index ea8db5e6..9dba949 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -177,7 +177,7 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
>  	else
>  		pvrdma_page_dir_insert_umem(&cq->pdir, cq->umem, 0);
>
> -	atomic_set(&cq->refcnt, 1);
> +	refcount_set(&cq->refcnt, 1);
>  	init_waitqueue_head(&cq->wait);
>  	spin_lock_init(&cq->cq_lock);
>
> @@ -229,8 +229,8 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
>
>  static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq *cq)
>  {
> -	atomic_dec(&cq->refcnt);
> -	wait_event(cq->wait, !atomic_read(&cq->refcnt));
> +	if (!refcount_dec_and_test(&cq->refcnt))
> +		wait_event(cq->wait, !refcount_read(&cq->refcnt));

Don't you suppose to call to wait_event without condition on refcnt and
sleep till refcnt == 0??

>
>  	if (!cq->is_kernel)
>  		ib_umem_release(cq->umem);
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> index 941e324..5cff9fa 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> @@ -333,7 +333,7 @@ static void pvrdma_qp_event(struct pvrdma_dev *dev, u32 qpn, int type)
>  	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
>  	qp = dev->qp_tbl[qpn % dev->dsr->caps.max_qp];
>  	if (qp)
> -		atomic_inc(&qp->refcnt);
> +		refcount_inc(&qp->refcnt);
>  	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
>
>  	if (qp && qp->ibqp.event_handler) {
> @@ -346,8 +346,7 @@ static void pvrdma_qp_event(struct pvrdma_dev *dev, u32 qpn, int type)
>  		ibqp->event_handler(&e, ibqp->qp_context);
>  	}
>  	if (qp) {
> -		atomic_dec(&qp->refcnt);
> -		if (atomic_read(&qp->refcnt) == 0)
> +		if (refcount_dec_and_test(&qp->refcnt))
>  			wake_up(&qp->wait);
>  	}
>  }
> @@ -360,7 +359,7 @@ static void pvrdma_cq_event(struct pvrdma_dev *dev, u32 cqn, int type)
>  	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
>  	cq = dev->cq_tbl[cqn % dev->dsr->caps.max_cq];
>  	if (cq)
> -		atomic_inc(&cq->refcnt);
> +		refcount_inc(&cq->refcnt);
>  	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
>
>  	if (cq && cq->ibcq.event_handler) {
> @@ -373,8 +372,7 @@ static void pvrdma_cq_event(struct pvrdma_dev *dev, u32 cqn, int type)
>  		ibcq->event_handler(&e, ibcq->cq_context);
>  	}
>  	if (cq) {
> -		atomic_dec(&cq->refcnt);
> -		if (atomic_read(&cq->refcnt) == 0)
> +		if (refcount_dec_and_test(&cq->refcnt))
>  			wake_up(&cq->wait);
>  	}
>  }
> @@ -533,14 +531,13 @@ static irqreturn_t pvrdma_intrx_handler(int irq, void *dev_id)
>  		spin_lock_irqsave(&dev->cq_tbl_lock, flags);
>  		cq = dev->cq_tbl[cqne->info % dev->dsr->caps.max_cq];
>  		if (cq)
> -			atomic_inc(&cq->refcnt);
> +			refcount_inc(&cq->refcnt);
>  		spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
>
>  		if (cq && cq->ibcq.comp_handler)
>  			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
>  		if (cq) {
> -			atomic_dec(&cq->refcnt);
> -			if (atomic_read(&cq->refcnt))
> +			if (refcount_dec_and_test(&cq->refcnt))
>  				wake_up(&cq->wait);
>  		}
>  		pvrdma_idx_ring_inc(&ring->cons_head, ring_slots);
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> index 77e7e57..9745cb1 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> @@ -245,7 +245,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
>  		spin_lock_init(&qp->sq.lock);
>  		spin_lock_init(&qp->rq.lock);
>  		mutex_init(&qp->mutex);
> -		atomic_set(&qp->refcnt, 1);
> +		refcount_set(&qp->refcnt, 1);
>  		init_waitqueue_head(&qp->wait);
>
>  		qp->state = IB_QPS_RESET;
> @@ -427,8 +427,8 @@ static void pvrdma_free_qp(struct pvrdma_qp *qp)
>
>  	pvrdma_unlock_cqs(scq, rcq, &scq_flags, &rcq_flags);
>
> -	atomic_dec(&qp->refcnt);
> -	wait_event(qp->wait, !atomic_read(&qp->refcnt));
> +	if (!refcount_dec_and_test(&qp->refcnt))
> +		wait_event(qp->wait, !refcount_read(&qp->refcnt));
>
>  	if (!qp->is_kernel) {
>  		if (qp->rumem)
> --
> 1.8.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo4pFEACgkQ5GN7iDZy
WKcyuQ//ToUhCzlYJkC407kma26b+VhdsBwaUSqwQhOL5YPJIogyXCgiiKezcE2F
OaK+CH7f8hPcTRCeumB6+XiArC3isaU5+iVvy7VxjvEQE2nKQLfinYoYtZYV2XPj
y+BA0ZBIohESgnYol4RUt337qeMx2XlpZmOX3drTsWEKdasLsNHzzdXqLGtfgBsv
xn6ah7+cEc9joZwwZFkG1w9pNxkxsPiEt5A8Br4MwcQHWn9qxm7bx+eolP4XeEPt
QjgKnsouzA12fEAG7I1pV04nBqrspHfrl/kE/gutufo92lPUYWN5uXZt/6cuEWB7
Y6bwiKLWIdCjKscYpyVE1Yf8yJv8FiSvhPwqAMUkwxh7FkFaEQbUAvNJEIGZiLl5
v2IXojBOZWPC2uMybYutCm0yBHmROyXwe9Ps47RdF0j6iK0Jr5giwmib6pdDlsbV
ac2qhLojrFi9sPlXARsgE6BEPuvBKbLdBzQmWnt26D2gWsHB1cltAVgaRjj9dL4v
GJmZBR9qKQBpwzJuwFsCEmqSRLy3LGyEUkugRwXmV3PEXgzALbGiNh3CGRgRZAMF
T5zpuCaUDxu0971D2p56Ld83QxTn3VdG1V9DBHvmeck24lUKqV4LomcTFWBXc2Ca
cb4UFhA3XKZJl2M07RHPan+tK9zhr5NT5y6aNbUi40twf8g3Q1E=
=oz3M
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
