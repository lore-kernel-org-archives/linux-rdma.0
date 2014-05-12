From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/umad: Remove container_of() != NULL tests
Date: Mon, 12 May 2014 12:04:57 +0200
Message-ID: <1399889097.3017.1.camel@localhost.localdomain>
References: <53708666.6060209@acm.org> <5370869F.5040103@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5370869F.5040103-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 12 mai 2014 =C3=A0 10:30 +0200, Bart Van Assche a =C3=A9crit :
> container_of() never returns NULL. Hence remove the code that tests
> whether container_of() returns NULL.
>=20
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The patch seems fine.

But I don't think this one qualify for linux-stable.

> ---
>  drivers/infiniband/core/user_mad.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/=
core/user_mad.c
> index f0d588f..e61287c 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -783,10 +783,7 @@ static int ib_umad_open(struct inode *inode, str=
uct file *filp)
>  	int ret;
> =20
>  	port =3D container_of(inode->i_cdev, struct ib_umad_port, cdev);
> -	if (port)
> -		kref_get(&port->umad_dev->ref);
> -	else
> -		return -ENXIO;
> +	kref_get(&port->umad_dev->ref);
> =20
>  	mutex_lock(&port->file_mutex);
> =20
> @@ -880,10 +877,7 @@ static int ib_umad_sm_open(struct inode *inode, =
struct file *filp)
>  	int ret;
> =20
>  	port =3D container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
> -	if (port)
> -		kref_get(&port->umad_dev->ref);
> -	else
> -		return -ENXIO;
> +	kref_get(&port->umad_dev->ref);
> =20
>  	if (filp->f_flags & O_NONBLOCK) {
>  		if (down_trylock(&port->sm_sem)) {

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
