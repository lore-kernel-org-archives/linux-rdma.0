From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Fri, 16 Feb 2018 19:35:03 +0200
Message-ID: <20180216173502.GS2197@mtr-leonro.local>
References: <20180216165919.997D72BB6D@smtp.opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rmZDAlAp7pllCg/D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180216165919.997D72BB6D-ff04S8wfc4plDsoTORJclLwze2ij/50Q0E9HWUfgJXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rmZDAlAp7pllCg/D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 14, 2018 at 06:43:36PM -0800, Steve Wise wrote:
> uaccess_kernel() isn't sufficient to determine if an rdma resource is
> user-mode or not.  For example, resources allocated in the add_one()
> function of an ib_client get falsely labeled as user mode, when they
> are kernel mode allocations.  EG: mad qps.
>
> The result is that these qps are skipped over during a nldev query
> because of an erroneous namespace mismatch.
>
> So now we determine if the resource is user-mode by looking at the object
> struct's uobject or similar pointer to know if it was allocated for user
> mode applications.
>
> Fixes: 02d8883f520e ("RDMA/restrack: Add general infrastructure to track RDMA resources")
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>
> ---
>
> Changes since v1:
>
> changed _create_qp() to take the qp ib_uobject ptr so it is availble to
> rdma_restrack_add()
>
> ---
>  drivers/infiniband/core/core_priv.h  |  4 +++-
>  drivers/infiniband/core/restrack.c   | 35 +++++++++++++++++++++++++++++++++--
>  drivers/infiniband/core/uverbs_cmd.c |  4 ++--
>  drivers/infiniband/core/verbs.c      |  3 +--
>  4 files changed, 39 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
> index c4560d8..39b8332 100644
> --- a/drivers/infiniband/core/core_priv.h
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -305,7 +305,8 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
>  static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
>  					  struct ib_pd *pd,
>  					  struct ib_qp_init_attr *attr,
> -					  struct ib_udata *udata)
> +					  struct ib_udata *udata,
> +					  struct ib_uobject *uobj)

I'm fine with this solution either, but believe that v1 was cleaner way
to address this issue, because udata tells us already that we are
creating user/kernel QP and QP has already PD associated with it.

Also I tried to move to _ib_create_qp() as less as possible initialization
logic.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--rmZDAlAp7pllCg/D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqHFkYACgkQ5GN7iDZy
WKfi5hAAoeSanu42wkBXFg6yAE+kO5CVOJTCzmbYTBW+mcE8u8Ar6OTABhnwdpuD
actWrJskFY4niC5Nu4HDgfAwLMmbp/uVIQg2KcGgAAQflhlb6Tc74eK3Y2QUeqyY
2hN6KQKFK2hCFaoLfh4I0l5Gywu96doeWMYGdhPDqGLofhDjD2tDg+d5APBzFe6g
RIJQ6QRDDUu0Q0plIOLYKFk727dHRv+1VkBwNnwFwwvdJUR1jpPJjNMiPGsRu+qc
ERAuVO3Qlmr5VZfS+H71JUNjTqivyUQPiY5XnlDrtJKKTy7wNnwsjGmkbmUjmVaH
ebj9us/v+jwRzhsi68kbgNsQbcmrkizoV0b0E7Pij/YTME4R6SbqW+WSFOlTVUY3
3fYQ2sD0q+apqKUpd9npeGupMguxXVu/uihusF9JNkBUsgTRowFd9YrWvY+aryPj
BKAmQvNDMGO1LB7KwlsIEPC+uGhbV51FqyLP8+ZB0Bvb155fa6AdQOnJWHPVMu7E
EEKjbF34kwSDKlS4gkZwK4+lk2PbImCGvlDBxCTjeyooJ6LzCG5msnI9NWGfjrGS
f+up9XZ4AtGQAjs/BhBuB+S8s2YkaR7FSNZniB//eCN5X1jBrZos4Gsacsse8NCM
DGEy+0KlMm+K9jqa93ZZm4gs01Q9lbQ2oEzG2i7RoCIhAoiXup4=
=VF5P
-----END PGP SIGNATURE-----

--rmZDAlAp7pllCg/D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
