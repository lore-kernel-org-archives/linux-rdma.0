From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Thu, 9 Jun 2016 15:47:59 -0400
Message-ID: <20160609194758.GA9017@phlsvsds.ph.intel.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com> <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com> <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w@mail.gmail.com> <20160609144554.GA14212@phlsvsds.ph.intel.com> <20160609191608.GA5408@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160609191608.GA5408-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 09, 2016 at 10:16:08PM +0300, Leon Romanovsky wrote:
>On Thu, Jun 09, 2016 at 10:45:55AM -0400, Dennis Dalessandro wrote:
>> On Thu, Jun 09, 2016 at 04:17:15PM +0300, Moni Shoua wrote:
>> >2.  Trying to force SoftRoCE on this model will end up with rxe driver
>> >registers to rvt with all ib_device hooks implemented. This makes the
>> >reason to use rvt irrelevant in this case.
>> 
>> Everything? What about AH, MR, PD? Aren't those pretty generic constructs.
>> In fact you folks submitted the change for AH.
>> 
>
>Despite the fact that I submitted change to hfi1, it doesn't make me
>stake holder of that driver.

Let me be more clear. My point is that AH was generic enough for someone at 
Mellanox who was working on soft roce to write a patch for in the first 
place. Now it's somehow not generic enough and would need it's own driver 
specific hook?

Is just being able to use rdmavt's AH functionality enough to justify using 
it?  Probably not, but I see MR, PD, even CQ as being totally generic, is 
that enough? Maybe, maybe not. QP, I think may have some difficulties, maybe 
that's the deal breaker? Bottom line is you can't say _all_ rdmavt functions 
would need overridden. 

So perhaps a statement as to what high level blocks of rdmavt could not be 
used would help put the matter to rest?

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
