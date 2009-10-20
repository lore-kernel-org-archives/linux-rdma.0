From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Multicast joins failing on 1.5-rc1?
Date: Tue, 20 Oct 2009 14:52:00 -0400
Message-ID: <f0e08f230910201152g476383ffp8e7392dc0c48e41@mail.gmail.com>
References: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5E1097A-DFEA-4508-A47F-FF07C34EA525-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2009 at 2:16 PM, stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org> =
wrote:

<snip...>

> When I looked closer, I can see that I get an error -22 on the multic=
ast
> joins (using a qlogic switche's SM) for everything _except_ the broad=
cast
> join. =C2=A0I switched over to opensm, since it has far better debugg=
ing
> abilities and see the same behavior, though the error code is opensm =
logs a
> message with error 1B11.
>
> When I look through for the code, I found that error code associated =
with an
> invalid set of component masks:
> Oct 20 12:40:05 824130 [44240940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B1=
1:
> method =3D SubnAdmSet, scope_state =3D 0x1, component mask =3D 0x0000=
000000010083,
> expected comp mask =3D 0x00000000000130c7, MGID: ff12:601b:ffff::16 f=
rom port
> 0x0002c90300032431 (x3 HCA-1)

This is join behavior when the group is not (previously) created (by
some full member). Any idea what was creating this group before ?

-- Hal

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
