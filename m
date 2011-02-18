From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Thu, 17 Feb 2011 23:19:22 -0500
Message-ID: <AANLkTikh-8uGccT0tumHAu6cPOBm+k8joCaQ4W-grkHd@mail.gmail.com>
References: <20110217213017.25708.95042.stgit@homer>
	<AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 17, 2011 at 6:20 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:
> On Thu, Feb 17, 2011 at 1:30 PM, Michael Heinz <michael.heinz@qlogic.=
com> wrote:
>> This patch addresses the problem by providing a function to build th=
e node
>> description. If the provided source string for the description conta=
ins an
>> '@' character, the function will substitute the current utsname.
>>
>> This ensures that even after a fabric has been completely initialize=
d, if
>> a node's hostname changes, that change will be reflected in the next=
 sweep
>> of the SM, but also maintains compatibility with existing code since=
 the
>> behavior is unchanged if the description string does not contain an =
'@'
>> character.
>
> This looks like a reasonable approach to me, although of course the S=
M
> has no way of knowing it should update a port's node description if a
> hostname changes.

It does; There's an enhanced trap for this now.

> Aside from some minor quibbles
> =C2=A0- next time please use different subjects for each patch in the=
 thread
> =C2=A0- the prototype of ib_build_node_desc() seems to force every ca=
ll
> =C2=A0 site to have a cast; maybe the function should take a pointer =
to
> =C2=A0 struct ib_smp instead?
> =C2=A0- the internals of ib_build_node_desc() look a bit ugly, is the=
re any
> =C2=A0 way to make it a little cleaner?
> I do like this. =C2=A0Does anyone have any feelings about applying th=
is
> for 2.6.39? =C2=A0Is this shipping in OFED?

I need a little time to review this.

-- Hal

> =C2=A0- R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
