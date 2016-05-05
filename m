From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 08:00:34 -0400
Message-ID: <20160505120033.GA23895@phlsvsds.ph.intel.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com> <20160503162457.GB29160@leon.nu> <20160503165403.GA11903@phlsvsds.ph.intel.com> <20160503184218.GC29160@leon.nu> <20160504044107.GE29160@leon.nu> <20160504123621.GC10916@phlsvsds.ph.intel.com> <20160504181509.GA20488@obsidianresearch.com> <20160505063834.GH29160@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160505063834.GH29160-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 05, 2016 at 09:38:34AM +0300, Leon Romanovsky wrote:
>> I'd also make a very clear message to driver submitters: Do not
>> include uAPIs in your initial driver patch set. Those should follow on
>> as dedicated well identified patches so that they attracted the proper
>> review.
>
>It is hard to agree with this point.
>It contradicts to development model of submitting whole feature at once
>and not unconnected piece of code, which someone will be needed to
>maintain without any real user behind it.

I think the message really should be that if your driver contains uAPI 
changes those should be in separate patches that are clearly identified. So 
if you have a driver that is developed off-list initially, instead of just 
breaking it up into chunks for submission add another step.

Something like this:
1) Submit patch series which break-ups internally developed code
2) Submit patch series with separated out uAPI code
3) Submit patch that makes the build go-live

These can all be submitted together, but with the patches broken up like 
this reviewers can target uAPI code more easily.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
