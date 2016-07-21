From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v3 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send
	limit
Date: Thu, 21 Jul 2016 09:59:05 +0200
Message-ID: <20160721075905.GC20121@lst.de>
References: <8fb358c3-3504-02ca-fcb8-1624f28be1b0@sandisk.com> <03e7f98e-d810-2299-9f3e-2c697d2699fb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03e7f98e-d810-2299-9f3e-2c697d2699fb-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2016 at 09:22:03AM -0700, Bart Van Assche wrote:
> For IB and RoCE, the SGE limit for a queue pair is typically lower
> than what is defined by the HCA limits. For iWARP, the RDMA READ SGE
> limit is defined by dev->attrs.max_sge_rd. Modify rdma_rw_max_sge()
> accordingly.

It's not just iWarp - Melannox IB HCAs also have a lower RDMA READ than
WRITE limit.

> -static inline u32 rdma_rw_max_sge(struct ib_device *dev,
> +static inline u32 rdma_rw_max_sge(struct ib_device *dev, struct ib_qp *qp,
>  		enum dma_data_direction dir)
>  {
> +	return dir == DMA_TO_DEVICE ? qp->max_send_sge :
> +		min_t(u32, qp->max_send_sge, dev->attrs.max_sge_rd);
>  }

I'm a bit worried about this implicit and barely documented assumption
that we'll always have a lower RDMA READ than WRITE / SEND limit.

Can we fine tune the patch to add max_write_sge and max_read_sge
to struct ib_qp instead?  That also makes clear they apply to RDMA READ
and WRITE only.  Please also add a comment to ib_verbs.h to document
the exact semantics of this field(s) while you're at it, e.g. that
they only apply to users of the RDMA R/W API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
