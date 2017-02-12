From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 25/27] IB/hfi1: Add rvt_rnr_tbl_to_usec function
Date: Sun, 12 Feb 2017 19:48:53 +0200
Message-ID: <20170212174853.GK14015@mtr-leonro.local>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
 <20170208132818.16442.38634.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8kI7hWEHMS8Z+7/0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208132818.16442.38634.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8kI7hWEHMS8Z+7/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 05:28:19AM -0800, Dennis Dalessandro wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Return usec from an index into ib_rvt_rnr_table.
>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c |   11 +++++++++++
>  include/rdma/rdmavt_qp.h          |    1 +
>  2 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
> index db4315f..0b97598 100644
> --- a/drivers/infiniband/sw/rdmavt/qp.c
> +++ b/drivers/infiniband/sw/rdmavt/qp.c
> @@ -1954,6 +1954,17 @@ void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
>  }
>  EXPORT_SYMBOL(rvt_rc_error);
>
> +/*
> + *  rvt_rnr_tbl_to_usec - return index into ib_rvt_rnr_table
> + *  @index - the index
> + *  return usec from an index into ib_rvt_rnr_table
> + */
> +unsigned long rvt_rnr_tbl_to_usec(u32 index)
> +{
> +	return ib_rvt_rnr_table[(index & RVT_AETH_CREDIT_MASK)];
> +}
> +EXPORT_SYMBOL(rvt_rnr_tbl_to_usec);
> +

Do we have a usage of this new exported function?

>  static inline unsigned long rvt_aeth_to_usec(u32 aeth)
>  {
>  	return ib_rvt_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
> diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
> index 2f91fae..9767549 100644
> --- a/include/rdma/rdmavt_qp.h
> +++ b/include/rdma/rdmavt_qp.h
> @@ -653,6 +653,7 @@ static inline u32 rvt_div_mtu(struct rvt_qp *qp, u32 len)
>  void rvt_comm_est(struct rvt_qp *qp);
>  int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
>  void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
> +unsigned long rvt_rnr_tbl_to_usec(u32 index);
>  enum hrtimer_restart rvt_rc_rnr_retry(struct hrtimer *t);
>  void rvt_add_rnr_timer(struct rvt_qp *qp, u32 aeth);
>  void rvt_del_timers_sync(struct rvt_qp *qp);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--8kI7hWEHMS8Z+7/0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAligoAUACgkQ5GN7iDZy
WKcWRRAAlHX0FVjD+kJdfiBA+R7H1O0iCGYVr2JcCUVMUXWOxns8KlCQBcPCsArg
5TS97P35Vif6KGc6lIChl42I7DBUVR1JWPIclBG6ueE989600FvS1eBaERdCwQeR
oIxC0Lwky7QJ8yMKMNPTiTdSsY7ZcxLnhz4S1tu1VWSIyMIpxwrgLns1RUupv5w3
qrOxP7LH9Tv9PNmOOYWolqCHi/gFWM7oq2KNkX8hENccO7CdjydjsvTC3vyWRUln
vB+Q0kqkROKmTrL22heGkGeb4StB396sybJJ4Sjy0xZRiVak9NJmITxAP/WNKtcT
6HBhkRcDNmZQunLyOm++fyuhB4J5AauvHDzjNcPmldyHkozXx5dgnJ27Y+18qKEi
aII54exI+3Sou2PRg2UWWls5bWV2sQPBLUWc/j7iXj4sobMAopJUBP647UKZWRwI
3W01Ep2r3b3DT4WJUdJzUxrRmQLvnh96KzNcObcdKfJNcJMDbiYoNvC7IU8fbc7c
urn1ATHs8HL7ZxlIRHzR8LXRXxOH0wmm6KAsl/AaZfDnFczy2DaxoLqKxbMsCJcH
vv+FPI2rQ9qfr78DT62koG8C4rMnaUjA9lFRQr7oZ2gg5JncblEZeVZRFof7G67d
LnHQ30zY1A2lLfnMStUSq5oV3GYP74BLnM+LnUjqiTPM4heKL8o=
=PtSU
-----END PGP SIGNATURE-----

--8kI7hWEHMS8Z+7/0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
