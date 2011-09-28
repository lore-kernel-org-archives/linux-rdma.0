From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 2/4] [for-3.2] rdma/cm: Check for NULL conn_param in rdma_accept
Date: Wed, 28 Sep 2011 09:11:43 -0700
Message-ID: <CAL1RGDXRWsNHWBzE5Fk-VsKqhwb7LWdPJXN=dc72gpAf8KSjCQ@mail.gmail.com>
References: <AcxttV1HMI1FYcNYSSWS3/hmZom3ZA==> <1828884A29C6694DAF28B7E6B8A8237316E5A0AE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E5A0AE-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -2612,14 +2612,16 @@ static int cma_connect_iw(struct rdma_id_priv=
ate *id_priv,
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 iw_param.ord =3D conn_param->initiator_depth;
> - =A0 =A0 =A0 iw_param.ird =3D conn_param->responder_resources;
> - =A0 =A0 =A0 iw_param.private_data =3D conn_param->private_data;
> - =A0 =A0 =A0 iw_param.private_data_len =3D conn_param->private_data_=
len;
> - =A0 =A0 =A0 if (id_priv->id.qp)
> + =A0 =A0 =A0 if (conn_param) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_param.ord =3D conn_param->initiator_=
depth;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_param.ird =3D conn_param->responder_=
resources;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_param.private_data =3D conn_param->p=
rivate_data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_param.private_data_len =3D conn_para=
m->private_data_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_param.qpn =3D id_priv->id.qp ? id_pr=
iv->qp_num : conn_param->qp_num;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(&iw_param, 0, sizeof iw_param);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iw_param.qpn =3D id_priv->qp_num;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_param.qpn =3D conn_param->qp_num;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0ret =3D iw_cm_connect(cm_id, &iw_param);
> =A0out:
> =A0 =A0 =A0 =A0if (ret && !IS_ERR(cm_id)) {

I had to fix the context here since
0c9361fcdeccd316ed67d85aa819c08066964c5b ("RDMA/cma: Avoid assigning
an IS_ERR value to cm_id pointer in CMA id object") changed this
area...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
