From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] qedr: Fix possible memory leak in qedr_create_qp()
Date: Mon, 31 Oct 2016 07:33:18 +0200
Message-ID: <20161031053318.GU3617@leon.nu>
References: <1477672427-31575-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6wUvnnXCCq76soZt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477672427-31575-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--6wUvnnXCCq76soZt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2016 at 04:33:47PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> 'qp' is malloced in qedr_create_qp() and should be freed before leaving
> from the error handling cases, otherwise it will cause memory leak.
>
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>


Hi Ram,

While looking on this patch and associated code to it, I noticed the
following code stack:

qedr_create_qp
	-->
	dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
		-->
		qed_rdma_destroy_qp
			-->
			qed_roce_destroy_qp
This function will check the QP state and return -INVAL and comment
that this QP needs to be prepared before destroying it.

However immediately after returning, you are calling to kfree(qp)
without any checks.

It looks like an error and it is worth to take a look on it.

And did I miss the fix to memory leak posted during code review?

Thanks

> ---
>  drivers/infiniband/hw/qedr/verbs.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
> index a615142..b60f145 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -1477,6 +1477,7 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
>  	struct qedr_ucontext *ctx = NULL;
>  	struct qedr_create_qp_ureq ureq;
>  	struct qedr_qp *qp;
> +	struct ib_qp *ibqp;
>  	int rc = 0;
>
>  	DP_DEBUG(dev, QEDR_MSG_QP, "create qp: called from %s, pd=%p\n",
> @@ -1486,13 +1487,13 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
>  	if (rc)
>  		return ERR_PTR(rc);
>
> +	if (attrs->srq)
> +		return ERR_PTR(-EINVAL);
> +
>  	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
>  	if (!qp)
>  		return ERR_PTR(-ENOMEM);
>
> -	if (attrs->srq)
> -		return ERR_PTR(-EINVAL);
> -
>  	DP_DEBUG(dev, QEDR_MSG_QP,
>  		 "create qp: sq_cq=%p, sq_icid=%d, rq_cq=%p, rq_icid=%d\n",
>  		 get_qedr_cq(attrs->send_cq),
> @@ -1508,7 +1509,10 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
>  			       "create qp: unexpected udata when creating GSI QP\n");
>  			goto err0;
>  		}
> -		return qedr_create_gsi_qp(dev, attrs, qp);
> +		ibqp = qedr_create_gsi_qp(dev, attrs, qp);
> +		if (IS_ERR(ibqp))
> +			kfree(qp);
> +		return ibqp;
>  	}
>
>  	memset(&in_params, 0, sizeof(in_params));
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--6wUvnnXCCq76soZt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFteeAAoJEORje4g2clinZbQP/3mgPgC1VJczcEmpBgLfqAol
QkSF60jQHeDQN/caUUaXVKZ8CcQ/rPp9GJdCmpyqVKRnnMf7ExXitziBGZzG6cMG
GvmyhhsLnHOzDxYICg1bUGsa++o6QJuTQ3WVjcy/VX5XIolDQ8AlQDqCP7oHrVbb
NDpz9rfHMitB7ZPTbxjb4IoqPtBXIZI3EMBRrNuEz2+JyhtFYgj6acXy6Wr6EClr
kZcJMi2v9vSFMT2XCUaqyQFcSc2eVJ96QC2by/YNGuImnauZnOWrICvrVl76rT3c
KFf+UFQial3AMdHKxdaOApFeY06oAwqpvpZ71NbyYgYGva+SsmKNi2X+klHIe09v
g5pUFlQoLQlwqf263ua06U4sNyKw+uiA/CeHjvlaTH0IzDgyisfq+lJv40aF0OhQ
aIP+mmB3afGc/ZZbyvaBYL9iG7aBOWZKO3PIKXvBi0Ex+c6Vi0doIPn+r3k8JjDx
YDyNvlLN2SkvIsjSPQqzwVKul26KbjXJkcWkqADceOMXjzPGzlqHjwFgbowgClGJ
78jMx80w8cYMD+kDDuituk1zCcIRKMmEXvvIvmgcjPerWWbXa0d5cKYLYHnVwIwt
VJu1BIdNEqQkIPzcsHbc+ugxFaziaNNbJfDCXmLtYGeS7rcCxNQWMQIqOJg7U5W8
VoHz1hFeNHLSYR8CCtAU
=3SBf
-----END PGP SIGNATURE-----

--6wUvnnXCCq76soZt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
