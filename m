From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Temporarily disable ex_query_device uverb
Date: Mon, 02 Feb 2015 14:10:26 +0100
Message-ID: <1422882626.3030.56.camel@opteya.com>
References: <1422797730-14571-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422797730-14571-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le dimanche 01 f=C3=A9vrier 2015 =C3=A0 15:35 +0200, Haggai Eran a =C3=A9=
crit :
> Commit 5a77abf9a97a ("IB/core: Add support for extended query device =
caps")
> added a new extended verb to query the capabilities of RDMA devices, =
but the
> semantics of this verb are still under debate [1].
>=20
> Block access to this verb from user-space until the new semantics are=
 in
> place.
>=20
> Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> [1] [PATCH v1 0/5] IB/core: extended query device caps cleanup for v3=
=2E19
>     http://www.spinics.net/lists/linux-rdma/msg22904.html
>=20
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

> ---
>=20
> Hi Roland,
>=20
> As I wrote in a separate mail, I hope you can accept Yann's patches t=
o modify
> the new query device verb [1] in time for kernel 3.19.=20
>=20
> If you decide to revert the extended query device verb, here is a min=
imal patch
> to do block this verb temporarily, leaving the rest of the ODP infras=
tructure
> in-place.
>=20
> Regards,
> Haggai
>=20
>  drivers/infiniband/core/uverbs_main.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniba=
nd/core/uverbs_main.c
> index e6c23b9eab33..5db1a8cc388d 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -123,7 +123,6 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uve=
rbs_file *file,
>  				    struct ib_udata *uhw) =3D {
>  	[IB_USER_VERBS_EX_CMD_CREATE_FLOW]	=3D ib_uverbs_ex_create_flow,
>  	[IB_USER_VERBS_EX_CMD_DESTROY_FLOW]	=3D ib_uverbs_ex_destroy_flow,
> -	[IB_USER_VERBS_EX_CMD_QUERY_DEVICE]	=3D ib_uverbs_ex_query_device
>  };
> =20
>  static void ib_uverbs_add_one(struct ib_device *device);

That's the smallest (and smartest) patch to be applied instead of
reverting.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
