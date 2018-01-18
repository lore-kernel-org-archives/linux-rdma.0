From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/core: add support for draining Shared receive
 queues
Date: Thu, 18 Jan 2018 12:31:21 +0200
Message-ID: <a7a9ee47-3133-df04-ccce-a4a30dd50c97@mellanox.com>
References: <1516197178-26493-1-git-send-email-maxg@mellanox.com>
 <1516197178-26493-2-git-send-email-maxg@mellanox.com>
 <1516205474.2820.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516205474.2820.5.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 1/17/2018 6:11 PM, Bart Van Assche wrote:
> On Wed, 2018-01-17 at 15:52 +0200, Max Gurtovoy wrote:
>> +/*
>> + * __ib_drain_srq() - Block until all Last WQE Reached event arrives, or
>> + *                    timeout expires (best effort).
>> + * @qp:               queue pair associated with SRQ to drain
>> + *
>> + * In order to avoid WQE and data segment leakage, one should destroy
>> + * QP associated after performing the following:
>> + *  - moving QP to err state
>> + *  - wait for the Affiliated Asynchronous Last WQE Reached Event
>> + *  - drain the CQ
>> + */
>> +static void __ib_drain_srq(struct ib_qp *qp)
>> +{
>> +	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
>> +	struct ib_cq *cq;
>> +	int ret;
>> +
>> +	if (!qp->srq) {
>> +		WARN_ONCE(1, "QP 0x%p is not associated with SRQ\n", qp);
>> +		return;
>> +	}
>> +
>> +	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>> +	if (ret) {
>> +		WARN_ONCE(ret, "failed to drain shared recv queue: %d\n", ret);
>> +		return;
>> +	}
>> +
>> +	if (ib_srq_has_cq(qp->srq->srq_type)) {
>> +		cq = qp->srq->ext.cq;
>> +	} else if (qp->recv_cq) {
>> +		cq = qp->recv_cq;
>> +	} else {
>> +		WARN_ONCE(1, "QP 0x%p has no CQ associated with SRQ\n", qp);
>> +		return;
>> +	}
>> +
>> +	/*
>> +         * ULP should invoke ib_notify_qp on IB_EVENT_QP_LAST_WQE_REACHED
>> +         * arrival, otherwise timeout will expire and leakage may occur.
>> +         * Use long timeout, for the buggy ULPs/HCAs that don't notify the
>> +         * QP nor raising IB_EVENT_QP_LAST_WQE_REACHED event.
>> +         */
>> +	if (wait_for_completion_timeout(&qp->srq_completion, 10 * HZ) > 0)
>> +		ib_process_cq_direct(cq, -1);
>> +}
> 
> Hello Max,

Hello Bart,

> 
> It seems weird to me that __ib_drain_srq() does not follow the same approach as
> __ib_drain_rq(). Have you considered to post an additional receive work entry
> on the SRQ and to wait until the completion for that work entry is signaled?

This approach will never generate a completion. No flushes for SRQ. we 
get completion (SRQ recv completion) only if consumed from the wire (and 
this will not happen in our case).

> That would avoid that a completion has to be added in the ib_qp data structure
> and would also avoid that all ULPs that use SRQs have to be modified.

I'm always open for new suggestions for implementation :)

> 
> Thanks,
> 
> Bart.
> 

-Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
