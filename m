From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1] IB/core: memset attr variable to prevent garbage data
Date: Fri, 26 Sep 2014 17:24:04 +0200
Message-ID: <1411745044.7778.30.camel@localhost.localdomain>
References: <1303ef19-9e66-4ad0-9788-995faadb05ab@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303ef19-9e66-4ad0-9788-995faadb05ab-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 26 septembre 2014 =C3=A0 19:30 +0530, Devesh Sharma a =C3=A9=
crit :
> During create-ah from user land, uverbs is sending
> garbage data in attr.dmac and attr.vlan_id. This
> patch prevents the same.
>=20

Is the last sentence complete ?

> Fixes: dd5f03beb4f7 ('IB/core: Ethernet L2 attributes in verbs/cm
> structures')
>=20
> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Thanks for the updated patch.

Please put the "Cc:" in the commit message:

=46ixes: dd5f03beb4f7 ('IB/core: Ethernet L2 attributes in verbs/cm str=
uctures')
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

This way, the list of people involved in handling the issue would be
recorded in the git history.
Additionnaly, git send-email gathers the Cc: in the commit message and
automatically send the email to the people listed.

> ---
>  drivers/infiniband/core/uverbs_cmd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 0600c50..5ba2a86 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2518,6 +2518,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_fi=
le *file,
>  	attr.grh.sgid_index    =3D cmd.attr.grh.sgid_index;
>  	attr.grh.hop_limit     =3D cmd.attr.grh.hop_limit;
>  	attr.grh.traffic_class =3D cmd.attr.grh.traffic_class;
> +	attr.vlan_id           =3D 0;
> +	memset(&attr.dmac, 0, sizeof(attr.dmac));

OK.

>  	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
> =20
>  	ah =3D ib_create_ah(pd, &attr);

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
