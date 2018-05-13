From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 driver attrs
Date: Sun, 13 May 2018 16:15:09 +0300
Message-ID: <20180513131509.GE10381@mtr-leonro.mtl.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <312486eb14b460e455e7b2926d7ea06e3a8411fc.1525709213.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <312486eb14b460e455e7b2926d7ea06e3a8411fc.1525709213.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2018 at 08:53:10AM -0700, Steve Wise wrote:
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h | 37 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)

Please write in commit message something like: "Based on kernel commit
....", so we will be able to track changes.

>
> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> index 45474f1..40be0d8 100644
> --- a/rdma/include/uapi/rdma/rdma_netlink.h
> +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> @@ -249,10 +249,22 @@ enum rdma_nldev_command {
>  	RDMA_NLDEV_NUM_OPS
>  };
>
> +enum {
> +	RDMA_NLDEV_ATTR_ENTRY_STRLEN = 16,
> +};
> +
> +enum rdma_nldev_print_type {
> +	RDMA_NLDEV_PRINT_TYPE_UNSPEC,
> +	RDMA_NLDEV_PRINT_TYPE_HEX,
> +};
> +
>  enum rdma_nldev_attr {
>  	/* don't change the order or add anything between, this is ABI! */
>  	RDMA_NLDEV_ATTR_UNSPEC,
>
> +	/* Pad attribute for 64b alignment */
> +	RDMA_NLDEV_ATTR_PAD = RDMA_NLDEV_ATTR_UNSPEC,
> +
>  	/* Identifier for ib_device */
>  	RDMA_NLDEV_ATTR_DEV_INDEX,		/* u32 */
>
> @@ -387,8 +399,31 @@ enum rdma_nldev_attr {
>  	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
>  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
>  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> +	/*
> +	 * driver-specific attributes.
> +	 */
> +	RDMA_NLDEV_ATTR_DRIVER,			/* nested table */
> +	RDMA_NLDEV_ATTR_DRIVER_ENTRY,		/* nested table */
> +	RDMA_NLDEV_ATTR_DRIVER_STRING,		/* string */
> +	/*
> +	 * u8 values from enum rdma_nldev_print_type
> +	 */
> +	RDMA_NLDEV_ATTR_DRIVER_PRINT_TYPE,	/* u8 */
> +	RDMA_NLDEV_ATTR_DRIVER_S32,		/* s32 */
> +	RDMA_NLDEV_ATTR_DRIVER_U32,		/* u32 */
> +	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
> +	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
>
> -	/* Netdev information for relevant protocols, like RoCE and iWARP */
> +	/*
> +	 * Provides logical name and index of netdevice which is
> +	 * connected to physical port. This information is relevant
> +	 * for RoCE and iWARP.
> +	 *
> +	 * The netdevices which are associated with containers are
> +	 * supposed to be exported together with GID table once it
> +	 * will be exposed through the netlink. Because the
> +	 * associated netdevices are properties of GIDs.
> +	 */
>  	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
>  	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
>
> --
> 1.8.3.1
>

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJa+DpdAAoJEORje4g2clin38sP/RNuYXAhcUyEMJpw8DWjWd0T
KlEZrMySUkJgsqcLDt85GV8xRVz36sGQfhRIUCMC0oZoePWuS0vdB009HFyxDTuX
QSvePwA2TIrlKoGh37RHniBFW5N9X7yy3/rPMKUO7NpxnYr8riIvqJ3SLMMxb6qq
eIrWfCPlusPET7B98tkl+saxGNFOSVHz77/3i9xBrvUniGM5WKIsfT5nCg/mx6UB
IRsqmF3J1iXpiOav7c0YqKvc5kZjh/M+AfuONsoHHInCK1DuRNjdLoHHzlZJpzJY
+E/JixojKflshuhtsaXGFw10TxjaML27Xln1SYeUI/bxIlwdJNTu5sGzKRiTnZ4S
/MvP3EhwmB+sM0qK8pQ2ci9P2aLiyzYy6i1xnibIaTD5+G5Pr5TqQ6mapbT8JIBV
hKfwlXqWHVBti+oEZhcWkAL/bSkNt1rJ/YDsd/jsJ9fIJoQXhuymteQkn7EazaY5
zgFWtuHdfSGWQLc88/Ddj01Jsk6mbB896WNlqkJDyDbPmdlPus+0bA7lHgrAEh+6
IPIhGvBhAMBytVxws/wAJCP8UtWDusOj1ysYkSkz0Cgz2CsB2Zm59rC6svwfL/if
gU0V3SSRmDaY13LevEMV0U6BTJX6fYZHvD4qbQWrawTVUn+hfDQ0ZJW9BJOMT7cl
kyNM2r3LXOME5/OxKKKM
=bbrq
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
