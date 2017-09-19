From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/bnxt_re: Fix frame stack compilation warning
Date: Tue, 19 Sep 2017 23:56:47 +0300
Message-ID: <20170919205647.GN5788@mtr-leonro.local>
References: <20170919102213.30911-1-leon@kernel.org>
 <b73b905c-baa2-0cb6-bccc-5f259ccedc48@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8cpS+6Cx+xtICsjy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b73b905c-baa2-0cb6-bccc-5f259ccedc48-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8cpS+6Cx+xtICsjy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2017 at 02:24:19PM -0400, Jonathan Toppins wrote:
> On 09/19/2017 06:22 AM, Leon Romanovsky wrote:
> > Reduce stack size by dynamically allocating memory instead
> > of declaring large struct on the stack:
> >
> > drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function =E2=80=98bnxt_re_=
query_qp=E2=80=99:
> > drivers/infiniband/hw/bnxt_re/ib_verbs.c:1600:1: warning: the frame siz=
e of 1216 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]
> >  }
> >  ^
> >
> > Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 67 +++++++++++++++++-------=
--------
> >  1 file changed, 36 insertions(+), 31 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infinib=
and/hw/bnxt_re/ib_verbs.c
> > index 01eee15bbd65..03caf48af8e2 100644
> > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > @@ -1551,43 +1551,46 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp, struc=
t ib_qp_attr *qp_attr,
> >  {
> >  	struct bnxt_re_qp *qp =3D container_of(ib_qp, struct bnxt_re_qp, ib_q=
p);
> >  	struct bnxt_re_dev *rdev =3D qp->rdev;
> > -	struct bnxt_qplib_qp qplib_qp;
> > +	struct bnxt_qplib_qp *qplib_qp;
> >  	int rc;
> >
> > -	memset(&qplib_qp, 0, sizeof(struct bnxt_qplib_qp));
> > -	qplib_qp.id =3D qp->qplib_qp.id;
> > -	qplib_qp.ah.host_sgid_index =3D qp->qplib_qp.ah.host_sgid_index;
> > +	qplib_qp =3D kzalloc(sizeof(*qplib_qp), GFP_KERNEL);
>                                                 ^^^^
> Can this process block? Further down in the code I see a call to kzalloc
> and they specifically use GFP_ATOMIC.
>
>     bnxt_qplib_query_qp() ->
>         bnxt_qplib_rcfw_alloc_sbuf()
>
> Looking through the rest of the function and what it calls I am thinking
> this function is assumed to not block so I think GFP_ATOMIC should be
> used here.

bnxt_re_query_qp() is called as callback of ibdev->query_qp and it is
unlikely that this function will be called in non-blocking context.

For me, It looks like an error to use GFP_ATOMIC down the call stack.

P.S. Our mlx4/mlx5 use GFP_KERNEL in query_qp callbacks.

>
> > +	if (!qplib_qp)
> > +		return -ENOMEM;
> > +
> > +	qplib_qp->id =3D qp->qplib_qp.id;
> > +	qplib_qp->ah.host_sgid_index =3D qp->qplib_qp.ah.host_sgid_index;
> >
> > -	rc =3D bnxt_qplib_query_qp(&rdev->qplib_res, &qplib_qp);
> > +	rc =3D bnxt_qplib_query_qp(&rdev->qplib_res, qplib_qp);
> >  	if (rc) {
> >  		dev_err(rdev_to_dev(rdev), "Failed to query HW QP");
> > -		return rc;
> > +		goto out;
> >  	}
> > -	qp_attr->qp_state =3D __to_ib_qp_state(qplib_qp.state);
> > -	qp_attr->en_sqd_async_notify =3D qplib_qp.en_sqd_async_notify ? 1 : 0;
> > -	qp_attr->qp_access_flags =3D __to_ib_access_flags(qplib_qp.access);
> > -	qp_attr->pkey_index =3D qplib_qp.pkey_index;
> > -	qp_attr->qkey =3D qplib_qp.qkey;
> > +	qp_attr->qp_state =3D __to_ib_qp_state(qplib_qp->state);
> > +	qp_attr->en_sqd_async_notify =3D qplib_qp->en_sqd_async_notify ? 1 : =
0;
> > +	qp_attr->qp_access_flags =3D __to_ib_access_flags(qplib_qp->access);
> > +	qp_attr->pkey_index =3D qplib_qp->pkey_index;
> > +	qp_attr->qkey =3D qplib_qp->qkey;
> >  	qp_attr->ah_attr.type =3D RDMA_AH_ATTR_TYPE_ROCE;
> > -	rdma_ah_set_grh(&qp_attr->ah_attr, NULL, qplib_qp.ah.flow_label,
> > -			qplib_qp.ah.host_sgid_index,
> > -			qplib_qp.ah.hop_limit,
> > -			qplib_qp.ah.traffic_class);
> > -	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, qplib_qp.ah.dgid.data);
> > -	rdma_ah_set_sl(&qp_attr->ah_attr, qplib_qp.ah.sl);
> > -	ether_addr_copy(qp_attr->ah_attr.roce.dmac, qplib_qp.ah.dmac);
> > -	qp_attr->path_mtu =3D __to_ib_mtu(qplib_qp.path_mtu);
> > -	qp_attr->timeout =3D qplib_qp.timeout;
> > -	qp_attr->retry_cnt =3D qplib_qp.retry_cnt;
> > -	qp_attr->rnr_retry =3D qplib_qp.rnr_retry;
> > -	qp_attr->min_rnr_timer =3D qplib_qp.min_rnr_timer;
> > -	qp_attr->rq_psn =3D qplib_qp.rq.psn;
> > -	qp_attr->max_rd_atomic =3D qplib_qp.max_rd_atomic;
> > -	qp_attr->sq_psn =3D qplib_qp.sq.psn;
> > -	qp_attr->max_dest_rd_atomic =3D qplib_qp.max_dest_rd_atomic;
> > -	qp_init_attr->sq_sig_type =3D qplib_qp.sig_type ? IB_SIGNAL_ALL_WR :
> > -							IB_SIGNAL_REQ_WR;
> > -	qp_attr->dest_qp_num =3D qplib_qp.dest_qpn;
> > +	rdma_ah_set_grh(&qp_attr->ah_attr, NULL, qplib_qp->ah.flow_label,
> > +			qplib_qp->ah.host_sgid_index,
> > +			qplib_qp->ah.hop_limit,
> > +			qplib_qp->ah.traffic_class);
> > +	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, qplib_qp->ah.dgid.data);
> > +	rdma_ah_set_sl(&qp_attr->ah_attr, qplib_qp->ah.sl);
> > +	ether_addr_copy(qp_attr->ah_attr.roce.dmac, qplib_qp->ah.dmac);
> > +	qp_attr->path_mtu =3D __to_ib_mtu(qplib_qp->path_mtu);
> > +	qp_attr->timeout =3D qplib_qp->timeout;
> > +	qp_attr->retry_cnt =3D qplib_qp->retry_cnt;
> > +	qp_attr->rnr_retry =3D qplib_qp->rnr_retry;
> > +	qp_attr->min_rnr_timer =3D qplib_qp->min_rnr_timer;
> > +	qp_attr->rq_psn =3D qplib_qp->rq.psn;
> > +	qp_attr->max_rd_atomic =3D qplib_qp->max_rd_atomic;
> > +	qp_attr->sq_psn =3D qplib_qp->sq.psn;
> > +	qp_attr->max_dest_rd_atomic =3D qplib_qp->max_dest_rd_atomic;
> > +	qp_init_attr->sq_sig_type =3D qplib_qp->sig_type ? IB_SIGNAL_ALL_WR :
> > +							 IB_SIGNAL_REQ_WR;
> > +	qp_attr->dest_qp_num =3D qplib_qp->dest_qpn;
> >
> >  	qp_attr->cap.max_send_wr =3D qp->qplib_qp.sq.max_wqe;
> >  	qp_attr->cap.max_send_sge =3D qp->qplib_qp.sq.max_sge;
> > @@ -1596,7 +1599,9 @@ int bnxt_re_query_qp(struct ib_qp *ib_qp, struct =
ib_qp_attr *qp_attr,
> >  	qp_attr->cap.max_inline_data =3D qp->qplib_qp.max_inline_data;
> >  	qp_init_attr->cap =3D qp_attr->cap;
> >
> > -	return 0;
> > +out:
> > +	kfree(qplib_qp);
> > +	return rc;
> >  }
> >
> >  /* Routine for sending QP1 packets for RoCE V1 an V2
> > --
> > 2.14.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>

--8cpS+6Cx+xtICsjy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnBhI8ACgkQ5GN7iDZy
WKeYWBAAtovQJriTCszW0iKv5VSlmr3hlqQpHJ6iCsOwPKh1KuQudUCMEf/IYkss
rE7o/v4hP2mnScXKqSZS3LrkLqlzHgl883GAu+iJVHYpJdeHLq+baOuDcSMUgGpd
6FQ6UCQxWoIcVDirhiJzJPttvGIBvzH7EeEWVXDm67dFfq3DC6TDVZJul/ryc862
ZOaLdK6Su9W0LkVkmTo4hm/Zg28PaXIZdPl/OcOur4S8vIIYXWP1r82oZxRFcfm6
/5wna2a5FDHIJu7D365cM9Ht2t2UxpJhfq8CgEHe8uPX6LEBA+E4xwwY1SA15bqW
uAHXPxIBGvCjnYZWn1tgqcVhCxTgN4HD6TOKnkr8GITUq7EqNwB6Yid9GqWvRwD/
OeZGcoS11KkQSvHXJvJ2LSE7zXxem0mE4BIR9CRfzSdjKA8KVc8kHu82a9j/y9zQ
RWCt2808pWmTSqE6TIaFPw/uAaybSUmwfHlxpdYMjvGecFr+xoLF9G1lpnOvs/d1
VJtyt4yoknevz0GFjg1p7yZa5wofj2yW1NtBMlA0gSHsnclGuXQeYRvqYMYYLQLG
0mJtIlPoFMQdAY43LMKH81CWqr+ltLi+ibav/k8jo0odjncLTa9DgJ3QnFRAkuZp
2e7dd8BMm6JWCRbYlSDhoJA2kkyJgq5iRf4J8VKTjRNHk9Ns4N0=
=snVC
-----END PGP SIGNATURE-----

--8cpS+6Cx+xtICsjy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
