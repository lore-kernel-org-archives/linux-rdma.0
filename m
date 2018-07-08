From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net v2] net/mlx5: fix uaccess beyond "count" in debugfs
 read/write handlers
Date: Sun, 8 Jul 2018 09:51:13 +0300
Message-ID: <20180708065113.GJ3014@mtr-leonro.mtl.com>
References: <20180706201809.105152-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Do9hQ/bfCb4zBpLo"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706201809.105152-1-jannh@google.com>
Sender: netdev-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Do9hQ/bfCb4zBpLo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2018 at 10:18:09PM +0200, Jann Horn wrote:
> In general, accessing userspace memory beyond the length of the supplied
> buffer in VFS read/write handlers can lead to both kernel memory corruption
> (via kernel_read()/kernel_write(), which can e.g. be triggered via
> sys_splice()) and privilege escalation inside userspace.
>
> In this case, the affected files are in debugfs (and should therefore only
> be accessible to root) and check that *pos is zero (which prevents the
> sys_splice() trick). Therefore, this is not a security fix, but rather a
> small cleanup.
>
> For the read handlers, fix it by using simple_read_from_buffer() instead of
> custom logic.
> For the write handler, add a check.
>
> changed in v2:
>  - also fix dbg_write()
>

Thanks Jann,

Next time, please don't put changelog in commit message.

Saeed, are you taking it to mlx5-next? It is cleanup and better to be
sent to -next.

> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 28 +++++--------------
>  .../net/ethernet/mellanox/mlx5/core/debugfs.c | 22 ++-------------
>  2 files changed, 9 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--Do9hQ/bfCb4zBpLo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbQbRhAAoJEORje4g2clinu1YP/AvI1s90yyjOwS/8ver6jaFc
7yPyBd1GBoUlRYWVf32siFaBwnPfPOS+pJtovsW66+Lxj0LqYniwPQ68GW8UkkGZ
tf9g8CvAm4mjAOgaJZiR3JB0kArvAeY2hRgyNu7iItp0AeL9WJH0RZONueBCCoqD
jTRW6oB1GsNnCfzbSnrt0ecQTVCidATIfmC5WsSImnkDgXBO4kLM7XZBbZvgmhIv
BoISxh8m7U7iGENTVpY9MdtrRTd7MbH+7eR6z0nGD6FeN/mjkAqjDGq1+Sr1bPBi
z/8Irbi6OXANufG8YNNoXeccoawAWYGpaZCc3VFpYYdrZgFuxnCdSAVXphDmf+6J
X+xeuhZpwjLbcXN6YwT5ZT4mPFDFdyB4o8sJFHrrPHPn0wxtILh0FP8c3H8mak+/
WinknsmOeJpw6pH1hAS3Tk7wRP+2SJ7M565o54G4wRmLxtUhaMG9a75VlzkCmgmP
hT60nwXZb8355FKZjQXZm+ELd2aHfOgIVcsNoA5Ly8h+Qhuch0AXP0eo3sv0qoGW
7Sstx8IbMM9FiMn6sT3I8/Rmcs7bfiXs1fHSC5wZC/cOUmBEhdcH+Oz97N8KDkKn
RdYWtOVnGlUc+DY/9WFtgEwN0m283iO4gAcsipa0vls9fRmP1rgMi0smieIrAsYD
A3GACI8rle0ItZ27XT/W
=mzoB
-----END PGP SIGNATURE-----

--Do9hQ/bfCb4zBpLo--
