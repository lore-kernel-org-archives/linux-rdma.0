From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 21/37] IB/mlx5: Switch from dma_device to dev.parent
Date: Sun, 22 Jan 2017 16:15:31 +0200
Message-ID: <20170122141531.GJ28570@mtr-leonro.local>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <20170120210437.26389-22-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170120210437.26389-22-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 20, 2017 at 01:04:21PM -0800, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c |  2 +-
>  drivers/infiniband/hw/mlx5/mr.c   | 14 +++++++-------
>  2 files changed, 8 insertions(+), 8 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliEvoIACgkQ5GN7iDZy
WKd4RA/+Lu5TpfZA9FUO+IrTkkR+++V9gIA3NVHYQRVuoWsKpqzrLEArJdoGTdri
aaBZergE2158XtzvIPvlamP+IAcAmNvZs7yYVQvFcUZ72ZvAtLb1AqmN/Y56QjV8
vt429X1o8kBuG6Ud5SC3vB7IGzP07nt745YYudtQRUWtquKMsiZdyQZNpTwTGPXu
LN8eyPAqH14ZdRMIHh7xvyG7F9Jg5lVzxmMvLBSFPGzouJv7xCXOOXrARtwuDGCH
QtYDE0QFwSZgFtTmMpFVN6J5qxtT6MqbFlY4kdA4QRdNHrNDlQiCtnJDD50ZDM7P
YVAO1smyfoRQ7d+ECbMDufax4t9ChBczOa6I+HCoT28sVYfRxJ6idGggAOVvpwip
d3RVeHVPw+CpkzNFWeiFkWG1oUINY7dk7M2x7KyYOnkqF/jhljUc4vlwAAdZgRM+
Hnv8RUdfI7vsTBHAu8jnuIAT4dAkaoVwRIQvwcytLB7pCUY71Qbs5a2lyMJkYimH
9CtiBZrc4xwkfV0voAoFR38/FtX/6VTHsIxXLX2d0Npy3uaBRpxQ96bXy95xTEIT
gWgbEYsF8e4qEu1712fy8xlAmRoNh61xTsGmpYqc3pwFs3UlcsNigy1T7/5fWx7j
xQjQbJf44bB2sCooTgPZfxTZqx8QMlzN2rTK47Mw23kHw1EIi+E=
=QM1B
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
