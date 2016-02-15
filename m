From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB: new common API for draining queues
Date: Mon, 15 Feb 2016 16:05:44 -0500
Message-ID: <56C23DA8.40905@redhat.com>
References: <cover.1455230646.git.swise@chelsio.com>
 <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ux9q98hlM34M7PHbkTQRLhQnEJFHxRieh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ux9q98hlM34M7PHbkTQRLhQnEJFHxRieh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/05/2016 04:13 PM, Steve Wise wrote:
> From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>
>=20
> Add provider-specific drain_sq/drain_rq functions for providers needing=

> special drain logic.
>=20
> Add static functions __ib_drain_sq() and __ib_drain_rq() which post noo=
p
> WRs to the SQ or RQ and block until their completions are processed.
> This ensures the applications completions have all been processed.

Except it doesn't, comments inline below...and applications is
possessive, so needs a '

> Add API functions ib_drain_sq(), ib_drain_rq(), and ib_drain_qp().
>=20
> Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c | 144 ++++++++++++++++++++++++++++++++=
++++++++
>  include/rdma/ib_verbs.h         |   5 ++
>  2 files changed, 149 insertions(+)
>=20
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/=
verbs.c
> index 5af6d02..aed521e 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1657,3 +1657,147 @@ next_page:
>  	return i;
>  }
>  EXPORT_SYMBOL(ib_sg_to_pages);
> +
> +struct ib_drain_cqe {
> +	struct ib_cqe cqe;
> +	struct completion done;
> +};
> +
> +static void ib_drain_qp_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct ib_drain_cqe *cqe =3D container_of(wc->wr_cqe, struct ib_drain=
_cqe,
> +						cqe);
> +
> +	complete(&cqe->done);
> +}
> +
> +static void wait_for_drain(struct ib_cq *cq, struct completion *c)
> +{
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT)
> +		do
> +			ib_process_cq_direct(cq, 1024);
> +		while (!wait_for_completion_timeout(c, msecs_to_jiffies(100)));
> +	else
> +		wait_for_completion(c);
> +}
> +
> +/*
> + * Post a WR and block until its completion is reaped for the SQ.
> + */
> +static void __ib_drain_sq(struct ib_qp *qp)
> +{
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct ib_drain_cqe sdrain;
> +	struct ib_send_wr swr =3D {}, *bad_swr;
> +	int ret;
> +
> +	swr.wr_cqe =3D &sdrain.cqe;
> +	sdrain.cqe.done =3D ib_drain_qp_done;
> +	init_completion(&sdrain.done);
> +
> +	ret =3D ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> +		return;
> +	}

Set QP to ERR state...OK...

> +	ret =3D ib_post_send(qp, &swr, &bad_swr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
> +		return;
> +	}

