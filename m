From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 08/15] IB/pvrdma: Add support for Completion Queues
Date: Wed, 7 Sep 2016 17:25:30 +0000
Message-ID: <BLUPR0501MB83629470B22B65E27B4332AC5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-9-git-send-email-aditr@vmware.com>
 <20160825124120.GB27446@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160825124120.GB27446-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 25, 2016 at 05:41:41 -0700, Yuval Shaia wrote:
> On Wed, Aug 03, 2016 at 04:27:37PM -0700, Adit Ranadive wrote:
> > This patch adds the support for creating and destroying completion
> > queues on the paravirtual RDMA device.
> >
> > Changes v2->v3:
> >  - Removed boolean from pvrdma_cmd_post.
> >  - Return -EAGAIN if qp retrieved from CQE is bogus.
> >  - Check for invalid index of ring.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_cq.c | 437
> > +++++++++++++++++++++++++++++++
> >  1 file changed, 437 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_cq.c

...

> > +int pvrdma_req_notify_cq(struct ib_cq *ibcq,
> > +			 enum ib_cq_notify_flags notify_flags) {
> > +	struct pvrdma_dev *dev =3D to_vdev(ibcq->device);
> > +	struct pvrdma_cq *cq =3D to_vcq(ibcq);
> > +	u32 val =3D cq->cq_handle;
> > +
> > +	val |=3D (notify_flags & IB_CQ_SOLICITED_MASK) =3D=3D IB_CQ_SOLICITED
> ?
> > +		PVRDMA_UAR_CQ_ARM_SOL : PVRDMA_UAR_CQ_ARM;
> > +
> > +	writel(cpu_to_le32(val), dev->driver_uar.map +
> > +PVRDMA_UAR_CQ_OFFSET);
>=20
> With such a nice wrappers to dev->regs i wonder why you choose not to do
> the same for driver_uar.map.

I added those in v4.

> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * pvrdma_create_cq - create completion queue
> > + * @ibdev: the device
> > + * @attr: completion queue attributes
> > + * @context: user context
> > + * @udata: user data
> > + *
> > + * @return: ib_cq completion queue pointer on success,
> > + *          otherwise returns negative errno.
> > + */
> > +struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
> > +			       const struct ib_cq_init_attr *attr,
> > +			       struct ib_ucontext *context,
> > +			       struct ib_udata *udata)
> > +{
> > +	int entries =3D attr->cqe;
> > +	struct pvrdma_dev *dev =3D to_vdev(ibdev);
> > +	struct pvrdma_cq *cq;
> > +	int ret;
> > +	int npages;
> > +	unsigned long flags;
> > +	union pvrdma_cmd_req req;
> > +	union pvrdma_cmd_resp rsp;
> > +	struct pvrdma_cmd_create_cq *cmd =3D &req.create_cq;
> > +	struct pvrdma_cmd_create_cq_resp *resp =3D &rsp.create_cq_resp;
> > +	struct pvrdma_create_cq ucmd;
> > +
> > +	BUILD_BUG_ON(sizeof(struct pvrdma_cqe) !=3D 64);
> > +
> > +	entries =3D roundup_pow_of_two(entries);
> > +	if (entries < 1 || entries > dev->dsr->caps.max_cqe)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	if (!atomic_add_unless(&dev->num_cqs, 1, dev->dsr-
> >caps.max_cq))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	cq =3D kzalloc(sizeof(*cq), GFP_KERNEL);
> > +	if (!cq) {
> > +		atomic_dec(&dev->num_cqs);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	cq->ibcq.cqe =3D entries;
> > +
> > +	if (context) {
> > +		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
> > +			ret =3D -EFAULT;
> > +			goto err_cq;
> > +		}
> > +
> > +		cq->umem =3D ib_umem_get(context, ucmd.buf_addr,
> ucmd.buf_size,
> > +				       IB_ACCESS_LOCAL_WRITE, 1);
> > +		if (IS_ERR(cq->umem)) {
> > +			ret =3D PTR_ERR(cq->umem);
> > +			goto err_cq;
> > +		}
> > +
> > +		npages =3D ib_umem_page_count(cq->umem);
> > +	} else {
> > +		cq->is_kernel =3D true;
> > +
> > +		/* One extra page for shared ring state */
> > +		npages =3D 1 + (entries * sizeof(struct pvrdma_cqe) +
> > +			      PAGE_SIZE - 1) / PAGE_SIZE;
> > +
> > +		/* Skip header page. */
> > +		cq->offset =3D PAGE_SIZE;
> > +	}
> > +
> > +	if (npages < 0 || npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
> > +		dev_warn(&dev->pdev->dev,
> > +			 "overflow pages in completion queue\n");
> > +		ret =3D -EINVAL;
> > +		goto err_umem;
> > +	}
> > +
> > +	ret =3D pvrdma_page_dir_init(dev, &cq->pdir, npages, cq->is_kernel);
> > +	if (ret) {
> > +		dev_warn(&dev->pdev->dev,
> > +			 "could not allocate page directory\n");
> > +		goto err_umem;
> > +	}
> > +
> > +	if (cq->is_kernel) {
> > +		/* Ring state is always the first page. */
> > +		cq->ring_state =3D cq->pdir.pages[0];
> > +	} else {
> > +		pvrdma_page_dir_insert_umem(&cq->pdir, cq->umem, 0);
> > +	}
> > +
> > +	atomic_set(&cq->refcnt, 1);
> > +	init_waitqueue_head(&cq->wait);
> > +	spin_lock_init(&cq->cq_lock);
> > +
> > +	memset(cmd, 0, sizeof(*cmd));
> > +	cmd->hdr.cmd =3D PVRDMA_CMD_CREATE_CQ;
> > +	cmd->nchunks =3D npages;
> > +	cmd->ctx_handle =3D (context) ?
> > +		(u64)to_vucontext(context)->ctx_handle : 0;
> > +	cmd->cqe =3D entries;
> > +	cmd->pdir_dma =3D cq->pdir.dir_dma;
> > +	ret =3D pvrdma_cmd_post(dev, &req, &rsp);
> > +
> > +	if (ret < 0 || rsp.hdr.ack !=3D PVRDMA_CMD_CREATE_CQ_RESP) {
> > +		dev_warn(&dev->pdev->dev,
> > +			 "could not create completion queue\n");
> > +		goto err_page_dir;
> > +	}
> > +
> > +	cq->ibcq.cqe =3D resp->cqe;
> > +	cq->cq_handle =3D resp->cq_handle;
> > +	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
> > +	dev->cq_tbl[cq->cq_handle % dev->dsr->caps.max_cq] =3D cq;
> > +	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
> > +
> > +	if (context) {
> > +		cq->uar =3D &(to_vucontext(context)->uar);
> > +
> > +		/* Copy udata back. */
> > +		if (ib_copy_to_udata(udata, &cq->cq_handle,
> sizeof(__u32))) {
> > +			dev_warn(&dev->pdev->dev,
> > +				 "failed to copy back udata\n");
> > +			ret =3D -EINVAL;
>=20
> Don't we need to destroy the cq here?

You are right. Added.

>=20
> > +			goto err_page_dir;
> > +		}
> > +	}
> > +
> > +	return &cq->ibcq;
> > +
> > +err_page_dir:
> > +	pvrdma_page_dir_cleanup(dev, &cq->pdir);
> > +err_umem:
> > +	if (context)
> > +		ib_umem_release(cq->umem);
> > +err_cq:
> > +	atomic_dec(&dev->num_cqs);
> > +	kfree(cq);
> > +
> > +	return ERR_PTR(ret);
> > +}
> > +
> > +static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq
> > +*cq) {
> > +	atomic_dec(&cq->refcnt);
> > +	wait_event(cq->wait, !atomic_read(&cq->refcnt));
> > +
> > +	if (!cq->is_kernel)
> > +		ib_umem_release(cq->umem);
> > +
> > +	pvrdma_page_dir_cleanup(dev, &cq->pdir);
> > +	kfree(cq);
> > +}
> > +
> > +/**
> > + * pvrdma_destroy_cq - destroy completion queue
> > + * @cq: the completion queue to destroy.
> > + *
> > + * @return: 0 for success.
> > + */
> > +int pvrdma_destroy_cq(struct ib_cq *cq) {
> > +	struct pvrdma_cq *vcq =3D to_vcq(cq);
> > +	union pvrdma_cmd_req req;
> > +	struct pvrdma_cmd_destroy_cq *cmd =3D &req.destroy_cq;
> > +	struct pvrdma_dev *dev =3D to_vdev(cq->device);
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	memset(cmd, 0, sizeof(*cmd));
> > +	cmd->hdr.cmd =3D PVRDMA_CMD_DESTROY_CQ;
> > +	cmd->cq_handle =3D vcq->cq_handle;
> > +
> > +	ret =3D pvrdma_cmd_post(dev, &req, NULL);
> > +	if (ret < 0)
> > +		dev_warn(&dev->pdev->dev,
> > +			 "could not destroy completion queue\n");
> > +
> > +	/* free cq's resources */
> > +	spin_lock_irqsave(&dev->cq_tbl_lock, flags);
> > +	dev->cq_tbl[vcq->cq_handle] =3D NULL;
> > +	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
> > +
> > +	pvrdma_free_cq(dev, vcq);
> > +	atomic_dec(&dev->num_cqs);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * pvrdma_modify_cq - modify the CQ moderation parameters
> > + * @ibcq: the CQ to modify
> > + * @cq_count: number of CQEs that will trigger an event
> > + * @cq_period: max period of time in usec before triggering an event
> > + *
> > + * @return: -EOPNOTSUPP as CQ resize is not supported.
> > + */
> > +int pvrdma_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period) {
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static inline struct pvrdma_cqe *get_cqe(struct pvrdma_cq *cq, int i)
> > +{
> > +	return (struct pvrdma_cqe *)pvrdma_page_dir_get_ptr(
> > +					&cq->pdir,
> > +					cq->offset +
> > +					sizeof(struct pvrdma_cqe) * i);
> > +}
> > +
> > +void pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq) {
> > +	int head;
> > +	int has_data;
> > +
> > +	if (!cq->is_kernel)
> > +		return;
> > +
> > +	/* Lock held */
> > +	has_data =3D pvrdma_idx_ring_has_data(&cq->ring_state->rx,
> > +					    cq->ibcq.cqe, &head);
> > +	if (unlikely(has_data > 0)) {
> > +		int items;
> > +		int curr;
> > +		int tail =3D pvrdma_idx(&cq->ring_state->rx.prod_tail,
> > +				      cq->ibcq.cqe);
> > +		struct pvrdma_cqe *cqe;
> > +		struct pvrdma_cqe *curr_cqe;
> > +
> > +		items =3D (tail > head) ? (tail - head) :
> > +			(cq->ibcq.cqe - head + tail);
> > +		curr =3D --tail;
> > +		while (items-- > 0) {
> > +			if (curr < 0)
> > +				curr =3D cq->ibcq.cqe - 1;
> > +			if (tail < 0)
> > +				tail =3D cq->ibcq.cqe - 1;
> > +			curr_cqe =3D get_cqe(cq, curr);
> > +			if ((curr_cqe->qp & 0xFFFF) !=3D qp->qp_handle) {
> > +				if (curr !=3D tail) {
> > +					cqe =3D get_cqe(cq, tail);
> > +					*cqe =3D *curr_cqe;
> > +				}
> > +				tail--;
> > +			} else {
> > +				pvrdma_idx_ring_inc(
> > +					&cq->ring_state->rx.cons_head,
> > +					cq->ibcq.cqe);
> > +			}
> > +			curr--;
> > +		}
> > +	}
> > +}
> > +
> > +static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp
> **cur_qp,
> > +			   struct ib_wc *wc)
> > +{
> > +	struct pvrdma_dev *dev =3D to_vdev(cq->ibcq.device);
> > +	int has_data;
> > +	unsigned int head;
> > +	bool tried =3D false;
> > +	struct pvrdma_cqe *cqe;
> > +
> > +retry:
> > +	has_data =3D pvrdma_idx_ring_has_data(&cq->ring_state->rx,
> > +					    cq->ibcq.cqe, &head);
> > +	if (has_data =3D=3D 0) {
> > +		u32 val;
> > +
> > +		if (tried)
> > +			return -EAGAIN;
> > +
> > +		/* Pass down POLL to give physical HCA a chance to poll. */
> > +		val =3D cq->cq_handle | PVRDMA_UAR_CQ_POLL;
> > +		writel(cpu_to_le32(val),
> > +		       dev->driver_uar.map + PVRDMA_UAR_CQ_OFFSET);
> > +
> > +		tried =3D true;
> > +		goto retry;
> > +	} else if (has_data =3D=3D PVRDMA_INVALID_IDX) {
> > +		/* Ring state could be corrupted. Treat as unrecoverable. */
> > +		return -EINVAL;
>=20
> Please try your best not to return anything but 0 or -EAGAIN from this
> function.
> Returning -EINVAL will cause caller (pvrdma_poll_cq) to drop all successi=
ve
> CQE in tn batch.

This reason I want to return -EINVAL here is that its possible that the rin=
g state is
corrupted so any successive calls to poll_cq will likely not give any valid=
 data.
If that means successive CQEs are dropped then that should be okay since we=
 have
no idea now which CQEs were consumed.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
