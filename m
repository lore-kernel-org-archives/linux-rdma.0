From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 9/9] IB/srp: Add fast registration support
Date: Wed, 14 May 2014 09:05:48 +0200
Message-ID: <537315CC.1090001@acm.org>
References: <53722E4F.7070709@acm.org> <53722FE2.4010808@acm.org> <53724CC9.6080509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53724CC9.6080509-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/13/14 18:48, Sagi Grimberg wrote:
> On 5/13/2014 5:44 PM, Bart Van Assche wrote:
>>   static int srp_create_target_ib(struct srp_target_port *target)
>>   {
>>       struct srp_device *dev = target->srp_host->srp_dev;
>> @@ -318,6 +449,8 @@ static int srp_create_target_ib(struct
>> srp_target_port *target)
>>       struct ib_cq *recv_cq, *send_cq;
>>       struct ib_qp *qp;
>>       struct ib_fmr_pool *fmr_pool = NULL;
>> +    struct srp_fr_pool *fr_pool = NULL;
>> +    const int m = 1 + dev->use_fast_reg;
>>       int ret;
>>         init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
>> @@ -332,7 +465,7 @@ static int srp_create_target_ib(struct
>> srp_target_port *target)
>>       }
>>         send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL,
>> target,
>> -                   target->queue_size, target->comp_vector);
>> +                   m * target->queue_size, target->comp_vector);
> 
> So it is correct to expand the send CQ and QP send queue, but why not x3?
> For fast registration we do:
> - FASTREG
> - RDMA
> - LOCAL_INV
> 
> I'm aware we are suppressing the completions but I think we need to
> reserve room for FLUSH errors in case QP went to error state when the
> send queue is packed.

The first FLUSH error triggers a call of srp_tl_err_work(). The second
and later FLUSH errors are ignored by srp_handle_qp_err(). Do you think
multiplying target->queue_size with a factor 3 instead of 2 would make a
difference in fast registration mode ?

>>   static void srp_unmap_data(struct scsi_cmnd *scmnd,
>>                  struct srp_target_port *target,
>>                  struct srp_request *req)
>>   {
>> -    struct ib_device *ibdev = target->srp_host->srp_dev->dev;
>> -    struct ib_pool_fmr **pfmr;
>> +    struct srp_device *dev = target->srp_host->srp_dev;
>> +    struct ib_device *ibdev = dev->dev;
>> +    int i;
>>         if (!scsi_sglist(scmnd) ||
>>           (scmnd->sc_data_direction != DMA_TO_DEVICE &&
>>            scmnd->sc_data_direction != DMA_FROM_DEVICE))
>>           return;
>>   -    pfmr = req->fmr_list;
>> -    while (req->nmdesc--)
>> -        ib_fmr_pool_unmap(*pfmr++);
>> +    if (dev->use_fast_reg) {
>> +        struct srp_fr_desc **pfr;
>> +
>> +        for (i = req->nmdesc, pfr = req->fr_list; i > 0; i--, pfr++)
>> +            srp_inv_rkey(target, (*pfr)->mr->rkey);
>
> No check on return code here? I assume we should react here if we
> failed to post a work request right?

OK, I will add a check for the srp_inv_rkey() return code.

>>   +static int srp_map_finish_fr(struct srp_map_state *state,
>> +                 struct srp_target_port *target)
>> +{
>> +    struct srp_device *dev = target->srp_host->srp_dev;
>> +    struct ib_send_wr *bad_wr;
>> +    struct ib_send_wr wr;
>> +    struct srp_fr_desc *desc;
>> +    u32 rkey;
>> +
>> +    desc = srp_fr_pool_get(target->fr_pool);
>> +    if (!desc)
>> +        return -ENOMEM;
>> +
>> +    rkey = ib_inc_rkey(desc->mr->rkey);
>> +    ib_update_fast_reg_key(desc->mr, rkey);
>> +
>> +    memcpy(desc->frpl->page_list, state->pages,
>> +           sizeof(state->pages[0]) * state->npages);
> 
> I would really like to avoid this memcpy. Any chance we can map directly
> to frpl->page_list instead ?

Avoiding this memcpy() would be relatively easy if all memory that is
holding data for a SCSI command would always be registered. However,
since if register_always == false the fast registration algorithm in
this patch only allocates an rkey if needed (npages > 1) and since how
many pages are present in a mapping descriptor is only known after
state->pages[] has been filled in, eliminating that memcpy would be
challenging.

>> -    state->next_fmr    = req->fmr_list;
>> -
>> -    use_fmr = target->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
>> +    if (dev->use_fast_reg) {
>> +        state->next_fmr = req->fmr_list;
> 
> is this correct?
> shouldn't this be state->next_fr = req->fr_list (dev->use_fast_reg ==
> true)?
> or did I misunderstood?
> 
>> +        use_memory_registration = !!target->fr_pool;
>> +    } else {
>> +        state->next_fr = req->fr_list;
> 
> Same here?

req->fmr_list and req->fr_list point at the same memory location since
both pointers are members of the same union. This also holds for
state->next_fmr and state->next_fr. So swapping these two statements as
proposed wouldn't change the generated code. But I agree that this would
make the code easier to read.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
