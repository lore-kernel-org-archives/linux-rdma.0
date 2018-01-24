From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Wed, 24 Jan 2018 08:44:29 +0200
Message-ID: <20180124064429.GC1393@mtr-leonro.local>
References: <20180123115013.12213-1-leonro@mellanox.com>
 <20180123152142.GB30619@mellanox.com>
 <1516723456.3339.3.camel@wdc.com>
 <20180123185732.GA1393@mtr-leonro.local>
 <1516746607.3339.47.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Fq7EdiloNwzjWdQG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516746607.3339.47.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Fq7EdiloNwzjWdQG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 23, 2018 at 10:30:08PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-23 at 20:57 +0200, Leon Romanovsky wrote:
> > So how are we going to solve that rdma/for-next doesn't compile?
>
> How about the following?
>
> [PATCH] IB/srpt: Fix CONFIG_DEBUG_OBJECTS_RCU_HEAD=y build
>
> Avoid that the kernel build fails as follows if RCU debugging is
> enabled:
>
> ERROR: "init_rcu_head" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined!
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 5ccc75c389e2..a78a79791950 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1977,7 +1977,6 @@ static struct srpt_nexus *srpt_get_nexus(struct srpt_port *sport,
>  			nexus = ERR_PTR(-ENOMEM);
>  			break;
>  		}
> -		init_rcu_head(&tmp_nexus->rcu);
>  		INIT_LIST_HEAD(&tmp_nexus->ch_list);
>  		memcpy(tmp_nexus->i_port_id, i_port_id, 16);
>  		memcpy(tmp_nexus->t_port_id, t_port_id, 16);
> @@ -2147,7 +2146,6 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
>  		goto reject;
>  	}
>
> -	init_rcu_head(&ch->rcu);
>  	kref_init(&ch->kref);
>  	ch->pkey = be16_to_cpu(pkey);
>  	ch->nexus = nexus;

Thanks

--Fq7EdiloNwzjWdQG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpoK0wACgkQ5GN7iDZy
WKe+BRAAr4EIiHG7SVL5NsU6Q10joyeOmRUL3rY5eD5biXBEqv7F9cXGUy/P2W7N
UO/q3/MD/pDrePIZwzKHV/AtSVGrtUiR6A8DIuUYEHiFaBl3EYOUSfxX41bzI8mf
hVn6Xb1l//2Fix82Ul/MniuRFIQhHsMB0utrJNjKASbjqvzQonRBuASPKF4TMry8
p9z/kCNmGNN5WMEIjpVt1txKnp62WAnzeSCI2Dsi9FAa7Fiw5z9P0rKmBVQHEool
8XYE5PIhAHTC3FiHtNQhn7NokUYcLnqSyzbI3Uf4bFQ9lQbiLe4TXa3ohog8S4qA
VLhJVPFC4nxbQsZ2DnMZzEQ85R4044ZxCI8nZmX/74JsTP8CKy3olHNAbmOW9Ncy
xK+eTtlaRpXaMNM5NFRS+nB8oa2swV2j8mjKNN7aNj37WQ/HTMyVavARegqCoBja
KsX+MY1DUYO1CXy3QO1Sz1fj6BwAhJLnajpuHxGKJHBGVoMItImoAnXd4BEcu4n7
sb4jf0P25WSQxyvhHQAeNkpZnrx70xIJJ0H5884wN+9bE+ABxNHWw6BseDPqsdmh
mZJKS300yBP7z3bu4yCEg/5bXwC3ZI1IKinn6VMHJfSjrHkh3rnFKhOL0U9kGXnJ
QJ/CZadKnTHKs5c5oMY3/zj37FCZWuWNYIWuQkGp6sXmbISXP60=
=EwAS
-----END PGP SIGNATURE-----

--Fq7EdiloNwzjWdQG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
