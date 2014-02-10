From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] NULL undeclared on Fedora
Date: Mon, 10 Feb 2014 12:52:47 +0100
Message-ID: <1392033167.11170.22.camel@localhost.localdomain>
References: <54347E5A035A054EAE9D05927FB467F972DEC731@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54347E5A035A054EAE9D05927FB467F972DEC731-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 10 f=C3=A9vrier 2014 =C3=A0 07:45 +0000, Davis, Arlin R a =C3=A9=
crit :
>  Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  dat/include/dat2/dat_platform_specific.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/dat/include/dat2/dat_platform_specific.h b/dat/include/d=
at2/dat_platform_specific.h
> index ba4cfbc..8d62bd0 100644
> --- a/dat/include/dat2/dat_platform_specific.h
> +++ b/dat/include/dat2/dat_platform_specific.h
> @@ -147,6 +147,7 @@ typedef DAT_UINT64		DAT_PADDR;
>  #if defined(__KERNEL__)
>  #include <linux/types.h>
>  #else
> +#include <stdio.h>

You could use #include <stddef.h> if only NULL is needed
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stddef.h.html

>  #include <sys/types.h>
>  #include <linux/stddef.h>
>  #endif /* defined(__KERNEL__) */

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
