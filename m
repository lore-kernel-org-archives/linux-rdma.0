From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v4 2/7] RDMA/core: Add helper function to
 create named QPs
Date: Wed, 17 Jan 2018 07:59:42 +0200
Message-ID: <20180117055942.GF13639@mtr-leonro.local>
References: <20180115151255.30167-1-leon@kernel.org>
 <20180115151255.30167-3-leon@kernel.org>
 <1516138540.2844.36.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516138540.2844.36.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 16, 2018 at 09:35:42PM +0000, Bart Van Assche wrote:
> On Mon, 2018-01-15 at 17:12 +0200, Leon Romanovsky wrote:
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -1141,6 +1141,12 @@ struct ib_qp_init_attr {
> >  	u8			port_num;
> >  	struct ib_rwq_ind_table *rwq_ind_tbl;
> >  	u32			source_qpn;
> > +
> > +	/*
> > +	 * Name of entity which created this QP, empty string means that
> > +	 * it will be taken automatically from task_struct.
> > +	 */
> > +	char comm[TASK_COMM_LEN];
> >  };
>
> Why is comm[] an array? For queue pairs created from user space, are there any
> queue pairs that can live longer than the task that created them? If not, does
> that mean that it is safe to change comm into a const char pointer?

As I wrote in cover letter, this code will be refactored and moved to PD once
Steve's implementation of CMA resource tracking will be accepted in upstream.

>
> Additionally, please use the kernel-doc syntax to document structure members.

Kernel-doc checker doesn't work with patches and ib_verbs.h full of
kernel-doc warning.

>
> Thanks,
>
> Bart.

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpe5k4ACgkQ5GN7iDZy
WKfbmA//dW2UDB1RSfEbSJlCkqjoCa7EmYg+0CnaF6AfxQEqFKWxsd3UntvsIBoK
GpNyr4G8VVdjm0dCaNXe47cyoSxgmR9AClK0kSCYTXyA9cTv9FeqkfF9T2svhu7E
AMM5IStMbq2igWgwzdyTV0wFK+l/Hi0U8+YJ46OvCnwketBMbOS4mooyORgMU+Nw
nMOjK4B0PUnclTTM+793MLW0Pc7PgAp86AHy94qXe9ahZFoHaUhrHm67Omk4Hp28
R97c+7rxYFOdqy+yi4rAElD/LA5k1Warm3XV4+gAH3Qhd97D4fMs8kWFhvw2GKH3
dCatgEMGPcGAa4MgcUvgtxk9PfpyKe3MwnpEpvNZ2oXTjddX5juBhO+/ZamB54sl
dcWOEjCPCnHX9B4l+hasMkgFWtmxxlvWOJyOcneKeGx9CAogflGtlnIyj24/VD0Z
YUYDUQZlZMs1nizM9iE8jtxbawOJdxwBRHtQDH6Iiu0fj5vBTATDBz7Sn1Gfr25X
QhHnBysVo//X4jML5yIKC+5LWuiDVBwJUGXDYuU2rWxt7ZVryzGa1qF6LEpVtjZP
QAJGQyXuLxxGA6nHBse9KaPl7XitLwjzC+Rg8w1t5kuKp2SYxJLyM3vddT+NbcOL
v0AGyecd6SjLrz5/HIgaUZPrgeWCH5kyEly5YmlMd/AG1ks3Kp4=
=rX6K
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
