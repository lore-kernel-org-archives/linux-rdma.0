From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] memory: use SCNxPTR format to read uintptr_t
 values
Date: Wed, 11 Jul 2012 18:17:32 +0200
Message-ID: <1342023452.5418.3.camel@test.quest-ce.net>
References: <1342019435-10041-1-git-send-email-ydroneaud@opteya.com>
	 <CAL1RGDUQiWdSYbCH8k7Bwu8y549wQtQ7=tPA1G=uJuGW76G4hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUQiWdSYbCH8k7Bwu8y549wQtQ7=tPA1G=uJuGW76G4hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le mercredi 11 juillet 2012 =C3=A0 08:47 -0700, Roland Dreier a =C3=A9c=
rit :
> On Wed, Jul 11, 2012 at 8:10 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>=
 wrote:
> > @@ -116,7 +117,7 @@ static unsigned long get_page_size(void *base)
> >                 int n;
> >                 uintptr_t range_start, range_end;
> >
> > -               n =3D sscanf(buf, "%lx-%lx", &range_start, &range_e=
nd);
> > +               n =3D sscanf(buf, "%" SCNxPTR "-%" SCNxPTR, &range_=
start, &range_end);
> >
> >                 if (n < 2)
> >                         continue;
>=20
> Looks fine in itself, and I don't necessarily expect you to be the on=
e
> to answer, but:
>=20
>  - what does /proc/<pid>/maps show when running a 32-bit process on a=
 64-bit
>    kernel?  Should we be using uint64_t / SCNx64?  (but surely 32-bit=
 processes
>    are guaranteed to have all their mappings fit into 32 bits)
>=20

"maps" file is presented to 32bits process as a 32bits mapping.

>  - earlier in this function, why do we do /proc/%d/maps, getpid()?  W=
hy doesn't
>    /proc/self/maps always work?
>=20

I think /proc/self/maps would always work here.

Using explicitly the pid could be of use for the child to read its
parent mapping.

Regards

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
