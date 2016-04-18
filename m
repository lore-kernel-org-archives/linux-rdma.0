From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] [PATCH 08/21] IB/hfi1: Adjust default MTU to be 10KB
Date: Mon, 18 Apr 2016 10:07:08 +0300
Message-ID: <20160418070708.GJ6349@leon.nu>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
 <20160412181708.21853.23423.stgit@scvm10.sc.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QnBU6tTI9sljzm9u"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160412181708.21853.23423.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--QnBU6tTI9sljzm9u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 12, 2016 at 11:17:09AM -0700, Dennis Dalessandro wrote:
> From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Increasing the default MTU size to 10KB improves performance
> for PSM. Change the default MTU to 10KB but constrain
> Verbs MTU to 8KB. Also update default MTU module parameter
> description to be HFI1_DEFAULT_MAX_MTU.
>=20
> Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/rdma/hfi1/driver.c |    3 ++-
>  drivers/staging/rdma/hfi1/hfi.h    |    4 ++--
>  drivers/staging/rdma/hfi1/qp.c     |    6 +++++-
>  3 files changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hf=
i1/driver.c
> index 34511e5..700c6fa 100644
> --- a/drivers/staging/rdma/hfi1/driver.c
> +++ b/drivers/staging/rdma/hfi1/driver.c
> @@ -75,7 +75,8 @@ DEFINE_MUTEX(hfi1_mutex);	/* general driver use */
> =20
>  unsigned int hfi1_max_mtu =3D HFI1_DEFAULT_MAX_MTU;
>  module_param_named(max_mtu, hfi1_max_mtu, uint, S_IRUGO);
> -MODULE_PARM_DESC(max_mtu, "Set max MTU bytes, default is 8192");
> +MODULE_PARM_DESC(max_mtu, "Set max MTU bytes, default is " __stringify(
> +		 HFI1_DEFAULT_MAX_MTU));
> =20
>  unsigned int hfi1_cu =3D 1;
>  module_param_named(cu, hfi1_cu, uint, S_IRUGO);
> diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/=
hfi.h
> index ac553f1..ff04593 100644
> --- a/drivers/staging/rdma/hfi1/hfi.h
> +++ b/drivers/staging/rdma/hfi1/hfi.h
> @@ -455,9 +455,9 @@ struct rvt_sge_state;
>  #define HLS_UP (HLS_UP_INIT | HLS_UP_ARMED | HLS_UP_ACTIVE)
> =20
>  /* use this MTU size if none other is given */
> -#define HFI1_DEFAULT_ACTIVE_MTU 8192
> +#define HFI1_DEFAULT_ACTIVE_MTU 10240
>  /* use this MTU size as the default maximum */
> -#define HFI1_DEFAULT_MAX_MTU 8192
> +#define HFI1_DEFAULT_MAX_MTU 10240
>  /* default partition key */
>  #define DEFAULT_PKEY 0xffff
> =20
> diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/q=
p.c
> index 29a5ad2..e68d08a 100644
> --- a/drivers/staging/rdma/hfi1/qp.c
> +++ b/drivers/staging/rdma/hfi1/qp.c
> @@ -167,8 +167,12 @@ static inline int opa_mtu_enum_to_int(int mtu)
>   */
>  static inline int verbs_mtu_enum_to_int(struct ib_device *dev, enum ib_m=
tu mtu)
>  {
> -	int val =3D opa_mtu_enum_to_int((int)mtu);
> +	int val;
> =20
> +	/* Constraining 10KB packets to 8KB packets */
> +	if (mtu =3D=3D (enum ib_mtu)OPA_MTU_10240)
> +		mtu =3D OPA_MTU_8192;
> +	val =3D opa_mtu_enum_to_int((int)mtu);

Just spotted my attention,
Curious names, castings and type conversions.

>  	if (val > 0)
>  		return val;
>  	return ib_mtu_enum_to_int(mtu);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--QnBU6tTI9sljzm9u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFIecAAoJEORje4g2clinPkYQAMuI1X+pFUKv0kYMx4Ty9vtZ
4KdVssZqQaWsNTtd4PkawupkMe35EwreYWzFHVR05tK3KvVANGlXkKr5BhcRnPP9
dH2ywego9cXP/JE0IEB4xz5uNjSfRBXSAlxsZBLFijYME8l/zLeDJrVB47t2oKQ/
rSPzcr9I3aCivMydV4wJvSwceeXgHri/0T9rjeUDs1MYL5H1v88NjLV/Yq8NWxeO
d/MVtzw0xEusJ1CMtToVcE2WrIuPB3DpwIceAMUWVR4noAPoK681bfiu1LuS4Hu3
8zeRuYWEp65smaxXN4JBITsOXcWaB/GLX9PQph0Gn6xrWymvTGaQSNsfUHGuOsew
SZ8yt4rJDX9lUSnGdgRGg0EvtRj0pz9/a/HXyoKLyrXckcz58+ExUzh21aonOi6n
Sp4vnlu8Jq8sVd1MDWowu4vLYfhXek9myrvurc7/5Vl431RW1GcYoogZkYUNj59z
ncQMuSO12IE+EDESe8J53WF17PpVULuLrwY8NTLJzR1SpqDVGTNzcHrLOiC2JtYr
piJDnSCmlJF2xOkLFH/MI43gi6orSoTv4AWDjLiq+GWfQvE3W2AHzLIT92eAhpLl
WuC/Plh2WqO+FBt/hGqR58U2ljYVXu9EeEiR7o7YgGOGP2OAIHARZAahQVpsN+X1
vrMQDRz0LkDiSX9HCah/
=Nh3z
-----END PGP SIGNATURE-----

--QnBU6tTI9sljzm9u--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
