From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] IB/isert: convert to new CQ API
Date: Wed, 17 Feb 2016 15:18:52 +0100
Message-ID: <20160217141852.GA15646@lst.de>
References: <1455567060-18381-1-git-send-email-hch@lst.de> <1455567060-18381-3-git-send-email-hch@lst.de> <56C364B8.6010807@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C364B8.6010807@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 16, 2016 at 08:04:40PM +0200, Max Gurtovoy wrote:
>> @@ -977,7 +959,10 @@ isert_post_recvm(struct isert_conn *isert_conn, u32 count)
>>
>>   	for (rx_wr = isert_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
>>   		rx_desc = &isert_conn->rx_descs[i];
>> -		rx_wr->wr_id = (uintptr_t)rx_desc;
>> +
>> +		rx_desc->rx_cqe.done = isert_recv_done;
>
> perhaps we can do it once in isert_alloc_rx_descriptors ?

Ok.

>> +static void
>> +isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>>   {
>> +	struct isert_conn *isert_conn = wc->qp->qp_context;
>> +	struct ib_device *ib_dev = isert_conn->cm_id->device;
>> +	struct iser_rx_desc *rx_desc =
>> +		container_of(wc->wr_cqe, struct iser_rx_desc, rx_cqe);
>
> maybe we can define it as:
> static inline struct iser_rx_desc *
> isert_rx(struct ib_cqe *rx_cqe)
> {
>    return container_of(rx_cqe, struct iser_rx_desc, rx_cqe);
> }
> in the .h file ?

There is just a single use of this pattern, but if everyone prefers
the helper I can add it.

>> +	struct iscsi_hdr *hdr = &rx_desc->iscsi_header;
>>   	struct iser_ctrl *iser_ctrl = &rx_desc->iser_header;
>>   	uint64_t read_va = 0, write_va = 0;
>
>
>
>> +	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>> +		isert_print_wc(wc);
>> +		if (!--isert_conn->post_recv_buf_count)
>
> maybe we can do isert_conn->post_recv_buf_count-- once at the beginning of 
> the function?

I'd rather not move the assignment around in this patch.  If you
think this can sensible be done please send a follow up patch that
also explains why it's safe.

> maybe we can do isert_conn->post_recv_buf_count-- once at the beginning of 
> the function?

Same as above.

>> +	struct iser_tx_desc *desc =
>> +		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);
>
> maybe we can define it as:
> static inline struct iser_tx_desc *
> isert_tx(struct ib_cqe *tx_cqe)
> {
>    return container_of(tx_cqe, struct iser_tx_desc, tx_cqe);
> }

We've got a couple more instances of this one, so this might be
worth it.
