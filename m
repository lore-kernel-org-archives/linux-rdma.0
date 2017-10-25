From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 05/13] SoftiWarp application interface
Date: Wed, 25 Oct 2017 14:17:22 +0000
Message-ID: <OFA9213400.51E5BE58-ON002581C4.004D3BE7-002581C4.004E7EE8@notes.na.collabserv.com>
References: <20171020133013.GC11604@ssaleem-MOBL4.amr.corp.intel.com>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-6-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020133013.GC11604-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote: -----

>To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>Date: 10/20/2017 03:30PM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 05/13] SoftiWarp application interface
>
>On Fri, Oct 06, 2017 at 08:28:45AM -0400, Bernard Metzler wrote:
>> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/siw/siw_ae.c    |  113 ++
>>  drivers/infiniband/sw/siw/siw_verbs.c | 1929
>+++++++++++++++++++++++++++++++++
>>  drivers/infiniband/sw/siw/siw_verbs.h |  119 ++
>>  include/uapi/rdma/siw_user.h          |  220 ++++
>>  4 files changed, 2381 insertions(+)
>>  create mode 100644 drivers/infiniband/sw/siw/siw_ae.c
>>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.c
>>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.h
>>  create mode 100644 include/uapi/rdma/siw_user.h
>> 
>
>> + *
>> + * Post a list of S-WR's to a SQ.
>> + *
>> + * @ofa_qp:	OFA QP contained in siw QP
>> + * @wr:		Null terminated list of user WR's
>> + * @bad_wr:	Points to failing WR in case of synchronous failure.
>> + */
>> +int siw_post_send(struct ib_qp *ofa_qp, struct ib_send_wr *wr,
>> +		  struct ib_send_wr **bad_wr)
>> +{
>> +	struct siw_qp	*qp = siw_qp_ofa2siw(ofa_qp);
>> +	struct siw_wqe	*wqe = tx_wqe(qp);
>> +
>> +	unsigned long flags;
>> +	int rv = 0;
>> +
>> +	dprint(DBG_WR|DBG_TX, "(QP%d): state=%d\n",
>> +		QP_ID(qp), qp->attrs.state);
>> +
>> +	/*
>> +	 * Try to acquire QP state lock. Must be non-blocking
>> +	 * to accommodate kernel clients needs.
>> +	 */
>> +	if (!down_read_trylock(&qp->state_lock)) {
>> +		*bad_wr = wr;
>> +		return -ENOTCONN;
>> +	}
>> +
>> +	if (unlikely(qp->attrs.state != SIW_QP_STATE_RTS)) {
>> +		dprint(DBG_WR, "(QP%d): state=%d\n",
>> +			QP_ID(qp), qp->attrs.state);
>> +		up_read(&qp->state_lock);
>> +		*bad_wr = wr;
>> +		return -ENOTCONN;
>> +	}
>> +	if (wr && qp->kernel_verbs == 0) {
>Can qp->kernel_verbs ever be 0? Isnt this post_send for kernel QPs
>only?
>
We use the post_send to trigger a 'software SQ doorbell' for user 
level applications. After the application library wrote its WQE,
we must make sure the kernel part of siw starts processing the SQ.
This is being done by calling post_send with an empty WR.

We experimented with having our own system call for that
doorbell, which would avoid running through the kernel rdma
core logic of post_send. It would save us another 1..2 us, but we removed
that, aiming at code acceptance ;)


>> +		dprint(DBG_WR|DBG_ON, "(QP%d): user mapped SQ with OFA WR\n",
>> +			QP_ID(qp));
>> +		up_read(&qp->state_lock);
>> +		*bad_wr = wr;
>> +		return -EINVAL;
>> +	}
>> +
>> +	spin_lock_irqsave(&qp->sq_lock, flags);
>> +
>> +	while (wr) {
>> +		u32 idx = qp->sq_put % qp->attrs.sq_size;
>> +		struct siw_sqe *sqe = &qp->sendq[idx];
>> +
>> +		if (sqe->flags) {
>> +			dprint(DBG_WR, "(QP%d): SQ full\n", QP_ID(qp));
>> +			rv = -ENOMEM;
>> +			break;
>> +		}
>> +		if (wr->num_sge > qp->attrs.sq_max_sges) {
>> +			/*
>> +			 * NOTE: we allow for zero length wr's here.
>> +			 */
>> +			dprint(DBG_WR, "(QP%d): Num SGE: %d\n",
>> +				QP_ID(qp), wr->num_sge);
>> +			rv = -EINVAL;
>> +			break;
>> +		}
>> +		sqe->id = wr->wr_id;
>> +		sqe->flags = 0;
>sqe->flags will always be 0 if we reached to this point in code no?
>Since we break out of the loop if sqe->flags != 0.
>
>
Correct, thanks. Will remove that unneeded line.

>
>
>> +
>> +	if (qp->kernel_verbs)
>> +		siw_sq_start(qp);
>ditto. Is this check neccessary?
>
>
We schedule SQ processing, if we are called by a kernel
client. If called by a user client, we can start SQ processing 
immediately from within user context (for a fixed burst of wire
frames only). That helps to minimize processing delay for small
messages to be send out.

>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
