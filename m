From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Tue, 19 Sep 2017 20:47:21 +0300
Message-ID: <20170919174721.GL5788@mtr-leonro.local>
References: <1505842717-26646-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="P7Tqkd/m/Jnohiaz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505842717-26646-1-git-send-email-Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--P7Tqkd/m/Jnohiaz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 19, 2017 at 08:38:37PM +0300, Michal Kalderon wrote:
> Initialize the rdma_type (iWARP or RoCE) which is set according to
> device configuration in qed.
>
> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---

Please add Fixes.

Thanks

--P7Tqkd/m/Jnohiaz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnBWCkACgkQ5GN7iDZy
WKfAExAAiMBQjVQFAiPTxMt+fCrW8hfwqbovDMQ5Q8JuiTnnls323gJpW3L2UmMb
DA9lkuTtdTqG8dBPVuR45v6uuZ6qVJ8RxkIqxkhBeVmbBNUGL/HcWtA8mPkyDsC4
dSlDuV4A5p52oyASUSyLOLuV5+WjXTYp4olrQ4bpGutYNwev9Mi2lUCPxibW6aWu
tHdoJLHnS3hHHOLAP3jci/WT/oAJg4Ynj+Q8Q9xGPfD+C9ryaR6JzenM4/Gd75PR
mWnQrTlRt9/DMoSEJZZYfK0XK0pE3UCVgfJ+DQd2n1YJdW6oCduw7Yk5lQGoi+uz
2vedB/w7YuG69z1uFBia6QX4qIlETN7GyruPi/sY7XBFjZVSYgTsnMGyJ4LGuDv2
9je0neRpP10oBn4sfMCXUyYeEplMaa3P+hPX218kOK71dPqbEPVG+5FP66TCc+PX
mbaphmHoHqb6r36LT+syg2KcxU7hYlgjVsbT6R0G0540PFUVEWTrqQ4ssdJLa/AA
RP7ToP6TARLJ1VjNyj93kaF0O6geuE2QcqI9zMq26kUMG5rkFiTq4AFV9gN7rv3P
Gajzbc6OPt8c1P4uVZbjBBv7nm2QjYiYZIDkSmCHRY7pKLEUz/mbxJlpiEMrLTWP
LVhQ5MvQ2e7U3oCqOgESr7175AS48aDGuaWM5k2kxFcn3E29Lso=
=/6tx
-----END PGP SIGNATURE-----

--P7Tqkd/m/Jnohiaz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
