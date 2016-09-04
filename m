From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/9] RDMA fixes for 4.8
Date: Sun, 4 Sep 2016 11:27:14 +0300
Message-ID: <20160904082714.GM21847@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <d5eff78f-0014-e748-11c9-888c70542391@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BjavXC7V3ilNTWHC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d5eff78f-0014-e748-11c9-888c70542391-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BjavXC7V3ilNTWHC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 02, 2016 at 02:13:27PM -0400, Doug Ledford wrote:
> On 8/28/2016 3:58 AM, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > This is compilation of fixes to RDMA core, IPoIB, Mellanox mlx4
> > and mlx5 drivers all together. Most of the fixes are one liners and
> > for easy handling, I'm sending them in one patchset.
> >
> > Thanks
> >
> > Chuck Lever (1):
> >   IB/mlx5: Return EINVAL when caller specifies too many SGEs
> >
> > Erez Shitrit (2):
> >   IB/core: Fix use after free in send_leave function
> >   IB/ipoib: Fix memory corruption during ipoib cm connection
> >     establishment
> >
> > Leon Romanovsky (5):
> >   Revert "IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one"
> >   IB/mlx4: Don't return errors from poll_cq
> >   IB/mlx5: Simplify code by removing return variable
> >   IB/mlx5: Add VERBOSITY Kconfig option
> >   IB/mlx5: Don't return errors from poll_cq
> >
> > Yishai Hadas (1):
> >   IB/mlx5: Use TIR number based on selector
> >
> >  drivers/infiniband/core/multicast.c       | 13 ++-----------
> >  drivers/infiniband/hw/mlx4/cq.c           | 26 ++------------------------
> >  drivers/infiniband/hw/mlx5/Kconfig        |  6 ++++++
> >  drivers/infiniband/hw/mlx5/cq.c           | 22 ++--------------------
> >  drivers/infiniband/hw/mlx5/main.c         |  6 +++++-
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h      |  1 +
> >  drivers/infiniband/hw/mlx5/qp.c           | 15 ++++++---------
> >  drivers/infiniband/ulp/ipoib/ipoib.h      |  1 +
> >  drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 16 ++++++++++++++++
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
> >  10 files changed, 42 insertions(+), 66 deletions(-)
>
> I took everything except patch 7.  That one had to go.  It would take a
> very strong argument about why that needs a Kconfig option instead of a
> runtime config switch to make me change my mind.

Thanks,
I responded to that thread.

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--BjavXC7V3ilNTWHC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXy9riAAoJEORje4g2clinFOoP/27ACLNxgWEw4jDdWynGw5uO
vH62T+UYgoGZkPRQxZp/ICtZYTzYcBHjhgEitItnJbIEUwDNDhE/EA28QqWCnSU6
Bx8LqpxUplQavhgyrh2pSs4R7KAGINud3LGD4dDNsaqgcp07SOHjr/rXIy4mODkA
2Rk8+2sde2uNGNDt2eAX3drjqsp4NfesryO316i5OCZMVHGbg2TfI0x9LUr6/Ymb
LyNdodeaaI4+SGGbZp4+G7Mkcfy6NgX7p1VTR4IqMTSz5NlpXZ6Sf6Y8RzEE1eN3
kgchoueN3Of0o6zm49DYPRhx6d5eZQd1ZFBdZE4ivsqLYiTPF4FXkkX/nQvqnPNI
ggkh8YNfAhem/hX4Tk8F3Ksa1PneMkKl2HmnNmxpyPBfuTsmEsrEwZM/kxEWjInP
z5CqxWcjvw/6bd3xEvpCGE+raOFyxxSMGmKeG47lgBvuXCw+Ks6Lj4u7qPZjbzm/
QNwhIuPWneU0iEnYRu/jmix+v2Y45q7c26HwJqLRc5dh5Wxslp13SqpDZBu+lTWt
xlgWido8Pn6+bqnmQ6uk+wHUgtjLB2UkRl3wJCAWMVVEr/Roy8V8dulo+DnBYGcQ
K1etyMqGkDFBArL2lEf8aFnwR5URc6g58r5kMcXEDvmEZ4XC+VCqLn36TVpA7m7d
SJI/hsVqp8uVfNxJY53E
=UYUs
-----END PGP SIGNATURE-----

--BjavXC7V3ilNTWHC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
