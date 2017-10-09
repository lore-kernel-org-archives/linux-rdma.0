From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/7] IB/hfi1: Fix serdes loopback set-up
Date: Mon, 9 Oct 2017 22:58:46 +0300
Message-ID: <20171009195846.GH1252@mtr-leonro.local>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
 <20171009193744.6965.76584.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jHkwA2TBA/ec6v+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171009193744.6965.76584.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9jHkwA2TBA/ec6v+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 12:37:48PM -0700, Dennis Dalessandro wrote:
> From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Change serdes mode setting to use MISC_CONFIG_BITS in
> VERIFY_CAP_LOCAL_LINK_WIDTH register. This method of
> setting up serdes loopback is universally compatible
> across all firmware versions.
>
> Change-Id: I3ccd935c4b33e843c83c36a2caee77d62249cdc8

It doesn't belong here.
We don't love Gerrit here :)

> Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/chip.c |   42 ++++++++++++-------------------------
>  drivers/infiniband/hw/hfi1/chip.h |    3 +++
>  2 files changed, 17 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
> index d2d72e0..a6d61c4 100644
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -9190,25 +9190,6 @@ static int do_quick_linkup(struct hfi1_devdata *dd)
>  }
>
>  /*
> - * Set the SerDes to internal loopback mode.
> - * Returns 0 on success, -errno on error.
> - */
> -static int set_serdes_loopback_mode(struct hfi1_devdata *dd)
> -{
> -	int ret;
> -
> -	ret = set_physical_link_state(dd, PLS_INTERNAL_SERDES_LOOPBACK);
> -	if (ret == HCMD_SUCCESS)
> -		return 0;
> -	dd_dev_err(dd,
> -		   "Set physical link state to SerDes Loopback failed with return %d\n",
> -		   ret);
> -	if (ret >= 0)
> -		ret = -EINVAL;
> -	return ret;
> -}
> -
> -/*
>   * Do all special steps to set up loopback.
>   */
>  static int init_loopback(struct hfi1_devdata *dd)
> @@ -9233,13 +9214,11 @@ static int init_loopback(struct hfi1_devdata *dd)
>  		return 0;
>  	}
>
> -	/* handle serdes loopback */
> -	if (loopback == LOOPBACK_SERDES) {
> -		/* internal serdes loopack needs quick linkup on RTL */
> -		if (dd->icode == ICODE_RTL_SILICON)
> -			quick_linkup = 1;
> -		return set_serdes_loopback_mode(dd);
> -	}
> +	/*
> +	 * SerDes loopback init sequence is handled in set_local_link_attributes
> +	 */
> +	if (loopback == LOOPBACK_SERDES)
> +		return 0;
>
>  	/* LCB loopback - handled at poll time */
>  	if (loopback == LOOPBACK_LCB) {
> @@ -9298,7 +9277,7 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
>  	u8 tx_polarity_inversion;
>  	u8 rx_polarity_inversion;
>  	int ret;
> -
> +	u32 misc_bits = 0;
>  	/* reset our fabric serdes to clear any lingering problems */
>  	fabric_serdes_reset(dd);
>
> @@ -9344,7 +9323,14 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
>  	if (ret != HCMD_SUCCESS)
>  		goto set_local_link_attributes_fail;
>
> -	ret = write_vc_local_link_width(dd, 0, 0,
> +	/*
> +	 * SerDes loopback init sequence requires
> +	 * setting bit 0 of MISC_CONFIG_BITS
> +	 */
> +	if (loopback == LOOPBACK_SERDES)
> +		misc_bits |= 1 << LOOPBACK_SERDES_CONFIG_BIT_MASK_SHIFT;
> +
> +	ret = write_vc_local_link_width(dd, misc_bits, 0,
>  					opa_to_vc_link_widths(
>  						ppd->link_width_enabled));
>  	if (ret != HCMD_SUCCESS)
> diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
> index 213b6a3..fc122c1 100644
> --- a/drivers/infiniband/hw/hfi1/chip.h
> +++ b/drivers/infiniband/hw/hfi1/chip.h
> @@ -583,6 +583,9 @@ enum {
>  #define LOOPBACK_LCB	2
>  #define LOOPBACK_CABLE	3	/* external cable */
>
> +/* set up serdes bit in MISC_CONFIG_BITS */
> +#define LOOPBACK_SERDES_CONFIG_BIT_MASK_SHIFT 0
> +
>  /* read and write hardware registers */
>  u64 read_csr(const struct hfi1_devdata *dd, u32 offset);
>  void write_csr(const struct hfi1_devdata *dd, u32 offset, u64 value);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9jHkwA2TBA/ec6v+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnb1PYACgkQ5GN7iDZy
WKdijg//UcQu4bU3rnpnYBDMwDWdo7np9uog3f/dYSdrALUk4wr7ej73zbyzE1ny
D2sJUTutRECo1TFnnbmql6oiKKFxcRAE+iJUDMLjq7jYk3aoveMIzoNYrnMe57h8
3NqhD8uWvnhbuYBRQiv+x2GOQz/a6kly41XpX+4mB3/D04R0w6ZJx/tTO/BzU107
dhgQ9fhxebTDTk/OT3Bd8N7lh+0p4AVYkUG7CRoPQq05A+yZcrWrECiSrZKpwgXz
YJUg5CcrLhcCvzzBusfrg3kzSfEUijPjGn/eK0An0iRS8pNGSODkaywgum2lCBIw
nKe+68AZuT3ENA0osCGjatjOEKKEXGWosNAYHXtlulzVp4K/4LMLy7F2i8/ZVGDs
y/PRN2rnlES7HRnwRWzEnFF2+geh6wYkdBTnZXdBxXHQ/Yynf4K4zrkABMUMLEaH
WSstq6lTLI7Rp3xYso/6tBvst5AjaADf/84d+guG9/ZUMTlOW37MUZF3EmbsjQO3
Amd8O6JLvuBzd8MmOMA7P0/xVuTWnKjuMzHnF4DtgzwymTrO2sZpMrPY1D1D7dEx
XAUHueZMzN7XRARx6snUjQwpUlhSnv7uVqDiHBjyOVODjB/wwpKWB19XnQ5JCZGC
UV95MsbZXYgKXcU7cyyRNBzDZ58Qo3MyMRppkQvlrPJXovsn9AU=
=x1aS
-----END PGP SIGNATURE-----

--9jHkwA2TBA/ec6v+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
