From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Thu, 8 Feb 2018 18:39:14 +0200
Message-ID: <20180208163914.GH2197@mtr-leonro.local>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
 <20180205180904.GB11446@mellanox.com>
 <d572b570-0844-e441-19a0-e6804557fb58@mellanox.com>
 <20180205231617.GQ11446@mellanox.com>
 <CALzJLG9QQ_B4xj-E+HtpxUWZhFU9eWeqSNHSaQjf5HH=9TPXTg@mail.gmail.com>
 <20180208162605.GK9051@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180208162605.GK9051-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 08, 2018 at 09:26:05AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 07, 2018 at 09:45:52PM -0800, Saeed Mahameed wrote:
>
> > I see, that this patch is already on its way to linus, with no proper
> > mlx5 maintainer sign-off, nice.
>
> Doug and I can be more careful to not accept patches without
> maintainer ack's - but this means I will want to see Acks from you no
> matter who sends the patch (including patches sent by Leon).

Please don't invent the wheel, mlx5 is my responsibility too,
I'm just successfully avoid dealing with netdev patches.

 8897 MELLANOX MLX5 core VPI driver
 8898 M:      Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 8899 M:      Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 8900 M:      Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 8901 L:      netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 8902 L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 8903 W:      http://www.mellanox.com
 8904 Q:      http://patchwork.ozlabs.org/project/netdev/list/
 8905 S:      Supported
 8906 F:      drivers/net/ethernet/mellanox/mlx5/core/
 8907 F:      include/linux/mlx5/

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp8fTIACgkQ5GN7iDZy
WKd36RAAmpuV2Nuo/ClvbdX8snzcZDxLYb6aArnBWkPZMsdAEQNnHAebg7RGlMr2
AMi4+6Bxh/2kqua8jb8dIaMdDMOonqB2jJsWrMGXBf7iA+GZo2/cKQV/a3neOOuy
1jLupgQsTgnMUzPJ+BJ4y2AOJIzGd8G0z6o6I7aAGct/FOoAdSIDHy4a61YJz98W
YSK4oFQwZHwyKH8HjXsFEwKM1zP8KK/QXj796V8oNgFXP2gHrVtf83GSYrzL5V/V
ZoYo1DMoZ9KvIzIRvKxRKO1+eXjIV+0Q32beM2+4S0ebYCykvWwR6RiRpQkUtKR8
wMdSHSsPma9fTiMYZ2QdhTrjcKqG/vAVBC73mkTa7zvLw4vOivn5xx9hAFT4CZD5
fM0uJO24fDeD8UBWF2hn3pntaeLXh+KE3h1LoM9QzqEUwF/MOzq3lbtl42UNgBaa
UpJp2M4AKAndvTrP93oBrgAn0o0GVF0ZCiZ1FECYiS0wwZj09lni3ItNcZlr7dqd
bzy1pTCPesrKJyT+QwymIqg36qSQOPGrHFNWDx5lVWvhQrQWFHMrfJl1GuvH1q70
+ANPZFBbn4f370wclKGhFcmwoNfk6QuDSvhq2dGgCRyigGnk8CsO4BcTKBsULQ+D
4I07p393j9w3wI3ubOTIuIK/y4Yrt1rsWTiRXizkOgYXHMZGcwQ=
=qO2o
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
