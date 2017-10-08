From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Sun, 8 Oct 2017 13:03:17 +0300
Message-ID: <20171008100317.GR25829@mtr-leonro.local>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
 <20171006214243.11296-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zsAhXfiBV62A5hVr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006214243.11296-4-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--zsAhXfiBV62A5hVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 02:42:39PM -0700, Bart Van Assche wrote:
> Although the non-SRQ mode needs more resources that mode has three
> advantages over SRQ:
> - It works with all RDMA adapters, even those that do not support
>   SRQ.
> - Posting WRs and polling WCs does not trigger lock contention
>   because only one thread at a time accesses a WR or WC queue in
>   non-SRQ mode.
> - The end-to-end flow control mechanism is used.
>
> From the IB spec:
>
>     C9-150.2.1: For QPs that are not associated with an SRQ, each HCA
>     receive queue shall generate end-to-end flow control credits. If
>     a QP is associated with an SRQ, the HCA receive queue shall not
>     generate end-to-end flow control credits.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 130 +++++++++++++++++++++++++---------
>  drivers/infiniband/ulp/srpt/ib_srpt.h |   4 ++
>  2 files changed, 99 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 6cf95ad870cc..a21b7a96635c 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -75,11 +75,19 @@ module_param(srp_max_req_size, int, 0444);
>  MODULE_PARM_DESC(srp_max_req_size,
>  		 "Maximum size of SRP request messages in bytes.");
>
> +static bool use_srq;
> +module_param(use_srq, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(use_srq, "Whether or not to use SRQ");
> +

It is a little bit strange to ask from user to decide if his adapter
supports SRQ or not.

It should be automatically.


>  static int srpt_srq_size = DEFAULT_SRPT_SRQ_SIZE;
>  module_param(srpt_srq_size, int, 0444);
>  MODULE_PARM_DESC(srpt_srq_size,
>  		 "Shared receive queue (SRQ) size.");
>
> +static int srpt_sq_size = DEF_SRPT_SQ_SIZE;
> +module_param(srpt_sq_size, int, 0444);
> +MODULE_PARM_DESC(srpt_sq_size, "Per-channel send queue (SQ) size.");
> +

Thanks.

--zsAhXfiBV62A5hVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnZ9+QACgkQ5GN7iDZy
WKd3BRAAghKGScvkQVTgwBg2hzYkujLcWmDZc2VW1r0tR4U1VmkTL0P0Lo8q6l92
Uw/PVf8F+N6gXshD+zYoPzcnPWBeBbyk5tIUk0897TiEiF0I4Sr95RrRrwqNhrz9
sWCWRrxgIgM+7DrNtQ6yPBAKdx40kezdvabtdZEyBf9hk47iz38n4gv8OR2WEYo7
a2/CvFOQVtnTJD1wFYFPFP0GLr1w/feHdT+SJCrrCwTDvIl2faNmHnfK++0/C3Y9
CN0QaMJsMoF/vb7a2G7RWKZcEdMwNoTjP663THb/x82GG+kKlq1ZQwnH/ivpTliX
5OEeqD8XrJXTppxNNokNdIAHMtOYRGhpzwS+wpJpo0+lfhTUYeGDSkla9LNGYayV
IaeRnp/xj6VpSzvCQo0+Zg81aQqNef+mzkOrmnuSFP5XO4asPPwvmCYqLLd2d2Em
OCjPSvAN7KnCvu+XoWBpjuEd14Tq+ACq7rKcV33dctIdg6IkYvHwl8W9BAdriaWy
dNJDic9M6stNESvM1I/jCPqdsTkTP5Xd2/YNXC7i9EcoPtdEayhpQ0ejjAah8I4J
CgptOYyFxM4cLAq4JE/2nUx0/3X45VVmrj3p+X+gYBETBkHWYxNkjsbxKF5MWrdt
ne50/nq0iZHiAEjalX6oAvrFUUQgq4tqUfkn6mqWj+PqRICQrLU=
=R85V
-----END PGP SIGNATURE-----

--zsAhXfiBV62A5hVr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
