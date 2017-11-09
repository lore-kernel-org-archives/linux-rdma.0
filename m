From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 1/9] RDMA/core: Add implicit per-device completion
 queue pools
Date: Thu, 9 Nov 2017 19:31:28 +0200
Message-ID: <23b598f2-6982-0d15-69e4-c526c627ec33@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <20171108095742.25365-2-sagi@grimberg.me>
 <fe2c23b7-2923-2693-28c3-6a6f399bda26@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fe2c23b7-2923-2693-28c3-6a6f399bda26-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



>> +static int ib_alloc_cqs(struct ib_device *dev, int nr_cqes,
>> +        enum ib_poll_context poll_ctx)
>> +{
>> +    LIST_HEAD(tmp_list);
>> +    struct ib_cq *cq;
>> +    unsigned long flags;
>> +    int nr_cqs, ret, i;
>> +
>> +    /*
>> +     * Allocated at least as many CQEs as requested, and otherwise
>> +     * a reasonable batch size so that we can share CQs between
>> +     * multiple users instead of allocating a larger number of CQs.
>> +     */
>> +    nr_cqes = max(nr_cqes, min(dev->attrs.max_cqe, IB_CQE_BATCH));
> 
> did you mean min() ?

No, I meant max. If we choose the CQ size, we choose the min between the
default and the device capability, if the user chooses, we rely that it
asked for no more than the device capability (and if not, allocation
will fail, as it should).

>> +restart:
>> +    /*
>> +     * Find the least used CQ with correct affinity and
>> +     * enough free cq entries
>> +     */
>> +    found = NULL;
>> +    spin_lock_irqsave(&dev->cq_lock, flags);
>> +    list_for_each_entry(cq, &dev->cq_pools[poll_ctx], pool_entry) {
>> +        if (vector != -1 && vector != cq->comp_vector)
> 
> how vector can be -1 ?

-1 is a wild-card affinity hint value that chooses the least used cq
(see ib_create_qp).

>> @@ -811,9 +813,51 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>>       if (qp_init_attr->cap.max_rdma_ctxs)
>>           rdma_rw_init_qp(device, qp_init_attr);
>> +    if (qp_init_attr->create_flags & IB_QP_CREATE_ASSIGN_CQS) {
>> +        int affinity = -1;
>> +
>> +        if (WARN_ON(qp_init_attr->recv_cq))
>> +            goto out;
>> +        if (WARN_ON(qp_init_attr->send_cq))
>> +            goto out;
>> +
>> +        if (qp_init_attr->create_flags & IB_QP_CREATE_AFFINITY_HINT)
>> +            affinity = qp_init_attr->affinity_hint;
>> +
>> +        nr_cqes = qp_init_attr->cap.max_recv_wr +
>> +              qp_init_attr->cap.max_send_wr;
>> +        if (nr_cqes) {
> 
> what will happen if nr_cqes == 0 in that case ?

The same thing that would happen without this code I think. This is
creating a qp without ability to post send and/or receive work requests.

>> @@ -2338,6 +2354,9 @@ struct ib_device {
>>       u32                          index;
>> +    spinlock_t             cq_lock;
> 
> maybe can be called cq_pools_lock (cq_lock is general) ?

I can change that.

>> +    struct list_head         cq_pools[IB_POLL_WORKQUEUE + 1];
> 
> maybe it's better to add and use IB_POLL_LAST ?

Yea, I can change that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
