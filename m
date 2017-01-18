From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH RFC rdma-core 3/3] qedr: Use common provider debug macros
Date: Wed, 18 Jan 2017 09:52:20 +0000
Message-ID: <SN1PR07MB2207DDD71313CCB847C64653F87F0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1484682494-76200-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484682494-76200-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Replace qedr specific debug macros with
> common provider macros.
>=20
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Thanks for doing this Tatyana!

> @@ -254,7 +251,8 @@ struct ibv_cq *qelr_create_cq(struct ibv_context *con=
text, int cqe,
>  			       &cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
>  			       &resp.ibv_resp, sizeof(resp));
>  	if (rc) {
> -		DP_ERR(cxt->dbg_fp, "create cq: failed with rc =3D %d\n", rc);
> +		LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_ALL, VERBS_DBG_LEVEL_VERBOSE=
,
> +				"create cq: failed with rc =3D %d\n", rc);
>  		goto err_1;
>  	}
>=20

I'm OK with replacing DP_VERBOSE with LOG_DBG_FLUSH(,..., VERBS_DBG_LEVEL_V=
ERBOSE, ...)
as these prints should be printed only if enabled. In multiple locations, h=
owever, I see that
DP_ERR is replaced as DP_VERBOSE. But whenever a DP_ERR appears the output =
is expected to
show regardless of verbosity level.

> @@ -1208,7 +1212,7 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv=
_send_wr *wr,
>  			qp->wqe_wr_id[qp->sq.prod].wqe_size =3D swqe->wqe_size;
>  			qp->prev_wqe_size =3D swqe->wqe_size;
>  			qp->wqe_wr_id[qp->sq.prod].bytes_len =3D swqe->length;
> -			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
> +			LOG_DBG_FLUSH(cxt->dbg_fp, VERBS_DBG_MASK_CQ, VERBS_DBG_LEVEL_VERBOSE=
,
>  				      "SEND w/ IMM length =3D %d imm data=3D%x\n",
>  				      swqe->length, wr->imm_data);
>  			break;

Please delete _all_ occurrences of FP_DP_VERVBOSE
They will flood the debug buffer and will render it unusable.
(they were disabled by default from being even compiled).
Alternatively I can delete them myself, but if so then don't replace them w=
ith anything.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
