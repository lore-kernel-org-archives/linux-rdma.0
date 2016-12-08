From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 03/11] IB/core: Change ah_attr.dlid from 16 to 32 bits
Date: Thu, 8 Dec 2016 14:01:15 -0800
Message-ID: <9400a611-e37a-3e1f-2233-5650b4856831@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-4-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BCAD7@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BCAD7-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/8/2016 1:12 PM, Hefty, Sean wrote:
> Example:
>
>> -		if (rmpp_recv->slid == ah_attr.dlid) {
>> +		if (rmpp_recv->slid == (u16)ah_attr.dlid) {
>
>>  struct ib_ah_attr {
>>  	struct ib_global_route	grh;
>> -	u16			dlid;
>> +	u32			dlid;
>
> There are a bunch of places where the lid is simply cast back to a u16.  How is the code supposed to determine if a u16 cast is a safe operation or not?

The idea is that all underlying drivers which use the dlid field from 
the address handle will use then after casting to u16. That way there is 
no change in the driver behavior.

The only exception is the hfi1 driver which will use the full 32 bit 
lid. Patches specific to hfi1 driver are in the works and will be posted 
once this patch series is accepted.

ULPs, and other core data structures like the ones in rpmm_recv have 
been modified to be 32 bits. The u16 cast you see in this patch was 
added to avoid compiler warnings. Patch 07/11 removes the cast when 
rmpp_recv->slid is increased to 32 bits. Like Jason pointed out before, 
i will re-order these patches which will avoid some of these temporary 
casts.
>
> I don’t like the overloading of the term 'lid' to sometimes mean a 16-bit value and other times a 32-bit value, with no way of distinguishing which one we have.  Maybe we need to call out a version (lidv2 = 32-bits) or carry the size.  I don't have a strong idea here.  But when looking at this patch, lid is re-defined to u32, then nearly everywhere cast back to u16, which looks questionable.
The intention was to not cause too many changes to the underlying 
drivers when the lid field was increased. Casting was a simpler approach.

In summary, once all these patches are through, the cast to u16 only be 
in the drivers and not in the core data structures.
>
> - Sean
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
