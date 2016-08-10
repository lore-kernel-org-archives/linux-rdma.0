From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 11/15] IB/pvrdma: Add Queue Pair support
Date: Wed, 10 Aug 2016 07:16:40 +0300
Message-ID: <20160810041640.GG23921@leon.nu>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-12-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266864-16888-12-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 04:27:40PM -0700, Adit Ranadive wrote:
> This patch adds the ability to create, modify, query and destroy QPs. The
> PVRDMA device supports RC, UD and GSI QPs.
>=20
> Changes v2->v3:
>  - Removed boolean in pvrdma_cmd_post.
>=20
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/pvrdma/pvrdma_qp.c | 975 +++++++++++++++++++++++++=
++++++
>  1 file changed, 975 insertions(+)
>  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_qp.c
>=20
> diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_qp.c b/drivers/infiniban=
d/hw/pvrdma/pvrdma_qp.c
> new file mode 100644
> index 0000000..59acb5c
> --- /dev/null
> +++ b/drivers/infiniband/hw/pvrdma/pvrdma_qp.c
> @@ -0,0 +1,975 @@
> +/*
> + * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of EITHER the GNU General Public License
> + * version 2 as published by the Free Software Foundation or the BSD
> + * 2-Clause License. This program is distributed in the hope that it
> + * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
> + * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License version 2 for more details at
> + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program available in the file COPYING in the main
> + * directory of this source tree.
> + *
> + * The BSD 2-Clause License
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> + * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> + * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
> + * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> + * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
> + * OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +#include <asm/page.h>
> +#include <linux/io.h>
> +#include <linux/wait.h>
> +#include <rdma/ib_addr.h>
> +#include <rdma/ib_smi.h>
> +#include <rdma/ib_user_verbs.h>
> +
> +#include "pvrdma.h"
> +#include "pvrdma_user.h"
> +
> +static inline void get_cqs(struct pvrdma_qp *qp, struct pvrdma_cq **send=
_cq,
> +			   struct pvrdma_cq **recv_cq)
> +{
> +	*send_cq =3D to_vcq(qp->ibqp.send_cq);
> +	*recv_cq =3D to_vcq(qp->ibqp.recv_cq);
> +}
> +
> +static void pvrdma_reset_qp(struct pvrdma_qp *qp)
> +{
> +	struct pvrdma_cq *scq, *rcq;
> +	unsigned long flags;
> +
> +	/* Clean up cqes */
> +	get_cqs(qp, &scq, &rcq);
> +	spin_lock_irqsave(&scq->cq_lock, flags);
> +	pvrdma_flush_cqe(qp, scq);

The preference is to call functions which require locks to be held
before executing them in _func_name() format and not as you called func_nam=
e().

