From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 9/9] IB/srp: Add fast registration support
Date: Wed, 07 May 2014 16:59:52 +0200
Message-ID: <536A4A68.4080605@acm.org>
References: <5368DA5B.80609@acm.org> <5368DC09.70608@acm.org> <536A1A3A.9090208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <536A1A3A.9090208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/07/14 13:34, Sagi Grimberg wrote:
>> +module_param(prefer_fr, bool, 0444);
>> +MODULE_PARM_DESC(prefer_fr,
>> +         "Whether to use FR if both FMR and FR are supported");
> 
> Will it be better to make it a per-target attribute?

Hello Sagi,

The only reason I introduced this kernel module parameter was to allow
me to test fast registration support on HCA's that support both FMR and
FR. I'm not sure it is useful to end users to configure this parameter.
Hence my preference to leave it global instead of converting it into a
per-target attribute.

>> +module_param(register_always, bool, 0444);
>> +MODULE_PARM_DESC(register_always,
>> +         "Use memory registration even for contiguous memory regions");
>> +
> 
> This is a separate patch not related to fast registration support, I
> suggest to post it as patch #10

OK, I will split this out into a separate patch.

>> +static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port
>> *target)
>> +{
>> +    struct srp_device *dev = target->srp_host->srp_dev;
>> +    struct srp_fr_pool *pool;
>> +    int max_pages_per_mr;
>> +
>> +    for (max_pages_per_mr = SRP_MAX_PAGES_PER_MR;
>> +         max_pages_per_mr >= SRP_MIN_PAGES_PER_MR;
>> +         max_pages_per_mr /= 2) {
> 
> Isn't there some device capability for that? maybe max_mr_size?
> Also for smaller max_pages you won't be able to handle 512 pages in a
> single cmnd (you would need 2 FRMRs).
> At least a warning print?

I will look into using max_mr_size here. Using multiple registrations
per command should be fine in the context of the SRP protocol as long as
cmd_sg_entries has not been set to a very small value.

>> +        pool = srp_create_fr_pool(dev->dev, dev->pd,
>> +                      SRP_MDESC_PER_POOL, max_pages_per_mr);
> 
> 1024 FRMRs per connection?! we use 1024 FMRs for all connections
> (per-device). I'd say that's a major over-allocation.

It depends on how many discontiguous I/O requests are submitted
concurrently. Anyway, how about limiting the number of memory regions to
the queue size ?

>> -    init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
>> +    init_attr->sq_sig_type         = IB_SIGNAL_REQ_WR;
> 
> Will it be better to do this in a preparation patch? (not so important
> to me)

This patch is the first patch for the SRP initiator in which work
requests are queued for which the IB_SEND_SIGNALED flag is not set. That
is why I had included the above change in this patch.

>> @@ -898,20 +1112,25 @@ static int srp_rport_reconnect(struct srp_rport
>> *rport)
>>        * callbacks will have finished before a new QP is allocated.
>>        */
>>       ret = srp_new_cm_id(target);
>> +
>> +    for (i = 0; i < target->req_ring_size; ++i) {
>> +        struct srp_request *req = &target->req_ring[i];
>> +        srp_finish_req(target, req, NULL, DID_RESET << 16);
>> +    }
> 
> Can you explain why this moved here? I'm not sure I understand.

In fast registration mode calling srp_finish_req() can trigger rkey
invalidation. Trying to invalidate an rkey after the queue pair has been
destroyed and recreated would be wrong since that would cause the new
queue pair to transition into the error state. That is why this loop has
been moved up. Moving the srp_finish_req() loop up is safe since
srp_claim_req() prevents that any work completions that are received
after srp_finish_req() has finished cause any harm.

>> +static int srp_map_finish_fr(struct srp_map_state *state,
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
> 
> Usually the inc_rkey is done right after the invalidation (but that's
> not really an issue).
> Maybe it is better here in case the target did remote invalidate (not
> supported at the moment but maybe in the future?)

Indeed - if remote invalidation would be added later on the code for
incrementing the rkey would have to be moved anyway.

>> @@ -2910,7 +3213,8 @@ static void srp_add_one(struct ib_device *device)
>>       if (IS_ERR(srp_dev->mr))
>>           goto err_pd;
>>   -    srp_alloc_fmr_pool(srp_dev);
>> +    if (!srp_dev->use_fast_reg)
>> +        srp_alloc_fmr_pool(srp_dev);
> 
> So I ask here, are we OK with this asymmetry? FMRs are per-device and
> FRMRs are per-target?
> I have a feeling that converting FMRs to per-connection might simplify
> things, what do you think?

Making the FMR pools per-device instead of per-target would cause the
FMR and FR pool allocation and deallocation code to appear in the same
functions but unfortunately wouldn't make this patch shorter. My goal
with this patch was to introduce fast registration support without
changing the FMR code too much.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
