From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/8] uverbs extensions fixes
Date: Tue, 05 Nov 2013 10:05:20 +0100
Message-ID: <1383642320.18301.46.camel@localhost.localdomain>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126771-7658-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 30 octobre 2013 =C3=A0 11:52 +0200, Matan Barak a =C3=A9cri=
t :
> This series is a continuous improvement for the uverbs extension mech=
anism
> that was introduced as an experimental feature for v3.12.
>=20
> Yann Droneaud suggested and implemented the following improvements:
> - structure renaming to match others uverbs public structs;
> - changes usage of the flow_attr.size to not count the
>   "extended command header" but to describe only the size
>   of the flow specs following flow_attr;
> - removed unneeded flow_spec structure that don't need to be
>   exposed to userspace.
> - ensure 64bits alignment
>=20
> This series is actually Yann's series with a bug fix.
>=20
> Changes from Yann's series
> (V0 http://marc.info/?l=3Dlinux-rdma&m=3D138151196022025):
> 1. Re-enable flow steering verbs and the extension verbs mechanism.
> 2. Squashed patches 1 and 2 from the original series
> 3. ib_uverbs_write should return the number of bytes including the
>    header's size (Patch 7).
>=20

Thanks Matan for carrying on the patchset.

I've quite the same patchset, but the other way around, eg. enabling
the flow steering verbs after cleanup on the new ABI. I thought it woul=
d
make more sense this way. Would you like me to send the patchset this
way, with my others patches to rename the function, which was dropped
from my latest attempt in order to squeeze the patchset to bare
minimal ?

Regarding the extensible framework, I haven't found time to design a ne=
w
proposal for the interface.

I keep in my mind that something built around writev(2) (struct iovec)
and/or cmsg(3) / netlink(3) would be preferable to ease sending
multipart command to uverbs subsystem.

BTW, I think we should drop the patch that adds the comp_mask in the
header. As you wrote in a previous mail, a comp_mask could be present
in the "provider" part of the command. This make handling of comp_mask
from header very different, very specific, while it's not, since there
could be more "comp_mask": one in command, one in provider, one in
response and one in the provider response parts. So I would prefer not
have the command comp_mask being treated differently than the other.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
