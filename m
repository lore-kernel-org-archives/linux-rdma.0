From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Mon, 12 Jun 2017 20:24:26 +0300
Message-ID: <20170612172426.GD2576@mtr-leonro.local>
References: <20170611083931.13686-1-leon@kernel.org>
 <20170611083931.13686-2-leon@kernel.org>
 <073401d2e39b$d935bf60$8ba13e20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <073401d2e39b$d935bf60$8ba13e20$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2017 at 11:49:25AM -0500, Steve Wise wrote:
> Hey Leon:
>
> > diff --git a/drivers/infiniband/core/netlink.c
> b/drivers/infiniband/core/netlink.c
> > index fcc9702efd38..7f498ecc0f0b 100644
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -38,16 +38,13 @@
> >  #include <net/sock.h>
> >  #include <rdma/rdma_netlink.h>
> >
> > -struct ibnl_client {
> > -	struct list_head		list;
> > -	int				index;
> > -	int				nops;
> > -	const struct ibnl_client_cbs   *cb_table;
> > -};
> > +#include "core_priv.h"
> >
> > -static DEFINE_MUTEX(ibnl_mutex);
> > +static DEFINE_MUTEX(rdma_nl_mutex);
> >  static struct sock *nls;
> > -static LIST_HEAD(client_list);
> > +static struct {
> > +	const struct ibnl_client_cbs   *cb_table;
> > +} rdma_nl_types[RDMA_NL_NUM_CLIENTS];
> >
> >  int ibnl_chk_listeners(unsigned int group)
> >  {
> > @@ -57,58 +54,74 @@ int ibnl_chk_listeners(unsigned int group)
> >  }
> >  EXPORT_SYMBOL(ibnl_chk_listeners);
> >
> > -int ibnl_add_client(int index, int nops,
> > -		    const struct ibnl_client_cbs cb_table[])
> > +static bool is_nl_msg_valid(unsigned int type, unsigned int op)
> >  {
> > -	struct ibnl_client *cur;
> > -	struct ibnl_client *nl_client;
> > +	unsigned int max_num_ops[RDMA_NL_NUM_CLIENTS - 1] = {
> > +				  RDMA_NL_RDMA_CM_NUM_OPS,
> > +				  RDMA_NL_IWPM_NUM_OPS,
> > +				  0,
> > +				  RDMA_NL_LS_NUM_OPS,
> > +				  0 };
>
> Why build max_num_ops on every call to is_nl_msg_valid()?  Shouldn't it be
> global and static and const?

Should and will :)

It is my fault, I'll post new version.

Thanks

>
> Steve.
>

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk+zkoACgkQ5GN7iDZy
WKc/tRAAhh/xFcA66SO38EUjzRmifs6EhBB0ufefB3fPzObrSZXzVI08yK7ttS4P
XIu56P3AN91qVZEfglgX8Fr+YgplsDkgqxIv1z+CNLlj03wAZa+x73XOXrqG46ZR
NoBoK6fkxkCRjnU3Q2I8AvX0KtWeRu1UGOz8SwkUBYPPlR/2LURb9V0LYwvgIJz2
aHR1KjWsGN7qjNAd1Vqhg0mWt60i/TbewNrXqdI9YmJJQk0is0bgZBocKQiLMXFa
9ZB5Gsjs4+RbrUxQSUwJYaUsNpsk16/fZvd3T91fAUy57bPg5sC7ErDZ72H2P0di
0qNm0TNeQPG/4LGLymwLSo5cl9jEZdZLA5+qNHMLRlNsvZTbmSuRnQhVtgamNiUu
sjVaVpvYJ/csFQp7DXGpuOsacCahbPeyxEfsyp5bkm8l2QBW3Bo6ZKNSPqRmo5iN
sE75u1D0VkoMGCVPMXvKOJUXWo23kuH2SgCAvdc842+4jaaEcacE7w7SyMpdbleV
HdyCujjqPmUQJEyidw1DEU6szp0H8KOI6KKbUK1WDp+envWVx2VxcuO8cKU2NkCq
zEfmhV0lQ93BnmcJKQ9GHL8qy0YxmLpR9hxHot3X6FnKbcJeLiRdoSEvxhqrQV2/
C3Ftb7M9imjVLW7SPbAofdIDXey0eClNb9MHORLckafZ/grtLrQ=
=Y0X3
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
