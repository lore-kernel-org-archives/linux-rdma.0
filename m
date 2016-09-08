From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/9] ib_mad: incoming sminfo SMPs gets discarded if no
 process_mad function is registered
Date: Thu, 08 Sep 2016 19:22:30 +0200
Message-ID: <1473355350.569.5.camel@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
         <1472774969-18997-2-git-send-email-knut.omang@oracle.com>
         <57867d7f-cc9f-5ec2-6632-c552e6469e40@dev.mellanox.co.il>
         <1473248532.3103.51.camel@oracle.com>
         <098f69ae-6940-589a-e9ad-c65e34c958b7@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <098f69ae-6940-589a-e9ad-c65e34c958b7-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-09-08 at 07:33 -0400, Hal Rosenstock wrote:
> On 9/7/2016 7:42 AM, Knut Omang wrote:
>> On Tue, 2016-09-06 at 10:01 -0400, Hal Rosenstock wrote:
>>> On 9/1/2016 8:09 PM, Knut Omang wrote:
>>>>
>>>> From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> The process_mad function is an optional IB driver entry point
>>>> allows a driver to intercept or modify MAD traffic.
>>>
>>> process_mad is optional but currently that optionality is based on
>>> whether MADs (QP0 and/or QP1) are supported or not. This is reflected in
>>> the core_cap_flags and is related to the device type: IB including RoCE
>>> v. non IB. The current in tree device drivers that do not support
>>> process_mad are i40iw (iWARP) and usnic.
>>
>> I see - we are introducing a new case here, then.
>>>>
>>>> This fix allows MAD traffic to flow down to the device also
>>>> when MAD traffic is completely handled by the device
>>>
>>> All MAD traffic is not handled by the device.
>>
>> Yes, in our case all MAD packet handling is done by the device,
>
> SMInfo is not handled by device unless you have SM in hardware.
> It also depends on management class, method, and direction
> (outgoing/incoming) and in case of DR SMP the DR path.

Yes, with "handling" here we really mean "deciding what to do with it" -
in our case, the driver is not involved in those decisions at all.
That includes both inbound and outbound DR and LID routed SMInfo packets.

>> the driver's task for MAD packets is just to forward.
>
> I think that it's a little more complex than that. See above.
>
> Perhaps some of this is due to not understanding what the effects of
> forwarding are with device such as SIF where SMA (and SMI) as well as
> PMA are totally in hardware. If MAD is locally handled rather than
> "forwarded", I assume that the device generates and sends the response
> MAD, right ?

Yes, correct.

> Do locally handled MADs work correctly ?

Yes

> Does OpenSM properly run on SIF?

The goal is to have OpenSM work seamlessly with SIF, yes.

> I saw a post yesterday on issue with running OpenSM on SIF in terms of
> obtaining the local PortInfo via DR SMP with hop count of 0.

Do you have a link ref to this?

>>>> and no process_mad function is provided.
>>>>
>>>> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>  drivers/infiniband/core/mad.c | 6 ++++++
>>>>  drivers/infiniband/core/smi.h | 6 ++----
>>>>  2 files changed, 8 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
>>>> index 2d49228..ece33ec 100644
>>>> --- a/drivers/infiniband/core/mad.c
>>>> +++ b/drivers/infiniband/core/mad.c
>>>> @@ -813,6 +813,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
>>>>  			goto out;
>>>>  	}
>>>>
>>>> +	/* If device does not define the optional process_mad function it means that
>>>> +	 * everything is handled in hardware:
>>>> +	 */
>>>> +	if (!device->process_mad)
>>>> +		goto out;
>>>> +
>>> This changes the ib_post_send_mad flow for those devices in that it
>>> takes the send rather than error path.
>>
>> Yes, but no packets will ever be received by this function for the i40iw and usnic
>> devices because they have said in their capabilities that they do not support SMI?
>
> You're right - it shouldn't get here for those devices (it's based on
> MAD rather than SMI cap) - umad open would fail for the port GUID.

Ok, I see - good!

>>>>  	local = kmalloc(sizeof *local, GFP_ATOMIC);
>>>>  	if (!local) {
>>>>  		ret = -ENOMEM;
>>>> diff --git a/drivers/infiniband/core/smi.h b/drivers/infiniband/core/smi.h
>>>> index 33c91c8..16a9f9a 100644
>>>> --- a/drivers/infiniband/core/smi.h
>>>> +++ b/drivers/infiniband/core/smi.h
>>>> @@ -67,8 +67,7 @@ static inline enum smi_action smi_check_local_smp(struct ib_smp *smp,
>>>>  {
>>>>  	/* C14-9:3 -- We're at the end of the DR segment of path */
>>>>  	/* C14-9:4 -- Hop Pointer = Hop Count + 1 -> give to SMA/SM */
>>>> -	return ((device->process_mad &&
>>>> -		!ib_get_smp_direction(smp) &&
>>>> +	return ((!ib_get_smp_direction(smp) &&
>>>>  		(smp->hop_ptr == smp->hop_cnt + 1)) ?
>>>>  		IB_SMI_HANDLE : IB_SMI_DISCARD);
>>>>  }
>>>> @@ -82,8 +81,7 @@ static inline enum smi_action smi_check_local_returning_smp(struct ib_smp *smp,
>>>>  {
>>>>  	/* C14-13:3 -- We're at the end of the DR segment of path */
>>>>  	/* C14-13:4 -- Hop Pointer == 0 -> give to SM */
>>>> -	return ((device->process_mad &&
>>>> -		ib_get_smp_direction(smp) &&
>>>> +	return ((ib_get_smp_direction(smp) &&
>>>>  		!smp->hop_ptr) ? IB_SMI_HANDLE : IB_SMI_DISCARD);
>>>>  }
>>> Also, with this approach of optional process_mad for IB device, will/how
>>> will sysfs port counters be supported for this device ? This currently
>>> relies on process_mad.
>>
>> Yes, that is actually a problem for us right now.
>> We do however think that the solution of composing a packet to send via process_mad is
>> kind of overkill as this doesn't allow devices to optimize the way to retrieve this info.
>
> Is there a way other than via PMA to get these counters ?

Yes, the driver have a work request based model to request such info from the device.
This is partly firmware based so it can be extended/adapted if necessary.

>>> It should be possible to implement a process_mad routine to return
>>> ib_mad_result based on management class and perhaps attribute ID in the
>>> case of SMInfo. Can this alternative approach be used for SIF ?
>>
>> The problem is that the handle_outgoing_dr_smp function has an implicit assumption that
>> some packets are handled by the process_mad function itself. There is no way to provide return
>> values from the process_mad function that ensures that packets are always forwarded to the device,
>> so the only viable solution without breaking the API seems to be to not implement process_mad.
>
> Are you referring to the difference between returning 0 when no
> process_mad function as this patch does and what happens when
> process_mad returns 0 inside of the ib_mad_post_send routine ?

Yes, that sounds about right, it's been a while since we struggled with this.

> Doesn't the send MAD need to be tracked in the MAD layer ?

The MAD layer tracking happens above the driver, it creates and manages QP0 and sees all mad packets
that gets sent as with Connect-X<n> ?

> Is there some problem invoking ib_send_mad (or ib_send_rmpp_mad) ?

No, to my knowledge we are able to support the normal management
applications just as one would expect.

Thanks,
Knut

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
