From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] ibacm: In acm_util.c:acm_if_iter_sys, try
 IPv4 if IPv6 doesn't find any appropriate interfaces
Date: Wed, 25 Oct 2017 12:50:59 -0400
Message-ID: <70189c34-5ad3-1dbe-00a3-abfee6bd230e@dev.mellanox.co.il>
References: <8d19d9a9-1f97-408e-ca60-d42e67fbf60c@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AB1A24BB@ORSMSX109.amr.corp.intel.com>
 <cb3ecc66-d128-e735-4bc7-c35aca3fa915@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AB1A2521@ORSMSX109.amr.corp.intel.com>
 <20171025162235.GE15557@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025162235.GE15557-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/25/2017 12:22 PM, Jason Gunthorpe wrote:
> On Wed, Oct 25, 2017 at 03:35:09PM +0000, Hefty, Sean wrote:
>>>>> @@ -135,9 +136,12 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void
>>>>> *ctx)
>>>>>  	size_t addr_len;
>>>>>  	char *alias_sep;
>>>>>
>>>>> -	s = socket(AF_INET6, SOCK_DGRAM, 0);
>>>>> -	if (!s)
>>>>> -		return -1;
>>>>> +next_family:
>>>>> +	s = socket(family, SOCK_DGRAM, 0);
>>>>> +	if (!s) {
>>>>
>>>> If ipv6 is disabled, wouldn't we fail here and could open an ipv4
>>> socket?  So, we don't goto out just to go back to this location?
>>>
>>> In the case where ipv6 is disabled in kernel, the socket is created
>>> but the ioctl failed.
>>
>> That seems goofy IMO.  Thanks for the explanation though.  :)
> 
> This explanation should go in the commit message..

Added to next version of patch

> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
