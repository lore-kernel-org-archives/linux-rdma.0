From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/6] IB/hfi1, qib, cm, sa: Last set for 4.15
 merge window
Date: Wed, 29 Nov 2017 13:43:03 -0500
Message-ID: <0b5b45ef-9a05-7c89-7926-27d097bae68e@intel.com>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114122859.10579.79788.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/14/2017 7:34 AM, Dennis Dalessandro wrote:
> Hi Doug,
> 
> Here is the latest set of patches I have that we'd like to land in 4.15. There
> are some driver fixes, including a qib that is marked as stable. We also have
> a CM and SA patch thrown in the mix.
> 
> As always patches available for browsing at:
> https://github.com/ddalessa/kernel/tree/for-4.15
> 
> ---
> 
> Dennis Dalessandro (1):
>        IB/hfi1: Initialize bth1 in 16B rc ack builder

This is probably the only one that really needs to go for the rc. The 
rest can push off till 4.16 I think. This is trivial and prevents use of 
an uninitialized variable.

> Don Hiatt (2):
>        IB/hfi1: Mask the path bits with the LMC for 16B RC Acks
>        IB/CM: Change sgid to IB GID when handling CM request

These two fix problems introduced in 4.13

> Jan Sokolowski (1):
>        IB/hfi1: Use 4096 for default active MTU in query_qp

This is not a critical bug fix.

> Mike Marciniszyn (1):
>        IB/qib: Fix comparison error with qperf compare/swap test

This one is an older bug in qib.

> Venkata Sandeep Dhanalakota (1):
>        IB/SA: Check dlid before SA agent queries for ClassPortInfo

Still under discussion/rework.

Jason, if you want to pull:
https://patchwork.kernel.org/patch/10057487/
for the -rc I can submit a v2 of the other 5 once Sandeep's rework is ready.

-Denny


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
