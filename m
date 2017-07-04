From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] ConnectX-3 RSS Implementation
Date: Tue, 4 Jul 2017 16:24:06 +0300
Message-ID: <20170704132406.GJ1528@mtr-leonro.local>
References: <20170622134412.7680-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s5/bjXLgkIwAv6Hi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170622134412.7680-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--s5/bjXLgkIwAv6Hi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 22, 2017 at 04:44:08PM +0300, Leon Romanovsky wrote:
> Hi Doug,
>
> This patch set adds to ConnectX-3 devices the ability to use RSS
> feature, which was initially implemented in mlx5-based devices [1].
>
> The backport of RSS feature to ConnectX-3 hardware was a challenge
> task due to differences in architectures between mlx4 and mlx5 based
> devices.
>
> It caused to a limited number of usage limitations, mentioned in the relevant
> commit messages where it applies.
>
> This series supports all RSS related verbs.
>
> Thanks.
>
> [1] https://www.spinics.net/lists/linux-rdma/msg36526.html
>
> ---
> We based this series on our previous mlx4 submissions to reduce merge conflicts.
> For your convenience, I prepared the branch with the following merge sequence:
> "topic/no-io" -> "topic/mlx4-resource-utilization" -> "topic/mlx4-receive-inline"
>
> Available in the "topic/mlx4-rss" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/mlx4-rss
>
> Thanks
>
> Guy Levi (4):
>   IB/mlx4: Add support for WQ related verbs
>   IB/mlx4: Add support for WQ indirection table related verbs
>   IB/mlx4: Add support for RSS QP
>   IB/mlx4: Expose RSS capabilities
>
>  drivers/infiniband/hw/mlx4/main.c    |  51 ++
>  drivers/infiniband/hw/mlx4/mlx4_ib.h |  32 +-
>  drivers/infiniband/hw/mlx4/qp.c      | 907 ++++++++++++++++++++++++++++++++---
>  include/uapi/rdma/mlx4-abi.h         |  49 ++
>  4 files changed, 975 insertions(+), 64 deletions(-)
>
> --

Please drop this series in favor of v1.

Thanks

--s5/bjXLgkIwAv6Hi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllblvYACgkQ5GN7iDZy
WKfZExAAqB2VAR3Frdi3kGKqx36C8v1ZXOEJNi9mOSnH2rqPA6+p3QWU1l2duDTw
ocCGowH3h2cXjkZTGi3a/UP1Gm145h8m0wrIPU54ofdXaeFC8KOvK53oUy4PU2Mp
zxP6e6D0UvBpKqGR/Ix3iPyRwXIizHVcGFfto/yT8BJRu9ICE5cdg+c4CwduiMbn
waddRRtIsdt3ATRXQs9I2O9YzCmrXC/Qj4G3tZwPGXjG3NOZ16xPp1jsJdGBrvcc
lIiDdPEdT76tlWipXlwmkBfmKgHkVa7cj6vfvihoQmHijxYh3MISkP87I3mWTm8Q
tJ9zxN2R/SGXpmpSeQvvIQhdnkgB1tnWZjWE5wSanckrX9jz6XIqm9uDgMUBqvEf
AHu1W0td2t5rAIxILbEobIZyoOZg3AyyfrFwaTORx5ymxkQKedTt3H8eWEuySm37
FyfHHLV4q1vpeUh57KfLMObWbXv26hw94rNkz8ZRj6/pn0VkI9lvg1ItwVIgSxK1
myc757MTO1vEnImAj6Doat3/VUNxZBapBvgm/QNGJ4P7bl4KoRJnUcbIa/u1VObY
VY+o7oZn0f2iX3SFS3JSy8c20kx+/yGQZ/mb2Va4qHfjwr2CIb73chrNcQB5vNhw
y8VCqoDmt7dZJ719spyT2N0BGGq6QS8/AT6DKLZBiqvsJnhRvIg=
=xTIE
-----END PGP SIGNATURE-----

--s5/bjXLgkIwAv6Hi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
