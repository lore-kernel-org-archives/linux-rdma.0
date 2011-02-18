From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Fri, 18 Feb 2011 17:57:57 -0500
Message-ID: <AANLkTi=H3MRyH7Cg+iivYhsVNsQyZVD6FN6G12nBUJ8O@mail.gmail.com>
References: <20110217213017.25708.95042.stgit@homer>
	<AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
	<AANLkTikh-8uGccT0tumHAu6cPOBm+k8joCaQ4W-grkHd@mail.gmail.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB4A20B289C7@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B289C7-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike,

On Fri, Feb 18, 2011 at 11:22 AM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>=
 wrote:
> Hal,
>
> I'm in the process of smoke-testing changes to meet Roland's "quibble=
s" - I'm going to change the code to pass the structure instead of a ch=
ar*.
>
> Also, I just want to point out that even in the case where no enhance=
d trap is used, any change will still be seen by the SM the next time i=
t sweeps. There will still be lag involved, but I don't think it's insu=
rmountable.

That's not true for all SMs. It's true for a "heavy" but not a "light"
sweep. There's no requirement to rediscover NodeDescriptions all the
time periodically.

I should have my comments (on your now updated patches) by COB Tuesday
as Monday is a holiday.

-- Hal

> -----Original Message-----
> From: Hal Rosenstock [mailto:hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, February 17, 2011 11:19 PM
> To: Roland Dreier
> Cc: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 0/2] Improved node descriptions
>
> On Thu, Feb 17, 2011 at 6:20 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wr=
ote:
>> On Thu, Feb 17, 2011 at 1:30 PM, Michael Heinz <michael.heinz@qlogic=
=2Ecom> wrote:
>>> This patch addresses the problem by providing a function to build t=
he node
>>> description. If the provided source string for the description cont=
ains an
>>> '@' character, the function will substitute the current utsname.
>>>
>>> This ensures that even after a fabric has been completely initializ=
ed, if
>>> a node's hostname changes, that change will be reflected in the nex=
t sweep
>>> of the SM, but also maintains compatibility with existing code sinc=
e the
>>> behavior is unchanged if the description string does not contain an=
 '@'
>>> character.
>>
>> This looks like a reasonable approach to me, although of course the =
SM
>> has no way of knowing it should update a port's node description if =
a
>> hostname changes.
>
> It does; There's an enhanced trap for this now.
>
>> Aside from some minor quibbles
>> =C2=A0- next time please use different subjects for each patch in th=
e thread
>> =C2=A0- the prototype of ib_build_node_desc() seems to force every c=
all
>> =C2=A0 site to have a cast; maybe the function should take a pointer=
 to
>> =C2=A0 struct ib_smp instead?
>> =C2=A0- the internals of ib_build_node_desc() look a bit ugly, is th=
ere any
>> =C2=A0 way to make it a little cleaner?
>> I do like this. =C2=A0Does anyone have any feelings about applying t=
his
>> for 2.6.39? =C2=A0Is this shipping in OFED?
>
> I need a little time to review this.
>
> -- Hal
>
>> =C2=A0- R.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
> This message and any attached documents contain information from QLog=
ic Corporation or its wholly-owned subsidiaries that may be confidentia=
l. If you are not the intended recipient, you may not read, copy, distr=
ibute, or use this information. If you have received this transmission =
in error, please notify the sender immediately by reply e-mail and then=
 delete this message.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
