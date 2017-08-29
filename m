From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/vmw_pvrdma: Report network header type
 in WC
Date: Tue, 29 Aug 2017 08:45:33 +0300
Message-ID: <20170829054533.GH23726@mtr-leonro.local>
References: <cover.1503965717.git.aditr@vmware.com>
 <521f5e2169789e31a7e91dab691cd155f0100090.1503965717.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bygAmIonOAIqBxQB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <521f5e2169789e31a7e91dab691cd155f0100090.1503965717.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bygAmIonOAIqBxQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2017 at 05:19:35PM -0700, Adit Ranadive wrote:
> From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>
> We should report the network header type in the work completion so that
> the kernel can infer the right RoCE type headers.
>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    |  6 ++++++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c |  2 ++
>  include/uapi/rdma/vmw_pvrdma-abi.h           | 13 +++++++++++--
>  3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> index 663a0c3..99b2c97 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> @@ -426,6 +426,12 @@ static inline int pvrdma_wc_flags_to_ib(int flags)
>  	return flags;
>  }
>
> +static inline enum rdma_network_type pvrdma_wc_network_hdr_to_ib(
> +					enum pvrdma_network_type type)
> +{
> +	return (enum rdma_network_type)type;
> +}
> +
>  static inline int ib_send_flags_to_pvrdma(int flags)
>  {
>  	return flags & PVRDMA_MASK(PVRDMA_SEND_FLAGS_MAX);
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index 90aa326..34727f6 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -389,6 +389,8 @@ static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp **cur_qp,
>  	wc->dlid_path_bits = cqe->dlid_path_bits;
>  	wc->port_num = cqe->port_num;
>  	wc->vendor_err = cqe->vendor_err;
> +	wc->network_hdr_type =
> +			pvrdma_wc_network_hdr_to_ib(cqe->network_hdr_type);
>
>  	/* Update shared ring state */
>  	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq->ibcq.cqe);
> diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
> index c8c1d2d..6a87806 100644
> --- a/include/uapi/rdma/vmw_pvrdma-abi.h
> +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
> @@ -58,6 +58,13 @@
>  #define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
>  #define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
>
> +enum pvrdma_network_type {
> +	PVRDMA_NETWORK_IB,
> +	PVRDMA_NETWORK_ROCE_V1 = PVRDMA_NETWORK_IB,
> +	PVRDMA_NETWORK_IPV4,
> +	PVRDMA_NETWORK_IPV6
> +};

Doug,

I see that you are already merged this patch, but it is problematic patch.

They defined in uapi file, the new enum which is equal to already existed
 128 enum rdma_network_type {
 129         RDMA_NETWORK_IB,
 130         RDMA_NETWORK_ROCE_V1 = RDMA_NETWORK_IB,
 131         RDMA_NETWORK_IPV4,
 132         RDMA_NETWORK_IPV6
 133 };

And the more important they are doing direct casting from rdma_network_type to
pvrdma_network_type as is in the same patch.

The proper way to do it is to return rdma_network_type directly without obfuscation
and without creating new supported forever UAPI enum.


> +
>  enum pvrdma_wr_opcode {
>  	PVRDMA_WR_RDMA_WRITE,
>  	PVRDMA_WR_RDMA_WRITE_WITH_IMM,
> @@ -125,7 +132,8 @@ enum pvrdma_wc_flags {
>  	PVRDMA_WC_IP_CSUM_OK		= 1 << 3,
>  	PVRDMA_WC_WITH_SMAC		= 1 << 4,
>  	PVRDMA_WC_WITH_VLAN		= 1 << 5,
> -	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_VLAN,
> +	PVRDMA_WC_WITH_NETWORK_HDR_TYPE	= 1 << 6,
> +	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_NETWORK_HDR_TYPE,
>  };
>
>  struct pvrdma_alloc_ucontext_resp {
> @@ -283,7 +291,8 @@ struct pvrdma_cqe {
>  	__u8 dlid_path_bits;
>  	__u8 port_num;
>  	__u8 smac[6];
> -	__u8 reserved2[7]; /* Pad to next power of 2 (64). */
> +	__u8 network_hdr_type;
> +	__u8 reserved2[6]; /* Pad to next power of 2 (64). */
>  };
>
>  #endif /* __VMW_PVRDMA_ABI_H__ */
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--bygAmIonOAIqBxQB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmk/30ACgkQ5GN7iDZy
WKe8NA/9EBcjHkC3nbNpA30W3GNN//nQ2Q9DilHWFpbPcsz7JQBjgEs0XqaBvyNM
SjBjF1SRFLBwvMqE4UB2Yj6VvtwCn4QfMYVN3CYoj+3PUU0CQBUfNGu3faDEdWug
mxJdThfozQbFDj5ViRMRf0rosHRjgUVSEDOuprTm1fnyFpdwCco5LhCfmJH4l6Mk
x0bECgMPP5SfwVj/zi+zykyj5Tk18uiqDBCP7t1MJGa49jPvZgAQTVJHgIzTk9UL
uuihn6eKEKQsEXTTFvmFhkV871JH0zvGNJcAbRkvvWFeaxDTYsE/tQVGCcA05sNU
SKXkTAhoaTxrrw2/F2cSIw/g0UvVNdFMGqZA1vM0d1TWBoY/Xjs4C+5eEvAgY1il
WuAhO0KekxTvfDlXIA5mFMgemO+PjMK5Rlo5svpoJqwMmCzb+uTh0m94Lf6qdzuk
1rKJNn/I8ZnqyvrR2tWXbITpUDVX6BZZXoVzA7I0dFCNgGFVB3TqcNeF4QqTlnfO
ywongCFzfwT5KriUzIc9GR/IHHctMRdRk5eeVOOXP9O+egkxdAdkxptjI1dTbK+L
A7eubMHuMJ1x7DHSoSJg2z9PXvkk7u9qy1U0S4H2RU0uxpW2HUG1ifGEzKebi/Po
a/amvLum6g5P1+/zPwOg1S/s5oarJM5Y6E1chs0Ejx5MWW0CLZg=
=p0wV
-----END PGP SIGNATURE-----

--bygAmIonOAIqBxQB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
