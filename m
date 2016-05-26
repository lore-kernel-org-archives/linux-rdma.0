From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC ABI 8/8] IB/core: Implement device_create with the new ABI
Date: Thu, 26 May 2016 16:24:06 +0300
Message-ID: <CAAKD3BDVFs4rivq1qEih-Z5uOMSVp=OuwDaVroK=UjAhcj6wsg@mail.gmail.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
	<1464100526-31730-9-git-send-email-leonro@mellanox.com>
	<20160524220720.GF7950@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524220720.GF7950-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 1:07 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, May 24, 2016 at 05:35:26PM +0300, Leon Romanovsky wrote:
>
>> +     ucontext->device = ib_dev;
>> +     INIT_LIST_HEAD(&ucontext->pd_list);
>> +     INIT_LIST_HEAD(&ucontext->mr_list);
>> +     INIT_LIST_HEAD(&ucontext->mw_list);
>> +     INIT_LIST_HEAD(&ucontext->cq_list);
>> +     INIT_LIST_HEAD(&ucontext->qp_list);
>> +     INIT_LIST_HEAD(&ucontext->srq_list);
>> +     INIT_LIST_HEAD(&ucontext->ah_list);
>> +     INIT_LIST_HEAD(&ucontext->xrcd_list);
>> +     INIT_LIST_HEAD(&ucontext->rule_list);
> [..]
>
> Please don't cut and paste like this.
>
> Considering your approach I'd suggest just go ahead and immediately
> implement a compat wrapper for each replaced write() style call.
>
> eg replace ib_uverbs_get_context with something that forms a
> new-style-command and calls the netlink version directly.
>

Of course, this is just the first step of the ABI. It's only intended
to show some concepts regarding the new ABI and not as a final ABI
conversion.
I agree that we don't want code duplication and the old ABI handling
code should just wrap the parameters and call the new code path.

> This also then serves as the example on how to implement the user
> space migration.
>
>> +             nla = ib_uverbs_nla_put(uresp, IBNL_RESPONSE_TYPE_VENDOR,
>> +                                     sizeof(vendor_len), &vendor_len);
>
> Please don't use the word 'vendor' in any of this.
>
> There is only common and driver-specific.
>
> Maybe call this IBNL_RESPONSE_DRIVER_UDATA
>

Ok

>> +     nla = ib_uverbs_nla_put(uresp, IBNL_RESPONSE_TYPE_RESP,
>> +                             sizeof(resp), &resp);
>
> And this IBNL_RESPONSE_COMMON ?
>

Yeah

>> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
>> index f5dc276..10c2412 100644
>> +++ b/drivers/infiniband/core/uverbs_main.c
>
>> +static const struct nla_policy ibnl_create_device_policy[] = {
>
> Why isn't this stuff in a _nl file?
>

All validators and function pointers should move into uverbs_cmd_nl file.

>> +enum ibnl_create_device {
>> +     IBNL_CREATE_DEVICE_CORE = IBNL_VENDOR_ATTRS_MAX,
>> +     IBNL_CREATE_DEVICE_MAX
>> +};
>
> Whats all this about? Looks very strange.
>

The first attribute ids of every command are reserved for the vendor part.

> Jason

Thanks for taking a look. The patches are still WIP and we'll fix the
above issues.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
