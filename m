From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Wed, 24 Jan 2018 17:36:33 -0500
Message-ID: <1516833393.27592.108.camel@redhat.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
         <20180123152142.GB30619@mellanox.com> <1516723456.3339.3.camel@wdc.com>
         <20180123185732.GA1393@mtr-leonro.local> <1516746607.3339.47.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YHG2D8MbwnUCDIMfew5p"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516746607.3339.47.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-YHG2D8MbwnUCDIMfew5p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-23 at 22:30 +0000, Bart Van Assche wrote:
> On Tue, 2018-01-23 at 20:57 +0200, Leon Romanovsky wrote:
> > So how are we going to solve that rdma/for-next doesn't compile?
>=20
> How about the following?
>=20
> [PATCH] IB/srpt: Fix CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy build
>=20
> Avoid that the kernel build fails as follows if RCU debugging is
> enabled:
>=20
> ERROR: "init_rcu_head" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined=
!
>=20
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
> index 5ccc75c389e2..a78a79791950 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1977,7 +1977,6 @@ static struct srpt_nexus *srpt_get_nexus(struct srp=
t_port *sport,
>  			nexus =3D ERR_PTR(-ENOMEM);
>  			break;
>  		}
> -		init_rcu_head(&tmp_nexus->rcu);
>  		INIT_LIST_HEAD(&tmp_nexus->ch_list);
>  		memcpy(tmp_nexus->i_port_id, i_port_id, 16);
>  		memcpy(tmp_nexus->t_port_id, t_port_id, 16);
> @@ -2147,7 +2146,6 @@ static int srpt_cm_req_recv(struct srpt_device *con=
st sdev,
>  		goto reject;
>  	}
> =20
> -	init_rcu_head(&ch->rcu);
>  	kref_init(&ch->kref);
>  	ch->pkey =3D be16_to_cpu(pkey);
>  	ch->nexus =3D nexus;

Hi Bart,

Can you please resend this as an official patch with SOB so we can pull
this in?  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-YHG2D8MbwnUCDIMfew5p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlppCnEACgkQuCajMw5X
L9339w//fuk+trAWpx2o094Zazu1ZcjfnQuAoVRi3k/PKPgsTG3n6+I7usjzQkpT
ewFyBzYLBeZ0bQ8/FMGe8sKPjWY9mkWoaSIpIqS0euJhl0AaudE35Aj0Mf63dIEF
SNlruenghSHS5zmli6HnEOkbnHTppZKcc6C/q3JPFCigJU5Ahxz1h8CryyW08v56
UtanqCG5WzeyKNZDRWQdC29id7vKDfJDwufMJLGqWwmwIT6w1+xb7iyprizNItzC
6NnHRHqrJJNC+Ku08ZwSPwdTFQFcCNBa40kPstoIsKiJ8M7NmcWeClbm3rC48BWu
moP8DBAqq8aPOqNb6VgoXYqN8ySLsk7alaUYkW7NADRIkuFAj0MhRnf0kPekriCN
gBOLa9zSKSV2JEqtHkGBH/nFQvwkUdgK44HL2cullkX3mFrNg9I38JMI5if2OX4B
Du+uLM2kyf/MfZMneMfxhrH9SNoh5CiijjbXprXttaeZ5sLdTyWlWjFqA4pWtsdZ
f3El9Lbz8MUuiI1GeR9Vuvsz4z4KzdjH45lSYe3Z0nA6xGCExr4SdCkmPstGUvo4
iftmmOEXQ2BfwfHUqdikaqO31eSunF+kl+FJH2HUOxPCHLbDsgeVqx5RVlQEamy1
3zo7oiTVyg8E8SBylVsnpfmmuRmeScnKG01EbqMjdMN/wf+i6ak=
=1xCP
-----END PGP SIGNATURE-----

--=-YHG2D8MbwnUCDIMfew5p--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
