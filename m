From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [pull request][rdma-next v1 REPOST 00/10] Hardware tag matching
 support
Date: Sun, 27 Aug 2017 09:08:39 +0300
Message-ID: <20170827060839.GO1724@mtr-leonro.local>
References: <20170817125212.3173-1-leon@kernel.org>
 <1503604595.78641.39.camel@redhat.com>
 <1503605434.78641.41.camel@redhat.com>
 <1503608030.78641.57.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="A/2QVx3Okwt4+LIK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503608030.78641.57.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--A/2QVx3Okwt4+LIK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 24, 2017 at 04:53:50PM -0400, Doug Ledford wrote:
> On Thu, 2017-08-24 at 16:10 -0400, Doug Ledford wrote:
> > On Thu, 2017-08-24 at 15:56 -0400, Doug Ledford wrote:
> > > On Thu, 2017-08-17 at 15:52 +0300, Leon Romanovsky wrote:
> > > > This patch series adds to Mellanox ConnectX HCA driver support of
> > > > tag matching. It introduces new hardware object eXtended shared
> > > > Receive
> > > > Queue (XRQ), which follows SRQ semantics with addition of
> > > > extended
> > > > receive buffers topologies and offloads.
> > > >
> > > > This series adds tag matching topology and rendezvouz offload.
> > > >
> > > > Changelog:
> > > > v0->v1:
> > > >  * Rebased version, no change
> > > > RFC->v0:
> > > >  * Followed after RFC posted on the ML and OFVWG discussions
> > > >  * Implements agreed verbs interface
> > > >  * Rebased on top of latest version
> > > >  * Adding feature description under Documentaion/infiniband
> > > >  * In struct ib_srq_init_attr moved CQ outside XRC inner struct.
> > > >  * Added max size of the information passed after the RNDV header
> > > >  * Added hca_sq_owner HW flag for RNDV QPs
> > > >
> > > > Thanks
> > >
> > > I know in the previous thread on this submission that you thought
> > > it
> > > didn't need the shared pull request, but I'm seeing this when I try
> > > to
> > > build after pulling this patch series in:
> > > In file included from ./include/linux/mlx5/driver.h:49:0,
> > >                  from ./include/linux/mlx5/fs.h:36,
> > >                  from drivers/infiniband/hw/mlx5/qp.c:37:
> > > drivers/infiniband/hw/mlx5/qp.c: In function =E2=80=98create_qp_commo=
n=E2=80=99:
> > > drivers/infiniband/hw/mlx5/qp.c:1734:6: error:
> > > =E2=80=98MLX5_QPC_OFFLOAD_TYPE_RNDV=E2=80=99 undeclared (first use in=
 this
> > > function);
> > > did you mean =E2=80=98MLX5_XRQC_OFFLOAD_RNDV=E2=80=99?
> > >       MLX5_QPC_OFFLOAD_TYPE_RNDV);
> >
> > Nevermind.  This is an ordering issue.  I took this before your 24
> > patch series and I think that is the source of the problem.
>
> Nope, that didn't fix it either.  Maybe it needs one of your other
> patchsets?  I also tried it on the shared code base an it fails to
> build there in the same way.

I found the issue, in my "REPOST", I missed one patch, don't know how it
happened, but it is clearly my fault. Sorry about that.

Original pull request - 11 patches:
[pull request][rdma-next v1 00/11] Hardware tag matching support
https://www.spinics.net/lists/linux-rdma/msg53357.html

Repost of that pull request, which is supposed to be the same - 10 patches:
[pull request][rdma-next v1 REPOST 00/10] Hardware tag matching support
http://www.spinics.net/lists/linux-rdma/msg53522.html

The =E2=80=98MLX5_QPC_OFFLOAD_TYPE_RNDV=E2=80=99 is declared in first patch=
 "net/mlx5:
Update HW layout definitions" of this series, and the shared code was
prepared on clean v4.13-rc4 tag.

The failures that you are experiencing is due to miss of first patch:
 * b7a79bc53ce8 - net/mlx5: Update HW layout definitions (10 days ago)

See the difference between the mellanox-shared branch and my tag.

=E2=9E=9C  linux-rdma git:(rdma-next) git l grdma/mellanox-shared
6bb33a5770aa (grdma/mellanox-shared) Documentation: Hardware tag matching
380529f2a59b IB/mlx5: Support IB_SRQT_TM
98d90bfb6e58 net/mlx5: Add XRQ support
aa0d027930d6 IB/mlx5: Fill XRQ capabilities
5d7ef472505a IB/uverbs: Expose XRQ capabilities
6061811b8759 IB/uverbs: Add new SRQ type IB_SRQT_TM
2d87bd3ae6f0 IB/uverbs: Add XRQ creation parameter to UAPI
633b67ed6758 IB/core: Add new SRQ type IB_SRQT_TM
e190f28d0630 IB/core: Separate CQ handle in SRQ context
8f3d761c09f6 IB/core: Add XRQ capabilities
f336076a90bb Merge tag 'mlx5-shared-2017-08-07' of git://git.kernel.org/pub=
/scm/linux/kernel/git/mellanox/linux into k.o/mellanox

