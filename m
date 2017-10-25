From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 11/13] SoftiWarp Completion Queue methods
Date: Wed, 25 Oct 2017 13:51:25 +0000
Message-ID: <OF397EC712.ADB744E7-ON002581C4.004C1E61-002581C4.004C1E66@notes.na.collabserv.com>
References: <20171020125836.GB11604@ssaleem-MOBL4.amr.corp.intel.com>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-12-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020125836.GB11604-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote: -----

>To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>Date: 10/20/2017 02:58PM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 11/13] SoftiWarp Completion Queue methods
>
>On Fri, Oct 06, 2017 at 08:28:51AM -0400, Bernard Metzler wrote:
>> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/siw/siw_cq.c | 164
>+++++++++++++++++++++++++++++++++++++
>>  1 file changed, 164 insertions(+)
>>  create mode 100644 drivers/infiniband/sw/siw/siw_cq.c
>> 
>> diff --git a/drivers/infiniband/sw/siw/siw_cq.c
>b/drivers/infiniband/sw/siw/siw_cq.c
>> new file mode 100644
>> index 000000000000..0cd6e010e7a7
>> --- /dev/null
>> +++ b/drivers/infiniband/sw/siw/siw_cq.c
>
>> +/*
>> + * Reap one CQE from the CQ.
>> + *
>> + * Caller must hold qp read lock
>
>Why is this a mandate?
>
>
Good point - it is not. Will remove that stupid comment. 

>> + * TODO: Provide routine which can read more than one CQE
>> + */
>> +int siw_reap_cqe(struct siw_cq *cq, struct ib_wc *ofa_wc)
>> +{
>> +	struct siw_cqe *cqe;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&cq->lock, flags);
>> +
>> +	cqe = &cq->queue[cq->cq_get % cq->num_cqe];
>> +	if (cqe->flags & SIW_WQE_VALID) {
>> +		siw_wc_siw2ofa(cqe, ofa_wc);
>> +
>> +		if (cq->kernel_verbs) {
>> +			dprint(DBG_WR,
>> +				" QP%d, CQ%d: Reap WQE type: %d at idx %d\n",
>> +				QP_ID((struct siw_qp *)cqe->qp), OBJ_ID(cq),
>> +				cqe->opcode, cq->cq_get % cq->num_cqe);
>> +			siw_qp_put(cqe->qp);
>
>Where do we do the siw_qp_get()?
>
>

We do it when we create the CQE, that is, in siw_sqe_complete(), or
siw_rqe_complete(). See siw_qp.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
