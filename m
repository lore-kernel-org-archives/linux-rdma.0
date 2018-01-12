From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 02/17] verbs: Include rdma/ib_user_verbs.h in
 kern-abi.h
Date: Fri, 12 Jan 2018 08:34:33 +0200
Message-ID: <20180112063433.GH15760@mtr-leonro.local>
References: <20180111221340.965-1-jgg@ziepe.ca>
 <20180111221340.965-3-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0rSojgWGcpz+ezC3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111221340.965-3-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 03:13:25PM -0700, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> There are a few overlapping definitions that are identical in both
> headers, delete them from kern-abi.h to make them includable.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibverbs/kern-abi.h | 62 ++++++---------------------------------------------
>  1 file changed, 7 insertions(+), 55 deletions(-)
>
> diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
> index f53e22fce5303b..d7acdaa9a4bca9 100644
> --- a/libibverbs/kern-abi.h
> +++ b/libibverbs/kern-abi.h
> @@ -37,9 +37,14 @@
>
>  #include <linux/types.h>
>
> +#include <rdma/ib_user_verbs.h>
> +
>  /*
> - * This file must be kept in sync with the kernel's version of
> - * drivers/infiniband/include/ib_user_verbs.h
> + * This file contains copied data from the kernel's include/uapi/rdma/ib_user_verbs.h,
> + * now included above.
> + *
> + * Whenever possible use the definition from the kernel header and avoid
> + * copying from that header into this file.
>   */
>
>  /*
> @@ -48,59 +53,6 @@
>  #define IB_USER_VERBS_MIN_ABI_VERSION	3
>  #define IB_USER_VERBS_MAX_ABI_VERSION	6
>
> -#define IB_USER_VERBS_CMD_THRESHOLD    50
> -
> -enum {
> -	IB_USER_VERBS_CMD_GET_CONTEXT,
> -	IB_USER_VERBS_CMD_QUERY_DEVICE,
> -	IB_USER_VERBS_CMD_QUERY_PORT,
> -	IB_USER_VERBS_CMD_ALLOC_PD,
> -	IB_USER_VERBS_CMD_DEALLOC_PD,
> -	IB_USER_VERBS_CMD_CREATE_AH,
> -	IB_USER_VERBS_CMD_MODIFY_AH,
> -	IB_USER_VERBS_CMD_QUERY_AH,
> -	IB_USER_VERBS_CMD_DESTROY_AH,
> -	IB_USER_VERBS_CMD_REG_MR,
> -	IB_USER_VERBS_CMD_REG_SMR,
> -	IB_USER_VERBS_CMD_REREG_MR,
> -	IB_USER_VERBS_CMD_QUERY_MR,
> -	IB_USER_VERBS_CMD_DEREG_MR,
> -	IB_USER_VERBS_CMD_ALLOC_MW,
> -	IB_USER_VERBS_CMD_BIND_MW,
> -	IB_USER_VERBS_CMD_DEALLOC_MW,
> -	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL,
> -	IB_USER_VERBS_CMD_CREATE_CQ,
> -	IB_USER_VERBS_CMD_RESIZE_CQ,
> -	IB_USER_VERBS_CMD_DESTROY_CQ,
> -	IB_USER_VERBS_CMD_POLL_CQ,
> -	IB_USER_VERBS_CMD_PEEK_CQ,
> -	IB_USER_VERBS_CMD_REQ_NOTIFY_CQ,
> -	IB_USER_VERBS_CMD_CREATE_QP,
> -	IB_USER_VERBS_CMD_QUERY_QP,
> -	IB_USER_VERBS_CMD_MODIFY_QP,
> -	IB_USER_VERBS_CMD_DESTROY_QP,
> -	IB_USER_VERBS_CMD_POST_SEND,
> -	IB_USER_VERBS_CMD_POST_RECV,
> -	IB_USER_VERBS_CMD_ATTACH_MCAST,
> -	IB_USER_VERBS_CMD_DETACH_MCAST,
> -	IB_USER_VERBS_CMD_CREATE_SRQ,
> -	IB_USER_VERBS_CMD_MODIFY_SRQ,
> -	IB_USER_VERBS_CMD_QUERY_SRQ,
> -	IB_USER_VERBS_CMD_DESTROY_SRQ,
> -	IB_USER_VERBS_CMD_POST_SRQ_RECV,
> -	IB_USER_VERBS_CMD_OPEN_XRCD,
> -	IB_USER_VERBS_CMD_CLOSE_XRCD,
> -	IB_USER_VERBS_CMD_CREATE_XSRQ,
> -	IB_USER_VERBS_CMD_OPEN_QP
> -};
> -
> -#define IB_USER_VERBS_CMD_COMMAND_MASK		0xff
> -#define IB_USER_VERBS_CMD_FLAGS_MASK		0xff000000u
> -#define IB_USER_VERBS_CMD_FLAGS_SHIFT		24
> -
> -
> -#define IB_USER_VERBS_CMD_FLAG_EXTENDED		0x80ul

This define was added to kernel api (rdma/ib_user_verbs.h) in commit
f21519b23c1b ("IB/core: extended command: an improved infrastructure for uverbs commands")

It means that this proposed commit won't compile on the systems with
kernel dated before 2013. I don't think that it is real issue, but worth
to mention it in commit message/comment.

Thanks

> -
>  /* use this mask for creating extended commands */
>  #define IB_USER_VERBS_CMD_EXTENDED_MASK \
>  	(IB_USER_VERBS_CMD_FLAG_EXTENDED << \
> --
> 2.15.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--0rSojgWGcpz+ezC3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYVvkACgkQ5GN7iDZy
WKd90Q/9EBk5OB5jAsz2x4lpOvHCVQh+4ulEasTw08EgnHMs2Hc6jXLxetEaFYjF
lPTVa2E3yNMOX6o9k8hQYoBzaABC++8FXQCY7pgx/3uaL8KwUQ2qDnxaXuPSIXKP
Z6iPz4eI0A4v3SjhRx79ur9SzBAiQ64wDEfrusNHm7JZS5ecDl3o+E0vVVuttA1w
QSVOq4rY2vdpSWEwx/TxtwnwbV+bpOItTcwLJjGX5ugTDEy6//5UASo1XXTDTf8H
cTCCFaVFw1Yn2C1iEirPYNy8munA6HMyp+9Ocx0JXqymYp/zt5rxnTPT+T6m3Ei/
O7nMA3eva8ZGgNYrlZ4TK5aCBiX0DczkcxdjheM0A2y/FvXtwrbOjZbyVN6XD+IX
Sj0XZv/v1OJBjk7YP/gxl3a8F8XtyXVUsYhe0MzQTf6M0bXod1lebD5zXSpKTiuY
MOE393nf+5m41pVgenOy/4111TdtPoG/hN90VbjJMR4QfivhDYqAF2a61TOh2xHv
OG+ylSj+XhE706cPCLvZN7eOofhiTCcwlDe5mowLBhqaKhEp9FcXt84A5MruaFzN
w4CKQp7x5qZfMVYCwqFeg+K6D8FoElmeZI98q3RPvLEoVjcw/M/+FwD4QnVOCDB5
JvnZJVCWzCrI22K4HdMYaAbq6M4ZkNBhenElHIg3HhDAMRx2Dr0=
=uxqU
-----END PGP SIGNATURE-----

--0rSojgWGcpz+ezC3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
