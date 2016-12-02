From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Fri, 2 Dec 2016 15:07:27 +0200
Message-ID: <20161202130726.GB3663@yuval-lap>
References: <cover.1475458407.git.aditr@vmware.com>
 <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 02, 2016 at 07:10:32PM -0700, Adit Ranadive wrote:
> +		} else {
> +			qp->is_kernel = true;
> +
> +			ret = pvrdma_set_sq_size(to_vdev(pd->device),
> +						 &init_attr->cap,
> +						 init_attr->qp_type, qp);
> +			if (ret)
> +				goto err_qp;
> +
> +			ret = pvrdma_set_rq_size(to_vdev(pd->device),
> +						 &init_attr->cap, qp);
> +			if (ret)
> +				goto err_qp;
> +
> +			qp->npages = qp->npages_send + qp->npages_recv;

Per next comment shouldn't it be:
qp->npages = qp->npages_send + qp->npages_recv + PAGE_SIZE;

Otherwise there will be only npages_send - 1 pages for send ring.

> +
> +			/* Skip header page. */
> +			qp->sq.offset = PAGE_SIZE;
> +
> +			/* Recv queue pages are after send pages. */
> +			qp->rq.offset = qp->npages_send * PAGE_SIZE;

Unless i'm missing something here, per comment it should be:
qp->rq.offset = qp->sq.offset + qp->npages_send * PAGE_SIZE;

> +		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
