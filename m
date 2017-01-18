From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 3/3] qedr: Use common provider debug macros
Date: Wed, 18 Jan 2017 13:36:53 +0200
Message-ID: <20170118113653.GA32481@mtr-leonro.local>
References: <1484682494-76200-1-git-send-email-tatyana.e.nikolova@intel.com>
 <SN1PR07MB2207DDD71313CCB847C64653F87F0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JVVqWhpkAs5raV7A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB2207DDD71313CCB847C64653F87F0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--JVVqWhpkAs5raV7A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 18, 2017 at 09:52:20AM +0000, Amrani, Ram wrote:
> > Replace qedr specific debug macros with
> > common provider macros.
> >
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
>
> Thanks for doing this Tatyana!
>
> > @@ -254,7 +251,8 @@ struct ibv_cq *qelr_create_cq(struct ibv_context *context, int cqe,
> >  			       &cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
> >  			       &resp.ibv_resp, sizeof(resp));
> >  	if (rc) {
> > -		DP_ERR(cxt->dbg_fp, "create cq: failed with rc = %d\n", rc);
> > +		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE,
> > +				"create cq: failed with rc = %d\n", rc);
> >  		goto err_1;
> >  	}
> >
>
> I'm OK with replacing DP_VERBOSE with LOG_DBG_FLUSH(,..., VERBS_DBG_LEVEL_VERBOSE, ...)
> as these prints should be printed only if enabled. In multiple locations, however, I see that
> DP_ERR is replaced as DP_VERBOSE. But whenever a DP_ERR appears the output is expected to
> show regardless of verbosity level.
>
> > @@ -1208,7 +1212,7 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
> >  			qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
> >  			qp->prev_wqe_size = swqe->wqe_size;
> >  			qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
> > -			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
> > +			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE,
> >  				      "SEND w/ IMM length = %d imm data=%x\n",
> >  				      swqe->length, wr->imm_data);
> >  			break;
>
> Please delete _all_ occurrences of FP_DP_VERVBOSE
> They will flood the debug buffer and will render it unusable.
> (they were disabled by default from being even compiled).
> Alternatively I can delete them myself, but if so then don't replace them with anything.

Ram,
Please do, so I'll be able to apply that patch immediately and won't need to
wait till you Ack on Tatyana's series, especially in regards her other
patch which fixed compilation error.

Thanks.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--JVVqWhpkAs5raV7A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh/U1UACgkQ5GN7iDZy
WKfUxA//QPGN+go1nlx+9XdUYWYjJ9NxddI3bWu8WM0+d+Rarwf4Pt6xlO4l79Xe
f3Z7XCNHcU0hruYEPOxlb/KID/OuY52mINd5sRRoM/H/a/HTG3f6+Ouz2GzX0/yi
LkOzw75Bwq+eDqPdsqFIeucnSTd+z5YrYT6x9fJ1UdfwingPVOyLYYBj7xbJOdBA
gNdwbhzHD7hOvVT/A+/EnxAavH6B6S24LduIdKAh+XDd1t3dXxG3ZAuD0YSqec9T
z/Igl5CQlwGu6mHwoOVjHN85YMD+6Rg4I2qVgPzlObJkMa4uXsq90qnos74iUhfK
hVXCrq60Ng8rH2LAIzG5fkQTn7oHh0EoPUiVTVM9eNz9015gj1wrGCK/x8JZ8B/J
gsnBE5yOGkmsud5Xl113wKvyiZ1+d+kCESEgM5sGVtGKNkl/WRgHnxvC2NrafkCP
oVE1hpnfyJ09TyxL83Y91v051q0mFLLeFKk98zNSFh/Ycv6QZP7rm7Ws8IBFVO20
d/pICRQQCHl86quJiXf/MbSjcug8iI7u9/G8RmDoVn4WYAVm6Yj1n/FdfOCWXYw6
0EvPrD2AXjFMoyMu3VSHWxLFZzOd+2gBjcRZbS3vMvra/P3h38wvsqSpDKi1CWKB
iuJDqLiZAkw/m+L/ASUG+CRCqzBMxImnKOZdSeJ+J3XC2kJshZc=
=hTbq
-----END PGP SIGNATURE-----

--JVVqWhpkAs5raV7A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
