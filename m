From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Sun, 12 Jun 2016 12:51:16 +0300
Message-ID: <CAG9sBKN3+Yf7dUG0ORNFNG=j+AgR1eq5mvPQxx6jZEXEGRpk3w@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com> <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w@mail.gmail.com>
 <20160609144554.GA14212@phlsvsds.ph.intel.com> <20160609191608.GA5408@leon.nu>
 <20160609194758.GA9017@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609194758.GA9017-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 9, 2016 at 10:47 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Jun 09, 2016 at 10:16:08PM +0300, Leon Romanovsky wrote:
>>
>> On Thu, Jun 09, 2016 at 10:45:55AM -0400, Dennis Dalessandro wrote:
>>>
>>> On Thu, Jun 09, 2016 at 04:17:15PM +0300, Moni Shoua wrote:
>>> >2.  Trying to force SoftRoCE on this model will end up with rxe driver
>>> >registers to rvt with all ib_device hooks implemented. This makes the
>>> >reason to use rvt irrelevant in this case.
>>>
>>> Everything? What about AH, MR, PD? Aren't those pretty generic
>>> constructs.
>>> In fact you folks submitted the change for AH.
>>>
>>
>> Despite the fact that I submitted change to hfi1, it doesn't make me
>> stake holder of that driver.
>
>
> Let me be more clear. My point is that AH was generic enough for someone at
> Mellanox who was working on soft roce to write a patch for in the first
> place. Now it's somehow not generic enough and would need it's own driver
> specific hook?
>
You are right on this Denny. AH structure suits SoftRoCE but as you
say below this is not enough to justify using rdmavt for SoftRoCE

> Is just being able to use rdmavt's AH functionality enough to justify using
> it?  Probably not, but I see MR, PD, even CQ as being totally generic, is
> that enough? Maybe, maybe not. QP, I think may have some difficulties, maybe
> that's the deal breaker? Bottom line is you can't say _all_ rdmavt functions
> would need overridden.
I'm sorry if I gave the impression that I think everything is not
generic but this doesn't change the fact that there are deal breakers
in rdmavt.
I'd like to explain myself again, rdmavt was designed for a specific
use: to avoid code duplications in Intel drivers. But like no one
asked before to unify Intel HW driver with another HW vendor driver
there is no reason to ask unifying it now (SoftRoCE is considered a
virtual HW driver). Each vendor has it's own logic and technology for
resource usage, acceleration, abstraction and so on and before you
start building a generic SW driver you need to find an abstract HW
model first. This kind of work has never been done AFAIK. Sure, there
are some blocks that I would take from rdmavt to this SW driver but
that's it.
To be clear, for what is was designed for, rdmavt is well designed.
There was no criticism on this. All I was saying is that SoftRoCe has
different needs
> So perhaps a statement as to what high level blocks of rdmavt could not be
> used would help put the matter to rest?

>
>
> -Denny
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
