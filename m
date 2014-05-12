From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/umad: Remove container_of() != NULL tests
Date: Mon, 12 May 2014 14:40:15 +0200
Message-ID: <1399898415.3017.15.camel@localhost.localdomain>
References: <53708666.6060209@acm.org> <5370869F.5040103@acm.org>
	 <1399889097.3017.1.camel@localhost.localdomain> <5370A41F.8050001@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5370A41F.8050001-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le lundi 12 mai 2014 =C3=A0 12:36 +0200, Bart Van Assche a =C3=A9crit :
> On 05/12/14 12:04, Yann Droneaud wrote:
> > Le lundi 12 mai 2014 =C3=A0 10:30 +0200, Bart Van Assche a =C3=A9cr=
it :
> >> container_of() never returns NULL. Hence remove the code that test=
s
> >> whether container_of() returns NULL.
> >>
> >> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> >> Cc: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
> >> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > The patch seems fine.
> >
> > But I don't think this one qualify for linux-stable.
>=20
> One chunk in patch 3/3 touches code that is also touched by this patc=
h.
> This means that if only patches 2/3 and 3/3 would be sent to stable t=
hat
> these wouldn't apply properly. Hence the "Cc: stable" tag in this pat=
ch.
>=20

You could re-order the patches to make this one apply on top of the two
others.

Anyway, it's a minor issue that doesn't justifiy by itself to respin th=
e
patchset. But if you're going to take account of my others remarks, it
might be worth to reorder the patchset.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
