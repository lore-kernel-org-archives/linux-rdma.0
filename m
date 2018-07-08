From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] IB/mlx5: fix uaccess beyond "count" in debugfs
 read/write handlers
Date: Sun, 8 Jul 2018 09:56:23 +0300
Message-ID: <20180708065623.GK3014@mtr-leonro.mtl.com>
References: <20180706204803.131152-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="olLTNZSltDMg5Vbm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180706204803.131152-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--olLTNZSltDMg5Vbm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2018 at 10:48:03PM +0200, Jann Horn wrote:
> In general, accessing userspace memory beyond the length of the supplied
> buffer in VFS read/write handlers can lead to both kernel memory corruption
> (via kernel_read()/kernel_write(), which can e.g. be triggered via
> sys_splice()) and privilege escalation inside userspace.
>
> In this case, the affected files are in debugfs (and should therefore only
> be accessible to root), and the read handlers check that *pos is zero
> (meaning that at least sys_splice() can't trigger kernel memory
> corruption). Because of the root requirement, this is not a security fix,
> but rather a cleanup.
>
> For the read handlers, fix it by using simple_read_from_buffer() instead of
> custom logic. Add min() calls to the write handlers.
>
> changed in v2:
>  - also fix write handlers

No changelog in commit messages, please

>
> Fixes: 4a2da0b8c078 ("IB/mlx5: Add debug control parameters for congestion control")
> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  drivers/infiniband/hw/mlx5/cong.c |  9 +--------
>  drivers/infiniband/hw/mlx5/mr.c   | 32 ++++++++-----------------------
>  2 files changed, 9 insertions(+), 32 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--olLTNZSltDMg5Vbm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbQbWXAAoJEORje4g2clinPx8P/jNfA93fdBWfoorvH4XIZ2il
JSvBy/KhuY2DjlzWz+NQHmyYBlvFvd/zSz4AANYbsUOAdKwVsIqRqJE3JV2MjrpZ
pgaETsx+z4747a9m8OSBj63dhQ048GufMj7Ml9td5h5XK5ShzcfunanhNodJ5V+0
Rvo/4I4LVx6Yz8lVsPTUz+vRqpXh3zO8CQU4Xh4QzxUoN26ksCUJ/i53gtnvWXO/
ssg+9d1NxSVexJ6Eqg1nYOPqUk+mMMQ00ysUsKQGrrf4SfT1gDsbA3yLv4LkrLIe
kElL7FzuTRuWrvlHe5DH8CzBBBwFCkfzRBfZK4OXIbYiDxc1LL6jkWe+jULhjeBq
fOULh6m8QFdB2LBaZAvFcwhITVh+NxrZCC0PqgZ8lWvw8Fn/RAOWcsshe6nEstym
f0BKrQjp0iAxj8SxajVKsi9Fjhb4AnjAbq24ewsGEXwVe8x9INKkULOh0fMMEf2E
bKWTq+LCxFTPIRJ5+qry29Qezz/YA8YtuKKMGUeC6e5M365HXw47NYJrPEL1Liv2
/dpiv8nRsF3tKqG7UhpqRbCINaOqboEGjGR0bmx5JW9iIa3DDm+0CzOt9jUjicPb
/m9LsSyS2inI5ZZErxRXT92Yq9deiKX5OtyxpNwIEqftAGmSrtVY0cBhvBJTIU9h
17YwCVB4TagZ4k7woMhA
=Tw9m
-----END PGP SIGNATURE-----

--olLTNZSltDMg5Vbm--
