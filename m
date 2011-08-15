From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Question about dead code int he libibverbs
Date: Mon, 15 Aug 2011 10:48:52 -0700
Message-ID: <CAG4TOxNQOPSqb2M1FagDOMG7+5uQDXEbULx1Zzm5gacu-WOCCg@mail.gmail.com>
References: <CALvMawp5pSnHeYseJx06kAT=6gogfy6C5k2+=6t=HVhPOfkXjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawp5pSnHeYseJx06kAT=6gogfy6C5k2+=6t=HVhPOfkXjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 14, 2011 at 4:08 AM, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:

> I read the code of the libibverbs and I noticed the following code:
> =A0=A0=A0 file: memory.c
> =A0=A0=A0 function ibv_madvise_range():
>
> The code:
> <snip start>
> =A0=A0=A0=A0=A0=A0=A0 if (node) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp =3D __mm_prev(node)=
;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tmp && node->refcnt=
 =3D=3D tmp->refcnt)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 node =3D merge_ranges(node, tmp);
> =A0=A0=A0=A0=A0=A0=A0 }
> <snip end>
>
> Seems to be useless, since the values of the variables tmp or node ar=
en't in
> use after this code is being executed.

But doesn't merge_ranges() have side effects?  I don't see how this is
dead code.
I guess we could stop storing the return value of merge_ranges().

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
