From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 0/4] Sending kernel pathrecord query to user cache
 server
Date: Wed, 10 Jun 2015 11:19:39 -0400
Message-ID: <5578558B.1070503@dev.mellanox.co.il>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com> <55783D84.6040709@dev.mellanox.co.il> <3F128C9216C9B84BB6ED23EF16290AFB0CABCC2E@CRSMSX101.amr.corp.intel.com> <55784C35.2020401@dev.mellanox.co.il> <3F128C9216C9B84BB6ED23EF16290AFB0CABCC80@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABCC80-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/10/2015 11:07 AM, Wan, Kaike wrote:
> 
> 
>> -----Original Message-----
>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Sent: Wednesday, June 10, 2015 10:40 AM
>>>
>>>
>>>> -----Original Message-----
>>>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>>>> Sent: Wednesday, June 10, 2015 9:37 AM
>>>>
>>>>>
>>>>> A SA cache is undeniably critical for fabric scalability and performance.
>>>>> In user space, the ibacm application provides a good example of
>>>>> pathrecord cache for address and route resolution. With the recent
>>>>> implementation of the provider architecture, ibacm offers more
>>>> extensibility as a SA cache.
>>>>> In kernel, ipoib implements its own small cache for pathrecords,
>>>>> which is however not available for general use. Furthermore, the
>>>>> implementation of a SA cache in user space offers better
>>>>> flexibility, larger capacity, and more robustness for the system.
>>>>>
>>>>> In this patch series, a mechanism is implemented to allow ib_sa to
>>>>> send pathrecord query to a user application (eg ibacm) through netlink.
>>>>
>>>> While this appears to address the current upstream use model for ACM
>>>> with it's multicast overlay backend where PRs are static, it does not
>>>> appear to address PR changes.
>>>> Should aging/revalidation of PRs be supported ? If so, would this
>>>> make PRs similar at "high" level to IP neighbor cache in kernel ?
>>>
>>> Even for the default provider acmp, PRs will time out and the length of
>> timeout is configurable. For other providers (eg ibssa), the PR change could
>> be managed correctly and promptly, and this capability is beyond ibacm core
>> itself.
>>
>> That deals with the update of PR in user space (ACM). Doesn't kernel need
>> some way of knowing PR was updated ?
> 
> Maybe. If a kernel client is interested in PR changes, it can register for notification 

Wouldn't the notification mechanism be via netlink ? What would the
granularity be for the registrations and notifications ?

> and once a notice is received, it can always go back to query for the new PR. 

> But that is the responsibility of the individual client and is beyond the scope of this patch series.

I thought that the goal is to have an interface that addresses kernel
<-> userspace needs for PRs in general and ACM was just first consumer.
I'm not sure that it's sufficient for other ACM providers.

-- Hal

> Kaike
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
