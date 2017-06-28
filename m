From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH resend] rxe: fix broken receive queue draining
Date: Wed, 28 Jun 2017 13:07:07 +0300
Message-ID: <20170628100707.GC1248@mtr-leonro.local>
References: <1498555178-12106-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sIsKpy5+/8vj5Foo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498555178-12106-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--sIsKpy5+/8vj5Foo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 27, 2017 at 12:19:38PM +0300, Sagi Grimberg wrote:
> From: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
>
> If we modified the qp to ERROR state, and
> drained the recieve queue, post_recv must
> trigger the responder task to complete
> the drain work request.
>
> Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_resp.c  | 3 +++
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 3 +++
>  2 files changed, 6 insertions(+)
>
It looks OK for me.

Moni ?

> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 23039768f541..f66b48c114ac 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -1217,6 +1217,9 @@ void rxe_drain_req_pkts(struct rxe_qp *qp, bool notify)
>  		kfree_skb(skb);
>  	}
>
> +	if (notify)
> +		return;
> +
>  	while (!qp->srq && qp->rq.queue && queue_head(qp->rq.queue))
>  		advance_consumer(qp->rq.queue);
>  }
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 83d709e74dfb..94af4d67988b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -919,6 +919,9 @@ static int rxe_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>
>  	spin_unlock_irqrestore(&rq->producer_lock, flags);
>
> +	if (qp->resp.state == QP_STATE_ERROR)
> +		rxe_run_task(&qp->resp.task, 1);
> +
>  err1:
>  	return err;
>  }
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sIsKpy5+/8vj5Foo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllTf8sACgkQ5GN7iDZy
WKey1xAAoWGZeqysFXs9ssTzxk9Zol17HqHfUDGD5PhdbXnv9UagRsXgh+bATaQR
d5Ju5jWxWX3V2wqCeziwFRkoFjzD2nxvrIL5uHU3slc3cJbZPgeIjbq28zcWpDh+
4pOML0yheYOsTWL0MccPVhUSWL/WHH9163wql8RA9n2+GsI45jIWTV2++X4iha/q
LNk6ToXX5l7zoKXBcLdWbPDSULQlh/qQ0i+/T0qbQZ84ENRmCszxlqP1d3UGicLb
yrs3TyPQ/CHPR82dKW5SEA+eMcvbFPmRrx27nfziKPxG0xORP+9e0viQynfN7oxr
sbbdVPWkN7RWzQiYdqTsQNOe+StfGveDH3GipfWoTVbXTiEVPqITrWq3ynwcp+V9
Dj4uiZkZmqdv2/sodXaAJr0bz8cyL5K13fRIIOvMYLBKuxdvQ3/AvqlEYJEC/Exq
prN+jygL8jBFdm2AKcZDM/mCsa/0Rd01WyvLMrPG6/Q2gBhUjKEFjtXCmckuuBR7
zbdD/L0RvBAmwH2qbaQjU6bpKUi3Kl/APr/49Zg7YvXGX2MG+Fg1u0mr5k27eiNH
UqHtw4Du+d5wgeRuKvPOPC2iqCm/lDyqtyAoTKrs9zZCplRpuxHbUbGmgmV3DB1y
YD3xfR37KzzoXyVrMW0vBPBC9J7V6GPjPByHZOyTtMkjsjlZrxE=
=chqV
-----END PGP SIGNATURE-----

--sIsKpy5+/8vj5Foo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
