From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 11/15] IB/pvrdma: Add Queue Pair support
Date: Wed, 7 Sep 2016 19:33:44 +0000
Message-ID: <BLUPR0501MB8369B428D77DFE0343650EEC5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-12-git-send-email-aditr@vmware.com>
 <20160829144405.GA6214@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160829144405.GA6214@yuval-lap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On  Mon, Aug 29, 2016 at 07:44:24 -0700, Yuval Shaia wrote:
> On Wed, Aug 03, 2016 at 04:27:40PM -0700, Adit Ranadive wrote:
> > This patch adds the ability to create, modify, query and destroy QPs.
> > The PVRDMA device supports RC, UD and GSI QPs.
> >
> > Changes v2->v3:
> >  - Removed boolean in pvrdma_cmd_post.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_qp.c | 975
> > +++++++++++++++++++++++++++++++
> >  1 file changed, 975 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_qp.c
> >

...

> > +static int pvrdma_set_rq_size(struct pvrdma_dev *dev,
> > +			      struct ib_qp_cap *cap,
> > +			      struct pvrdma_qp *qp)
> > +{
> > +	if (cap->max_recv_wr > dev->dsr->caps.max_qp_wr ||
> > +	    cap->max_recv_sge > dev->dsr->caps.max_sge) {
> > +		dev_warn(&dev->pdev->dev, "recv queue size invalid\n");
> > +		return -EINVAL;
> > +	}
>=20
> (extremely) minor suggestion to rename cap to req_cap as w/o knowing the
> context (cap is caller's requested attr) one might be confused how come Q=
P
> max can be more than device max.
> Again, minor.
> (applied also to pvrdma_set_sq_size).

Ok. Makes sense. Adding in v4.

> > +
> > +	qp->rq.wqe_cnt =3D roundup_pow_of_two(max(1U, cap-
> >max_recv_wr));
> > +	qp->rq.max_gs =3D roundup_pow_of_two(max(1U, cap-
> >max_recv_sge));
> > +
> > +	/* Write back */
> > +	cap->max_recv_wr =3D qp->rq.wqe_cnt;
> > +	cap->max_recv_sge =3D qp->rq.max_gs;
> > +
> > +	qp->rq.wqe_size =3D roundup_pow_of_two(sizeof(struct
> pvrdma_rq_wqe_hdr) +
> > +					     sizeof(struct ib_sge) *
> > +					     qp->rq.max_gs);
> > +	qp->npages_recv =3D (qp->rq.wqe_cnt * qp->rq.wqe_size +
> PAGE_SIZE - 1) /
> > +			  PAGE_SIZE;
> > +
> > +	return 0;
> > +}
> > +
> > +static int pvrdma_set_sq_size(struct pvrdma_dev *dev, struct ib_qp_cap
> *cap,
> > +			      enum ib_qp_type type, struct pvrdma_qp *qp) {
> > +	if (cap->max_send_wr > dev->dsr->caps.max_qp_wr ||
> > +	    cap->max_send_sge > dev->dsr->caps.max_sge) {
> > +		dev_warn(&dev->pdev->dev, "send queue size invalid\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	qp->sq.wqe_cnt =3D roundup_pow_of_two(max(1U, cap-
> >max_send_wr));
> > +	qp->sq.max_gs =3D roundup_pow_of_two(max(1U, cap-
> >max_send_sge));
> > +
> > +	/* Write back */
> > +	cap->max_send_wr =3D qp->sq.wqe_cnt;
> > +	cap->max_send_sge =3D qp->sq.max_gs;
> > +
> > +	qp->sq.wqe_size =3D roundup_pow_of_two(sizeof(struct
> pvrdma_sq_wqe_hdr) +
> > +					     sizeof(struct ib_sge) *
> > +					     qp->sq.max_gs);
> > +	/* Note: one extra page for the header. */
> > +	qp->npages_send =3D 1 + (qp->sq.wqe_cnt * qp->sq.wqe_size +
> > +			       PAGE_SIZE - 1) / PAGE_SIZE;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * pvrdma_create_qp - create queue pair
> > + * @pd: protection domain
> > + * @init_attr: queue pair attributes
> > + * @udata: user data
> > + *
> > + * @return: the ib_qp pointer on success, otherwise returns an errno.
> > + */
> > +struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
> > +			       struct ib_qp_init_attr *init_attr,
> > +			       struct ib_udata *udata)
> > +{
> > +	struct pvrdma_qp *qp;
> > +	struct pvrdma_dev *dev =3D to_vdev(pd->device);
> > +	struct pvrdma_cq *send_cq, *recv_cq;
> > +	union pvrdma_cmd_req req;
> > +	union pvrdma_cmd_resp rsp;
> > +	struct pvrdma_cmd_create_qp *cmd =3D &req.create_qp;
> > +	struct pvrdma_cmd_create_qp_resp *resp =3D &rsp.create_qp_resp;
> > +	struct pvrdma_create_qp ucmd;
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	if (!atomic_add_unless(&dev->num_qps, 1, dev->dsr-
> >caps.max_qp))
> > +		return ERR_PTR(-EINVAL);
>=20
> Suggesting EAGAIN, ENOMEM, ENOSPC but not "Invalid argument" as
> nothing is wrong with input args.

Changed this to -ENOMEM.

> > +
> > +	if (init_attr->create_flags) {
> > +		dev_warn(&dev->pdev->dev,
> > +			 "invalid create queuepair flags %#x\n",
> > +			 init_attr->create_flags);
> > +		atomic_dec(&dev->num_qps);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > +	if (init_attr->qp_type !=3D IB_QPT_RC &&
> > +	    init_attr->qp_type !=3D IB_QPT_UD &&
> > +	    init_attr->qp_type !=3D IB_QPT_GSI) {
> > +		dev_warn(&dev->pdev->dev, "queuepair type %d not
> supported\n",
> > +			 init_attr->qp_type);
> > +		atomic_dec(&dev->num_qps);
> > +		return ERR_PTR(-EINVAL);
> > +	}
>=20
> Can we move the two blocks above so we would not need to dec(num_qps)
> on validation failure.
> It also make sense to first validate input and just then to allocate reso=
urce.

Ok.

...

> > +static void pvrdma_free_qp(struct pvrdma_qp *qp) {
> > +	struct pvrdma_dev *dev =3D to_vdev(qp->ibqp.device);
> > +	struct pvrdma_cq *scq;
> > +	struct pvrdma_cq *rcq;
> > +	unsigned long flags, flags1, flags2;
> > +
> > +	/* In case cq is polling */
> > +	get_cqs(qp, &scq, &rcq);
> > +	if ((uintptr_t)scq <=3D (uintptr_t)rcq) {
>=20
> ???
> Comment might help here :)

I updated this whole cleanup CQs path so this check will go away.

...

> > +
> > +	index =3D pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
> > +	for (nreq =3D 0; wr; nreq++, wr =3D wr->next) {
> > +		unsigned int tail;
> > +
> > +		if (unlikely(!pvrdma_idx_ring_has_space(
> > +				qp->sq.ring, qp->sq.wqe_cnt, &tail))) {
> > +			dev_warn(&dev->pdev->dev, "send queue is
> full\n");
>=20
> Please consider replace it with dev_warn_ratelimited.
> (applied to all dev_warn in this function and in pvrdma_post_recv).

Ok. Will look at this.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
