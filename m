From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Thu, 9 Jun 2016 18:12:17 +0300
Message-ID: <CAG9sBKO-m9zjoVDhiz6skshtizZcSc8BdzzHtEHmYz1j1qcrng@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com> <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w@mail.gmail.com>
 <20160609144554.GA14212@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609144554.GA14212-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> 2.  Trying to force SoftRoCE on this model will end up with rxe driver
>> registers to rvt with all ib_device hooks implemented. This makes the
>> reason to use rvt irrelevant in this case.
>
>
> Everything? What about AH, MR, PD? Aren't those pretty generic constructs.
> In fact you folks submitted the change for AH.
>
OK, I guess I can use these hooks from rvt but this still is not
enough to justify the use of it.
You are right, we did contribute few lines to AH but this was when we
thought we thought that the rvt design will be different.
>> 3.  Modifying rvt model to make it more suitable for a generic lower
>> driver model can have a big effect on QIB/HF1 performance. This
>> probably will raise objections from QIB/HF1 owners. In that context I
>> want to say that attempts to influence rvt model months ago, when rvt
>> was still an idea, were rejected with this exact reason (being bad for
>> QIB/HF1 performance).
>
>
> Yes, performance trumps, that's the nature of the game.
Not complaining :)

>
> I'm not saying that you have to use rdmavt, however I believe it could be
> possible.  Also I want to make it clear that we are not against changes in
> rdmavt to further its use in other drivers. In fact quite the contrary.
> Changes are welcomed, of course with the caveat that it does not harm
> performance.
>
If you remember I tried to send an alternative to rdmavt with which I
believe  was a base for generic SW driver that can attach to a thin
net layer. The biggest problem there was to develop abstract
interfaces to those net layers that uses the HW specific capabilities
for performance. It was you guys who used the performance argument to
reject the suggestion.



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
