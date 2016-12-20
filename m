From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/qib: use rb_entry()
Date: Tue, 20 Dec 2016 16:21:27 +0200
Message-ID: <20161220142127.GZ1074@mtr-leonro.local>
References: <ddabc96c798df194791134d8e070d728e2a7b59f.1482203698.git.geliangtang@gmail.com>
 <b3d122a5a5a74579c4854cde74974e2cbc140be0.1482203536.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9Wosya/OiUJZ+2ov"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b3d122a5a5a74579c4854cde74974e2cbc140be0.1482203536.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--9Wosya/OiUJZ+2ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 20, 2016 at 10:02:12PM +0800, Geliang Tang wrote:
> To make the code clearer, use rb_entry() instead of container_of() to
> deal with rbtree.
>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  drivers/infiniband/hw/qib/qib_user_sdma.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

> diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
> index 3e0677c..926f3c8 100644
> --- a/drivers/infiniband/hw/qib/qib_user_sdma.c
> +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> @@ -144,8 +144,8 @@ qib_user_sdma_rb_search(struct rb_root *root, pid_t pid)
>  	struct rb_node *node = root->rb_node;
>
>  	while (node) {
> -		sdma_rb_node = container_of(node,
> -			struct qib_user_sdma_rb_node, node);
> +		sdma_rb_node = rb_entry(node, struct qib_user_sdma_rb_node,
> +					node);
>  		if (pid < sdma_rb_node->pid)
>  			node = node->rb_left;
>  		else if (pid > sdma_rb_node->pid)
> @@ -164,7 +164,7 @@ qib_user_sdma_rb_insert(struct rb_root *root, struct qib_user_sdma_rb_node *new)
>  	struct qib_user_sdma_rb_node *got;
>
>  	while (*node) {
> -		got = container_of(*node, struct qib_user_sdma_rb_node, node);
> +		got = rb_entry(*node, struct qib_user_sdma_rb_node, node);
>  		parent = *node;
>  		if (new->pid < got->pid)
>  			node = &((*node)->rb_left);
> --
> 2.9.3
>

--9Wosya/OiUJZ+2ov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhZPmcACgkQ5GN7iDZy
WKfNPg/9GPsobAQ7sPc2zGcCFO+GRo64pFRas81AQoq53GD5p9esgERio/DX/Keb
phAvTunxyYEC3IsciQ9VxRydIpwEmNj6yMUcNJeVJhUtB5D7/gymGK/8uS+oB2/2
ThIJGcFTgP0cExPnbUEfv/yIVF1ABaoFCAeBIXtNp5ItAV/JGTs1dU2Bon54oNWS
k31whW9vBE3e/Hos/nUEoNE9n6I+7TbgAJMOjYdceuXjSevC01t7mSyewu2S0+xj
iZI7uiR88+Jl0O50iiDfFBAFUoktVNiZUclEJngiU1p7rQEgib6treiQdz1fa4V1
GKuNMVo/AYCZXrDlVQMd/Hcn3TB8sr5E8orb64FdyqvG8sYjbnVF6Edl4FtPHSAl
Q26Gxo6LDiy0YjG6zlg8wHaojTEANaqMn7MaBRjmxSr+w1Zj6kRg8LN0ZjHJ+F17
zrwieEVEI3EinjCcPNJHrvGFu0bEMJgb1XAu4smENOXrZARc+6t2kWxdQG0x163i
l2a80Wd0n+P2pYCT9ARa3IsvI4tkaFya+KkMOre6VPoom9rshwy2yiZx9kAkqwnl
muk7ZuXM8HJEIBGe+Mj+9bBw3IjIEzSSBoSepXUboEdkPafaTVL9MuGqaBXvmUAV
c6WUxGaPl82jQcHKUiPjj7axIvbKWknF+pvkrGTMPME7N6dTBmU=
=xA8k
-----END PGP SIGNATURE-----

--9Wosya/OiUJZ+2ov--
