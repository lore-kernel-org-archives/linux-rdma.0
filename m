From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add cleanup routines.
Date: Fri, 11 Apr 2014 19:00:49 +0200
Message-ID: <1397235649.29001.19.camel@localhost.localdomain>
References: <A521BD06-7228-4FA9-97DD-7DFA51BE7505@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A521BD06-7228-4FA9-97DD-7DFA51BE7505-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 11 avril 2014 =C3=A0 18:50 +0200, Hannes Weisbach a =C3=A9c=
rit :
> Dynamically loaded library handles are saved in a list and dlclosed()=
 on
> exit. The list of struct ibv_driver *, as well as the global
> struct ibv_device ** list are free()d.
>=20

Please adds some explanation, in particular the purpose of the changes.
Your commit message only explain "how", but you should also explain
"why".

> Signed-off-by: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
> ---
>  src/device.c | 10 ++++++++++
>  src/init.c   | 51 ++++++++++++++++++++++++++++++++++++++++++++++----=
-
>  2 files changed, 56 insertions(+), 5 deletions(-)
>=20
> diff --git a/src/device.c b/src/device.c
> index beb7b3c..d5b76bb 100644
> --- a/src/device.c
> +++ b/src/device.c
> @@ -305,3 +305,13 @@ void __ibv_ack_async_event(struct ibv_async_even=
t *event)
>  	}
>  }
>  default_symver(__ibv_ack_async_event, ibv_ack_async_event);
> +
> +FINI static void ibverbs_deinit()

In C, empty prototype declare a function which accept any parameter. So
perhaps void ibverbs(void) is what you mean.

> +{
> +	size_t i;
> +	for (i =3D 0; i < num_devices; i++) {
> +		/* driver callback needed. May not be malloc'd memory */

Seems dangerous. Such interrogation must be explicitly added in the
commit message.=20

> +		free(device_list[i]);
> +	}
> +	free(device_list);
> +}
> diff --git a/src/init.c b/src/init.c
> index d0e4b1c..2a8bca4 100644
> --- a/src/init.c
> +++ b/src/init.c
> @@ -67,6 +67,11 @@ struct ibv_driver_name {
>  	struct ibv_driver_name *next;
>  };
> =20
> +struct ibv_so_list {
> +	void *dlhandle;
> +	struct ibv_so_list *next;
> +};
> +
>  struct ibv_driver {
>  	const char	       *name;
>  	ibv_driver_init_func	init_func;
> @@ -77,6 +82,7 @@ struct ibv_driver {
>  static struct ibv_sysfs_dev *sysfs_dev_list;
>  static struct ibv_driver_name *driver_name_list;
>  static struct ibv_driver *head_driver, *tail_driver;
> +static struct ibv_so_list *so_list;
> =20
>  static int find_sysfs_devs(void)
>  {
> @@ -193,7 +199,14 @@ void verbs_register_driver(const char *name, ver=
bs_driver_init_func init_func)
>  static void load_driver(const char *name)
>  {
>  	char *so_name;
> -	void *dlhandle;
> +	struct ibv_so_list *elem;
> +	struct ibv_so_list **list;
> +
> +	elem =3D malloc(sizeof(*elem));
> +	if(!elem)
> +		return;
> +
> +	elem->next =3D NULL;
> =20
>  #define __IBV_QUOTE(x)	#x
>  #define IBV_QUOTE(x)	__IBV_QUOTE(x)
> @@ -205,16 +218,25 @@ static void load_driver(const char *name)
>  		     name) < 0) {
>  		fprintf(stderr, PFX "Warning: couldn't load driver '%s'.\n",
>  			name);
> -		return;
> +		goto err;
>  	}
> =20
> -	dlhandle =3D dlopen(so_name, RTLD_NOW);
> -	if (!dlhandle) {
> +	elem->dlhandle =3D dlopen(so_name, RTLD_NOW);
> +	if (!elem->dlhandle) {
>  		fprintf(stderr, PFX "Warning: couldn't load driver '%s': %s\n",
>  			name, dlerror());
> -		goto out;
> +		goto err;
>  	}
> =20
> +	for (list =3D &so_list; *list; list =3D &(*list)->next)
> +		;
> +
> +	*list =3D elem;
> +
> +	goto out;
> +
> +err:
> +	free(elem);
>  out:
>  	free(so_name);
>  }
> @@ -573,3 +595,22 @@ out:
> =20
>  	return num_devices;
>  }
> +
> +FINI static void unload_drivers()

same remarks about prototype.

> +{
> +	struct ibv_driver *driver;
> +	struct ibv_so_list * list;
> +
> +	for (driver =3D head_driver; driver;) {
> +		struct ibv_driver *tmp =3D driver;
> +		driver =3D driver->next;
> +		free(tmp);
> +	}
> +

Is it safe here to free the driver ?

> +	for (list =3D so_list; list;) {
> +		struct ibv_so_list *tmp =3D list;
> +		list =3D list->next;
> +		dlclose(tmp->dlhandle);
> +		free(tmp);
> +	}
> +}

Why not store the dlopen() handle in the struct ibv_driver itself ?
This way only one list has to be scanned.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
