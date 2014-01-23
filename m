From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 1/2] IB/core: Fix build warnings
Date: Thu, 23 Jan 2014 10:47:00 +0100
Message-ID: <1390470420.9865.1.camel@localhost.localdomain>
References: <1383466844-8805-1-git-send-email-ogerlitz@mellanox.com>
	 <1383466844-8805-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383466844-8805-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 03 novembre 2013 =C3=A0 10:20 +0200, Or Gerlitz a =C3=A9cri=
t :
> Fix the below few "make W=3D1" build warnings we have on the IB core.
>=20
> drivers/infiniband/core/sysfs.c: In function =E2=80=98state_show=E2=80=
=99:
> drivers/infiniband/core/sysfs.c:107: warning: comparison of unsigned =
expression >=3D 0 is always true
> drivers/infiniband/core/verbs.c: In function =E2=80=98ib_modify_qp_is=
_ok=E2=80=99:
> drivers/infiniband/core/verbs.c:783: warning: comparison of unsigned =
expression < 0 is always false
> drivers/infiniband/core/verbs.c:784: warning: comparison of unsigned =
expression < 0 is always false
> drivers/infiniband/core/iwcm.c: In function =E2=80=98destroy_cm_id=E2=
=80=99:
> drivers/infiniband/core/iwcm.c:330: warning: variable =E2=80=98ret=E2=
=80=99 set but not used
>=20
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

PS: Perhaps you could split the patch in two parts: one to remove the
unused variable, and another to remove the check on unsigned variables =
?

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
