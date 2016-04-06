From: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Wed, 6 Apr 2016 20:34:35 +0300
Message-ID: <570548AB.4090802@grimberg.me>
References: <20160404134656.GA30269@infradead.org>
 <5702A46F.5070109@grimberg.me> <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org> <57037D8E.4030506@grimberg.me>
 <20160405094339.GA1622@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160405094339.GA1622-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> This implies that maybe something broke in ib_sg_to_pages:
>>
>> Can you run iser with this patch applied (FR or FMR):
>
> For FMR this won't trigger, but here is the FR run:
>
> [   63.016616] iser: iser_fast_reg_mr: failed to map sg (101/102)
> [   63.023183] iser: iser_data_buf_dump: sg[0] dma_addr:0x90E15D200
> page:0xffffea0024385740 off:0x200 sz:0xe00 dma_len:0xe00
> [   63.035466] iser: iser_data_buf_dump: sg[1] dma_addr:0x90611D000
> page:0xffffea0024184740 off:0x0 sz:0x1000 dma_len:0x1000
> [   63.047749] iser: iser_data_buf_dump: sg[2] dma_addr:0x90EDB3000
> page:0xffffea00243b6cc0 off:0x0 sz:0x1000 dma_len:0x1000
> [   63.060050] iser: iser_data_buf_dump: sg[3] dma_addr:0x9062CB000
> page:0xffffea002418b2c0 off:0x0 sz:0x1000 dma_len:0x1000

...

> [   64.215764] iser: iser_data_buf_dump: sg[95] dma_addr:0x90E440000
> page:0xffffea0024391000 off:0x0 sz:0x2000 dma_len:0x2000
> [   64.228380] iser: iser_data_buf_dump: sg[96] dma_addr:0x90E43E000
> page:0xffffea0024390f80 off:0x0 sz:0x2000 dma_len:0x2000
> [   64.240995] iser: iser_data_buf_dump: sg[97] dma_addr:0x901586000
> page:0xffffea0024056180 off:0x0 sz:0x2000 dma_len:0x2000
> [   64.253611] iser: iser_data_buf_dump: sg[98] dma_addr:0x90F390000
> page:0xffffea00243ce400 off:0x0 sz:0x2000 dma_len:0x2000
> [   64.266219] iser: iser_data_buf_dump: sg[99] dma_addr:0x90660E000
> page:0xffffea0024198380 off:0x0 sz:0x2000 dma_len:0x2000
> [   64.278836] iser: iser_data_buf_dump: sg[100] dma_addr:0x9017E6000
> page:0xffffea002405f980 off:0x0 sz:0x1000 dma_len:0x1000
> [   64.291577] iser: iser_data_buf_dump: sg[101] dma_addr:0x93FBF1000
> page:0xffffea0024fefc40 off:0x0 sz:0x200 dma_len:0x200
>

So this scatterlist seems perfectly fine (no gaps). The only thing I
can think of is that we don't have enough space reserved, but I counted
127 pages in the scatterlist when iser reserves 128 (by default).

Just in case I mis-counted, can you (or Max) try with the below
patch:
--
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c 
b/drivers/infiniband/ulp/iser/iser_initiator.c
index ed54b388e7ad..f2ac891c432a 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -250,7 +250,7 @@ int iser_alloc_rx_descriptors(struct iser_conn 
*iser_conn,
         iser_conn->min_posted_rx = iser_conn->qp_max_recv_dtos >> 2;

         if (device->reg_ops->alloc_reg_res(ib_conn, session->scsi_cmds_max,
-                                          iser_conn->scsi_sg_tablesize))
+                                          iser_conn->scsi_sg_tablesize 
+ 1))
                 goto create_rdma_reg_res_failed;

         if (iser_alloc_login_buf(iser_conn))
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c 
b/drivers/infiniband/ulp/iser/iser_verbs.c
index 40c0f4978e2f..937b97f34be1 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -721,7 +721,7 @@ iser_calc_scsi_params(struct iser_conn *iser_conn,

         sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
         sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
- 
device->ib_device->attrs.max_fast_reg_page_list_len);
+ 
device->ib_device->attrs.max_fast_reg_page_list_len - 1);

         if (sg_tablesize > sup_sg_tablesize) {
                 sg_tablesize = sup_sg_tablesize;
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
