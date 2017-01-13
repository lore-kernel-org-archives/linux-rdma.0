From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/core: add port state cache
Date: Thu, 12 Jan 2017 22:16:38 -0500
Message-ID: <1484277398.123135.49.camel@redhat.com>
References: <CAMGffE=gytHRs+SVOmNPCkWX6tZ9hkeFznqeQQs-TFJMMJi97g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-U9G1qfcCKGr+M+SiquGJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=gytHRs+SVOmNPCkWX6tZ9hkeFznqeQQs-TFJMMJi97g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-U9G1qfcCKGr+M+SiquGJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-12-12 at 12:43 +0100, Jinpu Wang wrote:
> From fc80c1730d94a38934c5c60f9b9561745723dfd9 Mon Sep 17 00:00:00
> 2001
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date: Mon, 12 Dec 2016 09:52:42 +0100
> Subject: [PATCH 1/4] IB/core: add port state cache
>=20
> We need a port state cache in ib_core, later we will use in rdma_cm.

All of these patches were mangled. =C2=A0Their tabs were converted to
spaces, they had line wraps where they shouldn't, etc.

Please don't send them using an email program, it obviously isn't
working in your case. =C2=A0I strongly recommend using "git send-email" to
send the series.

Before resending, add a comment to the first about the memory being
freed during the release operation, that will forestall any more
questions about memory leaks. =C2=A0Also capture Sean Hefty's ack on all of
your patches.

I'm ready to take them, I just need you to rework them. =C2=A0Thanks.

> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/core/cache.c | 9 ++++++++-
> =C2=A0include/rdma/ib_verbs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 1 +
> =C2=A02 files changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cache.c
> b/drivers/infiniband/core/cache.c
> index 1a2984c..025db27 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -1109,6 +1109,8 @@ static void ib_cache_update(struct ib_device
> *device,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0device->cache.lmc_cache[port - rdma_start_p=
ort(device)] =3D
> tprops->lmc;
> +=C2=A0=C2=A0=C2=A0=C2=A0device->cache.port_state_cache[port - rdma_start=
_port(device)] =3D
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tprops->state;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0write_unlock_irq(&device->cache.lock);
>=20
> @@ -1168,7 +1170,11 @@ int ib_cache_setup_one(struct ib_device
> *device)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(rdma_end=
_port(device) -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rdm=
a_start_port(device) + 1),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0GFP_KERNE=
L);
> -=C2=A0=C2=A0=C2=A0=C2=A0if (!device->cache.pkey_cache ||
> +=C2=A0=C2=A0=C2=A0=C2=A0device->cache.port_state_cache =3D kmalloc(sizeo=
f
> *device->cache.port_state_cache *
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(rdma_end_port(=
device) -
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rdma_star=
t_port(device) + 1),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0GFP_KERNEL);
> +=C2=A0=C2=A0=C2=A0=C2=A0if (!device->cache.pkey_cache || !device->cache.=
port_state_cache=20
> ||
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0!device->cache.lmc_=
cache) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pr_warn("Couldn't a=
llocate cache for %s\n", device->name);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return -ENOMEM;
> @@ -1213,6 +1219,7 @@ void ib_cache_release_one(struct ib_device
> *device)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gid_table_release_one(device);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(device->cache.pkey_cache);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(device->cache.lmc_cache);
> +=C2=A0=C2=A0=C2=A0=C2=A0kfree(device->cache.port_state_cache);
> =C2=A0}
>=20
> =C2=A0void ib_cache_cleanup_one(struct ib_device *device)
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 5ad43a4..a167ae0 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1761,6 +1761,7 @@ struct ib_cache {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ib_pkey_cache=C2=A0=C2=A0**pkey_cach=
e;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ib_gid_table=C2=A0=C2=A0=C2=A0**gid_=
cache;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0*lmc_cache;
> +=C2=A0=C2=A0=C2=A0=C2=A0enum ib_port_state=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
*port_state_cache;
> =C2=A0};
>=20
> =C2=A0struct ib_dma_mapping_ops {
> --=C2=A0
> 2.7.4
>=20
>=20
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-U9G1qfcCKGr+M+SiquGJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYeEaWAAoJELgmozMOVy/dn6cP/jWKy/sTr/W2Nmemh4u+W9k8
YK6/vPDe83X3+NR6FKabnE5eADMtca+UBUBTiEgAygVkx0dVEIdUSM21jIkveYXp
5sMvuN4RwInqREbT03ElqRU/lkhHuYQ8NXvkgn/B0IwqBowrFzdOfrajIJkhrjLA
n8VwZerx5sJdDEYBNHxyRyLpnD3fJ7tRXeXgh2w2q+vuDOm1NyG8c4BucEQFpnxc
90qvwUGcMrLp0bRMOGY1jsofURGVefVMXY+6MHpsvAyf5R0MLt1zBkso3TARcS/w
Wa8p45HqJRlmw2ke3nxm+nFBfgzgUFj8jb8t1q4jM3KdmwozYjMK+0O7QhrQ1wbD
mcLNv/aJfdljYtuV4ZHMHiFxwdyemzrkWWGJggP79MzVGki1TGQ8Tao/407sahFS
AkOO68/c7KN4E/eNiE+wvmPX6mD0J88aMjN9JzM1Y/+uiwtXlDv2w/cDOHo8etRp
JV3LaGFuoKNjFIQ2pN81MekRdZrqI0dn7azDdQqsH5rVvK2lcu4bU2S1KkwJi8rq
AihYclIOHr5cEYzH6ZUAtkx5IVAPyLMCjDkCGoOKQKjq1glzsiDH45SIYp36R67Y
Irx2NEkgc6ZBNWsqgIdWJhS8UAxepdBfF21OnY12889snY3zuwQcgT+uSKWQ4nm+
DQG/ZpqPQ82N/MybwBho
=C6I7
-----END PGP SIGNATURE-----

--=-U9G1qfcCKGr+M+SiquGJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