=E2=9E=9C  linux-rdma git:(rdma-next) git pl --graph rdma-next-2017-08-17-1
* 89f4e752bf80 - (tag: rdma-next-2017-08-17-1) Documentation: Hardware tag =
matching (10 days ago)
* a6eb9232179a - IB/mlx5: Support IB_SRQT_TM (10 days ago)
* 7173547b6e90 - net/mlx5: Add XRQ support (10 days ago)
* 3d88f302a3fd - IB/mlx5: Fill XRQ capabilities (10 days ago)
* 216c76559abb - IB/uverbs: Expose XRQ capabilities (10 days ago)
* 9cff356f28d8 - IB/uverbs: Add new SRQ type IB_SRQT_TM (10 days ago)
* 50a9896131e6 - IB/uverbs: Add XRQ creation parameter to UAPI (10 days ago)
* 25b0c9ac0cf0 - IB/core: Add new SRQ type IB_SRQT_TM (10 days ago)
* a4f8b0bc8a67 - IB/core: Separate CQ handle in SRQ context (10 days ago)
* 1dee69e16539 - IB/core: Add XRQ capabilities (10 days ago)
* b7a79bc53ce8 - net/mlx5: Update HW layout definitions (10 days ago)
*   c5fa0c255ce4 - Merge tag 'mlx5-shared-2017-08-07' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/mellanox/linux into HEAD (10 days ago)
|\
| * a8ffcc741acb - (tag: mlx5-shared-2017-08-07, ml/topic/mlx5-shared-4.14)=
 net/mlx5: Increase the maximum flow counters supported (3 weeks ago)
| * 61690e09c3b4 - net/mlx5: Fix counter list hardware structure (3 weeks a=
go)
| * 97834eba7c19 - net/mlx5: Delay events till ib registration ends (3 week=
s ago)
| * e80541ecabd5 - net/mlx5: Add CONFIG_MLX5_ESWITCH Kconfig (3 weeks ago)
| * eeb66cdb6826 - net/mlx5: Separate between E-Switch and MPFS (3 weeks ag=
o)
| * a9f7705ffd66 - net/mlx5: Unify vport manager capability check (3 weeks =
ago)
| * 07c9f1e57839 - net/mlx5e: NIC netdev init flow cleanup (3 weeks ago)
| * 706b35834820 - net/mlx5e: Rearrange netdevice ops structures (3 weeks a=
go)
| * aae4e7a8bc44 - (tag: v4.13-rc4, backup/master) Linux 4.13-rc4 (3 weeks =
ago)

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--A/2QVx3Okwt4+LIK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmiYecACgkQ5GN7iDZy
WKcTsg/+KN9FlxE/8HOUa8+QKRFX84KJ0Xvjzytxd7cTYiZZckK4DeCMkfF8A5ij
4WodglwcS1R625o3Io6UycLlQ8uglHfe4Za89rqTH7yF1BCOsEqEE7sX4tlVGFgD
4KpjC6cdwIsBJYdKMwCWjrhXQB+FyaOIjS5EIwSnGHv0WjNCpzOUHfGrEraEZJ95
fs1ZNRXM3QDrO1nrUQN0PW6dZ4zhgnnrCOZ+QYbf19gMtGj+zNgcfNgIZVPBZMuj
E5pDyf5AVoJf0bDYTcysEW6ar3v2nxwu1hJFICQiteVQih8p/PrtQbI8ZBxoNrTh
M1v95V91ERJZBGT68CV7ckmUe1swDP0yhTIW2l0NChhO1KO87aocDO+iw2oRGH76
CUyuDtXu0CiGFGD8NqJjY0KnkeObV4z1Qfnn01GmGLzOyBYWThvU/L0i4FuW0W1z
+oQ/4zQnLEA4puuZi9leKq6zh+DfIbEKSXVy1yZ6DaOvW+Io/g7jqD4py8i8MTDe
sm+Dy9kof2C3LwRwYELUZUERSuVejiX1mhirY5EAiQmOv9Bs0tz8Yn4djQR0S6Yn
yV6isai5tG689t8bE8Qxr5zGHenRq3TymTYEJFCUDP7/6JVlTGybdGtLNPNQEJuV
eqByjiazHsz/Usva0r3bdeWBuMp7E06oBXjPqDgBL/IB8vu37W8=
=n2wn
-----END PGP SIGNATURE-----

--A/2QVx3Okwt4+LIK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
