From: Devesh Sharma <devesh28-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: release of debug/test tools for dapl and verbs
Date: Mon, 7 Dec 2009 19:03:53 +0530
Message-ID: <309a667c0912070533h20f94fdamf22761876105294e@mail.gmail.com>
References: <Pine.LNX.4.62.0912042106220.7602@mailhub.cdac.in>
	 <603F8A3875DCE940BA37B49D0A6EA0AE3C99B6C0@azsmsx501.amr.corp.intel.com>
	 <b681c62b0912070359m23d21bc2tf614258f2ae398d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b681c62b0912070359m23d21bc2tf614258f2ae398d4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "javed-If5XQcfNmg0@public.gmane.org" <javed-If5XQcfNmg0@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello chien,
thanks for your instant response. In addition to the TED explaination,
following is the elaboration for Vertde.

As far as ib-verbs API remains same, it should work with iWARP
hardware also, however we have not tested this path. In the future
releases this will be taken care.

Vertde is developed to test and debug kernel level ib-verbs, it does
not use IB or iWARP protocol dependent connection management service
for path resolution and address resolution, this has to be done
manually.

Comments, suggestions and feedback are welcome.

Thanks & Regards
Devesh

On Mon, Dec 7, 2009 at 5:29 PM, yogeshwar sonawane <yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> Hi chien,
>
> TED is an environment on top of uDAPL library. Hence TED can be run
> over iWARP adapters using there uDAPL libraries.
>
> Currently, TED source has uDAPL provider limits set for OFED uDAPL
> library. Kindly have a look at them (dbg_def.h under src/include path=
)
> and if required, change them. Things should work then.
>
> Till now, we have not tested TED with iWARP adapters. In future, we
> will try to do it.
>
> Any questions/suggestions/feedback is welcome.
>
> Thanks & Regards,
> Yogeshwar
>
> On Fri, Dec 4, 2009 at 9:52 PM, Tung, Chien Tin
> <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>can be used over any implementation of uDAPL/verbs over IB. there wi=
ll be
>>>regular updations with new features, bug fixes, docs etc. suggestion=
s are
>>>welcome.
>>
>> Will your tools work for iWARP adapters as well?
>>
>> Chien
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
