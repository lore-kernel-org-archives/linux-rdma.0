From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Generic InfiniBand transport done in software
Date: Thu, 24 Dec 2015 11:14:16 -0500
Message-ID: <20151224161415.GA674@phlsvsds.ph.intel.com>
References: <CAG9sBKO=fP2Xd=JXK7hvzGFRLQmh1dF+mWDxdnhU+TqFg7YD1Q@mail.gmail.com> <20151222181905.GA742@phlsvsds.ph.intel.com> <CAG9sBKNOu+d-5f6FYTXCyTGjJU-md4dW3MFMB2-UDgRFafRdBw@mail.gmail.com> <20151223200727.GA6886@phlsvsds.ph.intel.com> <CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNkeA2Op-OTJ_MQ=pC3BQ7=_tB4g6oV=fwDOJ7gs_y+fQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 05:43:11PM +0200, Moni Shoua wrote:
>>
>>
>> There were discussions, and Mellanox even contributed code to the effort.
>> See Kamal's patches in the patch set I provided.
>>
>As far as I see it discussions were shallow and never produced an
>agreement. Kamal's patches should not be considered as as such.

Point is others have looked at the code. No issues have been called out to 
date as to why what is there won't work for everyone.

>>> http://marc.info/?l=linux-rdma&m=144952098726776&w=2 presents a work
>>> that besides keeping the name RVT is far from the immature concept I
>>> mentioned earlier and its scope was changed from general purpose
>>> solution to Intel and HFI/QIB only.
>>
>>
>> The scope has never changed. Our goal is, and has always been to remove the
>> code duplication between qib and hfi1. We are doing that by way of rdmavt.
>> It is limited in scope to Intel's drivers currently for what I hope are
>> obvious reasons.
>>
>So you actually agree that rdmavt was intended to be a solution to
>Intel's specific drivers.
>Fair, but IMO this is not what we aimed for.
>In fact, if this is an Intel specific solution then why put it in
>drivers/infiniband/sw and why publish it when it is not ready?

Yes it is specific to Intel *now*, that doesn't mean it should stay that 
way. Rdmavt could, and in my opinion should, be extended to support 
soft-roce. I don't think replicating the same thing is a great idea.

As to the location, where do you think it should go. drivers/infiniband/sw 
makes the most sense to me, but open to suggestions.

And for the question of why publish when it's not ready, the better question 
is why not?  Is it not good to see the work in progress as it evolves so the 
community can provide feedback?

>> I think it makes sense that soft-roce be added as well and hope that
>> Mellanox decides to contribute rather than reinventing the wheel.
>>
>> Is there something in rdmavt that would not work for soft-roce, or is
>> something fundamental missing? I have asked this a number of times and
>> nothing has been raised so I assume there are no issues. If there are lets
>> discuss them.
>>
>Interfaces between rdmavt and its backends are missing. I consider
>this as fundamental.
>Concerns were raised but answers were not provided, at least not
>satisfying answers.

No one is arguing that. It is a work in progress and will get there. More 
details are in in Ira's response.

http://marc.info/?l=linux-rdma&m=145091253118395&w=2

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
