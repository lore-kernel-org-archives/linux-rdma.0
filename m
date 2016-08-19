From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH 16/22] IB/mlx4: Remove deprecated
 create_singlethread_workqueue
Date: Fri, 19 Aug 2016 18:43:15 +0300
Message-ID: <20160819154315.GD18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
 <0fd56271e4fd6518141f3af078c0f16c8107711f.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0fd56271e4fd6518141f3af078c0f16c8107711f.1471283717.git.bhaktipriya96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Chuck Lever <chuck.lever@oracle.com>, Mark Bloch <markb@mellanox.com>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Florian Westphal <fw@strlen.de>, Guy Shapiro <guysh@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Matan Barak <matanb@mellanox.com>, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2016 at 11:42:48PM +0530, Bhaktipriya Shridhar wrote:
> alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
> deprecated create_singlethread_workqueue(). This is the identity
> conversion.
>=20
> The workqueue "wq" queues work items &dm[i]->work, &ew->work.
> It has been identity converted.
>=20
> WQ_MEM_RECLAIM has been set to ensure forward progress under
> memory pressure.
>=20
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtykTAAoJEORje4g2clinR3UP/2NCPolPnEToG0zdouSz1twR
J9P/HlwFfr4gvJuBZNo0CGtI2PkXdZyQNwAj6f1YL8IrCRwhBQdZH1a68Di3FooL
A2McneafTQBNAOVwZVj/j5+jNGcXa68JKBmuyidRiaJcf18zbozrztfThQI8Bm6f
80+t2xyHhusBIR3X9qsFjl/SvSulnF16Vdvhj7X8pTuNoSovq5DNHPA6zt85RKMv
QPTtq6UeLOqL/4gt11pL4faM9+5sFJ3dfU0UXW9lOtzAuwd+afANmtH6+N3O3bN5
CDkukNRi+gdXvuz7yzzz2bcKXzhOreTIxhWIkTHM9+MheirBZnecY/ixglOwauou
6n47t2z+i3swT/1siPJsCkw9yfRj2CVOSh00FhwAvU8J8KQqkE2iTnMwuoiiBAw8
D3G6kUHGTvNb18MnU0C1sljzVsa6cR+ICYQgk2Fq2mnWFLDtds8C89lQULSuaXyV
Xs37G8eTVmr2cSRmZt0Nyr1RSlinm19CE/cf9Tk7XSCwKrkpu6MvTxBJXqyA+fjN
pKCSRqrSZxzXnjSXzLvZg9Ps/KQkeHJjnCkHiIziNHu58GkOwfsty4Hl67B7L5sC
IJj3I0Crk0Q24GgEtp7hbxE4Uu0/o5q18Z9PKamDMVW1J06TllZ6oWMuvL/bRPoT
RjVNu5Mo3J/NcC23cqfP
=6Q6m
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
