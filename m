From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Allocate cpu mask on the heap to silence warning
Date: Wed, 3 Aug 2016 21:54:03 +0300
Message-ID: <20160803185403.GH27667@leon.nu>
References: <1470249441-22787-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lqaZmxkhekPBfBzr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470249441-22787-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--lqaZmxkhekPBfBzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2016 at 02:37:21PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> If CONFIG_FRAME_WARN is small (1K) and CONFIG_NR_CPUS big
> then a frame size warning is triggered during build.
> Allocate the cpu mask dynamically to silence the warning.
>=20
> Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/affinity.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/h=
w/hfi1/affinity.c
> index 79575ee873f2..62be2eda1b96 100644
> --- a/drivers/infiniband/hw/hfi1/affinity.c
> +++ b/drivers/infiniband/hw/hfi1/affinity.c
> @@ -682,7 +682,7 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, c=
onst char *buf,
>  			   size_t count)
>  {
>  	struct hfi1_affinity_node *entry;
> -	struct cpumask mask;
> +	cpumask_var_t mask;
>  	int ret, i;
> =20
>  	spin_lock(&node_affinity.lock);
> @@ -692,19 +692,24 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd,=
 const char *buf,
>  	if (!entry)
>  		return -EINVAL;
> =20
> -	ret =3D cpulist_parse(buf, &mask);
> -	if (ret)
> +	ret =3D zalloc_cpumask_var(&mask, GFP_KERNEL);
> +	if (!ret)
>  		return ret;

Ira,
Are you aware that before this change you returned value different from
zero in case of error and now you will return zero?

Thanks

--lqaZmxkhekPBfBzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXoj3LAAoJEORje4g2clinXZoP/ibgcPU5VkMFKDIZ54IIKmkM
CCC2e15bhem3f6Iv69uG2SOiDfsuG1iHicbWiltIz0246XEi8lxfYaCuZsWoL724
3Vescx+urhU7RcIPbXleQjtz/2BCQ3SvZOIUxdAoEOOQvIxoiWF3yiL4h+Yqmhox
gTZIUJQN5E/RrmrsLrh2SIEV2TjYPlNxFDrcFQFx+gdjfv5pG4EPEIdfQlH/Cz/U
POeq7xaFWimWJYavlNS/VcdAq6UwYsBIOyb9pdA8s1awQPPes3sbo2DB69zP0V/T
Q/jPugh0yPosRvmKmflby8AJX2HjK0vz7mOOPUFdZ1y1h4GGm5wPUWBtPBRPOc3t
ZcOOgD7MZNe1XqYFhAFlGg61v6eYh0YS7PvmI0SwxM/G4EUMxf5bRsu9SCq6OGYd
nJKICsGgDeDYjf1i2Kmlk4hkrbOym8LFI38s+uLiLXapA0KMKMp8HarL1dBQgmwb
n4tSoiqucr+VV9JVg50vBHOhjmxJKdLvyPaQxbAE9+84HPJ/v74Sw2BSfPV9J56n
XYf4RGApfcAs/JD5CfZhvtb+2CwRWfQtRphrZsAzSa14Kgk9f+tcBJzFwz5DyoU9
qohjawF7u4gwsRwWrTfn61kh458nLMG1li+rOq+r3fV8ptvfMoeKOLuLAUGRblne
uh63jIMnUBjZNHirNF2y
=CgZf
-----END PGP SIGNATURE-----

--lqaZmxkhekPBfBzr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
