From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] NULL undeclared on Fedora
Date: Tue, 11 Feb 2014 12:37:31 +0100
Message-ID: <1392118651.11170.31.camel@localhost.localdomain>
References: <54347E5A035A054EAE9D05927FB467F972DEC731@ORSMSX101.amr.corp.intel.com>
	 <1392033167.11170.22.camel@localhost.localdomain>
	 <54347E5A035A054EAE9D05927FB467F972DEC88A@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54347E5A035A054EAE9D05927FB467F972DEC88A-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 10 f=C3=A9vrier 2014 =C3=A0 19:14 +0000, Davis, Arlin R a =C3=A9=
crit :
> > > --- a/dat/include/dat2/dat_platform_specific.h
> > > +++ b/dat/include/dat2/dat_platform_specific.h
> > > @@ -147,6 +147,7 @@ typedef DAT_UINT64		DAT_PADDR;
> > >  #if defined(__KERNEL__)
> > >  #include <linux/types.h>
> > >  #else
> > > +#include <stdio.h>
> >=20
> > You could use #include <stddef.h> if only NULL is needed
> > http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stddef.h.h=
tml
>=20
> There was an issue with Fedora where linux/stddef.h is empty. Looks l=
ike
> I need to clean this up and use <stddef.h> instead of <linux/stddef.h=
>=20
> for the non-kernel build.
>=20

In the kernel sources include/uapi/linux/stddef.h has only one line :
#include <linux/compiler.h>.

And <linux/compiler.h> is in include/linux/compiler.h thus not made
available to userspace: it's removed as part of header sanitise process
in make headers_install (see scripts/headers_install.sh).

I believe empty linux/stddef.h is kept for userspace compatibility:
http://codesearch.debian.net/search?q=3D%23include+%3Clinux%2Fstddef.h%=
3E

Newer userspace code should probably not use it anymore.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
