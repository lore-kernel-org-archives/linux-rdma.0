From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: memset attr variable to prevent garbage data
Date: Fri, 26 Sep 2014 14:12:25 +0200
Message-ID: <1411733545.7778.24.camel@localhost.localdomain>
References: <45be0302-ea5d-4f35-892a-47617edd27ec@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <45be0302-ea5d-4f35-892a-47617edd27ec-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 26 septembre 2014 =C3=A0 15:49 +0530, Devesh Sharma a =C3=A9=
crit :
> During create-ah from user land, uverbs is sending
> garbage data in attr.dmac and attr.vlan_id. This
> patch prevents the same.
>=20
> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 0600c50..0b1ce71 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2508,6 +2508,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_fi=
le *file,
>  		goto err;
>  	}
> =20
> +	memset(&attr, 0, sizeof(attr));

It's a bit overkill.

>  	attr.dlid 	       =3D cmd.attr.dlid;
>  	attr.sl 	       =3D cmd.attr.sl;
>  	attr.src_path_bits     =3D cmd.attr.src_path_bits;

Just do

         memset(attr.dmac, 0, sizeof(attr.dmac));
         attr.vlan_id =3D 0;

In the spirit of
<http://marc.info/?i=3D1409661154-13718-1-git-send-email-ogerlitz@mella=
nox.com>,
please add the following to the commit message:

=46ixes: dd5f03beb4f7 ('IB/core: Ethernet L2 attributes in verbs/cm
structures')
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
