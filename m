From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [bug report] qedr: Add support for QP verbs
Date: Tue, 15 Nov 2016 10:36:25 +0000
Message-ID: <DM3PR07MB2201E89EF3D5A27A9FE6DFB5F8BF0@DM3PR07MB2201.namprd07.prod.outlook.com>
References: <20161114130310.GA14500@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161114130310.GA14500@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hello Ram Amrani,
>=20
> The patch cecbcddf6461: "qedr: Add support for QP verbs" from Oct 10, 201=
6,
> leads to the following static checker warning:
>=20
> 	drivers/infiniband/hw/qedr/verbs.c:2067 qedr_destroy_qp()
> 	'0x5 | 0x1' has '0x1' set on both sides
>=20
> drivers/infiniband/hw/qedr/verbs.c
>   2056  int qedr_destroy_qp(struct ib_qp *ibqp)
>   2057  {
>   2058          struct qedr_qp *qp =3D get_qedr_qp(ibqp);
>   2059          struct qedr_dev *dev =3D qp->dev;
>   2060          struct ib_qp_attr attr;
>   2061          int attr_mask =3D 0;
>   2062          int rc =3D 0;
>   2063
>   2064          DP_DEBUG(dev, QEDR_MSG_QP, "destroy qp: destroying %p, qp
> type=3D%d\n",
>   2065                   qp, qp->qp_type);
>   2066
>   2067          if (qp->state !=3D (QED_ROCE_QP_STATE_RESET |
> QED_ROCE_QP_STATE_ERR |
>   2068                            QED_ROCE_QP_STATE_INIT)) {
>=20
> These aren't bitfields, they're just numbers.  This code is pretty suspec=
t.  Not
> sure what was intended.
>=20
>   2069                  attr.qp_state =3D IB_QPS_ERR;
>   2070                  attr_mask |=3D IB_QP_STATE;
>   2071
>   2072                  /* Change the QP state to ERROR */
>   2073                  qedr_modify_qp(ibqp, &attr, attr_mask, NULL);
>   2074          }
>=20
> regards,
> dan carpenter

That's a real bug. Thanks!
Will fix.

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
