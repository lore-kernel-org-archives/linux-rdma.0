From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: shut up a maybe-uninitialized warning
Date: Tue, 02 Aug 2016 13:45:25 -0400
Message-ID: <1470159925.18081.21.camel@redhat.com>
References: <20160704150659.2883024-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-QOTpuwHXYEnsTlcEyl7n"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704150659.2883024-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-QOTpuwHXYEnsTlcEyl7n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-07-04 at 17:06 +0200, Arnd Bergmann wrote:
> The powerpc64 default configuration leads to warnings for the
> infiniband
> core code:
>=20
> infiniband/core/cma.c: In function 'cma_get_net_dev':
> infiniband/core/cma.c:1242:12: warning:
> 'src_addr_storage.sin_addr.s_addr' may be used uninitialized in this
> function [-Wmaybe-uninitialized]
>=20
> The code looks correct to me, and I don't see the warnings on the
> other architectures, so this is a dumb change to add an unneeded
> initialization to the variables in order to shut up the warning.
>=20
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Link: http://arm-soc.lixom.net/buildlogs/mainline/v4.7-
> rc6/buildall.powerpc.ppc64_defconfig.log.passed

I thought about taking this, but I also looked over the code and it
looks correct to me. =C2=A0This is a semi-hot path in the connection bring
up code, so I'm loathe to put in sizeof(struct sockaddr_storage) * 2 of
needless memory writes. =C2=A0So, I dropped this patch. =C2=A0Hopefully, pp=
c64
compiler will straighten its warnings out soon.

> ---
> =C2=A0drivers/infiniband/core/cma.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c
> b/drivers/infiniband/core/cma.c
> index a3c9930f1f93..924ac237310b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1309,7 +1309,7 @@ static bool validate_net_dev(struct net_device
> *net_dev,
> =C2=A0static struct net_device *cma_get_net_dev(struct ib_cm_event
> *ib_event,
> =C2=A0					=C2=A0=C2=A0const struct cma_req_info
> *req)
> =C2=A0{
> -	struct sockaddr_storage listen_addr_storage,
> src_addr_storage;
> +	struct sockaddr_storage listen_addr_storage =3D {},
> src_addr_storage =3D {};
> =C2=A0	struct sockaddr *listen_addr =3D (struct sockaddr
> *)&listen_addr_storage,
> =C2=A0			*src_addr =3D (struct sockaddr
> *)&src_addr_storage;
> =C2=A0	struct net_device *net_dev;

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-QOTpuwHXYEnsTlcEyl7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoNw1AAoJELgmozMOVy/dQUkP/3N/lZmJuID5pPWURnHJUdzI
el+KsaOHLEtkonGlwjHXxsLZZW99wCQXL/Qf/PuXpXEc4HqZNhp0xe4TZEuWnjik
sU6reRL50qAflLtLWs29GTm4wo3y/gIaLnVEeVg4SpQv6AXOEgZLTlx7+H0J6M9i
935melMuia+jK8Dl+ZQ0lvtqB7nxVjmbwa3d9AGrkJ3i++M9IFKET8qBLuPE9ZsF
jOCKZr2n1ddwUI+LGrIt/AjaPoUJXBclotAt3ljl7sK6A/L2j0z/877n6yNu4Jpp
rwxxxV/mJaAxbYozuxGbKly4Ts90ID4byajdNLFseyOV4ZXIYoCGttBj4PbJxG3o
vCzkqeCDL+c3jQoVnGGBwk37/3OHdVftU3P6puBds2ARpEFKBr2dp7pBvN6Z9kXX
FWn7tCvmZQGx+pF3Vjey4FkU7KRFcBTpe5sa5k9qyZIdaFSr0hnZBbpWHTT9uucI
Dj7/yTbO637N42rnOMabOUXGP8cJEKHMjg437De/fyViCdux8B0i9vTYBzG2+C4X
HxeJ/Nadw+sTkhE7MTNIOJC/1ZpPFc4yf3NRQVEt/QeWjFwTOCvN/bfQYj6HmCJq
d19dVOU/mtjXRdi6ig9u7cXnaMGaXx+js88DJFcxaXjUYiwL1slyAJ1TGgcyk+Re
aBpWuSBMo+UXr5N13q4W
=qmuI
-----END PGP SIGNATURE-----

--=-QOTpuwHXYEnsTlcEyl7n--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
