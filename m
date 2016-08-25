From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Send last streaming mode message for loopback
 connections
Date: Thu, 25 Aug 2016 06:46:00 +0300
Message-ID: <20160825034600.GB594@leon.nu>
References: <1472065157-56936-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472065157-56936-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 24, 2016 at 01:59:17PM -0500, Shiraz Saleem wrote:
> From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Send a zero length last streaming mode message for loopback
> connections to synchronize between accepting QP and connecting QP.
> This avoids data transfer to start on the accepting QP before
> the connecting QP is in RTS. Also remove function i40iw_loopback_nop()
> as it is no longer used.
>
> Fixes: f27b4746f378 ("i40iw: add connection management code")
>

Hi Shiraz,
It will be great if avoid the empty line between Fixes and tags for future submissions.
Thanks

> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
>
> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> index 6434398..7ca0638 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> @@ -3347,26 +3347,6 @@ int i40iw_cm_disconn(struct i40iw_qp *iwqp)
>  }
>
>  /**
> - * i40iw_loopback_nop - Send a nop
> - * @qp: associated hw qp
> - */
> -static void i40iw_loopback_nop(struct i40iw_sc_qp *qp)
> -{
> -	u64 *wqe;
> -	u64 header;
> -
> -	wqe = qp->qp_uk.sq_base->elem;
> -	set_64bit_val(wqe, 0, 0);
> -	set_64bit_val(wqe, 8, 0);
> -	set_64bit_val(wqe, 16, 0);
> -
> -	header = LS_64(I40IWQP_OP_NOP, I40IWQPSQ_OPCODE) |
> -	    LS_64(0, I40IWQPSQ_SIGCOMPL) |
> -	    LS_64(qp->qp_uk.swqe_polarity, I40IWQPSQ_VALID);
> -	set_64bit_val(wqe, 24, header);
> -}
> -
> -/**
>   * i40iw_qp_disconnect - free qp and close cm
>   * @iwqp: associate qp for the connection
>   */
> @@ -3638,7 +3618,7 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>  	} else {
>  		if (iwqp->page)
>  			iwqp->sc_qp.qp_uk.sq_base = kmap(iwqp->page);
> -		i40iw_loopback_nop(&iwqp->sc_qp);
> +		dev->iw_priv_qp_ops->qp_send_lsmm(&iwqp->sc_qp, NULL, 0, 0);
>  	}
>
>  	if (iwqp->page)
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvmn4AAoJEORje4g2clinWp4P/0FXy9pssibw9aS0MFED7kls
e0gDJx3cdS16Lyy84Uncr3+Q0jqU3UrJhHUvCZUWRI3OBUbw4UT4dGBqtzFB9jdX
2w+LYCDjdG1E/e1yA/rpW20U5yi+EHXxi047wHz1I9dXs6kxIAwEOJEKxsTcf/e/
UtXEevjTkWpxKcclgIin3mk0J+fVIuwncgD6A5uIj4AoJQJtLE3GzfbVSoeaum9X
3fPHxc3O+D7SIv3Qr84qVQBw/yUa6ydP6adRbHQD8VhPnAdkhkzS/EPVmiVae0TS
oIiKBsAA0/ElEr3k7LdtTj4R/kgkhkWbQ2pJICuPG/Qmk+1UEtKag8AAh7gWSZ6l
AmWgY5lokk2ECHcTDk/S9zGAppsdaB7SBTHdD3YzksuNsgouh40k6hWAvqfiwqC0
9qT9OUJiOVyAcpiHRUPCN1Mmjt7hc/2g8Q0WB3gcJXls9emAIpkH3Vxm/CzudzFw
2Sm/FeHqdkE07834JJjmo2zT1tepjmLoLSsLJLzXToGem19xl25dbmE/NP9ob66I
MUlgU7zasm4mXb9GOLnaQlixVCCRii8MYBd/bD0BzvbYXEIcQ+BxYQepECvho5uA
t6B/UjqEYb0hWIa432QR1UkK1HMIXMMGpJcgR+/OPWKMlqUTWvqX6AnfFOFSrbHi
BsTptE/fs38dhk3LWJPX
=wzcY
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
