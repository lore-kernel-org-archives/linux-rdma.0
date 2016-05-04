From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Wed, 4 May 2016 08:36:21 -0400
Message-ID: <20160504123621.GC10916@phlsvsds.ph.intel.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com> <20160503162457.GB29160@leon.nu> <20160503165403.GA11903@phlsvsds.ph.intel.com> <20160503184218.GC29160@leon.nu> <20160504044107.GE29160@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504044107.GE29160-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 07:41:07AM +0300, Leon Romanovsky wrote:
>> I didn't quote the whole email because I didn't see any question in
>> these 3 options:
>> * First option - doesn't meet the requirements and hard to extend.
>> * Second option - doesn't meet the requirements and HW limitations
>> * Third option - presented as one possible option and looks like the
>>   correct one.
>> 
>> And the real question is "where" do you need to implement third option.
>
>And to remove the tension, all what you was supposed to ask can be
>summarized in one question: "Do we have other customers for EEPROM in
>our RDMA stack?". If the answer is yes, you will need to implement it in
>core, and if the answer is no, you will implement it in your driver.
>
>Hope it helps.

I think it's slightly more complicated than that. There are three options 
really: core, driver, or get it out of the kernel.

Whether we have other things that need EEPROM in the RDMA stack is only part 
of the question. We also should consider: do we have customers for EEPROM in 
the RDMA stack that could program/access said EEPROM using user space and 
are instead doing it in a driver?

If that is the case then I'd say they should follow the path we are planning 
for hfi1 and remove the code from the kernel. If there is already a way to 
do something from user space that should be leveraged as much as possible.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
