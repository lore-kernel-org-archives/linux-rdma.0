From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Sat, 10 Dec 2016 16:34:21 +0200
Message-ID: <20161210143421.GC2521@mtr-leonro.local>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481306104-19352-9-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2016 at 11:55:02AM -0600, Tatyana Nikolova wrote:
> From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Debug prints for error paths are off by default. User
> has the option to turn them on by setting environment
> variable I40IW_DEBUG in command line.
>=20
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Tatyana,

This patch duplicates already existing code in most of providers and
libraries in rdma-core, while two of our main goals for creating this
consolidated library were simplification for users and reduce code duplicat=
ion.

It will be very beneficial if you:
1. Use and promote general pr_debug(..), srp_tools has nice piece of code, =
to be general code.
2. Create one and general place for all rdma-core's environment variables.

This infrastructure will allow us in the future create better manual of
all variables supported and ensure easy change if neeeded.

Thanks

> ---
>  providers/i40iw/i40iw_umain.c  | 11 ++++++---
>  providers/i40iw/i40iw_umain.h  |  7 ++++++
>  providers/i40iw/i40iw_uverbs.c | 52 +++++++++++++++++++++++-------------=
------
>  3 files changed, 44 insertions(+), 26 deletions(-)
>=20
> diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
> index 1756e65..a204859 100644
> --- a/providers/i40iw/i40iw_umain.c
> +++ b/providers/i40iw/i40iw_umain.c
> @@ -46,7 +46,7 @@
>  #include "i40iw_umain.h"
>  #include "i40iw-abi.h"
> =20
> -unsigned int i40iw_debug_level;
> +unsigned int i40iw_dbg;
> =20
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -184,7 +184,7 @@ static struct ibv_context *i40iw_ualloc_context(struc=
t ibv_device *ibdev, int cm
>  	return &iwvctx->ibv_ctx;
> =20
>  err_free:
> -	fprintf(stderr, PFX "%s: failed to allocate context for device.\n", __f=
unc__);
> +	i40iw_debug("failed to allocate context for device.\n");
>  	free(iwvctx);
> =20
>  	return NULL;
> @@ -216,6 +216,7 @@ static struct ibv_device_ops i40iw_udev_ops =3D {
>  struct ibv_device *i40iw_driver_init(const char *uverbs_sys_path, int ab=
i_version)
>  {
>  	char value[16];
> +	char *env_val;
>  	struct i40iw_udevice *dev;
>  	unsigned int vendor, device;
>  	int i;
> @@ -236,9 +237,13 @@ struct ibv_device *i40iw_driver_init(const char *uve=
rbs_sys_path, int abi_versio
> =20
>  	return NULL;
>  found:
> +	env_val =3D getenv("I40IW_DEBUG");
> +	if (env_val)
> +		i40iw_dbg =3D atoi(env_val);
> +
>  	dev =3D malloc(sizeof(*dev));
>  	if (!dev) {
> -		fprintf(stderr, PFX "%s: failed to allocate memory for device object\n=
", __func__);
> +		i40iw_debug("failed to allocate memory for device object\n");
>  		return NULL;
>  	}
> =20
> diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
> index 13d3da8..889c006 100644
> --- a/providers/i40iw/i40iw_umain.h
> +++ b/providers/i40iw/i40iw_umain.h
> @@ -72,6 +72,13 @@
>  #define I40E_DB_SHADOW_AREA_SIZE 64
>  #define I40E_DB_CQ_OFFSET 0x40
> =20
> +extern unsigned int i40iw_dbg;
> +#define i40iw_debug(fmt, args...) \
> +do { \
> +	if (i40iw_dbg) \
> +		fprintf(stderr, PFX "%s: " fmt, __FUNCTION__, ##args); \
> +} while (0)
> +
>  enum i40iw_uhca_type {
>  	INTEL_i40iw
>  };
> diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverb=
s.c
> index f6d9196..464900b 100644
> --- a/providers/i40iw/i40iw_uverbs.c
> +++ b/providers/i40iw/i40iw_uverbs.c
> @@ -65,7 +65,7 @@ int i40iw_uquery_device(struct ibv_context *context, st=
ruct ibv_device_attr *att
> =20
>  	ret =3D ibv_cmd_query_device(context, attr, &i40iw_fw_ver, &cmd, sizeof=
(cmd));
>  	if (ret) {
> -		fprintf(stderr, PFX "%s: query device failed and returned status code:=
 %d\n", __func__, ret);
> +		i40iw_debug("query device failed and returned status code: %d\n", ret);
>  		return ret;
>  	}
> =20
> @@ -165,7 +165,7 @@ struct ibv_mr *i40iw_ureg_mr(struct ibv_pd *pd, void =
*addr, size_t length, int a
>  	if (ibv_cmd_reg_mr(pd, addr, length, (uintptr_t)addr,
>  			   access, mr, &cmd.ibv_cmd, sizeof(cmd),
>  			   &resp, sizeof(resp))) {
> -		fprintf(stderr, PFX "%s: Failed to register memory\n", __func__);
> +		i40iw_debug("Failed to register memory\n");
>  		free(mr);
>  		return NULL;
>  	}
> @@ -264,7 +264,7 @@ struct ibv_cq *i40iw_ucreate_cq(struct ibv_context *c=
ontext, int cqe,
>  			     &iwucq->mr, &reg_mr_cmd.ibv_cmd, sizeof(reg_mr_cmd), &reg_mr_res=
p,
>  			     sizeof(reg_mr_resp));
>  	if (ret) {
> -		fprintf(stderr, PFX "%s: failed to pin memory for CQ\n", __func__);
> +		i40iw_debug("failed to pin memory for CQ\n");
>  		goto err;
>  	}
> =20
> @@ -274,7 +274,7 @@ struct ibv_cq *i40iw_ucreate_cq(struct ibv_context *c=
ontext, int cqe,
>  				&resp.ibv_resp, sizeof(resp));
>  	if (ret) {
>  		ibv_cmd_dereg_mr(&iwucq->mr);
> -		fprintf(stderr, PFX "%s: failed to create CQ\n", __func__);
> +		i40iw_debug("failed to create CQ\n");
>  		goto err;
>  	}
> =20
> @@ -286,7 +286,7 @@ struct ibv_cq *i40iw_ucreate_cq(struct ibv_context *c=
ontext, int cqe,
>  	if (!ret)
>  		return &iwucq->ibv_cq;
>  	else
> -		fprintf(stderr, PFX "%s: failed to initialze CQ, status %d\n", __func_=
_, ret);
> +		i40iw_debug("failed to initialze CQ, status %d\n", ret);
>  err:
>  	if (info.cq_base)
>  		free(info.cq_base);
> @@ -307,11 +307,11 @@ int i40iw_udestroy_cq(struct ibv_cq *cq)
> =20
>  	ret =3D pthread_spin_destroy(&iwucq->lock);
>  	if (ret)
> -		return ret;
> +		goto err;
> =20
>  	ret =3D ibv_cmd_destroy_cq(cq);
>  	if (ret)
> -		return ret;
> +		goto err;
> =20
>  	ibv_cmd_dereg_mr(&iwucq->mr);
> =20
> @@ -319,6 +319,9 @@ int i40iw_udestroy_cq(struct ibv_cq *cq)
>  	free(iwucq);
> =20
>  	return 0;
> +err:
> +	i40iw_debug("failed to destroy CQ, status %d\n", ret);
> +	return ret;
>  }
> =20
>  /**
> @@ -344,7 +347,7 @@ int i40iw_upoll_cq(struct ibv_cq *cq, int num_entries=
, struct ibv_wc *entry)
>  		if (ret =3D=3D I40IW_ERR_QUEUE_EMPTY) {
>  			break;
>  		} else if (ret) {
> -			fprintf(stderr, PFX "%s: Error polling CQ, status %d\n", __func__, re=
t);
> +			i40iw_debug("Error polling CQ, status %d\n", ret);
>  			if (!cqe_count)
>  				/* Indicate error */
>  				cqe_count =3D -1;
> @@ -519,7 +522,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, =
struct ibv_pd *pd,
>  	info->sq =3D memalign(I40IW_HW_PAGE_SIZE, totalqpsize);
> =20
>  	if (!info->sq) {
> -		fprintf(stderr, PFX "%s: failed to allocate memory for SQ\n", __func__=
);
> +		i40iw_debug("failed to allocate memory for SQ\n");
>  		return 0;
>  	}
> =20
> @@ -535,7 +538,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, =
struct ibv_pd *pd,
>  			     IBV_ACCESS_LOCAL_WRITE, &iwuqp->mr, &reg_mr_cmd.ibv_cmd,
>  			     sizeof(reg_mr_cmd), &reg_mr_resp, sizeof(reg_mr_resp));
>  	if (ret) {
> -		fprintf(stderr, PFX "%s: failed to pin memory for SQ\n", __func__);
> +		i40iw_debug("failed to pin memory for SQ\n");
>  		free(info->sq);
>  		return 0;
>  	}
> @@ -545,7 +548,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, =
struct ibv_pd *pd,
>  	ret =3D ibv_cmd_create_qp(pd, &iwuqp->ibv_qp, attr, &cmd.ibv_cmd, sizeo=
f(cmd),
>  				&resp->ibv_resp, sizeof(struct i40iw_ucreate_qp_resp));
>  	if (ret) {
> -		fprintf(stderr, PFX "%s: failed to create QP, status %d\n", __func__, =
ret);
> +		i40iw_debug("failed to create QP, status %d\n", ret);
>  		ibv_cmd_dereg_mr(&iwuqp->mr);
>  		free(info->sq);
>  		return 0;
> @@ -565,7 +568,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, =
struct ibv_pd *pd,
>  		map =3D mmap(NULL, I40IW_HW_PAGE_SIZE, PROT_WRITE | PROT_READ, MAP_SHA=
RED,
>  			   pd->context->cmd_fd, offset);
>  		if (map =3D=3D MAP_FAILED) {
> -			fprintf(stderr, PFX "%s: failed to map push page, errno %d\n", __func=
__, errno);
> +			i40iw_debug("failed to map push page, errno %d\n", errno);
>  			info->push_wqe =3D NULL;
>  			info->push_db =3D NULL;
>  		} else {
> @@ -575,7 +578,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, =
struct ibv_pd *pd,
>  			map =3D mmap(NULL, I40IW_HW_PAGE_SIZE, PROT_WRITE | PROT_READ, MAP_SH=
ARED,
>  				   pd->context->cmd_fd, offset);
>  			if (map =3D=3D MAP_FAILED) {
> -				fprintf(stderr, PFX "%s: failed to map push doorbell, errno %d\n", _=
_func__, errno);
> +				i40iw_debug("failed to map push doorbell, errno %d\n", errno);
>  				munmap(info->push_wqe, I40IW_HW_PAGE_SIZE);
>  				info->push_wqe =3D NULL;
>  				info->push_db =3D NULL;
> @@ -639,7 +642,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, st=
ruct ibv_qp_init_attr *attr
>  	int sq_attr, rq_attr;
> =20
>  	if (attr->qp_type !=3D IBV_QPT_RC) {
> -		fprintf(stderr, PFX "%s: failed to create QP, unsupported QP type: 0x%=
x\n", __func__, attr->qp_type);
> +		i40iw_debug("failed to create QP, unsupported QP type: 0x%x\n", attr->=
qp_type);
>  		return NULL;
>  	}
> =20
> @@ -658,8 +661,8 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, st=
ruct ibv_qp_init_attr *attr
>  	/* Sanity check QP size before proceeding */
>  	sqdepth =3D i40iw_qp_get_qdepth(sq_attr, attr->cap.max_send_sge, attr->=
cap.max_inline_data);
>  	if (!sqdepth) {
> -		fprintf(stderr, PFX "%s: invalid SQ attributes, max_send_wr=3D%d max_s=
end_sge=3D%d\n",
> -			__func__, attr->cap.max_send_wr, attr->cap.max_send_sge);
> +		i40iw_debug("invalid SQ attributes, max_send_wr=3D%d max_send_sge=3D%d=
\n",
> +			attr->cap.max_send_wr, attr->cap.max_send_sge);
>  		return NULL;
>  	}
> =20
> @@ -691,13 +694,13 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, =
struct ibv_qp_init_attr *attr
>  	info.sq_wrtrk_array =3D calloc(sqdepth, sizeof(*info.sq_wrtrk_array));
> =20
>  	if (!info.sq_wrtrk_array) {
> -		fprintf(stderr, PFX "%s: failed to allocate memory for SQ work array\n=
", __func__);
> +		i40iw_debug("failed to allocate memory for SQ work array\n");
>  		goto err_destroy_lock;
>  	}
> =20
>  	info.rq_wrid_array =3D calloc(rqdepth, sizeof(*info.rq_wrid_array));
>  	if (!info.rq_wrid_array) {
> -		fprintf(stderr, PFX "%s: failed to allocate memory for RQ work array\n=
", __func__);
> +		i40iw_debug("failed to allocate memory for RQ work array\n");
>  		goto err_free_sq_wrtrk;
>  	}
> =20
> @@ -706,7 +709,7 @@ struct ibv_qp *i40iw_ucreate_qp(struct ibv_pd *pd, st=
ruct ibv_qp_init_attr *attr
>  	status =3D i40iw_vmapped_qp(iwuqp, pd, attr, &resp, sqdepth, rqdepth, &=
info);
> =20
>  	if (!status) {
> -		fprintf(stderr, PFX "%s: failed to map QP\n", __func__);
> +		i40iw_debug("failed to map QP\n");
>  		goto err_free_rq_wrid;
>  	}
>  	info.qp_id =3D resp.qp_id;
> @@ -772,11 +775,11 @@ int i40iw_udestroy_qp(struct ibv_qp *qp)
> =20
>  	ret =3D pthread_spin_destroy(&iwuqp->lock);
>  	if (ret)
> -		return ret;
> +		goto err;
> =20
>  	ret =3D i40iw_destroy_vmapped_qp(iwuqp, iwuqp->qp.sq_base);
>  	if (ret)
> -		return ret;
> +		goto err;
> =20
>  	if (iwuqp->qp.sq_wrtrk_array)
>  		free(iwuqp->qp.sq_wrtrk_array);
> @@ -792,6 +795,9 @@ int i40iw_udestroy_qp(struct ibv_qp *qp)
>  	free(iwuqp);
> =20
>  	return 0;
> +err:
> +	i40iw_debug("failed to destroy QP, status %d\n", ret);
> +	return ret;
>  }
> =20
>  /**
> @@ -916,7 +922,7 @@ int i40iw_upost_send(struct ibv_qp *ib_qp, struct ibv=
_send_wr *ib_wr, struct ibv
>  		default:
>  			/* error */
>  			err =3D -EINVAL;
> -			fprintf(stderr, PFX "%s: post work request failed, invalid opcode: 0x=
%x\n", __func__, ib_wr->opcode);
> +			i40iw_debug("post work request failed, invalid opcode: 0x%x\n", ib_wr=
->opcode);
>  			break;
>  		}
> =20
> @@ -960,7 +966,7 @@ int i40iw_upost_recv(struct ibv_qp *ib_qp, struct ibv=
_recv_wr *ib_wr, struct ibv
>  		post_recv.sg_list =3D sg_list;
>  		ret =3D iwuqp->qp.ops.iw_post_receive(&iwuqp->qp, &post_recv);
>  		if (ret) {
> -			fprintf(stderr, PFX "%s: failed to post receives, status %d\n", __fun=
c__, ret);
> +			i40iw_debug("failed to post receives, status %d\n", ret);
>  			if (ret =3D=3D I40IW_ERR_QP_TOOMANY_WRS_POSTED)
>  				err =3D -ENOMEM;
>  			else
> --=20
> 1.8.5.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhMEmUACgkQ5GN7iDZy
WKc+KQ/7BlTFplWGfV95Mt0TBtmAIvWNE0YSH/bfjG7HshZ/B0uv+fCDvV+NgFjh
3/Hs9l1dyYwYNsxBTznsDXMZBBF7gLWoPeJ1kzNFPqv23MPK+kUIqcRh964DUuLu
gid4wo8LlrarfAJX/+N+vmUUNHMryd3NVEQYn3bdb/TASJvP7aRdPrGEdEupp4YW
1JWA8nVtMGEhiWRYIlp7iBDCFH/g1fJ/4lXruoaBydry8rZT/fylqedgXbTvBYwm
ucpRwHL7lmNIKwfQy5QIOuhVyhdGhv2g1taNOWqBe8X6C2Hs2hVYuIh4yBGDdWMh
u1zrYk2lvWww6hcAlxxFEERhAfl06n1UWf4l+qtm6wKvw+H640kgse7BQlsZnNSW
IvE9vON4AlQG6AczzprCZdzWSf8XM3FpRDT7ysXxxH7MYssi+FXirpBbZJ7NTQ4j
M7cLGqMN4T5sC57SVAdhpgkKJp7DwClNYYp5GqTUFJSlUgmsQqKHSesATvSe5fdo
Ap+JNcVjN5ftz9xmZ/SxtQjtG0a6mqkwnwGy8XsoykdIvXux2HBVSdmT5ng/0U0y
Fp/oh7ktE+NijUA88VXVCCk1gHYC1f8X7zfijQPvXO73g8jpDnJO+hTeqUNDc383
92lx7yYIc59WpXUHoAvvwkxw+d7b4sizfO0JBxZr9eXGfvp0vNQ=
=1SlR
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
