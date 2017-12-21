From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 4/4] RDMA/vmw_pvrdma: Remove usage of BIT() from
 UAPI header
Date: Thu, 21 Dec 2017 15:00:34 +0200
Message-ID: <20171221130034.GH2942@mtr-leonro.local>
References: <20171220192305.GA28403@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171220192721.GA32622@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z3PcgjD2qOzdkXVS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220192721.GA32622-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--z3PcgjD2qOzdkXVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 11:27:28AM -0800, Bryan Tan wrote:
> BIT() should not be used in the UAPI header. Remove it.
>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/rdma/vmw_pvrdma-abi.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

IMHO, it should go to -rc.
Doug, Jason?


>
> diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
> index 4007cac..02ca0d0 100644
> --- a/include/uapi/rdma/vmw_pvrdma-abi.h
> +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
> @@ -52,14 +52,14 @@
>  #define PVRDMA_UVERBS_ABI_VERSION	3		/* ABI Version. */
>  #define PVRDMA_UAR_HANDLE_MASK		0x00FFFFFF	/* Bottom 24 bits. */
>  #define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell. */
> -#define PVRDMA_UAR_QP_SEND		BIT(30)		/* Send bit. */
> -#define PVRDMA_UAR_QP_RECV		BIT(31)		/* Recv bit. */
> +#define PVRDMA_UAR_QP_SEND		(1 << 30)	/* Send bit. */
> +#define PVRDMA_UAR_QP_RECV		(1 << 31)	/* Recv bit. */
>  #define PVRDMA_UAR_CQ_OFFSET		4		/* CQ doorbell. */
> -#define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
> -#define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
> -#define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
> +#define PVRDMA_UAR_CQ_ARM_SOL		(1 << 29)	/* Arm solicited bit. */
> +#define PVRDMA_UAR_CQ_ARM		(1 << 30)	/* Arm bit. */
> +#define PVRDMA_UAR_CQ_POLL		(1 << 31)	/* Poll bit. */
>  #define PVRDMA_UAR_SRQ_OFFSET		8		/* SRQ doorbell. */
> -#define PVRDMA_UAR_SRQ_RECV		BIT(30)		/* Recv bit. */
> +#define PVRDMA_UAR_SRQ_RECV		(1 << 30)	/* Recv bit. */
>
>  enum pvrdma_wr_opcode {
>  	PVRDMA_WR_RDMA_WRITE,
> --
> 1.8.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--z3PcgjD2qOzdkXVS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo7sHEACgkQ5GN7iDZy
WKflkhAAslEdq69LFoGB4OseL69U3fNCotxsxJaZzicpjIbixxV0Hzgt+2XWIzLP
H1cStnTDeO/N9sw/l9CUTAO5ovndTXqWkXI36xtCt3VwVB0WK4stnVzlv6KTZy7C
SiqTOQrcq7KY16MDSnRkBpcrfFOjcmUx1zU/JOPxxSxKQwF+rCrhZd0qCMNrNUMf
UzXi0rtZnFaIoU8KZIsskYkc6pImVItqe4Ms0Na6RvKXST3C6MRI9r2Jfai6SM5Z
H1TcHVX6G3av1e8VjZIyJ6CQaYXwk0q//8GeXIMBMuegMb7uSvdx5FMiwLL6PNZd
+nV5XCSR/S5UHfAC931cr7UeIhZi67Z4Wv57IBdIjxZT4iPUwDBh9WtFOF5f8AMs
WbkVDf895lJH39mLtueI4Kw0kbKrhEVhuLXJEzqiVBUwbe1MakzB+fsWkFLa8JyT
JXSPL3OMc0Th1ab9SC5g5nZAx7KuS8rWivDpQMcE3C6/pOCO+y0wsoT5S6UplPix
SUVtE+XLZkv58hfIY9d7YRmFYD8r4zSfIj+eCt3kkIJ7rRKx/NjvciGxsZaq6BEW
+lD0Y8RE+V85mvG++BA7kyw5UR5gtSZ9klIgC29O8aBegn75wAI+NFZba7y1K3l8
AfA3lRRJ72T1P62tXXDq4fx3Tl1YCB28CgcblKI8uBUQr1cLJuQ=
=ncJr
-----END PGP SIGNATURE-----

--z3PcgjD2qOzdkXVS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
