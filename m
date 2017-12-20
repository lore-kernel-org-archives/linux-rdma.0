From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 07/11] IB/hfi1: Fix infinite loop in 8051
 command error path
Date: Wed, 20 Dec 2017 10:08:54 +0200
Message-ID: <20171220080854.GL2942@mtr-leonro.local>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035657.2126.88651.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jRdC2OsRnuV8iIl8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219035657.2126.88651.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jRdC2OsRnuV8iIl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 07:56:59PM -0800, Dennis Dalessandro wrote:
> From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> When an 8051 command times out, the entire DC block is restarted. During
> the restart, the host interface version bit is set, which calls
> do_8051_command() recursively. The host version bit needs to be set
> before the link moves into polling, so the host version bit can be set
> in set_local_link_attributes() instead. Thus, the 8051 command functions
> can be simplied as a non-locking version (dd->dc8051_lock) of those
> functions are no longer needed.
>
> Fixes: 9be6a5d788b0 ("IB/hfi1: Prevent LNI out of sync by resetting host interface version")
> Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/chip.c     |   85 ++++++++++++---------------------
>  drivers/infiniband/hw/hfi1/chip.h     |    2 -
>  drivers/infiniband/hw/hfi1/firmware.c |   64 ++++++-------------------
>  3 files changed, 49 insertions(+), 102 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
> index 87748a6..99c7347 100644
> --- a/drivers/infiniband/hw/hfi1/chip.c
> +++ b/drivers/infiniband/hw/hfi1/chip.c
> @@ -6518,11 +6518,12 @@ static void _dc_start(struct hfi1_devdata *dd)
>  	if (!dd->dc_shutdown)
>  		return;
>
> -	/*
> -	 * Take the 8051 out of reset, wait until 8051 is ready, and set host
> -	 * version bit.
> -	 */
> -	release_and_wait_ready_8051_firmware(dd);
> +	/* Take the 8051 out of reset */
> +	write_csr(dd, DC_DC8051_CFG_RST, 0ull);
> +	/* Wait until 8051 is ready */
> +	if (wait_fm_ready(dd, TIMEOUT_8051_START))
> +		dd_dev_err(dd, "%s: timeout starting 8051 firmware\n",
> +			   __func__);
>
>  	/* Take away reset for LCB and RX FPE (set in lcb_shutdown). */
>  	write_csr(dd, DCC_CFG_RESET, 0x10);
> @@ -8566,23 +8567,30 @@ int write_lcb_csr(struct hfi1_devdata *dd, u32 addr, u64 data)
>  }
>
>  /*
> - * If the 8051 is in reset mode (dd->dc_shutdown == 1), this function
> - * will still continue executing.
> - *
>   * Returns:
>   *	< 0 = Linux error, not able to get access
>   *	> 0 = 8051 command RETURN_CODE
>   */
> -static int _do_8051_command(struct hfi1_devdata *dd, u32 type, u64 in_data,
> -			    u64 *out_data)
> +static int do_8051_command(
> +	struct hfi1_devdata *dd,
> +	u32 type,
> +	u64 in_data,
> +	u64 *out_data)

What did you try to say by this change ? :)

Thanks

--jRdC2OsRnuV8iIl8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6GpYACgkQ5GN7iDZy
WKf71Q//YO3RrUuLCz1j3bF1cs7iHCTmX2Z1fCOxP/Pn5Cc4FOWUODyx808QqoH8
8scFaRw7IEUDn4GJgpj1ImTGFFYXsyzTbXDEAJvwJ4xX2TbB+pMpTDwKiaPgNEKl
8PnmFvpEVAdd+8tT6GFIT9KqfCC83VACUyf6QAW7FxuwowyX0m4F41SbaQq79AUL
bK5LVnzQ7W+NriGNsGA7YmoBm5FoHWII/jMT9/QaFZtAJ5BDbih1JqrEb+DWke/S
L/ZKcfTdYFhq/OhCnJAeOvIyyfGj8vb/Y4NEglX47T+ogezDi6X94D2cireliHMI
i0uAv7Jl8g4/XKKudn87qQa4+74DybVqySh2XzRC8EuJndrI94os0lW+IpYkNRO8
A80aos4XMDN4eqSouyaqywAyb45DPc3IArkvHMlLHZEOHG1oLKC0DywBB2y0nJkc
qazQ9kmLIqW8GW0GbAuyYbsFf+jHygfz7uy88k9brqYokzkvINwvGLOcFJUsBqXK
z1QjxUwq0S05PIPCwHB/x3LJ1McQAQ7bh4R6XygKTBLlxKFpYVm5nLW30t2QqKyL
H0nY5eAH2mXL/M6VmQCJHpgMJM+BvcOcZyIcFOEqjtZOmRGAXoFAIGisPJGSWXzI
mDKu0kSRwlAwVsR3AEnGnOqIltE+76+PV/qFffEOpn/3Kqq5FRo=
=uHla
-----END PGP SIGNATURE-----

--jRdC2OsRnuV8iIl8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
