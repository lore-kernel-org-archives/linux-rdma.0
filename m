From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] vmw_pvrdma: Explicitly check for IP_BASED_GIDS
 port flag
Date: Thu, 31 Aug 2017 12:06:02 +0300
Message-ID: <20170831090602.GF10539@mtr-leonro.local>
References: <1504136041-3070-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504136041-3070-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 30, 2017 at 04:34:01PM -0700, Adit Ranadive wrote:
> Rely on the IP_BASED_GIDS flag to use the ibv_resolve_eth_l2_from_gid
> function when creating the AH. Otherwise, fallback to the
> set_mac_from_gid function to set the DMAC.
>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
> Pull request:
> https://github.com/linux-rdma/rdma-core/pull/205
>
>  providers/vmw_pvrdma/verbs.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>

Thanks, applied.

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmn0XoACgkQ5GN7iDZy
WKc5LxAAzNFxWe9q4YQtTiQqnRMR9KBB9c2+9l1cr+XD6E603it1OgfON/hYcZLR
GVbsPqpjrRCmWyZZdW/LDytzQxiOj13hUoL/VTiLIz8ONKxwSe+oVqbDhXFPrkEc
UdrNvGbtJKDDpAzLIhJgLSQPXJCuRrjk7oDS6fvYO4Uv/8epcp+X3gv0pvHjpk8E
mi3eJYMcYWrm6HnOMFYeBzVioleo8+gq1dN1J9koX4O6bjUEbx67a9Dzg/kRU3gS
b3zA5fWG6v5CSLVoz2pid5tg5dukP5myM8BThEj3BrjL4vZOEIBLJKvZsnpI/YFh
l9o77Huii5mo2PZ8rZIfp5bWJINQ1laHjf2cyfrFslGW9OAdtYFEOXWox1h2JIH6
ZP2IsLn5BLZ6FlhaG1TJIUAEyDij1d9zwrBKxTtfr0HZyAKNZHNGOaS4vpGLaEvi
UQLTQAQ/34hP1e/lTKfnWZrFLnLQ/3F2eJb2NaG8C4ekKmgl4HPiCrD7mOtx+oz6
E3URaFbD6P+gf1Qqobl0aKsYWke6cMf+7F9UCaawgvPIoF6DKI01FZCX0bMt3r+c
2QLWZUA3xbiCmMsF8L/wxe63j0X+7DBpmpfdABALuQOSc+t85AjG67PcY77lWZ7o
pKy1qaWwlQZe/zQTE9xKbdtnBrFgIWgewsIp9806JrZ8rZELid8=
=KW2O
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
