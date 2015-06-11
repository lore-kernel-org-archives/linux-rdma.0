From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 11 Jun 2015 09:25:05 -0400
Message-ID: <55798C31.5090600@dev.mellanox.co.il>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com> <1433861837-26177-5-git-send-email-kaike.wan@intel.com> <55787838.3020606@dev.mellanox.co.il> <20150610191026.GA28334@obsidianresearch.com> <5578955A.4070001@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E1109B14D@CRSMSX101.amr.corp.intel.com> <55797DF3.6050304@dev.mellanox.co.il> <3F128C9216C9B84BB6ED23EF16290AFB0CABD089@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABD089-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/11/2015 8:54 AM, Wan, Kaike wrote:
>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Sent: Thursday, June 11, 2015 8:24 AM
>> To: Weiny, Ira
>> Cc: Jason Gunthorpe; Wan, Kaike; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John
>> Subject: Re: [PATCH v4 4/4] IB/sa: Route SA pathrecord query through netlink
>>
>> On 6/10/2015 5:09 PM, Weiny, Ira wrote:
>>>> On 6/10/2015 3:10 PM, Jason Gunthorpe wrote:
>>>>> On Wed, Jun 10, 2015 at 01:47:36PM -0400, Hal Rosenstock wrote:
>>>>>> On 6/9/2015 10:57 AM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>>>>>>> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>>>
>>>>>>> This patch routes a SA pathrecord query to netlink first
>>>>>>
>>>>>> Should only unicast PRs be done in this manner or should API
>>>>>> support enabling for unicast and/or multicast ?
>>>>>>
>>>>>> AFAIK kernel doesn't query multicast PRs now (queries MCMRs) but
>>>>>> this seems like it would help make it future proof and not have to
>>>>>> take timeout on local query unless app supports it.
>>>>>
>>>>> It is a good question. We can clearly extend toward that, using a
>>>>> MGID as the DGID and adding additional nested netlink fields.
>>>>>
>>>>> However, does it make sense?
>>>>
>>>> If it doesn't make sense, then should MGIDs as DGIDs never be
>>>> requested via the PR netlink API ?
>>>>
>>>
>>> Why should we prevent it?  What does it hurt?
>>
>> It's merely an optimization in that round trip to user space is avoided with
>> user space needing to perform some validation/lookup which would fail in
>> case multicast PRs not supported (which is case for ACM with multicast
>> backend).
> 
> If the kernel client can query SA for mulitcast PRs, why can't ibacm (even backed by acmp)? 

It can.

> Is there any code there that prevents a mgid being used as the destination?

No. It's a matter of optimization only.

>>
>> If user space PR capabilities (unicast, multicast, both) is supported, it affects
>> the API. 
> How? If we can query SA for multicast PRs without joining the multicast groups, 
> what additional changes in netlink API do we need to support both?

Nothing to support both but if we wanted to disable one or other based
on user space we would but it sounds like we don't need/want this but
would use user space rejection/no data for this.

>> Maybe it's overkill but requires user space to indicate no PR available
>> for multicast DGIDs. I think this is the tradeoff to be made/decided.
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