> +	spin_unlock_irqrestore(&scq->cq_lock, flags);
> +	if (rcq !=3D scq) {
> +		spin_lock_irqsave(&rcq->cq_lock, flags);
> +		pvrdma_flush_cqe(qp, rcq);
> +		spin_unlock_irqrestore(&rcq->cq_lock, flags);
> +	}
> +
> +	/*
> +	 * Reset queuepair. The checks are because usermode queuepairs won't
> +	 * have kernel ringstates.
> +	 */
> +	if (qp->rq.ring) {
> +		atomic_set(&qp->rq.ring->cons_head, 0);
> +		atomic_set(&qp->rq.ring->prod_tail, 0);
> +	}
> +	if (qp->sq.ring) {
> +		atomic_set(&qp->sq.ring->cons_head, 0);
> +		atomic_set(&qp->sq.ring->prod_tail, 0);
> +	}
> +}
> +
> +static int pvrdma_set_rq_size(struct pvrdma_dev *dev,
> +			      struct ib_qp_cap *cap,
> +			      struct pvrdma_qp *qp)
> +{
> +	if (cap->max_recv_wr > dev->dsr->caps.max_qp_wr ||
> +	    cap->max_recv_sge > dev->dsr->caps.max_sge) {
> +		dev_warn(&dev->pdev->dev, "recv queue size invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	qp->rq.wqe_cnt =3D roundup_pow_of_two(max(1U, cap->max_recv_wr));
> +	qp->rq.max_gs =3D roundup_pow_of_two(max(1U, cap->max_recv_sge));
> +
> +	/* Write back */
> +	cap->max_recv_wr =3D qp->rq.wqe_cnt;
> +	cap->max_recv_sge =3D qp->rq.max_gs;
> +
> +	qp->rq.wqe_size =3D roundup_pow_of_two(sizeof(struct pvrdma_rq_wqe_hdr)=
 +
> +					     sizeof(struct ib_sge) *
> +					     qp->rq.max_gs);
> +	qp->npages_recv =3D (qp->rq.wqe_cnt * qp->rq.wqe_size + PAGE_SIZE - 1) /
> +			  PAGE_SIZE;
> +
> +	return 0;
> +}
> +
> +static int pvrdma_set_sq_size(struct pvrdma_dev *dev, struct ib_qp_cap *=
cap,
> +			      enum ib_qp_type type, struct pvrdma_qp *qp)
> +{
> +	if (cap->max_send_wr > dev->dsr->caps.max_qp_wr ||
> +	    cap->max_send_sge > dev->dsr->caps.max_sge) {
> +		dev_warn(&dev->pdev->dev, "send queue size invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	qp->sq.wqe_cnt =3D roundup_pow_of_two(max(1U, cap->max_send_wr));
> +	qp->sq.max_gs =3D roundup_pow_of_two(max(1U, cap->max_send_sge));
> +
> +	/* Write back */
> +	cap->max_send_wr =3D qp->sq.wqe_cnt;
> +	cap->max_send_sge =3D qp->sq.max_gs;
> +
> +	qp->sq.wqe_size =3D roundup_pow_of_two(sizeof(struct pvrdma_sq_wqe_hdr)=
 +
> +					     sizeof(struct ib_sge) *
> +					     qp->sq.max_gs);
> +	/* Note: one extra page for the header. */
> +	qp->npages_send =3D 1 + (qp->sq.wqe_cnt * qp->sq.wqe_size +
> +			       PAGE_SIZE - 1) / PAGE_SIZE;
> +
> +	return 0;
> +}
> +
> +/**
> + * pvrdma_create_qp - create queue pair
> + * @pd: protection domain
> + * @init_attr: queue pair attributes
> + * @udata: user data
> + *
> + * @return: the ib_qp pointer on success, otherwise returns an errno.
> + */
> +struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
> +			       struct ib_qp_init_attr *init_attr,
> +			       struct ib_udata *udata)
> +{
> +	struct pvrdma_qp *qp;
> +	struct pvrdma_dev *dev =3D to_vdev(pd->device);
> +	struct pvrdma_cq *send_cq, *recv_cq;
> +	union pvrdma_cmd_req req;
> +	union pvrdma_cmd_resp rsp;
> +	struct pvrdma_cmd_create_qp *cmd =3D &req.create_qp;
> +	struct pvrdma_cmd_create_qp_resp *resp =3D &rsp.create_qp_resp;
> +	struct pvrdma_create_qp ucmd;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (!atomic_add_unless(&dev->num_qps, 1, dev->dsr->caps.max_qp))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (init_attr->create_flags) {
> +		dev_warn(&dev->pdev->dev,
> +			 "invalid create queuepair flags %#x\n",
> +			 init_attr->create_flags);
> +		atomic_dec(&dev->num_qps);
> +		return ERR_PTR(-EINVAL);

Declare qp =3D=3D NULL and use one exit point (goto err_qp), you are doing
the same for all returns.

> +	}
> +
> +	if (init_attr->qp_type !=3D IB_QPT_RC &&
> +	    init_attr->qp_type !=3D IB_QPT_UD &&
> +	    init_attr->qp_type !=3D IB_QPT_GSI) {
> +		dev_warn(&dev->pdev->dev, "queuepair type %d not supported\n",
> +			 init_attr->qp_type);
> +		atomic_dec(&dev->num_qps);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	switch (init_attr->qp_type) {
> +	case IB_QPT_GSI:
> +		if (init_attr->port_num =3D=3D 0 ||
> +		    init_attr->port_num > pd->device->phys_port_cnt ||
> +		    udata) {
> +			dev_warn(&dev->pdev->dev, "invalid queuepair attrs\n");
> +			atomic_dec(&dev->num_qps);
> +			return ERR_PTR(-EINVAL);
> +		}
> +		/* fall through */
> +	case IB_QPT_RC:
> +	case IB_QPT_UD:
> +		qp =3D kzalloc(sizeof(*qp), GFP_KERNEL);
> +		if (!qp) {
> +			atomic_dec(&dev->num_qps);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +
> +		spin_lock_init(&qp->sq.lock);
> +		spin_lock_init(&qp->rq.lock);
> +		mutex_init(&qp->mutex);
> +		atomic_set(&qp->refcnt, 1);
> +		init_waitqueue_head(&qp->wait);
> +
> +		qp->state =3D IB_QPS_RESET;
> +
> +		if (pd->uobject && udata) {
> +			dev_dbg(&dev->pdev->dev,
> +				"create queuepair from user space\n");
> +
> +			if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
> +				ret =3D -EFAULT;
> +				goto err_qp;
> +			}
> +
> +			/* set qp->sq.wqe_cnt, shift, buf_size.. */
> +			qp->rumem =3D ib_umem_get(pd->uobject->context,
> +						ucmd.rbuf_addr,
> +						ucmd.rbuf_size, 0, 0);
> +			if (IS_ERR(qp->rumem)) {
> +				ret =3D PTR_ERR(qp->rumem);
> +				goto err_qp;
> +			}
> +
> +			qp->sumem =3D ib_umem_get(pd->uobject->context,
> +						ucmd.sbuf_addr,
> +						ucmd.sbuf_size, 0, 0);
> +			if (IS_ERR(qp->sumem)) {
> +				ib_umem_release(qp->rumem);
> +				ret =3D PTR_ERR(qp->sumem);
> +				goto err_qp;
> +			}
> +
> +			qp->npages_send =3D ib_umem_page_count(qp->sumem);
> +			qp->npages_recv =3D ib_umem_page_count(qp->rumem);
> +			qp->npages =3D qp->npages_send + qp->npages_recv;
> +		} else {
> +			qp->is_kernel =3D true;
> +
> +			send_cq =3D to_vcq(init_attr->send_cq);
> +			recv_cq =3D to_vcq(init_attr->recv_cq);
> +
> +			ret =3D pvrdma_set_sq_size(to_vdev(pd->device),
> +						 &init_attr->cap,
> +						 init_attr->qp_type, qp);
> +			if (ret)
> +				goto err_qp;
> +
> +			ret =3D pvrdma_set_rq_size(to_vdev(pd->device),
> +						 &init_attr->cap, qp);
> +			if (ret)
> +				goto err_qp;
> +
> +			qp->npages =3D qp->npages_send + qp->npages_recv;
> +
> +			/* Skip header page. */
> +			qp->sq.offset =3D PAGE_SIZE;
> +
> +			/* Recv queue pages are after send pages. */
> +			qp->rq.offset =3D qp->npages_send * PAGE_SIZE;
> +		}
> +
> +		if (qp->npages < 0 || qp->npages > PVRDMA_PAGE_DIR_MAX_PAGES) {
> +			dev_warn(&dev->pdev->dev,
> +				 "overflow pages in queuepair\n");
> +			goto err_umem;
> +		}
> +
> +		ret =3D pvrdma_page_dir_init(dev, &qp->pdir, qp->npages,
> +					   qp->is_kernel);
> +		if (ret) {
> +			dev_warn(&dev->pdev->dev,
> +				 "could not allocate page directory\n");
> +			goto err_umem;
> +		}
> +
> +		if (!qp->is_kernel) {
> +			pvrdma_page_dir_insert_umem(&qp->pdir, qp->sumem, 0);
> +			pvrdma_page_dir_insert_umem(&qp->pdir, qp->rumem,
> +						    qp->npages_send);
> +		} else {
> +			/* Ring state is always the first page. */
> +			qp->sq.ring =3D qp->pdir.pages[0];
> +			qp->rq.ring =3D &qp->sq.ring[1];
> +		}
> +		break;
> +	default:
> +		atomic_dec(&dev->num_qps);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	/* Not supported */
> +	init_attr->cap.max_inline_data =3D 0;
> +
> +	memset(cmd, 0, sizeof(*cmd));
> +	cmd->hdr.cmd =3D PVRDMA_CMD_CREATE_QP;
> +	cmd->pd_handle =3D to_vpd(pd)->pd_handle;
> +	cmd->send_cq_handle =3D to_vcq(init_attr->send_cq)->cq_handle;
> +	cmd->recv_cq_handle =3D to_vcq(init_attr->recv_cq)->cq_handle;
> +	cmd->srq_handle =3D 0;
> +	cmd->max_send_wr =3D init_attr->cap.max_send_wr;
> +	cmd->max_recv_wr =3D init_attr->cap.max_recv_wr;
> +	cmd->max_send_sge =3D init_attr->cap.max_send_sge;
> +	cmd->max_recv_sge =3D init_attr->cap.max_recv_sge;
> +	cmd->max_inline_data =3D init_attr->cap.max_inline_data;
> +	cmd->sq_sig_all =3D (init_attr->sq_sig_type =3D=3D IB_SIGNAL_ALL_WR) ? =
1 : 0;
> +	cmd->qp_type =3D ib_qp_type_to_pvrdma(init_attr->qp_type);
> +	cmd->is_srq =3D 0; /* No support */
> +	cmd->lkey =3D 0;
> +	cmd->access_flags =3D IB_ACCESS_LOCAL_WRITE;
> +	cmd->total_chunks =3D qp->npages;
> +	cmd->send_chunks =3D qp->npages_send - 1;
> +	cmd->pdir_dma =3D qp->pdir.dir_dma;
> +
> +	dev_dbg(&dev->pdev->dev, "create queuepair with %d, %d, %d, %d\n",
> +		cmd->max_send_wr, cmd->max_recv_wr, cmd->max_send_sge,
> +		cmd->max_recv_sge);
> +
> +	ret =3D pvrdma_cmd_post(dev, &req, &rsp);
> +
> +	if (ret < 0 || resp->hdr.ack !=3D PVRDMA_CMD_CREATE_QP_RESP) {
> +		dev_warn(&dev->pdev->dev, "could not create queuepair\n");
> +		goto err_pdir;
> +	}
> +
> +	/* max_send_wr/_recv_wr/_send_sge/_recv_sge/_inline_data */
> +	qp->qp_handle =3D resp->qpn;
> +	qp->port =3D init_attr->port_num;
> +	qp->ibqp.qp_num =3D resp->qpn;
> +	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
> +	dev->qp_tbl[qp->qp_handle % dev->dsr->caps.max_qp] =3D qp;
> +	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
> +
> +	return &qp->ibqp;
> +
> +err_pdir:
> +	pvrdma_page_dir_cleanup(dev, &qp->pdir);
> +err_umem:
> +	if (pd->uobject && udata) {
> +		if (qp->rumem)
> +			ib_umem_release(qp->rumem);
> +		if (qp->sumem)
> +			ib_umem_release(qp->sumem);
> +	}
> +err_qp:
> +	kfree(qp);
> +	atomic_dec(&dev->num_qps);
> +
> +	return ERR_PTR(ret);
> +}
> +
> +static void pvrdma_free_qp(struct pvrdma_qp *qp)
> +{
> +	struct pvrdma_dev *dev =3D to_vdev(qp->ibqp.device);
> +	struct pvrdma_cq *scq;
> +	struct pvrdma_cq *rcq;
> +	unsigned long flags, flags1, flags2;
> +
> +	/* In case cq is polling */
> +	get_cqs(qp, &scq, &rcq);
> +	if ((uintptr_t)scq <=3D (uintptr_t)rcq) {
> +		spin_lock_irqsave(&scq->cq_lock, flags1);
> +		pvrdma_flush_cqe(qp, scq);
> +		if (rcq !=3D scq) {
> +			spin_lock_irqsave(&rcq->cq_lock, flags2);
> +			pvrdma_flush_cqe(qp, rcq);
> +		}
> +	} else {
> +		spin_lock_irqsave(&rcq->cq_lock, flags2);
> +		pvrdma_flush_cqe(qp, rcq);
> +		spin_lock_irqsave(&scq->cq_lock, flags1);
> +		pvrdma_flush_cqe(qp, scq);
> +	}
> +
> +	spin_lock_irqsave(&dev->qp_tbl_lock, flags);
> +	dev->qp_tbl[qp->qp_handle] =3D NULL;
> +	spin_unlock_irqrestore(&dev->qp_tbl_lock, flags);
> +
> +	if ((uintptr_t)scq <=3D (uintptr_t)rcq) {
> +		if (rcq !=3D scq)
> +			spin_unlock_irqrestore(&rcq->cq_lock, flags2);
> +		spin_unlock_irqrestore(&scq->cq_lock, flags1);
> +	} else {
> +		spin_unlock_irqrestore(&scq->cq_lock, flags1);
> +		spin_unlock_irqrestore(&rcq->cq_lock, flags2);
> +	}
> +
> +	atomic_dec(&qp->refcnt);
> +	wait_event(qp->wait, !atomic_read(&qp->refcnt));
> +
> +	pvrdma_page_dir_cleanup(dev, &qp->pdir);
> +
> +	kfree(qp);
> +
> +	atomic_dec(&dev->num_qps);
> +}
> +
> +/**
> + * pvrdma_destroy_qp - destroy a queue pair
> + * @qp: the queue pair to destroy
> + *
> + * @return: 0 on success.
> + */
> +int pvrdma_destroy_qp(struct ib_qp *qp)
> +{
> +	struct pvrdma_qp *vqp =3D to_vqp(qp);
> +	union pvrdma_cmd_req req;
> +	struct pvrdma_cmd_destroy_qp *cmd =3D &req.destroy_qp;
> +	int ret;
> +
> +	memset(cmd, 0, sizeof(*cmd));
> +	cmd->hdr.cmd =3D PVRDMA_CMD_DESTROY_QP;
> +	cmd->qp_handle =3D vqp->qp_handle;
> +
> +	ret =3D pvrdma_cmd_post(to_vdev(qp->device), &req, NULL);
> +	if (ret < 0) {
> +		struct pvrdma_dev *dev =3D to_vdev(qp->device);
> +
> +		dev_warn(&dev->pdev->dev, "destroy queuepair failed\n");
> +	}
> +
> +	pvrdma_free_qp(vqp);
> +
> +	return 0;
> +}
> +
> +/**
> + * pvrdma_modify_qp - modify queue pair attributes
> + * @ibqp: the queue pair
> + * @attr: the new queue pair's attributes
> + * @attr_mask: attributes mask
> + * @udata: user data
> + *
> + * @returns 0 on success, otherwise returns an errno.
> + */
> +int pvrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
> +		     int attr_mask, struct ib_udata *udata)
> +{
> +	struct pvrdma_dev *dev =3D to_vdev(ibqp->device);
> +	struct pvrdma_qp *qp =3D to_vqp(ibqp);
> +	union pvrdma_cmd_req req;
> +	union pvrdma_cmd_resp rsp;
> +	struct pvrdma_cmd_modify_qp *cmd =3D &req.modify_qp;
> +	int cur_state, next_state;
> +	int ret;
> +
> +	/* Sanity checking. Should need lock here */
> +	mutex_lock(&qp->mutex);
> +	cur_state =3D (attr_mask & IB_QP_CUR_STATE) ? attr->cur_qp_state :
> +		qp->state;
> +	next_state =3D (attr_mask & IB_QP_STATE) ? attr->qp_state : cur_state;
> +
> +	if (!ib_modify_qp_is_ok(cur_state, next_state, ibqp->qp_type,
> +				attr_mask, IB_LINK_LAYER_ETHERNET)) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	if (attr_mask & IB_QP_PORT) {
> +		if (attr->port_num =3D=3D 0 ||
> +		    attr->port_num > ibqp->device->phys_port_cnt) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	if (attr_mask & IB_QP_MIN_RNR_TIMER) {
> +		if (attr->min_rnr_timer > 31) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	if (attr_mask & IB_QP_PKEY_INDEX) {
> +		if (attr->pkey_index >=3D dev->dsr->caps.max_pkeys) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	if (attr_mask & IB_QP_QKEY)
> +		qp->qkey =3D attr->qkey;
> +
> +	if (cur_state =3D=3D next_state && cur_state =3D=3D IB_QPS_RESET) {
> +		ret =3D 0;
> +		goto out;
> +	}
> +
> +	switch (next_state) {
> +	case IB_QPS_RESET:
> +	case IB_QPS_INIT:
> +	case IB_QPS_RTR:
> +	case IB_QPS_RTS:
> +	case IB_QPS_SQD:
> +	case IB_QPS_SQE:
> +	case IB_QPS_ERR:
> +	default:

Why do you need such switch-case?

> +		qp->state =3D next_state;
> +		memset(cmd, 0, sizeof(*cmd));
> +		cmd->hdr.cmd =3D PVRDMA_CMD_MODIFY_QP;
> +		cmd->qp_handle =3D qp->qp_handle;
> +		cmd->attr_mask =3D ib_qp_attr_mask_to_pvrdma(attr_mask);
> +		cmd->attrs.qp_state =3D ib_qp_state_to_pvrdma(attr->qp_state);
> +		cmd->attrs.cur_qp_state =3D
> +			ib_qp_state_to_pvrdma(attr->cur_qp_state);
> +		cmd->attrs.path_mtu =3D ib_mtu_to_pvrdma(attr->path_mtu);
> +		cmd->attrs.path_mig_state =3D
> +			ib_mig_state_to_pvrdma(attr->path_mig_state);
> +		cmd->attrs.qkey =3D attr->qkey;
> +		cmd->attrs.rq_psn =3D attr->rq_psn;
> +		cmd->attrs.sq_psn =3D attr->sq_psn;
> +		cmd->attrs.dest_qp_num =3D attr->dest_qp_num;
> +		cmd->attrs.qp_access_flags =3D
> +			ib_access_flags_to_pvrdma(attr->qp_access_flags);
> +		cmd->attrs.pkey_index =3D attr->pkey_index;
> +		cmd->attrs.alt_pkey_index =3D attr->alt_pkey_index;
> +		cmd->attrs.en_sqd_async_notify =3D attr->en_sqd_async_notify;
> +		cmd->attrs.sq_draining =3D attr->sq_draining;
> +		cmd->attrs.max_rd_atomic =3D attr->max_rd_atomic;
> +		cmd->attrs.max_dest_rd_atomic =3D attr->max_dest_rd_atomic;
> +		cmd->attrs.min_rnr_timer =3D attr->min_rnr_timer;
> +		cmd->attrs.port_num =3D attr->port_num;
> +		cmd->attrs.timeout =3D attr->timeout;
> +		cmd->attrs.retry_cnt =3D attr->retry_cnt;
> +		cmd->attrs.rnr_retry =3D attr->rnr_retry;
> +		cmd->attrs.alt_port_num =3D attr->alt_port_num;
> +		cmd->attrs.alt_timeout =3D attr->alt_timeout;
> +		ib_qp_cap_to_pvrdma(&attr->cap, &cmd->attrs.cap);
> +		ib_ah_attr_to_pvrdma(&attr->ah_attr, &cmd->attrs.ah_attr);
> +		ib_ah_attr_to_pvrdma(&attr->alt_ah_attr,
> +				     &cmd->attrs.alt_ah_attr);
> +		ret =3D pvrdma_cmd_post(dev, &req, &rsp);
> +		if (ret < 0 || rsp.hdr.ack !=3D PVRDMA_CMD_MODIFY_QP_RESP ||
> +		    rsp.hdr.err > 0) {
> +			dev_warn(&dev->pdev->dev,
> +				 "could not modify queuepair\n");
> +			if (ret =3D=3D 0) {
> +				if (rsp.hdr.ack !=3D PVRDMA_CMD_MODIFY_QP_RESP)
> +					ret =3D -EINVAL;
> +				else
> +					ret =3D rsp.hdr.err;
> +			}
> +		}
> +
> +		/* Fall through */
> +		break;
> +	}
> +
> +	if (ret =3D=3D 0 && next_state =3D=3D IB_QPS_RESET)
> +		pvrdma_reset_qp(qp);
> +
> +out:
> +	mutex_unlock(&qp->mutex);
> +
> +	return ret;
> +}
> +
> +static inline void *get_sq_wqe(struct pvrdma_qp *qp, int n)
> +{
> +	return pvrdma_page_dir_get_ptr(&qp->pdir,
> +				       qp->sq.offset + n * qp->sq.wqe_size);
> +}
> +
> +static inline void *get_rq_wqe(struct pvrdma_qp *qp, int n)
> +{
> +	return pvrdma_page_dir_get_ptr(&qp->pdir,
> +				       qp->rq.offset + n * qp->rq.wqe_size);
> +}
> +
> +static int set_reg_seg(struct pvrdma_sq_wqe_hdr *wqe_hdr, struct ib_reg_=
wr *wr)
> +{
> +	struct pvrdma_user_mr *mr =3D to_vmr(wr->mr);
> +
> +	wqe_hdr->wr.fast_reg.iova_start =3D mr->ibmr.iova;
> +	wqe_hdr->wr.fast_reg.pl_pdir_dma =3D mr->pdir.dir_dma;
> +	wqe_hdr->wr.fast_reg.page_shift =3D mr->page_shift;
> +	wqe_hdr->wr.fast_reg.page_list_len =3D mr->npages;
> +	wqe_hdr->wr.fast_reg.length =3D mr->ibmr.length;
> +	wqe_hdr->wr.fast_reg.access_flags =3D wr->access;
> +	wqe_hdr->wr.fast_reg.rkey =3D wr->key;
> +
> +	return pvrdma_page_dir_insert_page_list(&mr->pdir, mr->pages,
> +						mr->npages);
> +}
> +
> +/**
> + * pvrdma_post_send - post send work request entries on a QP
> + * @ibqp: the QP
> + * @wr: work request list to post
> + * @bad_wr: the first bad WR returned
> + *
> + * @return: 0 on success, otherwise errno returned.
> + */
> +int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
> +		     struct ib_send_wr **bad_wr)
> +{
> +	struct pvrdma_qp *qp =3D to_vqp(ibqp);
> +	struct pvrdma_dev *dev =3D to_vdev(ibqp->device);
> +	unsigned long flags;
> +	struct pvrdma_sq_wqe_hdr *wqe_hdr;
> +	struct ib_sge *sge;
> +	int i, index;
> +	int nreq;
> +	int ret;
> +
> +	/*
> +	 * In states lower than RTS, we can fail immediately. In other states,
> +	 * just post and let the device figure it out.
> +	 */
> +	if (qp->state < IB_QPS_RTS) {
> +		*bad_wr =3D wr;
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&qp->sq.lock, flags);
> +
> +	index =3D pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
> +	for (nreq =3D 0; wr; nreq++, wr =3D wr->next) {
> +		unsigned int tail;
> +
> +		if (unlikely(!pvrdma_idx_ring_has_space(
> +				qp->sq.ring, qp->sq.wqe_cnt, &tail))) {
> +			dev_warn(&dev->pdev->dev, "send queue is full\n");
> +			*bad_wr =3D wr;
> +			ret =3D -ENOMEM;
> +			goto out;
> +		}
> +
> +		if (unlikely(wr->num_sge > qp->sq.max_gs || wr->num_sge < 0)) {
> +			dev_warn(&dev->pdev->dev, "send SGE overflow\n");
> +			*bad_wr =3D wr;
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
> +		if (unlikely(wr->opcode < 0)) {
> +			dev_warn(&dev->pdev->dev, "invalid send opcode\n");
> +			*bad_wr =3D wr;
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
> +		/*
> +		 * Only support UD, RC.
> +		 * Need to check opcode table for thorough checking.
> +		 * opcode		_UD	_UC	_RC
> +		 * _SEND		x	x	x
> +		 * _SEND_WITH_IMM	x	x	x
> +		 * _RDMA_WRITE			x	x
> +		 * _RDMA_WRITE_WITH_IMM		x	x
> +		 * _LOCAL_INV			x	x
> +		 * _SEND_WITH_INV		x	x
> +		 * _RDMA_READ				x
> +		 * _ATOMIC_CMP_AND_SWP			x
> +		 * _ATOMIC_FETCH_AND_ADD		x
> +		 * _MASK_ATOMIC_CMP_AND_SWP		x
> +		 * _MASK_ATOMIC_FETCH_AND_ADD		x
> +		 * _REG_MR				x
> +		 *
> +		 */
> +		if (qp->ibqp.qp_type !=3D IB_QPT_UD &&
> +		    qp->ibqp.qp_type !=3D IB_QPT_RC &&
> +			wr->opcode !=3D IB_WR_SEND) {
> +			dev_warn(&dev->pdev->dev,
> +				 "unsupported queuepair type\n");
> +			*bad_wr =3D wr;
> +			ret =3D -EINVAL;
> +			goto out;
> +		} else if (qp->ibqp.qp_type =3D=3D IB_QPT_UD ||
> +			   qp->ibqp.qp_type =3D=3D IB_QPT_GSI) {
> +			if (wr->opcode !=3D IB_WR_SEND &&
> +			    wr->opcode !=3D IB_WR_SEND_WITH_IMM) {
> +				dev_warn(&dev->pdev->dev,
> +					 "invalid send opcode\n");
> +				*bad_wr =3D wr;
> +				ret =3D -EINVAL;
> +				goto out;
> +			}
> +		}
> +
> +		wqe_hdr =3D (struct pvrdma_sq_wqe_hdr *)get_sq_wqe(qp, index);
> +		memset(wqe_hdr, 0, sizeof(*wqe_hdr));
> +		wqe_hdr->wr_id =3D wr->wr_id;
> +		wqe_hdr->num_sge =3D wr->num_sge;
> +		wqe_hdr->opcode =3D ib_wr_opcode_to_pvrdma(wr->opcode);
> +		wqe_hdr->send_flags =3D ib_send_flags_to_pvrdma(wr->send_flags);
> +		if (wr->opcode =3D=3D IB_WR_SEND_WITH_IMM ||
> +		    wr->opcode =3D=3D IB_WR_RDMA_WRITE_WITH_IMM)
> +			wqe_hdr->ex.imm_data =3D wr->ex.imm_data;
> +
> +		switch (qp->ibqp.qp_type) {
> +		case IB_QPT_GSI:
> +		case IB_QPT_UD:
> +			if (unlikely(!ud_wr(wr)->ah)) {
> +				dev_warn(&dev->pdev->dev,
> +					 "invalid address handle\n");
> +				*bad_wr =3D wr;
> +				ret =3D -EINVAL;
> +				goto out;
> +			}
> +
> +			/*
> +			 * Use qkey from qp context if high order bit set,
> +			 * otherwise from work request.
> +			 */
> +			wqe_hdr->wr.ud.remote_qpn =3D ud_wr(wr)->remote_qpn;
> +			wqe_hdr->wr.ud.remote_qkey =3D
> +				ud_wr(wr)->remote_qkey & 0x80000000 ?
> +				qp->qkey : ud_wr(wr)->remote_qkey;
> +			wqe_hdr->wr.ud.av =3D to_vah(ud_wr(wr)->ah)->av;
> +
> +			break;
> +		case IB_QPT_RC:
> +			switch (wr->opcode) {
> +			case IB_WR_RDMA_READ:
> +			case IB_WR_RDMA_WRITE:
> +			case IB_WR_RDMA_WRITE_WITH_IMM:
> +				wqe_hdr->wr.rdma.remote_addr =3D
> +					rdma_wr(wr)->remote_addr;
> +				wqe_hdr->wr.rdma.rkey =3D rdma_wr(wr)->rkey;
> +				break;
> +			case IB_WR_LOCAL_INV:
> +			case IB_WR_SEND_WITH_INV:
> +				wqe_hdr->ex.invalidate_rkey =3D
> +					wr->ex.invalidate_rkey;
> +				break;
> +			case IB_WR_ATOMIC_CMP_AND_SWP:
> +			case IB_WR_ATOMIC_FETCH_AND_ADD:
> +				wqe_hdr->wr.atomic.remote_addr =3D
> +					atomic_wr(wr)->remote_addr;
> +				wqe_hdr->wr.atomic.rkey =3D atomic_wr(wr)->rkey;
> +				wqe_hdr->wr.atomic.compare_add =3D
> +					atomic_wr(wr)->compare_add;
> +				if (wr->opcode =3D=3D IB_WR_ATOMIC_CMP_AND_SWP)
> +					wqe_hdr->wr.atomic.swap =3D
> +						atomic_wr(wr)->swap;
> +				break;
> +			case IB_WR_REG_MR:
> +				ret =3D set_reg_seg(wqe_hdr, reg_wr(wr));
> +				if (ret < 0) {
> +					dev_warn(&dev->pdev->dev,
> +						 "Failed to set fast register work request\n");
> +					*bad_wr =3D wr;
> +					goto out;
> +				}
> +				break;
> +			default:
> +				break;
> +			}
> +
> +			break;
> +		default:
> +			dev_warn(&dev->pdev->dev, "invalid queuepair type\n");
> +			ret =3D -EINVAL;
> +			*bad_wr =3D wr;
> +			goto out;
> +		}
> +
> +		sge =3D (struct ib_sge *)(wqe_hdr + 1);
> +		for (i =3D 0; i < wr->num_sge; i++) {
> +			/* Need to check wqe_size 0 or max size */
> +			sge->addr =3D wr->sg_list[i].addr;
> +			sge->length =3D wr->sg_list[i].length;
> +			sge->lkey =3D wr->sg_list[i].lkey;
> +			sge++;
> +		}
> +
> +		/* Make sure wqe is written before index update */
> +		smp_wmb();
> +
> +		index++;
> +		if (unlikely(index >=3D qp->sq.wqe_cnt))
> +			index =3D 0;
> +		/* Update shared sq ring */
> +		pvrdma_idx_ring_inc(&qp->sq.ring->prod_tail,
> +				    qp->sq.wqe_cnt);
> +	}
> +
> +	ret =3D 0;
> +
> +out:
> +	spin_unlock_irqrestore(&qp->sq.lock, flags);
> +
> +	if (!ret)
> +		writel(cpu_to_le32(PVRDMA_UAR_QP_SEND | qp->qp_handle),
> +		       dev->driver_uar.map + PVRDMA_UAR_QP_OFFSET);
> +
> +	return ret;
> +}
> +
> +/**
> + * pvrdma_post_receive - post receive work request entries on a QP
> + * @ibqp: the QP
> + * @wr: the work request list to post
> + * @bad_wr: the first bad WR returned
> + *
> + * @return: 0 on success, otherwise errno returned.
> + */
> +int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
> +		     struct ib_recv_wr **bad_wr)
> +{
> +	struct pvrdma_dev *dev =3D to_vdev(ibqp->device);
> +	unsigned long flags;
> +	struct pvrdma_qp *qp =3D to_vqp(ibqp);
> +	struct pvrdma_rq_wqe_hdr *wqe_hdr;
> +	struct ib_sge *sge;
> +	int index, nreq;
> +	int ret =3D 0;
> +	int i;
> +
> +	/*
> +	 * In the RESET state, we can fail immediately. For other states,
> +	 * just post and let the device figure it out.
> +	 */
> +	if (qp->state =3D=3D IB_QPS_RESET) {
> +		*bad_wr =3D wr;
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&qp->rq.lock, flags);
> +
> +	index =3D pvrdma_idx(&qp->rq.ring->prod_tail, qp->rq.wqe_cnt);
> +	for (nreq =3D 0; wr; nreq++, wr =3D wr->next) {
> +		unsigned int tail;
> +
> +		if (unlikely(wr->num_sge > qp->rq.max_gs ||
> +			     wr->num_sge < 0)) {
> +			ret =3D -EINVAL;
> +			*bad_wr =3D wr;
> +			dev_warn(&dev->pdev->dev, "recv SGE overflow\n");
> +			goto out;
> +		}
> +
> +		if (unlikely(!pvrdma_idx_ring_has_space(
> +				qp->rq.ring, qp->rq.wqe_cnt, &tail))) {
> +			ret =3D -ENOMEM;
> +			*bad_wr =3D wr;
> +			dev_warn(&dev->pdev->dev, "recv queue full\n");
> +			goto out;
> +		}
> +
> +		wqe_hdr =3D (struct pvrdma_rq_wqe_hdr *)get_rq_wqe(qp, index);
> +		wqe_hdr->wr_id =3D wr->wr_id;
> +		wqe_hdr->num_sge =3D wr->num_sge;
> +		wqe_hdr->total_len =3D 0;
> +
> +		sge =3D (struct ib_sge *)(wqe_hdr + 1);
> +		for (i =3D 0; i < wr->num_sge; i++) {
> +			sge->addr =3D wr->sg_list[i].addr;
> +			sge->length =3D wr->sg_list[i].length;
> +			sge->lkey =3D wr->sg_list[i].lkey;
> +			sge++;
> +		}
> +
> +		/* Make sure wqe is written before index update */
> +		smp_wmb();
> +
> +		index++;
> +		if (unlikely(index >=3D qp->rq.wqe_cnt))
> +			index =3D 0;
> +		/* Update shared rq ring */
> +		pvrdma_idx_ring_inc(&qp->rq.ring->prod_tail,
> +				    qp->rq.wqe_cnt);
> +	}
> +
> +	spin_unlock_irqrestore(&qp->rq.lock, flags);
> +
> +	writel(cpu_to_le32(PVRDMA_UAR_QP_RECV | qp->qp_handle),
> +	       dev->driver_uar.map + PVRDMA_UAR_QP_OFFSET);
> +
> +	return ret;
> +
> +out:
> +	spin_unlock_irqrestore(&qp->rq.lock, flags);
> +
> +	return ret;
> +}
> +
> +/**
> + * pvrdma_query_qp - query a queue pair's attributes
> + * @ibqp: the queue pair to query
> + * @attr: the queue pair's attributes
> + * @attr_mask: attributes mask
> + * @init_attr: initial queue pair attributes
> + *
> + * @returns 0 on success, otherwise returns an errno.
> + */
> +int pvrdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
> +		    int attr_mask, struct ib_qp_init_attr *init_attr)
> +{
> +	struct pvrdma_dev *dev =3D to_vdev(ibqp->device);
> +	struct pvrdma_qp *qp =3D to_vqp(ibqp);
> +	union pvrdma_cmd_req req;
> +	union pvrdma_cmd_resp rsp;
> +	struct pvrdma_cmd_query_qp *cmd =3D &req.query_qp;
> +	struct pvrdma_cmd_query_qp_resp *resp =3D &rsp.query_qp_resp;
> +	int ret =3D 0;
> +
> +	mutex_lock(&qp->mutex);
> +
> +	if (qp->state =3D=3D IB_QPS_RESET) {
> +		attr->qp_state =3D IB_QPS_RESET;
> +		goto out;
> +	}
> +
> +	memset(cmd, 0, sizeof(*cmd));
> +	cmd->hdr.cmd =3D PVRDMA_CMD_QUERY_QP;
> +	cmd->qp_handle =3D qp->qp_handle;
> +	cmd->attr_mask =3D ib_qp_attr_mask_to_pvrdma(attr_mask);
> +
> +	ret =3D pvrdma_cmd_post(dev, &req, &rsp);
> +	if (ret < 0 || resp->hdr.ack !=3D PVRDMA_CMD_QUERY_QP_RESP) {
> +		dev_warn(&dev->pdev->dev, "could not query queuepair\n");
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	attr->qp_state =3D pvrdma_qp_state_to_ib(resp->attrs.qp_state);
> +	attr->cur_qp_state =3D
> +		pvrdma_qp_state_to_ib(resp->attrs.cur_qp_state);
> +	attr->path_mtu =3D pvrdma_mtu_to_ib(resp->attrs.path_mtu);
> +	attr->path_mig_state =3D
> +		pvrdma_mig_state_to_ib(resp->attrs.path_mig_state);
> +	attr->qkey =3D resp->attrs.qkey;
> +	attr->rq_psn =3D resp->attrs.rq_psn;
> +	attr->sq_psn =3D resp->attrs.sq_psn;
> +	attr->dest_qp_num =3D resp->attrs.dest_qp_num;
> +	attr->qp_access_flags =3D
> +		pvrdma_access_flags_to_ib(resp->attrs.qp_access_flags);
> +	attr->pkey_index =3D resp->attrs.pkey_index;
> +	attr->alt_pkey_index =3D resp->attrs.alt_pkey_index;
> +	attr->en_sqd_async_notify =3D resp->attrs.en_sqd_async_notify;
> +	attr->sq_draining =3D resp->attrs.sq_draining;
> +	attr->max_rd_atomic =3D resp->attrs.max_rd_atomic;
> +	attr->max_dest_rd_atomic =3D resp->attrs.max_dest_rd_atomic;
> +	attr->min_rnr_timer =3D resp->attrs.min_rnr_timer;
> +	attr->port_num =3D resp->attrs.port_num;
> +	attr->timeout =3D resp->attrs.timeout;
> +	attr->retry_cnt =3D resp->attrs.retry_cnt;
> +	attr->rnr_retry =3D resp->attrs.rnr_retry;
> +	attr->alt_port_num =3D resp->attrs.alt_port_num;
> +	attr->alt_timeout =3D resp->attrs.alt_timeout;
> +	pvrdma_qp_cap_to_ib(&resp->attrs.cap, &attr->cap);
> +	pvrdma_ah_attr_to_ib(&resp->attrs.ah_attr, &attr->ah_attr);
> +	pvrdma_ah_attr_to_ib(&resp->attrs.alt_ah_attr, &attr->alt_ah_attr);
> +
> +	qp->state =3D attr->qp_state;
> +
> +	ret =3D 0;
> +
> +out:
> +	attr->cur_qp_state =3D attr->qp_state;
> +
> +	init_attr->event_handler =3D qp->ibqp.event_handler;
> +	init_attr->qp_context =3D qp->ibqp.qp_context;
> +	init_attr->send_cq =3D qp->ibqp.send_cq;
> +	init_attr->recv_cq =3D qp->ibqp.recv_cq;
> +	init_attr->srq =3D qp->ibqp.srq;
> +	init_attr->xrcd =3D NULL;
> +	init_attr->cap =3D attr->cap;
> +	init_attr->sq_sig_type =3D 0;
> +	init_attr->qp_type =3D qp->ibqp.qp_type;
> +	init_attr->create_flags =3D 0;
> +	init_attr->port_num =3D qp->port;
> +
> +	mutex_unlock(&qp->mutex);
> +	return ret;
> +}
> --=20
> 2.7.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqqqoAAoJEORje4g2clinEhUQAKeMcjDztsE9atdU78nAnE6v
HOZEVS3xH41ikGg2S7fvstj7MX+p8Lr98JzKGalOduES5uUgzKRyg+x8HA2VnClm
bhDU/df+bR0aunm8/02aKHE481+rl4evHfd+IxuXqPLfCMvNZeGLrx/7MiyDoRkU
SIM2jr+44XokHoPPebZ0lWDbf+lO9e2MX4yEEBDa4F90RGwWY5tZMOp6eGPfYRTj
YplZpEUJPfFmee4SciXM0q1oq87HGY+qv6u+tzS9AfLhhA4PKaGYJPAfjfphyfV/
vwMjtHXbuQNg7+BwP/vy1OjExEBmpemtjqtSoACDGe0+PiyIWTYFCcfkL5jQ9hNO
zOlvg19qgkpvQVaM3l942otPoRlVHo74invndJvJcXu+4fD6u8kuIMMJRbCYHY+J
1w3dGelkUe28PhgE0OFDAhWX3RMoASU8THu2nkgeHmEDfRr7CF8s4ngAA6q89Nqb
Ll+c26FKmqFS2jqxEn/AVJIhrpoXdfB2nPJFyF9nAzShIhJKh6vYGtji0pJSCzIT
Ok1FqR4gVVOa3N8qcwwqiOxa8CNEs6Ky18YeNlLzPZRRStheUStdIhcZqWRIVxVR
cO/Fm1u3GbYf30xbQ4v7wlrRX//hzc3NDAGHi184qoK+84JbqqN9v5oj3Sl7AIDy
wvmIYQ+Q39QjNlsR7cit
=xC3H
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