Post command to QP in ERR state (admittedly, I never do this and hadn't
even thought about whether or not it is allowed...obviously it is, but
my initial reaction would have been "won't ib_post_send return an error
when you try to post to a QP in ERR state?")....OK...

> +	wait_for_drain(qp->send_cq, &sdrain.done);

Wait for your posted WR to complete...OK...

As I mentioned in my comment above, I would have thought that the
attempt to post a send to a QP in ERR state would have returned an
error.  It must not or else this patch is worthless because of the order
of actions.  What that highlights though, is that this code will drain a
QP, but only if the caller has taken the time to stop all possible
contexts that might run on other cores and post commands to the QP.
Those commands will error out, but the caller must, none the less, take
steps to block other contexts from sending or else this drain is
useless.  That might be fine for the API, but it should be clearly
documented, and currently it isn't.

> +}
> +
> +/*
> + * Post a WR and block until its completion is reaped for the RQ.
> + */
> +static void __ib_drain_rq(struct ib_qp *qp)
> +{
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct ib_drain_cqe rdrain;
> +	struct ib_recv_wr rwr =3D {}, *bad_rwr;
> +	int ret;
> +
> +	rwr.wr_cqe =3D &rdrain.cqe;
> +	rdrain.cqe.done =3D ib_drain_qp_done;
> +	init_completion(&rdrain.done);
> +
> +	ret =3D ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> +		return;
> +	}
> +
> +	ret =3D ib_post_recv(qp, &rwr, &bad_rwr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
> +		return;
> +	}
> +
> +	wait_for_drain(qp->recv_cq, &rdrain.done);
> +}
> +
> +/**
> + * ib_drain_sq() - Block until all SQ CQEs have been consumed by the
> + *		   application.
> + * @qp:            queue pair to drain
> + *
> + * If the device has a provider-specific drain function, then
> + * call that.  Otherwise call the generic drain function
> + * __ib_drain_sq().
> + *
> + * The consumer must ensure there is room in the CQ and SQ
> + * for a drain work requests.  Also the consumer must allocate the

Either requests should be singular, or you should remove the article 'a'.=


> + * CQ using ib_alloc_cq().  It is up to the consumer to handle concurr=
ency
> + * issues if the CQs are using the IB_POLL_DIRECT polling context.
> + */
> +void ib_drain_sq(struct ib_qp *qp)
> +{
> +	if (qp->device->drain_sq)
> +		qp->device->drain_sq(qp);
> +	else
> +		__ib_drain_sq(qp);
> +}
> +EXPORT_SYMBOL(ib_drain_sq);
> +
> +/**
> + * ib_drain_rq() - Block until all RQ CQEs have been consumed by the
> + *		   application.
> + * @qp:            queue pair to drain
> + *
> + * If the device has a provider-specific drain function, then
> + * call that.  Otherwise call the generic drain function
> + * __ib_drain_rq().
> + *
> + * The consumer must ensure there is room in the CQ and RQ
> + * for a drain work requests.  Also the consumer must allocate the

Ditto...

> + * CQ using ib_alloc_cq().  It is up to the consumer to handle concurr=
ency
> + * issues if the CQs are using the IB_POLL_DIRECT polling context.
> + */
> +void ib_drain_rq(struct ib_qp *qp)
> +{
> +	if (qp->device->drain_rq)
> +		qp->device->drain_rq(qp);
> +	else
> +		__ib_drain_rq(qp);
> +}
> +EXPORT_SYMBOL(ib_drain_rq);
> +
> +/**
> + * ib_drain_qp() - Block until all CQEs have been consumed by the
> + *		   application on both the RQ and SQ.
> + * @qp:            queue pair to drain
> + *
> + * The consumer must ensure there is room in the CQ(s), SQ, and RQ
> + * for a drain work requests.  Also the consumer must allocate the

Ditto...

> + * CQ using ib_alloc_cq().  It is up to the consumer to handle concurr=
ency
> + * issues if the CQs are using the IB_POLL_DIRECT polling context.
> + */
> +void ib_drain_qp(struct ib_qp *qp)
> +{
> +	ib_drain_sq(qp);
> +	ib_drain_rq(qp);
> +}
> +EXPORT_SYMBOL(ib_drain_qp);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 284b00c..68b7e97 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1846,6 +1846,8 @@ struct ib_device {
>  	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
>  						      struct ib_mr_status *mr_status);
>  	void			   (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
> +	void			   (*drain_rq)(struct ib_qp *qp);
> +	void			   (*drain_sq)(struct ib_qp *qp);
> =20
>  	struct ib_dma_mapping_ops   *dma_ops;
> =20
> @@ -3094,4 +3096,7 @@ int ib_sg_to_pages(struct ib_mr *mr,
>  		   int sg_nents,
>  		   int (*set_page)(struct ib_mr *, u64));
> =20
> +void ib_drain_rq(struct ib_qp *qp);
> +void ib_drain_sq(struct ib_qp *qp);
> +void ib_drain_qp(struct ib_qp *qp);
>  #endif /* IB_VERBS_H */
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ux9q98hlM34M7PHbkTQRLhQnEJFHxRieh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWwj2oAAoJELgmozMOVy/dc9YQAK45xK8sOJlEh8Iznm74j4V3
FV6eWbr3A6mSngZUbqRHaUK9MnlDFFTvLrhugGdy0zzivKw/5QPNovBy0xMCB5YX
7U9MmsUMUevSe+WWRbPJ1QsiSfEIIF3F2Sv5Wd9alRkUjUxdRtdnHHJnrO8rLypJ
fKY5RzfguXNWUluwSCuj5NDBGQjEYcS9LGi3hUF7rHFjOa2NCguj+x/XxemFzEHm
i2vgHvyc2fR0/1gRFLI8Nb7WKYnCNxSE0I9NdDN0wb7PK9jIYrxtwazUMy+xhmFk
+loCx0AE6flhD35CBtMUs+A1lGxaKwHaeW7S1hZZBU6797PbstI3R8/O1uZXJI6j
6NAR8IgkU74AGIvYmEofaF/Rp4rVhMLBShgjJEGIU2GyjgtIuqPd6oQSVZx8ooBN
zk0fGCtelHtDAVK6rlfDnhpv8mGTYblf4DhE/xt3B7thwP3YsoaOwCeATy/dERZ0
PM/bkMerJ82bDURX7LpytGum5DOSNc5vPRjXf6KKeEeemi515liksDJ4OhrtUSPb
ppbpNQ6kuPHli0OVGZErEq/NiJbI3TaVXcBM0QXHfRHJeNqJd3C3zKeGu82FRNpk
/WNrjNU9hOYSaCzMwBL50uo0pnZWVV+dN+JBpwTSkA74SSzmJUWCgf5h0L1pkWsm
H4o4FlfEJAh1h6phZu8e
=sfBC
-----END PGP SIGNATURE-----

--ux9q98hlM34M7PHbkTQRLhQnEJFHxRieh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
