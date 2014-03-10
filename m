From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Suppress a sparse warning
Date: Mon, 10 Mar 2014 14:33:26 +0100
Message-ID: <1394458406.3257.53.camel@localhost.localdomain>
References: <531DAEA1.7060703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531DAEA1.7060703-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le lundi 10 mars 2014 =C3=A0 13:22 +0100, Bart Van Assche a =C3=A9crit =
:
> Suppress the following sparse warning:
>=20
> include/rdma/ib_addr.h:187:24: warning: cast removes address space of=
 expression
>=20

You should explain why there's a warning here, and why is it safe to
cast. (I believe it's related to RCU domain ?)

Regards.

> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  include/rdma/ib_addr.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
> index ce55906..bf11511 100644
> --- a/include/rdma/ib_addr.h
> +++ b/include/rdma/ib_addr.h
> @@ -184,7 +184,7 @@ static inline void iboe_addr_get_sgid(struct rdma=
_dev_addr *dev_addr,
> =20
>  	dev =3D dev_get_by_index(&init_net, dev_addr->bound_dev_if);
>  	if (dev) {
> -		ip4 =3D (struct in_device *)dev->ip_ptr;
> +		ip4 =3D (__force struct in_device *)dev->ip_ptr;
>  		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
>  			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
>  					       (struct in6_addr *)gid);

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
