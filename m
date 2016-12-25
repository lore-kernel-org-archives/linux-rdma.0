From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: max_inline_data in ibv_rc_pingpong
Date: Sun, 25 Dec 2016 11:48:34 +0000
Message-ID: <SN1PR07MB22079DB9A8D87699539DBB01F8970@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yishay, Doug,
I've noticed something irregular in ibv_rc_pingpong and I see that you are =
listed as the maintainers of libibverbs.
It seems that max_inline_data isn't configured prior to invoking ibv_create=
_qp(), but it is queried directly after.
This means that for a value of zero it will always be zero, or very small, =
depending on the vendor implementation.
Is there some background I'm missing?

        {
                struct ibv_qp_attr attr;
                struct ibv_qp_init_attr init_attr =3D {
                        .send_cq =3D ctx->cq,
                        .recv_cq =3D ctx->cq,
                        .cap     =3D {
                                .max_send_wr  =3D 1,
                                .max_recv_wr  =3D rx_depth,
                                .max_send_sge =3D 1,
                                .max_recv_sge =3D 1
                        },
                        .qp_type =3D IBV_QPT_RC
                };

                ctx->qp =3D ibv_create_qp(ctx->pd, &init_attr);
                if (!ctx->qp)  {
                        fprintf(stderr, "Couldn't create QP\n");
                        goto clean_cq;
                }

                ibv_query_qp(ctx->qp, &attr, IBV_QP_CAP, &init_attr);
                if (init_attr.cap.max_inline_data >=3D size) {
                        ctx->send_flags |=3D IBV_SEND_INLINE;
                }
        }


Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
