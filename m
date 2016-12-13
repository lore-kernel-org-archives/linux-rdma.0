From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/rxe: Fix handling of erroneous WR
Date: Tue, 13 Dec 2016 09:44:41 +0200
Message-ID: <20161213074441.GE8204@mtr-leonro.local>
References: <1479285558-19627-1-git-send-email-leon@kernel.org>
 <1479285558-19627-3-git-send-email-leon@kernel.org>
 <5bd83de1-64d3-e5a9-1c58-cca52d89d64a@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8vCeF2GUdMpe9ZbK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5bd83de1-64d3-e5a9-1c58-cca52d89d64a-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8vCeF2GUdMpe9ZbK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2016 at 08:03:03AM +0100, Bart Van Assche wrote:
> On 11/16/2016 09:39 AM, Leon Romanovsky wrote:
> > @@ -745,13 +746,17 @@ int rxe_requester(void *arg)
> >  	wqe->status =3D IB_WC_LOC_PROT_ERR;
> >  	wqe->state =3D wqe_state_error;
> >
> > -complete:
> > -	if (qp_type(qp) !=3D IB_QPT_RC) {
> > -		while (rxe_completer(qp) =3D=3D 0)
> > -			;
> > -	}
> > -
> > -	return 0;
> > +	/*
> > +	 * IBA Spec. Section 10.7.3.1 SIGNALED COMPLETIONS
> > +	 * ---------8<---------8<-------------
> > +	 * ...Note that if a completion error occurs, a Work Completion
> > +	 * will always be generated, even if the signaling
> > +	 * indicator requests an Unsignaled Completion.
> > +	 * ---------8<---------8<-------------
> > +	 */
> > +	wqe->wr.send_flags |=3D IB_SEND_SIGNALED;
> > +	__rxe_do_task(&qp->comp.task);
> > +	return -EAGAIN;
>
> Hello Leon and Yonatan,
>
> Sorry for the late reply but I think setting IB_SEND_SIGNALED for WQE's
> reporting a completion error is wrong.

I'm not clear about it. I didn't find in spec what to do with IB_SEND_SIGNA=
LED
flag in case of error.

According to spec:
	"C10-91: The CI shall generate a CQE when a Work Request
	completed under any of the following conditions:
	=E2=80=A2 The Work Request completed in error"


> I noticed this because this change
> conflicts with Doug's rxe branch on github. Have you considered to apply
> the following (untested) patch instead of setting the IB_SEND_SIGNALED
> flag?
>
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> @@ -418,7 +418,7 @@ static void do_complete(struct rxe_qp *qp, struct rxe=
_send_w
> qe *wqe)
>
>         if ((qp->sq_sig_type =3D=3D IB_SIGNAL_ALL_WR) ||
>             (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
> -           (qp->req.state =3D=3D QP_STATE_ERROR)) {
> +           wqe->status !=3D IB_WC_SUCCESS) {
>                 make_send_cqe(qp, wqe, &cqe);
>                 advance_consumer(qp->sq.queue);
>                 rxe_cq_post(qp->scq, &cqe, 0);
>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--8vCeF2GUdMpe9ZbK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhPpukACgkQ5GN7iDZy
WKdc1g//SxzG8vZLgGhv1XuUz3Sqk4x1+e1+lSW0EhYC1gbebl7a8Ynknt1k+RGL
spTN01mYz6b7UvSgdSBen4YmLgqfANG6FWElOQESS5GSGJiWsJdp6x4JOq5Bo79H
Qf/pI6uWIYmsy+vxne55D+wTnR+rYWkOT+1E63HPhvS7CkwgRFYtDQJO1KbdkVng
mE3zPY08W/rbpt/y8hs2trhDIeAS3cXNhkcl0eBNsuK8c5APlsCNKsPLAkX5+dNp
eSppotwF9/VF+yrTySIQHHffVW58K5s62pv3N7mHdg0emhnCHQd/BFjVcEfbvbuM
XcVzszTVf1n0Un2mnx1ImiHDSOh1QzJkd7V2Mx5e/7s8lNaIaxej5M3vnzryvdxJ
8rEPV29Au+oKofptIn5/WO/rX2Og1vn7eMPPeDZjOVEsc20zjGYmtrFNXp4edjsw
pTkTzJ8pVqXNhuLRQkhnxL2QKp8ToGp+AG9TgDPspaGVs0IS+o7efg3HKagkGa84
TiyTjKNcJBastytFJgmMgWDCvTfq5U8A+Ky3alOA35bt2Qj6dOJnOtKAf+zKssvH
Q0uWzwCNLu7TxVmm8k9HTbJig/Dj4fOSofAGZQ86S+AnG6cEU5xnZisZ3ugMu84V
HG8yTFZLwTLXzvjXJvdQGtr8HhNb4wcTG6XQIdjK7QeCNk6argQ=
=AJtr
-----END PGP SIGNATURE-----

--8vCeF2GUdMpe9ZbK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
