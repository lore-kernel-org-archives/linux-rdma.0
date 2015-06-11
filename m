From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't warn on no SA support in event handler
Date: Thu, 11 Jun 2015 01:03:04 -0400
Message-ID: <1433998984.71666.148.camel@redhat.com>
References: <1433927612-20517-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-fDOKxBiiCZzwaQFpu1xJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433927612-20517-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-fDOKxBiiCZzwaQFpu1xJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 12:13 +0300, Moni Shoua wrote:
> Registering an event handler is done for a device. This device may have
> one RoCE port (no SA cap) and one InfiniBand port (has SA cap).
> Therefore, warning from the event handler about a specific port that
> doesn't have SA cap is correct but pollutes the kernel log without a
> need.
>=20
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

> ---
>  drivers/infiniband/core/multicast.c | 2 +-
>  drivers/infiniband/core/sa_query.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/cor=
e/multicast.c
> index 605f20a..1244f02 100644
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -780,7 +780,7 @@ static void mcast_event_handler(struct ib_event_handl=
er *handler,
>  	int index;
> =20
>  	dev =3D container_of(handler, struct mcast_device, event_handler);
> -	if (WARN_ON(!rdma_cap_ib_mcast(dev->device, event->element.port_num)))
> +	if (!rdma_cap_ib_mcast(dev->device, event->element.port_num))
>  		return;
> =20
>  	index =3D event->element.port_num - dev->start_port;
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core=
/sa_query.c
> index 7f7c8c9..3d0b7b2 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -450,7 +450,7 @@ static void ib_sa_event(struct ib_event_handler *hand=
ler, struct ib_event *event
>  		struct ib_sa_port *port =3D
>  			&sa_dev->port[event->element.port_num - sa_dev->start_port];
> =20
> -		if (WARN_ON(!rdma_cap_ib_sa(handler->device, port->port_num)))
> +		if (!rdma_cap_ib_sa(handler->device, port->port_num))
>  			return;
> =20
>  		spin_lock_irqsave(&port->ah_lock, flags);


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-fDOKxBiiCZzwaQFpu1xJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeRaIAAoJELgmozMOVy/dsiMQALsMdL9dCb1GIs/DqXitqAzD
+52qmaL1wj/o8GXnMl/8uYqZeu7JvzX0so3fgSyq0WMkGBo4NUgHUAvrI1YuczuV
sTaRUVsguvdnjPsM2esoZ795mdgkW73rhZfpsuDaPbu+a/JVk7/jni8kafsZyYu8
hdol8eyghlBOJBxyzzwxZrHsOgvwwD6LQCN/IY5BncouRkqkWuQAj64yhJKBfL0v
AiDouCa0DzottqT4K/nmraq0l88tXvJRn61knlJue1zvvB2bUrT+sXVu6UfIfOMw
jf/qlD4orwa3TjwbeEkoxhPyHBnyJs6KI4Anxdx5PA5pjmcksY0MgX7Gvw/C8LZa
FEEuwv/Cw+2y6u34yvsNaiubp30GHo6yGl3Ke988FfQQ8fHxIMBoCyl1JsrzruY/
cMf/VpXH7XXYcl22nz0O++8FSYx/cZfasQGWhpIm9101F0QBrEnmBjEhkdsfWlSy
rcyjiUCS7E1c+EfyYKobI7iUvT6ZH8uUbRW5a93vjK7snzx4aa5cvXM5/WYB72US
RsXfmAGDEpAxZWf+Uprb3oe0yVH+dWzEKT4vVRu2qTmIlAa/s2Zg/5VMEzMv2Dib
zdcIuxVx87+tiBrfEeBQWshBm01ijd9fK1gKoPMTRMXgyb5e6tZp7EiUmxzJdcFZ
bGxcWGbZoa0ulqtzJga8
=mDGc
-----END PGP SIGNATURE-----

--=-fDOKxBiiCZzwaQFpu1xJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
