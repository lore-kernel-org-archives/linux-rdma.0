From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipatch: Use setup_timer and mod_timer
Date: Mon, 02 Mar 2015 17:47:36 +0100
Message-ID: <1425314856.3069.12.camel@opteya.com>
References: <20150301194637.GA3441@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150301194637.GA3441@vaishali-Ideapad-Z570>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le lundi 02 mars 2015 =C3=A0 01:16 +0530, Vaishali Thakkar a =C3=A9crit=
 :
> Use timer API functions setup_timer and mod_timer instead
> of structure assignments as they are standard way to set
> the timer and to update the expire field of an active timer
> respectively.
>=20
> This is done using Coccinelle and semantic patch used for
> this is as follows:
>=20
> // <smpl>
> @@
> expression x,y,z,a,b;
> @@
>=20
> -init_timer (&x);
> +setup_timer (&x, y, z);
> +mod_timer (&a, b);
> -x.function =3D y;
> -x.data =3D z;
> -x.expires =3D b;
> -add_timer(&a);
> // </smpl>
>=20
> Signed-off-by: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/ipath/ipath_driver.c    |  9 +++------
>  drivers/infiniband/hw/ipath/ipath_init_chip.c | 10 +++-------
>  drivers/infiniband/hw/ipath/ipath_verbs.c     |  7 ++-----
>  3 files changed, 8 insertions(+), 18 deletions(-)
>=20
[...]
> diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/=
infiniband/hw/ipath/ipath_init_chip.c
> index be2a60e..34ffb43 100644
> --- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
> +++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
> @@ -950,13 +950,9 @@ int ipath_init_chip(struct ipath_devdata *dd, in=
t reinit)
>  		 * set up stats retrieval timer, even if we had errors
>  		 * in last portion of setup
>  		 */
> -		init_timer(&dd->ipath_stats_timer);
> -		dd->ipath_stats_timer.function =3D ipath_get_faststats;
> -		dd->ipath_stats_timer.data =3D (unsigned long) dd;
> -		/* every 5 seconds; */
> -		dd->ipath_stats_timer.expires =3D jiffies + 5 * HZ;
> -		/* takes ~16 seconds to overflow at full IB 4x bandwdith */
> -		add_timer(&dd->ipath_stats_timer);
> +		setup_timer(&dd->ipath_stats_timer, ipath_get_faststats,
> +			    (unsigned long)dd);
> +		mod_timer(&dd->ipath_stats_timer, jiffies + 5 * HZ);

The code seems correct, but you remove the comments, loosing some usefu=
l
information.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
