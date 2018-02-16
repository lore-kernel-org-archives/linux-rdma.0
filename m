From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] vmw_pvrdma: Avoid rounding up of sge count to power of 2
Date: Fri, 16 Feb 2018 09:22:16 +0200
Message-ID: <20180216072216.GK2197@mtr-leonro.local>
References: <1518741592-12723-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l/3WCmqZNZ+BnHMk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518741592-12723-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--l/3WCmqZNZ+BnHMk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 15, 2018 at 04:39:52PM -0800, Adit Ranadive wrote:
> Creation of resources can fail if the rounding up exceeds
> provider supported values.
>
> Fixes: 4c8ed14eb6b7 ("vmw_pvrdma: Add SRQ support")
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Nitish Bhat <bnitish-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
> ---
>  providers/vmw_pvrdma/qp.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
> index efcc99b..4b9f897 100644
> --- a/providers/vmw_pvrdma/qp.c
> +++ b/providers/vmw_pvrdma/qp.c
> @@ -113,7 +113,7 @@ struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
>  	int ret;
>
>  	attr->attr.max_wr = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_wr));
> -	attr->attr.max_sge = align_next_power2(max_t(uint32_t, 1U, attr->attr.max_sge));
> +	attr->attr.max_sge = max_t(uint32_t, 1U, attr->attr.max_sge);

One of two: or your commit message is not correct and you should mention
that align_next_power2() is not needed, or your code is incorrect,
because user can provide large enough number and this call will fail
anyway.

>
>  	srq = malloc(sizeof(*srq));
>  	if (!srq)
> @@ -216,14 +216,12 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
>  	int ret;
>  	int is_srq = !!(attr->srq);
>
> -	attr->cap.max_send_sge =
> -		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_send_sge));
> +	attr->cap.max_send_sge = max_t(uint32_t, 1U, attr->cap.max_send_sge);
>  	attr->cap.max_send_wr =
>  		align_next_power2(max_t(uint32_t, 1U, attr->cap.max_send_wr));
>
>  	if (!is_srq) {
> -		attr->cap.max_recv_sge =
> -			align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_sge));
> +		attr->cap.max_recv_sge = max_t(uint32_t, 1U, attr->cap.max_recv_sge);
>  		attr->cap.max_recv_wr =
>  			align_next_power2(max_t(uint32_t, 1U, attr->cap.max_recv_wr));
>  	} else {
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--l/3WCmqZNZ+BnHMk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqGhqcACgkQ5GN7iDZy
WKfPmA//S/JcHxR4gt+cQSj1OgbuZXeV9drDGrE34Uemhkt0lw5YTUNz9QP1BEFn
oPduv+WJZovj6oxSaaGshM+pG/BtzyXIq+2NjsaascRLdqMgTlXE6IIDUQHOeX0E
/QF2ZghU3pX4K8iPiwVaNOR7srrWEnFBONYgvFHx+oI1SsAMI/hP+7BLh9rsgvSw
BpqsYdCOBNjkiajwmZTYH7XdOr6vKWP7tgVXoFA+oLEINA7Vk5NxPJ6YBV3lT6Ei
BkkMZF4TA+kmYcgDyr+zgOnYFG233DzW0BCERdpIX1ADMnBKijUZGVVeId8KscYD
bv5WfcHCZ0OUl6KZjnvnoiNMxHKZibLEvA5Bpbd0ysq0/isT3HA4IWBx25G60Tco
5hQrpitcY+MUwPUaUs5PLzf7rF1z6O0/pNxk5qk+PsM+97AYEu9ZDft/AQ5q0Fd4
JHEh9zaxm5r0f9OHZDBCnfiUgUHPaTXOPJJtM0G38wOtN5xGCl9SNXlVG1l31PdE
llO+EoQJhpXZe36yH0mUKSjru+YJKIRxmpw/3c8byJ2EIvUHCKwnzn1oCryuMOp2
eeL4kLI0vCbvkHG8R1Zxl7TkvBcT3iatTzE0WKpweqNvuRV87Ad2C9ELrQ0OPUM+
seh/ZzoKiNp27rRkaiQTSRfwPpv0VrxDIN4uSolWomEM0LyUzSc=
=m6IS
-----END PGP SIGNATURE-----

--l/3WCmqZNZ+BnHMk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
