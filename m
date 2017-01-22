From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 37/37] IB/rxe, IB/rdmavt: Use dma_virt_ops instead of
 duplicating it
Date: Sun, 22 Jan 2017 16:11:41 +0200
Message-ID: <20170122141141.GI28570@mtr-leonro.local>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <20170120210437.26389-38-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tSiBuZsJmMXpnp7T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170120210437.26389-38-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--tSiBuZsJmMXpnp7T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 20, 2017 at 01:04:37PM -0800, Bart Van Assche wrote:
> Make the rxe and rdmavt drivers use dma_virt_ops. Update the
> comments that refer to the source files removed by this patch.
> Remove struct ib_dma_mapping_ops. Remove ib_device.dma_ops.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/Kconfig  |   1 +
>  drivers/infiniband/sw/rdmavt/Makefile |   2 +-
>  drivers/infiniband/sw/rdmavt/dma.c    | 198 ----------------------------------
>  drivers/infiniband/sw/rdmavt/dma.h    |  53 ---------
>  drivers/infiniband/sw/rdmavt/mr.c     |   8 +-
>  drivers/infiniband/sw/rdmavt/vt.c     |   4 +-
>  drivers/infiniband/sw/rdmavt/vt.h     |   1 -
>  drivers/infiniband/sw/rxe/Kconfig     |   1 +
>  drivers/infiniband/sw/rxe/Makefile    |   1 -
>  drivers/infiniband/sw/rxe/rxe_dma.c   | 183 -------------------------------
>  drivers/infiniband/sw/rxe/rxe_loc.h   |   2 -
>  drivers/infiniband/sw/rxe/rxe_verbs.c |   3 +-
>  include/rdma/ib_verbs.h               | 103 ++----------------
>  13 files changed, 18 insertions(+), 542 deletions(-)
>  delete mode 100644 drivers/infiniband/sw/rdmavt/dma.c
>  delete mode 100644 drivers/infiniband/sw/rdmavt/dma.h
>  delete mode 100644 drivers/infiniband/sw/rxe/rxe_dma.c
>
> diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
> index 1da8d01a6855..fdd001ce13d8 100644
> --- a/drivers/infiniband/sw/rdmavt/Kconfig
> +++ b/drivers/infiniband/sw/rdmavt/Kconfig
> @@ -1,5 +1,6 @@
>  config INFINIBAND_RDMAVT
>  	tristate "RDMA verbs transport library"
>  	depends on 64BIT
> +	select DMA_VIRT_OPS

Bart,
Small question, is it an easy way to select this option
for whole INFINIBAND instead of doing for every driver?

Besides that,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--tSiBuZsJmMXpnp7T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliEvZsACgkQ5GN7iDZy
WKcTfxAArWBOyEB48g+fHU8kxtpiJ6lSXUXUDdiT7YR4nLtZ2dVQfFCy7TcznZiL
rgJ4XT09Xh7SnwwejmVnKv/DbfrNeLy0yBXgzEbeWhEllzFQHoqBi420sjiJSrvg
K7d+ALTsk7Z0jKk0Lf0Qv5/2cYy64lzdwqid2Le9pHz17yNx189bgyDlguQU8/d+
1RVzhWrFXJE7rZ8dVROOeFvNVEmnM15wHTIn/0rcY1RJUzNbZTUGH7zlbwy/ec0u
d/nTn/au3HuukHBUG/hucAhnp2/N60HOyD5/VJ7mt3CrH+owyDOw6Nyyz8y0XsXi
UJruWKu81aAfhfyctysP66Lu+Y3pOvjyOvLRjq/ThxeCUXDL4U/NHyXlwVhSqmgr
ut3K4Pi+HiLsDUx5zxW/Um7PyrEmCxTcUU7IB01nkr/675aW/aSABCk0gmy/64Fs
sVdzThXKxeyLB6EQN81w9MFZ6esUOHRi8j5FpRA864KDNSXK4DRLAaG7Y0aiL0Ws
5fM+VAGCL7fiSPx6UbiVTQPwZf3F1yrdGAhS+7fBNmOjeSI0esbSL7Oa6EgTtIFR
sXNg49mRpFUGUwgPfELK3eIPvZhqQFmGSrGeNOY/Np5sKnWWLLOotHieXWObVi34
ORvMbGbHZE9Lcp/RquCo88AlGSN/BNnkQLTaqbzTF+vOKAtZTKg=
=2Z4U
-----END PGP SIGNATURE-----

--tSiBuZsJmMXpnp7T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
