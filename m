From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 09/13] SoftiWarp transmit path
Date: Wed, 11 Oct 2017 15:54:51 +0300
Message-ID: <c6a446f1-f746-12f5-423c-78eb4d0a4cb9@grimberg.me>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-10-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-10-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bernard,

> +/*
> + * siw_0copy_tx()
> + *
> + * Pushes list of pages to TCP socket. If pages from multiple
> + * SGE's, all referenced pages of each SGE are pushed in one
> + * shot.
> + */
> +static int siw_0copy_tx(struct socket *s, struct page **page,
> +			struct siw_sge *sge, unsigned int offset,
> +			unsigned int size)
> +{

siw_zcopy_tx is a better name

> +	int i = 0, sent = 0, rv;
> +	int sge_bytes = min(sge->length - offset, size);
> +
> +	offset  = (sge->laddr + offset) & ~PAGE_MASK;
> +
> +	while (sent != size) {
> +
> +		rv = siw_tcp_sendpages(s, &page[i], offset, sge_bytes);
> +		if (rv >= 0) {
> +			sent += rv;
> +			if (size == sent || sge_bytes > rv)
> +				break;
> +
> +			i += PAGE_ALIGN(sge_bytes + offset) >> PAGE_SHIFT;
> +			sge++;
> +			sge_bytes = min(sge->length, size - sent);
> +			offset = sge->laddr & ~PAGE_MASK;
> +		} else {
> +			sent = rv;
> +			break;
> +		}
> +	}
> +	return sent;
> +}
> +
> +#define MAX_TRAILER (MPA_CRC_SIZE + 4)
> +
> +/*
> + * siw_tx_hdt() tries to push a complete packet to TCP where all
> + * packet fragments are referenced by the elements of one iovec.
> + * For the data portion, each involved page must be referenced by
> + * one extra element. All sge's data can be non-aligned to page
> + * boundaries. Two more elements are referencing iWARP header
> + * and trailer:
> + * MAX_ARRAY = 64KB/PAGE_SIZE + 1 + (2 * (SIW_MAX_SGE - 1) + HDR + TRL
> + */
> +#define MAX_ARRAY ((0xffff / PAGE_SIZE) + 1 + (2 * (SIW_MAX_SGE - 1) + 2))
> +
> +/*
> + * Write out iov referencing hdr, data and trailer of current FPDU.
> + * Update transmit state dependent on write return status
> + */
> +static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
> +{
> +	struct siw_wqe		*wqe = &c_tx->wqe_active;
> +	struct siw_sge		*sge = &wqe->sqe.sge[c_tx->sge_idx],
> +				*first_sge = sge;
> +	union siw_mem_resolved	*mem = &wqe->mem[c_tx->sge_idx];
> +	struct siw_mr		*mr = NULL;
> +
> +	struct kvec		iov[MAX_ARRAY];
> +	struct page		*page_array[MAX_ARRAY];
> +	struct msghdr		msg = {.msg_flags = MSG_DONTWAIT|MSG_EOR};
> +

Have you considered using iov_iter's for all the send and receive
routines? IMO, This code is very hard to review mostly because it
doesn't use any of the kernel services for file (and socket) I/O.

For example, no one said an MR needs to hold a real page_vec like its HW
fellows, it can easily hold kvec and iov_iter to describe the page
vector which in turn would be used to process rdma writes/reads.

My impression is that it would greatly simplify the entire code and make
it much more maintainable...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
