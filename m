From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 2/4] IB/isert: convert to new CQ API
Date: Thu, 18 Feb 2016 14:32:26 +0200
Message-ID: <56C5B9DA.5070306@mellanox.com>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
 <1455567060-18381-3-git-send-email-hch@lst.de>
 <56C364B8.6010807@mellanox.com> <20160217141852.GA15646@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160217141852.GA15646@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



>> maybe we can define it as:
>> static inline struct iser_rx_desc *
>> isert_rx(struct ib_cqe *rx_cqe)
>> {
>>     return container_of(rx_cqe, struct iser_rx_desc, rx_cqe);
>> }
>> in the .h file ?
>
> There is just a single use of this pattern, but if everyone prefers
> the helper I can add it.
>

Sagi, any thoughts ?

>>> +	struct iscsi_hdr *hdr = &rx_desc->iscsi_header;
>>>    	struct iser_ctrl *iser_ctrl = &rx_desc->iser_header;
>>>    	uint64_t read_va = 0, write_va = 0;
>>
>>
>>
>>> +	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>>> +		isert_print_wc(wc);
>>> +		if (!--isert_conn->post_recv_buf_count)
>>
>> maybe we can do isert_conn->post_recv_buf_count-- once at the beginning of
>> the function?
>
> I'd rather not move the assignment around in this patch.  If you
> think this can sensible be done please send a follow up patch that
> also explains why it's safe.
>

Ok.
