From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Possible bugs in MLX XRC
Date: Thu, 28 Dec 2017 09:57:27 +0000
Message-ID: <BN3PR07MB2578F607B5C4369BB432046AF8040@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In rdma-core mlx5 there's a lock over the srq_table. See below the mlx5_sto=
re_srq():

        pthread_mutex_lock(&ctx->srq_table_mutex);
        ret =3D ibv_cmd_create_srq(pd, ibsrq, attr, &cmd.ibv_cmd, sizeof(cm=
d),
                                 &resp.ibv_resp, sizeof(resp));
        if (ret)
                goto err_db;

        ret =3D mlx5_store_srq(ctx, resp.srqn, srq);
        if (ret)
                goto err_destroy;

        pthread_mutex_unlock(&ctx->srq_table_mutex);

For some reason, mlx5_clear_srq() isn't invoked under a mutex lock:
int mlx5_destroy_srq(struct ibv_srq *srq)
{
        int ret;
        struct mlx5_srq *msrq =3D to_msrq(srq);
        struct mlx5_context *ctx =3D to_mctx(srq->context);

        if (msrq->cmd_qp) {
                ret =3D mlx5_destroy_qp(msrq->cmd_qp);
                if (ret)
                        return ret;
                msrq->cmd_qp =3D NULL;
        }

        ret =3D ibv_cmd_destroy_srq(srq);
        if (ret)
                return ret;

        if (ctx->cqe_version && msrq->rsc.type =3D=3D MLX5_RSC_TYPE_XSRQ)
                mlx5_clear_uidx(ctx, msrq->rsc.rsn);
        else
                mlx5_clear_srq(ctx, msrq->srqn);

        mlx5_free_db(ctx, msrq->db);
        mlx5_free_buf(&msrq->buf);
        free(msrq->tm_list);
        free(msrq->wrid);
        free(msrq->op);
        free(msrq);

        return 0;
}

The mlx5_find_srq() isn't protected as well. This is fast path.
You cannot promise that poll_cq for a relevant CQE won't be invoked during =
or after the XRC SRQ removal.
This calls for something like CQEs that are being removed/marked as invalid=
 following the QP is destruction.

Cheers,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
