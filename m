From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v4 9/9] IB/srpt: convert to the generic RDMA READ/WRITE
	API
Date: Fri, 11 Mar 2016 10:14:42 +0100
Message-ID: <20160311091442.GC28498@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de> <1457461000-24088-10-git-send-email-hch@lst.de> <56E1F7C8.9000101@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E1F7C8.9000101-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>   	WARN_ON(ioctx->n_rdma <= 0);
>>   	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
>> +	ioctx->n_rdma = 0;
>>
>>   	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>>   		pr_info("RDMA_READ for ioctx 0x%p failed with status %d\n",
>
> ioctx->n_rdma is reset by srpt_get_send_ioctx(). Do we really need to reset 
> that member variable in srpt_rdma_read_done()?

Yes, otherwise the atomic_add in srpt_send_done will do the wrong thing.
Alernatively we could return WQE reservation in srpt_send_done always,
but given that we'd done with the RDMA READ commands it seems useful
to not hang onto them longer than necessary.

>> @@ -1832,8 +1626,11 @@ retry:
>>   	qp_init->srq = sdev->srq;
>>   	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
>>   	qp_init->qp_type = IB_QPT_RC;
>> -	qp_init->cap.max_send_wr = srp_sq_size;
>> -	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
>> +	qp_init->cap.max_send_wr = srp_sq_size / 2;
>> +	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
>> +	qp_init->cap.max_send_sge = max(sdev->device->attrs.max_sge_rd,
>> +					sdev->device->attrs.max_sge);
>> +	qp_init->port_num = ch->sport->port;
>>
>>   	ch->qp = ib_create_qp(sdev->pd, qp_init);
>>   	if (IS_ERR(ch->qp)) {
>
> The QP max_send_wr parameter has been changed but not the ib_alloc_cq() 
> argument. Is that perhaps an oversight?

The rdma_ctx add at least one to the send_wr count.  In case they
are all RDMA READs we will actually need one CQE per rdma_ctxs, although
we'll usually need less.  So I think the actualy count here is correct,
but I'll add a comment explaining things.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
