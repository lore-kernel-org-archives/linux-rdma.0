From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/core: Avoid leakage from kernel to user
 space
Date: Mon, 15 Sep 2014 15:45:00 +0200
Message-ID: <1410788700.7830.3.camel@localhost.localdomain>
References: <1410702475-28826-1-git-send-email-eli@mellanox.com>
	 <1410702475-28826-4-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410702475-28826-4-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 14 septembre 2014 =C3=A0 16:47 +0300, Eli Cohen a =C3=A9cri=
t :
> Clear the reserved field of struct ib_uverbs_async_event_desc which i=
s=20
> copied to user space.
>=20

This one could be applied right now on v3.17 and others.

> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Regards.

> ---
>  drivers/infiniband/core/uverbs_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniba=
nd/core/uverbs_main.c
> index c73b22a257fe..b21af1eaf503 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -477,6 +477,7 @@ static void ib_uverbs_async_handler(struct ib_uve=
rbs_file *file,
> =20
>  	entry->desc.async.element    =3D element;
>  	entry->desc.async.event_type =3D event;
> +	entry->desc.async.reserved   =3D 0;
>  	entry->counter               =3D counter;
> =20
>  	list_add_tail(&entry->list, &file->async_file->event_list);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
