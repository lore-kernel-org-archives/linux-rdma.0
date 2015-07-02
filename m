From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Thu, 02 Jul 2015 08:17:20 -0500
Message-ID: <559539E0.9030808@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213618.4188.50574.stgit@build.ogc.int> <55925FAE.4090004@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FFB053@ORSMSX109.amr.corp.intel.com> <5594D8BC.8000300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5594D8BC.8000300-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/2/2015 1:22 AM, Sagi Grimberg wrote:
> On 6/30/2015 8:10 PM, Hefty, Sean wrote:
>>> I suggest to start consolidating to ib_create_mr() that receives an
>>> extensible ib_mr_init_attr and additional attributes can be mr_roles
>>> and mr_attrs.
>>
>> I think this makes sense, but does it really help?
>> If the end result is that the app and providers basically
>> end up switching on mr_attr::type, we end up reducing the
>> number of APIs, but the code complexity remains the same.
>>
>
> I think it will reduce code complexity. First, the callers
> will have a single API to allocate a memory key. I'm not sure why you
> say that app needs to switch on mr::type, it knows which type it wants.
>

I dont see how doing this is less complex:

attr = FASTREG
mr = create_mr(attr)

vs:

mr = lloc_fast_reg_mr()

> As for drivers, From what I've seen, usually there is a single memory
> key allocation interface to the HW and for each API and drivers call it
> with a slightly different attributes and maybe do some extra driver
> specific logic.
>
> Yes, probably drivers will need to switch on mr_attr::type, but maybe
> just just to determine the correct HW interface and hopefully not to
> a completely different logic. I think that drivers can benefit in
> reduced code duplication in total.
>

There isn't much code duplication now because as you mentioned above, 
most drivers have common services that get called from the various entry 
points: alloc_fast_reg_mr(), get_dma_mr(), reg_user_mr(), etc...

> As a first step, we can do a naive switch on mr_attr::type in the
> drivers but I'd expect driver developers to change this logic in their
> driver.
>
> Thoughts?

I don't see any reduction in complexity of the application nor 
driver/core code.  Perhaps a reduction in API complexity by having a 
single entry point...but that entry point would be the place I would fan 
out and call the driver functions vs changing the core<->driver interface...

My 2 centimes...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
