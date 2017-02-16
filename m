From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] libqedr: Three queue related fixes
Date: Thu, 16 Feb 2017 08:10:52 +0200
Message-ID: <20170216061052.GU6989@mtr-leonro.local>
References: <1487224571-18627-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nSQp8DZZn7gZbDHt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487224571-18627-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nSQp8DZZn7gZbDHt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 16, 2017 at 07:56:08AM +0200, Ram Amrani wrote:
> Ram Amrani (3):
>   libqedr: Check queue mapping return value correctly
>   libqedr: Remove redundant memset
>   libqedr: Remove redundant RQ configuration
>
>  qelr_chain.c | 5 +++--
>  qelr_verbs.c | 2 --
>  2 files changed, 3 insertions(+), 4 deletions(-)
>

Thanks, applied.

--nSQp8DZZn7gZbDHt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlilQmwACgkQ5GN7iDZy
WKfLnRAAlg6h/QKcJGZqRXWhNE24D+sZL7TR4zxILJC5u/sAcMQSAT69UbAOLcnl
w4AbxYc8Bvm8hWu9OgyLcj2RT68yTi5Aq/M6xylZsphNAZo5vjZIzFOy/mh2VkXo
N4KGPspHcHg2YA2mWeAITUYn9A06gXgPSBTHMn4xk8uWucYOjvz0Wb9A92mVuxdr
TxK75KMqbfgBQyreXF7zCHQydqE8vBkTi/RDctG0gUMqcSJygPMRrRMQRBk7jgit
tKG0YhyZ8UTmHoBw8nZAP+FbIuWRd0zptrwsYQ7N2DmipA+GU9HT76uFYNpgh1pw
W9ykD6TGjxVahyR334KowQ/FdXOyJ/kq6M1xvn1pdS9o+bDlTW7AWvn4Ro+98cOO
GavbM+zV64EjyGi1ASEcwotkOcxo27IMzYbX2rWV9xsv6J4j/vyJCqRcKv+MQeGu
dugQtJfZ1c/A56Z54mhPk0BqAI5FMVTHs+PY8gqCbNzEEkRbaR+zB7wILO4w5CZw
KenSDITyoIO9BpYxwjFp34CGSg8E1W/Lz7oMQf61dl2GTq8B6UPsHQ2JpgKpAj/E
x6fETi4spbFDPEX1h0G2Sb2C++Dx/KzCSaLbiiyOhdQIZF0O8iBTHwlWZr3Ekal9
TjEOSR/cLQNpQCSKzyHB0L3gNFUMWzYt3st7a88IzqPwUXm3hmo=
=Dwgm
-----END PGP SIGNATURE-----

--nSQp8DZZn7gZbDHt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
