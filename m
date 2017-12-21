From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 for-rc 3/4] RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI
 header file
Date: Thu, 21 Dec 2017 14:59:29 +0200
Message-ID: <20171221125929.GG2942@mtr-leonro.local>
References: <20171220174748.GA18149@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171220175051.GA22751@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y974o0GblB/Ae/yP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220175051.GA22751-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Y974o0GblB/Ae/yP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 09:50:57AM -0800, Bryan Tan wrote:
> Support for SRQs were added in the vmw_pvrdma userlevel library
> before two necessary macros were added into the kernel ABI header
> file. Add the two UAR SRQ macros that are required by the userlevel
> library so that the library can rely on the kernel ABI header file
> for these SRQ macro definitions.
>
> Fixes: 8b10ba783c9d ("RDMA/vmw_pvrdma: Add shared receive queue support")
> Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/rdma/vmw_pvrdma-abi.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
> index aaa352f..4007cac 100644
> --- a/include/uapi/rdma/vmw_pvrdma-abi.h
> +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
> @@ -58,6 +58,8 @@
>  #define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
>  #define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
>  #define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
> +#define PVRDMA_UAR_SRQ_OFFSET		8		/* SRQ doorbell. */
> +#define PVRDMA_UAR_SRQ_RECV		BIT(30)		/* Recv bit. */
>

Didn't we see that BIT() in UAPI is a wrong thing to do? Why don't you
add normal (1 << 30) ?

>  enum pvrdma_wr_opcode {
>  	PVRDMA_WR_RDMA_WRITE,
> --
> 1.8.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Y974o0GblB/Ae/yP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo7sDEACgkQ5GN7iDZy
WKe6fRAAjKC38W9InnhPH5ZsrFngINYbMO7BuPuyR4w8MwWOJTd0/OvVDTsjQMEf
Wlz3ZW4Yp7dSG8xs86r0xB2dWPHYOab37WczslRpoD5GOZXR/Z6k0GOmKFxJy8Y7
EfSTekqfRZ037VXU11ShTdTKUjLBE0lQwGroL79pq05LMGYJfTc5Ejrg5qvLK9a9
5E6c1bMxQo4WzW7dOfqDDocPKmYAGWzjkqNzkH5oF4c6yvRLdGBQEtUpLmYaBMdh
/5nApYjCNbdpP5DZGvM7OmtkimpIWY7uxA/ahgSPDLDN6HGceQdPN5yk0XT3rHHv
PCRIAME1PB2SovW4aGo0Y1/waFE0BkdjTSJ9FWSkCQCEOOD9JZT7QcImHM9jQff3
xrH8Rrg2K+RLmafOa2q7mgrXm+l5KRMBVUTSxB6vQ41wQdFiFTRrY1FyDiAFVGQ7
8qLJuVyy8L/C62CPOMcfiyi7ds48F2KhnuZTabjh+umldOTI4FLb+sDa6FQe5n79
Zfs4rHKQQWjos1U6xZhLgyuqdDIiREhuSFloqQUSTXKBy0R4GG8aItmwUN5XIqTU
IXrOtOj8nDT/HsRGtjQXhCve4Vbz9eV00qVKLFcfjNRggZVFrEnI//Rg7ywlotKU
4qSy55qQN8NIlwjBYW0U9Cb6uxWg+Yn2cNQusPnB5Ys8PZC7YBA=
=OdIy
-----END PGP SIGNATURE-----

--Y974o0GblB/Ae/yP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
