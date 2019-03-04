From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH][next] net/mlx5e: Remove redundant assignment
Date: Mon, 4 Mar 2019 08:26:45 +0200
Message-ID: <20190304062645.GZ15253@mtr-leonro.mtl.com>
References: <20190302193933.GA13467@embeddedor.com>
 <da1f1300-20f4-2929-078b-71ac1772a933@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9r3HF47jptiQlX4s"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <da1f1300-20f4-2929-078b-71ac1772a933@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roi Dayan <roid@mellanox.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Eli Britstein <elibr@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--9r3HF47jptiQlX4s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 03, 2019 at 03:20:57PM +0000, Roi Dayan wrote:
>
>
> On 02/03/2019 21:39, Gustavo A. R. Silva wrote:
> > Remove redundant assignment to tun_entropy->enabled.
> >
> > Addesses-Coverity-ID: 1477328 ("Unused value")
> > Fixes: 97417f6182f8 ("net/mlx5e: Fix GRE key by controlling port tunnel entropy calculation")
>
> the commit doesn't fix any real issue but is more of a cleanup.
> so I'm not sure if fixes line is relevant or not.
> beside that looks ok.

It doesn't matter if it is real issue or not, the code is wrong and
should be fixed. This alone is enough to see the Fixes line.

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--9r3HF47jptiQlX4s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcfMUlAAoJEORje4g2clinGywP/0ZpFYeue+bt8fx34KHJ8tyF
bpIcORNXSGq00bKlxkQzVcXWxUl8PsWDpYjfnGVX3dq1GypbNkRcqIW8hWxvfyYR
YmCTEsFFts1CguikXedcKIfBKg8dHWu4FZi2qzbAvn4nzdx/fUUK/1mu/P+3S+Gx
lDaChHQn83cR7Raik28S8ArJZLbSqebaZyYL+DkG6r1NE8to6EzTmdL/V6f9Z79W
DjZNbjJQ7ktZ0iHkPcSDDuPJadgAk6dViSiE4oYT8ZLGFo1v9Wj4S4BJiAkPlU1I
UAI+fGx4TpKYijDZqcNCIDyM2F0PlZqQmk/4Bb9bfgJP0ZE9kEumIq7oHydumgfl
C71HWwNnGXCbOYuk9xO5QSIIemn8fiOnWbQceckHIK9e39aKfFjp0io+rQ/JvMRP
2gXHig1hZ+soFSKhVXP8uM9n0D83JMDMWR9drcO7w1hvSrXE5EhzmfQ0uEopaYpA
H+4vSv6i8cnTNaYpSLF0aN6On+MzHXOwLs6eLRRtPqbSjJbA5Ul9GhQ/ZWq7w7u9
91wGT6PbwcfGQkP2RRATahTw5CjLSZ53r5FUS4VKmj+IlI4c0GaQUhnN7vKBDz8f
+V/iaXJyeiDxNZK7EGSMK7aNC+l50AXfmA9oKgrQL+A4vBeUKBFoZeBYCtIiAWiV
+gu47+oFj1mntPV+xdxK
=aGGP
-----END PGP SIGNATURE-----

--9r3HF47jptiQlX4s--
