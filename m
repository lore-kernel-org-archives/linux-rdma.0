From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] hw: Fix permissions for OCRDMA_RESET_STATS
Date: Tue, 15 Aug 2017 21:31:58 +0300
Message-ID: <20170815183158.GB24282@mtr-leonro.local>
References: <1502207797-25589-1-git-send-email-vasilyev@ispras.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GACvPnKyN03uhzyl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502207797-25589-1-git-send-email-vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anton Vasilyev <vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--GACvPnKyN03uhzyl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 08, 2017 at 06:56:37PM +0300, Anton Vasilyev wrote:
> Debugfs file reset_stats is created with S_IRUSR permissions,
> but ocrdma_dbgfs_ops_read() doesn't support OCRDMA_RESET_STATS,
> whereas ocrdma_dbgfs_ops_write() supports only OCRDMA_RESET_STATS.
>
> The patch fixes misstype with permissions.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Anton Vasilyev <vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> index 66056f9..d42c617 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> @@ -834,7 +834,7 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
>
>  	dev->reset_stats.type = OCRDMA_RESET_STATS;
>  	dev->reset_stats.dev = dev;
> -	if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
> +	if (!debugfs_create_file("reset_stats", S_IWUSR, dev->dir,
>  				&dev->reset_stats, &ocrdma_dbg_ops))
>  		goto err;
>

If I didn't miss anything, the reset_stats knob wouldn't work.

Any read of statistics from that debugfs will trigger the call to
ocrdma_update_stats and it will call to ocrdma_mbx_rdma_stats(dev, false).

For write operations to that "reset_stats", there is call
to ocrdma_mbx_rdma_stats with second argument (reset) as true.

But it doesn't do much with that "reset" argument, except update of reset_stats.

git grep reset_stats drivers/infiniband/hw/ocrdma/* drivers/net/ethernet/emulex/
drivers/infiniband/hw/ocrdma/ocrdma.h:  struct ocrdma_stats reset_stats;
drivers/infiniband/hw/ocrdma/ocrdma_hw.c:               req->reset_stats = reset;
drivers/infiniband/hw/ocrdma/ocrdma_sli.h:      u8 reset_stats;
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    dev->reset_stats.type = OCRDMA_RESET_STATS;
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    dev->reset_stats.dev = dev;
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
drivers/infiniband/hw/ocrdma/ocrdma_stats.c:                            &dev->reset_stats, &ocrdma_dbg_ops))
drivers/net/ethernet/emulex/benet/be_cmds.c:    req->cmd_params.params.reset_stats = 0;
drivers/net/ethernet/emulex/benet/be_cmds.h:    u8 reset_stats;

Thanks

--GACvPnKyN03uhzyl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmTPh4ACgkQ5GN7iDZy
WKdd0g/+KHazV+mSqvNnRlKjL1ozrdYKnrAe9U/Q2op/sttf58eI+WrdPONzAbwM
CStza/PiHeG8DK3KNRdXn2aNoMt6HrIt8Em637Ga0A3j2MdQGR/MLyTo0c8WkxiE
Daqm+wuv913zbm0QiUh94k+kyR/NC2oB+YWVMa6LpCHnzroOH1d5UyCWAlUh5a9/
4tCgNqQReu2qloU8nrnkEZYJ9AMDaAh7t4Q7D/rrJiZy1J7w+JoicB+uOuYygka2
D6TfRNHR9FVxQ3O7SAX5OL86yWAWCKVUdxBMY+ApRib4FnF/gjlpNpALIVL8FpY3
NoDfkL1j9WNH5xzN5s8kTXg0qv/qhb3kTlqF64ZD8H/cQqp0PSML35iFILjzRXHN
tkSeGdBVgaudxSNbsUmvrk/GNF98dfiUFn+BS72hN9VWDZnhYLYfEdBBko5eC8PD
v7DRd/NUBCAxraZarR7gQmZW1L69i6I+oRjSWJQm33yaoXw3VcG15FkgxTOT0Wt5
0ZDT9/H92pMje7ezZtzDwY++m0Hb/7aKRbYFWRy0vmVxQaA2HHChZtbSbM8MEAX5
KyJGTwczDfBxyB0XpzIvtRbAz5H6OqlQE/U+fLZ2h04jUN11gb3xFLC2HeMF8Ytf
JZ0THum6OC8ZuLSUBdjH8FyZtkiasI/HmZNBf9fWEuTSktyrZy4=
=09C6
-----END PGP SIGNATURE-----

--GACvPnKyN03uhzyl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
