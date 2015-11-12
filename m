From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAVT pull request
Date: Thu, 12 Nov 2015 12:53:47 -0500
Message-ID: <20151112175346.GA5762@phlsvsds.ph.intel.com>
References: <8F089EE2-9289-4F89-8DB4-8CD971927EBB@mellanox.com> <20151109142552.GA16939@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109142552.GA16939-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 09:25:53AM -0500, Dennis Dalessandro wrote:
>On Mon, Nov 09, 2015 at 01:32:03PM +0000, Kamal Heib wrote:
>>   Hi Dennis,
>>   I forked from your rdmavt project at Github and created pull request [1].
>>   Could you please check my pull request for the following patches:
>>   Author: Kamal Heib <[1]kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>   Date:   Sun Nov 8 23:11:09 2015 +0200
>>       IB/rdmavt: Add address handle to rdmavt
>>
>>       Create datastructure for address handle and implement
>>       create/destroy/modify/query of address handle for rdmavt.
>>
>>       Signed-off-by: Kamal Heib <[2]kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>   Author: Kamal Heib <[3]kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>   Date:   Sun Nov 8 21:36:28 2015 +0200
>>       IB/rdmavt: Move common LID defines to rdmavt
>>
>>       Move {QIB, HFI1}_PERMISSIVE_LID to RVT_PERMISSIVE_LID
>>       Move {QIB, HFI1}_MULTICAST_LID_BASE to RVT_MULTICAST_LID_BASE
>>
>>       Signed-off-by: Kamal Heib <[4]kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>   [1] - [5]https://github.com/ddalessa/kernel/pull/1
>
>Hi Kamal,
>
>Thanks for the patches! I will take a look and run some quick sanity tests.

Just to update everyone. I have pulled these patches into a tree and ran 
tests, but the links do not come up. I have not yet been able to determine 
what the problem is. Nothing obvious from code inspection.

Still looking for feedback from anyone on the code which is posted. The 
interfaces are explained in comments. Kamal, or Moni, do you see any
problems with what I have there? If more detail is needed on something just 
let me know.

https://github.com/ddalessa/kernel/tree/rdmavt-v1

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
