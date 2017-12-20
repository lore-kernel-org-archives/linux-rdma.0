From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 for-rc 2/4] RDMA/vmw_pvrdma: Use refcount_dec_and_test
 to avoid warning
Date: Wed, 20 Dec 2017 21:55:36 +0200
Message-ID: <20171220195536.GA2942@mtr-leonro.local>
References: <20171220174748.GA18149@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171220174956.GA20571@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tuFXEhzhBeitrIAu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220174956.GA20571-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tuFXEhzhBeitrIAu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 09:50:01AM -0800, Bryan Tan wrote:
> refcount_dec generates a warning when the operation
> causes the refcount to hit zero. Avoid this by using
> refcount_dec_and_test.
>
> Fixes: 8b10ba783c9d ("RDMA/vmw_pvrdma: Add shared receive queue support")
> Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--tuFXEhzhBeitrIAu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6wDgACgkQ5GN7iDZy
WKcGfg/+Ol4EtGkoH3j7HGxhcWI0yZ7F+s5SAQOwfANjTkD5naAkQE7AFLy3Ncnr
6z1ILU0LtdRDwP9cvtESv22H1m6jxbs2rsDjfnU10niTeoapsyFEveHdrodr6kzY
tx2qAT17l0A/Q43LzfmZ4tMxxwWFMLinvRmndV5ky0Hcj71w7bH9o6PW47nm1V3D
NGNv/3LFQxc6r+2bCa8kYyZQ+HC8hHYnmt0t6mhTp8RJ7nwlFh+Dqf6itJ8nnLuT
3QfFHbCFF+6Qr9lR/yabBseHFwwujLAvc7qZ6allzkV0lh85kb31zK9TcBdc0ANN
PDnmLS0bnMWurRa9md/pPVd1lUFU6I1UaBMizdXK9PwXuN3DkdkE1JZedURhwOFX
XHB8riREgkzrJZrkw6MUuQL54li/78qWVMMf9nQ2uqMQCvm+HPor/gjUDvhDVIwD
tv8+btFO6lmkzf5MhuXl+8OC1yvhWyspR15J1A1IALUzELwIWh0P7AD+shsdl+B9
rsQj4hf0uupLanTWfBUMqAWGGX5nBUWzDEJb7Xy/TDpHG64tOKVv34h7MvcxQkL5
+JfU75KfPmDb8S/aCIM+BDV+uDnwaCPKZjOTJ2GsuYlxB9jgj5WV+2l2f9hNgYji
WlXPx+UxYj4wibayrfokMkfR4m7eSMLy4fqUAdF6Qan2K1guxtc=
=Iblm
-----END PGP SIGNATURE-----

--tuFXEhzhBeitrIAu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
