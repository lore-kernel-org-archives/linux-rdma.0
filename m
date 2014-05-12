From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/umad: Fix error handling
Date: Mon, 12 May 2014 12:18:10 +0200
Message-ID: <1399889890.3017.6.camel@localhost.localdomain>
References: <53708666.6060209@acm.org> <537086BA.3020807@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537086BA.3020807-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 12 mai 2014 =C3=A0 10:30 +0200, Bart Van Assche a =C3=A9crit :
> Avoid leaking a kref count in ib_umad_open() if port->ib_dev =3D=3D N=
ULL
> or if nonseekable_open() fails. Avoid leaking a kref count, that
> sm_sem is kept down and also that the IB_PORT_SM capability mask is
> not cleared in ib_umad_sm_open() if nonseekable_open() fails.
>=20
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/infiniband/core/user_mad.c | 37 +++++++++++++++++++++++-----=
---------
>  1 file changed, 23 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/=
core/user_mad.c
> index e61287c..5c67d80 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -780,24 +780,20 @@ static int ib_umad_open(struct inode *inode, st=
ruct file *filp)
>  {
>  	struct ib_umad_port *port;
>  	struct ib_umad_file *file;
> -	int ret;
> +	int ret =3D -ENXIO;
> =20

I don't like the way ret is gratuitously set,

>  	port =3D container_of(inode->i_cdev, struct ib_umad_port, cdev);
>  	kref_get(&port->umad_dev->ref);
> =20
>  	mutex_lock(&port->file_mutex);
> =20
> -	if (!port->ib_dev) {
> -		ret =3D -ENXIO;
> +	if (!port->ib_dev)
>  		goto out;
> -	}
> =20
> +	ret =3D -ENOMEM;

especially here: I think it should be moved in the error handling path:

>  	file =3D kzalloc(sizeof *file, GFP_KERNEL);
> -	if (!file) {
> -		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
> -		ret =3D -ENOMEM;

keep it here.

> +	if (!file)
>  		goto out;
> -	}
> =20
>  	mutex_init(&file->mutex);
>  	spin_lock_init(&file->send_lock);
> @@ -814,6 +810,10 @@ static int ib_umad_open(struct inode *inode, str=
uct file *filp)
> =20
>  out:
>  	mutex_unlock(&port->file_mutex);
> +
> +	if (ret)
> +		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
> +
>  	return ret;
>  }
> =20
> @@ -892,18 +892,27 @@ static int ib_umad_sm_open(struct inode *inode,=
 struct file *filp)
>  	}
> =20
>  	ret =3D ib_modify_port(port->ib_dev, port->port_num, 0, &props);
> -	if (ret) {
> -		up(&port->sm_sem);
> -		goto fail;
> -	}
> +	if (ret)
> +		goto up_sem;
> =20
>  	filp->private_data =3D port;
> =20
> -	return nonseekable_open(inode, filp);
> +	ret =3D nonseekable_open(inode, filp);
> +	if (ret)
> +		goto clr_sm_cap;
> =20
>  fail:
> -	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
> +	if (ret)
> +		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
>  	return ret;
> +
> +clr_sm_cap:
> +	swap(props.set_port_cap_mask, props.clr_port_cap_mask);
> +	ib_modify_port(port->ib_dev, port->port_num, 0, &props);
> +
> +up_sem:
> +	up(&port->sm_sem);
> +	goto fail;

I dislike jump backward, why not unconditionally call kref_put() in the
error path and return ret here.

This way you could drop fail label and the test on ret in the default
code path.

>  }
> =20
>  static int ib_umad_sm_close(struct inode *inode, struct file *filp)

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
