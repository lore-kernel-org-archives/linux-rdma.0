From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/umad: Fix a use-after-free
Date: Tue, 13 May 2014 19:43:28 +0200
Message-ID: <1400003008.3017.45.camel@localhost.localdomain>
References: <5371F430.5010109@acm.org> <5371F498.6010101@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5371F498.6010101-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Chiang <achiang-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 13 mai 2014 =C3=A0 12:31 +0200, Bart Van Assche a =C3=A9crit :
> Avoid that closing /dev/infiniband/umad<n> or /dev/infiniband/issm<n>
> triggers a use-after-free. __fput() in fs/file_table.c invokes
> f_op->release() before it invokes cdev_put(). Make sure that the
> ib_umad_device structure is freed by the cdev_put() call instead of
> f_op->release(). This avoids that changing the port mode from IB into
> Ethernet and back to IB followed by restarting opensmd triggers the
> following kernel oops:
>=20
> general protection fault: 0000 [#1] PREEMPT SMP
> RIP: 0010:[<ffffffff810cc65c>]  [<ffffffff810cc65c>] module_put+0x2c/=
0x170
> Call Trace:
>  [<ffffffff81190f20>] cdev_put+0x20/0x30
>  [<ffffffff8118e2ce>] __fput+0x1ae/0x1f0
>  [<ffffffff8118e35e>] ____fput+0xe/0x10
>  [<ffffffff810723bc>] task_work_run+0xac/0xe0
>  [<ffffffff81002a9f>] do_notify_resume+0x9f/0xc0
>  [<ffffffff814b8398>] int_signal+0x12/0x17
>=20
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=3D75051
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Alex Chiang <achiang-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/infiniband/core/user_mad.c | 33 ++++++++++++++++++++++------=
-----
>  1 file changed, 22 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/=
core/user_mad.c
> index 2b3dfcc..93d0823 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -98,7 +98,7 @@ struct ib_umad_port {
> =20
>  struct ib_umad_device {
>  	int                  start_port, end_port;
> -	struct kref          ref;
> +	struct kobject       kobj;
>  	struct ib_umad_port  port[0];
>  };
> =20
> @@ -134,14 +134,18 @@ static DECLARE_BITMAP(dev_map, IB_UMAD_MAX_PORT=
S);
>  static void ib_umad_add_one(struct ib_device *device);
>  static void ib_umad_remove_one(struct ib_device *device);
> =20
> -static void ib_umad_release_dev(struct kref *ref)
> +static void ib_umad_release_dev(struct kobject *kobj)
>  {
>  	struct ib_umad_device *dev =3D
> -		container_of(ref, struct ib_umad_device, ref);
> +		container_of(kobj, struct ib_umad_device, kobj);
> =20
>  	kfree(dev);
>  }
> =20
> +static struct kobj_type ib_umad_dev_ktype =3D {
> +	.release =3D ib_umad_release_dev,
> +};
> +
>  static int hdr_size(struct ib_umad_file *file)
>  {
>  	return file->use_pkey_index ? sizeof (struct ib_user_mad_hdr) :
> @@ -810,7 +814,7 @@ static int ib_umad_open(struct inode *inode, stru=
ct file *filp)
>  	if (ret)
>  		goto del;
> =20
> -	kref_get(&port->umad_dev->ref);
> +	kobject_get(&port->umad_dev->kobj);
> =20
>  out:
>  	mutex_unlock(&port->file_mutex);
> @@ -855,7 +859,7 @@ static int ib_umad_close(struct inode *inode, str=
uct file *filp)
>  	mutex_unlock(&file->port->file_mutex);
> =20
>  	kfree(file);
> -	kref_put(&dev->ref, ib_umad_release_dev);
> +	kobject_put(&dev->kobj);
> =20
>  	return 0;
>  }
> @@ -906,7 +910,7 @@ static int ib_umad_sm_open(struct inode *inode, s=
truct file *filp)
>  	if (ret)
>  		goto clr_sm_cap;
> =20
> -	kref_get(&port->umad_dev->ref);
> +	kobject_get(&port->umad_dev->kobj);
> =20
>  out:
>  	return ret;
> @@ -935,7 +939,7 @@ static int ib_umad_sm_close(struct inode *inode, =
struct file *filp)
> =20
>  	up(&port->sm_sem);
> =20
> -	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
> +	kobject_put(&port->umad_dev->kobj);
> =20
>  	return ret;
>  }
> @@ -1003,6 +1007,7 @@ static int find_overflow_devnum(void)
>  }
> =20
>  static int ib_umad_init_port(struct ib_device *device, int port_num,
> +			     struct ib_umad_device *umad_dev,
>  			     struct ib_umad_port *port)
>  {
>  	int devnum;
> @@ -1068,6 +1073,11 @@ static int ib_umad_init_port(struct ib_device =
*device, int port_num,
>  	if (device_create_file(port->sm_dev, &dev_attr_port))
>  		goto err_sm_dev;
> =20
> +	port->cdev.kobj.parent =3D &umad_dev->kobj;
> +	kobject_get(&umad_dev->kobj);

That could be written as

+	port->cdev.kobj.parent =3D kobject_get(&umad_dev->kobj);

And it seems to me it's semantically better to get the reference before
storing it.

> +	port->sm_cdev.kobj.parent =3D &umad_dev->kobj;
> +	kobject_get(&umad_dev->kobj);
> +

Same here:

+	port->sm_cdev.kobj.parent =3D kobject_get(&umad_dev->kobj);

But I think it could be written even more simpler:
as part of cdev_add(), kobject_get() is already done on
cdev->kobj.parent:

fs/char_dev.c:474

  int cdev_add(struct cdev *p, dev_t dev, unsigned count)
  {
          int error;

          p->dev =3D dev;
          p->count =3D count;

          error =3D kobj_map(cdev_map, dev, count, NULL,
                         exact_match, exact_lock, p);
          if (error)
                  return error;

          kobject_get(p->kobj.parent);

          return 0;
  }

So setting cdev->kobj.parent before calling cdev_add() should be enough=
=2E

Since there's no related kobject_put() in ib_umad_kill_port(), it seems
you already make use of cdev_put() calling kobject_put() on cdev kobj
parent. The same should be done for ib_umad_init_port().

>  	return 0;
> =20
>  err_sm_dev:
> @@ -1146,7 +1156,7 @@ static void ib_umad_add_one(struct ib_device *d=
evice)
>  	if (!umad_dev)
>  		return;
> =20
> -	kref_init(&umad_dev->ref);
> +	kobject_init(&umad_dev->kobj, &ib_umad_dev_ktype);
> =20
>  	umad_dev->start_port =3D s;
>  	umad_dev->end_port   =3D e;
> @@ -1154,7 +1164,8 @@ static void ib_umad_add_one(struct ib_device *d=
evice)
>  	for (i =3D s; i <=3D e; ++i) {
>  		umad_dev->port[i - s].umad_dev =3D umad_dev;
> =20
> -		if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
> +		if (ib_umad_init_port(device, i, umad_dev,
> +				      &umad_dev->port[i - s]))
>  			goto err;
>  	}
> =20
> @@ -1166,7 +1177,7 @@ err:
>  	while (--i >=3D s)
>  		ib_umad_kill_port(&umad_dev->port[i - s]);
> =20
> -	kref_put(&umad_dev->ref, ib_umad_release_dev);
> +	kobject_put(&umad_dev->kobj);
>  }
> =20
>  static void ib_umad_remove_one(struct ib_device *device)
> @@ -1180,7 +1191,7 @@ static void ib_umad_remove_one(struct ib_device=
 *device)
>  	for (i =3D 0; i <=3D umad_dev->end_port - umad_dev->start_port; ++i=
)
>  		ib_umad_kill_port(&umad_dev->port[i]);
> =20
> -	kref_put(&umad_dev->ref, ib_umad_release_dev);
> +	kobject_put(&umad_dev->kobj);
>  }
> =20
>  static char *umad_devnode(struct device *dev, umode_t *mode)

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
