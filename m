From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/8] IB/core: Use __be32 for LIDs in
 opa_is_extended_lid
Date: Tue, 3 Oct 2017 09:16:57 +0300
Message-ID: <20171003061657.GA13648@mtr-leonro.local>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180431.31117.33069.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171002180431.31117.33069.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 11:04:33AM -0700, Dennis Dalessandro wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> The LIDs passed to opa_extended_lid are in __be32 format,
> change function signature accordingly.
>
> This fixes the following sparse warnings:
>   drivers/infiniband/core/cm.c:1181:60: warning: incorrect type in
> 	argument 1 (different ba
>   drivers/infiniband/core/cm.c:1182:60: warning: incorrect type in
> 	argument 2 (different ba
>   drivers/infiniband/core/cm.c:1242:68: warning: incorrect type in
> 	argument 1 (different ba
>   drivers/infiniband/core/cm.c:1243:68: warning: incorrect type in
> 	argument 2 (different ba
>   drivers/infiniband/core/cm.c:2922:66: warning: incorrect type in
> 	argument 1 (different ba
>   drivers/infiniband/core/cm.c:2923:66: warning: incorrect type in
> 	argument 2 (different ba
>   include/rdma/opa_addr.h:102:14: warning: cast to restricted __be32
>
> Fixes: e92aa00a5189 ("IB/CM: Add OPA Path record support to CM")
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/rdma/opa_addr.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
> index e6e90f1..f68fca2 100644
> --- a/include/rdma/opa_addr.h
> +++ b/include/rdma/opa_addr.h
> @@ -97,15 +97,15 @@ static inline u32 opa_get_lid_from_gid(const union ib_gid *gid)
>   * @dlid: The DLID
>   * @slid: The SLID
>   */
> -static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
> +static inline bool opa_is_extended_lid(__be32 dlid, __be32 slid)
>  {
>  	if ((be32_to_cpu(dlid) >=
>  	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
>  	    (be32_to_cpu(slid) >=
>  	     be16_to_cpu(IB_MULTICAST_LID_BASE)))

You can drop be32_to_cpu and be16_to_cpu now.
The dlid is __be32 and IB_MULTICAST_LID_BASE is __be16. The direct
comparison will work.

>  		return true;
> -	else
> -		return false;
> +
> +	return false;
>  }
>
>  /* Get multicast lid base */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnTK1kACgkQ5GN7iDZy
WKehQA//RxhaXReTKWgYDi2+ICQimiRLWrS1JfMYDTkrtIw0IDMtRM1RB+ya/pX/
scxNh3RSiksKrNz8jnOTRfp1Z9n4EDoJlxAOBhlGs81ByHMJyaEF3NK4UFUl6xWP
sebdot6SgsjM0HI+uCdC2NO6/P7SMMO9v0w3elTIFNyV1bPcM2uUiZdejaDKnqSI
Bl5J6ZzmErvJJjzCiib0EYBj2ipkiRLgj5K4OaAiRY/ALdcTgRyHf/oVML5NvN7A
XNh9aBmM1lqxZ8EWNU/D1AujmJDiUVkWRDK1idSbA5iQj79cctBz+jJa8UxP8G9U
fcvUSGv7PDxx8HxGi2WQSZCPLsEHtQEuS+aOZ4peCm3JTfcF/F1qaY1TPKz7ZG0n
Z5eYYOzFAUOgOSUbd87PoAuyPnE9GBNZc1ZcEs3b3uoHqEBalxPV7GeOQq7EYWsg
xqb2mF/MpTqLp8gfFWxFt+YPc914ybicfr7KMIzIEKjln0ZMeoJoYw2JYbQnaHX0
EOVX1LHzEB2N0wT/ZCLQ1+Rj3sAwc1ld/YK+NbsAqBZg/dw4DvM8DO5ln4DVdGIp
LV+rOcxB1J59iUO2FfvW28wHXCJM5R85pkuekn/N9AZoMnbnaBiVA7xMiBaI4Z3Q
m8lHVmga1l9slVrVIP17Q7Qp1HsTFOUUUbc7sEvbVpQVwLQ9GF8=
=UTxu
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
