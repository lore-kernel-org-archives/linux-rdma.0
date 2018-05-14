From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] net/mlx4_core: Fix error handling in
 mlx4_init_port_info.
Date: Mon, 14 May 2018 09:21:09 +0300
Message-ID: <20180514062109.GK10381@mtr-leonro.mtl.com>
References: <20180513233845.135290-1-tarick@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180513233845.135290-1-tarick@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tarick Bedeir <tarick@google.com>
Cc: tariqt@mellanox.com, gthelen@google.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 13, 2018 at 04:38:45PM -0700, Tarick Bedeir wrote:
> Avoid exiting the function with a lingering sysfs file (if the first
> call to device_create_file() fails while the second succeeds), and avoid
> calling devlink_port_unregister() twice.
>
> In other words, either mlx4_init_port_info() succeeds and returns zero, or
> it fails, returns non-zero, and requires no cleanup.
>
> Fixes: 096335b3f983 ("mlx4_core: Allow dynamic MTU configuration for IB
> ports")

Please don't break "Fixes" lines, it complicates "grep".

IMHO, general cleanup exit point is needed in this function (goto ...),
but your fix is good enough too. Thanks for doing it.

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJa+SrVAAoJEORje4g2clinP+0P/2WCHSxqo1z6MnkYwbN24ix9
hPxeRmGlfBBAIEVt54BFI248Y2pxeOpRmtct1SktOeidkR2sqfIvTwGuuUBq8Iw9
gun9qfwgWXciGYNl/VR4udy65dwcd/YuRoeYbvpvFm3/7zYKZXKoXl1vEp9CvT0t
Lo2MEiaSjTUSo9wzzJBfvppeqsoI+h5vOx+zmsHjm2b3CjuikiqQ5/wBT410glx1
0EV5EY0Z0zfQROarzJViL2nn3Zeoai9VFfrVh2ujcZ9yOjF/K/GyO3ovE/h1DuhD
3GiMPEh7s1Ua1w8x1VyIf7oRZkIOSRpOvc1vclwF8sMD4eIwxtTpLs/DaaNB4lCi
YU3/hOfwfL3kAne79MTaK6PJPh3zVoeBFhwlu1xIkXR5D3VbmGnzU94iU7hzRiEN
90+majc6aurhetVzUN0NxSXTaRagOZ7Ae2vmCchHxSTczNe/8e1pGNOwef4h7HH6
QKQ5OHldp10A9s1tDh+wr2xt5VZsL1GKNfRVDXH/0H4nnBOyIopOkVtVbnSNUvYr
WW78FSCFIsDPRH9kcJf/XFzhusY+9Ev4z6+lJbQoRfR0uOGEMtttJfIIIgEfuW1b
W4AjihHqMeacQXOXRSevTtTnmpXJZm9rGd8kDZ1BqiCJo5PH+8Vl8uMQs8L9Tim+
/8CQJ23NPZwyqyccy4xj
=7qEX
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
