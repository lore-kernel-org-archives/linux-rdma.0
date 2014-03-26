From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] IB/core: Don't resolve passive side RoCE L2
 address in cma req handler
Date: Wed, 26 Mar 2014 18:10:24 +0100
Message-ID: <1395853824.3297.34.camel@localhost.localdomain>
References: <1395851011-8081-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395851011-8081-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 26 mars 2014 =C3=A0 18:23 +0200, Or Gerlitz a =C3=A9crit :
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The code that resolves the passive side source mac within the rdma_cm=
=20
> connection request handler was both redundant and buggy, remove it.
>=20
> It was redundant since later, when an RC QP is modified to RTR state=20
> the resolution will take place in the ib_core module. It was buggy b/=
c
> this callback also deals with UD SIDR exchange under which we wrongly
> looked on the REQ member of the CM event and dereferenced a random va=
lue.
>=20

Is that a revert of some patch ?

> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>=20
> Hi Roland, we're post 3.14-rc8 and hence I assume will go to 3.15-rc1=
=20
> and once there we will post it to -stable to it gets into 3.14.y
>=20

Just add Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

See:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Doc=
umentation/stable_kernel_rules.txt?id=3Dv3.14-rc8#n36

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
