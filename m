From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Wed, 4 May 2016 08:20:45 -0400
Message-ID: <20160504122044.GB10916@phlsvsds.ph.intel.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com> <20160503162457.GB29160@leon.nu> <20160503165403.GA11903@phlsvsds.ph.intel.com> <20160503184218.GC29160@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503184218.GC29160-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 03, 2016 at 09:42:18PM +0300, Leon Romanovsky wrote:
>On Tue, May 03, 2016 at 12:54:05PM -0400, Dennis Dalessandro wrote:
>> On Tue, May 03, 2016 at 07:24:57PM +0300, Leon Romanovsky wrote:
>> >On Mon, May 02, 2016 at 03:55:02PM -0400, Dennis Dalessandro wrote:
>> >>We also should be able to use any of these schemes to handle our eprom
>> >>reading/writing. Adding eprom to IPoIB as Doug suggested is a fine plan, but
>> >>we technically don't need to do it right now when we could make do with the
>> >>"UI" functionality and hide the details in user space. In the future there
>> >>may well be value in having an eprom capability in the rdma sub-system, but
>> >>for now we believe we can avoid extending the kernel in this regard.
>> >
>> >Just to understand better your RFC. Are you asking from the community
>> >excuse do not implement core functionality just because you don't need
>> >it? Am I right?
>> 
>> The purpose of the RFC is to get the community's feedback on our plans to
>> solve our UI/EPROM issue. The paragraphs [1] not snipped in your response
>> focus on that. It comes down to:
>> 
>> Use resource0 which does not support locking vs use a file in
>> /sys/kernel/debug.
>
>I didn't quote the whole email because I didn't see any question in
>these 3 options:
>* First option - doesn't meet the requirements and hard to extend.
>* Second option - doesn't meet the requirements and HW limitations
>* Third option - presented as one possible option and looks like the
>  correct one.
>
>And the real question is "where" do you need to implement third option.

As in where would it be visible? That would be in /sys/kernel/debug/hfi1.  
We have some counters and stats there already.  Based on Jason's response 
I'm thinking we can use that just for the locking aspect.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
