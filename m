From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/umem: use tgid instead of pid in ib_umem structure
Date: Thu, 3 May 2018 21:43:01 +0300
Message-ID: <20180503184301.GD4473@mtr-leonro.local>
References: <1525356274-736-1-git-send-email-lidongchen@tencent.com>
 <20180503153310.GA9738@ziepe.ca>
 <20180503181235.GB4473@mtr-leonro.local>
 <20180503182656.GB14956@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180503182656.GB14956@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lidong Chen <jemmy858585@gmail.com>, dledford@redhat.com, akpm@linux-foundation.org, qing.huang@oracle.com, artemyko@mellanox.com, dan.j.williams@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, adido@mellanox.com, galsha@mellanox.com, aviadye@mellanox.com, Lidong Chen <lidongchen@tencent.com>
List-Id: linux-rdma@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2018 at 12:26:56PM -0600, Jason Gunthorpe wrote:
> On Thu, May 03, 2018 at 09:12:35PM +0300, Leon Romanovsky wrote:
> > On Thu, May 03, 2018 at 09:33:10AM -0600, Jason Gunthorpe wrote:
> > > On Thu, May 03, 2018 at 10:04:34PM +0800, Lidong Chen wrote:
> > > > The userspace may invoke ibv_reg_mr and ibv_dereg_mr by different threads.
> > > > If when ibv_dereg_mr invoke and the thread which invoked ibv_reg_mr has
> > > > exited, get_pid_task will return NULL, ib_umem_release does not decrease
> > > > mm->pinned_vm. This patch fixes it by use tgid.
> > > >
> > > > Signed-off-by: Lidong Chen <lidongchen@tencent.com>
> > > >  drivers/infiniband/core/umem.c | 12 ++++++------
> > > >  include/rdma/ib_umem.h         |  2 +-
> > > >  2 files changed, 7 insertions(+), 7 deletions(-)
> > >
> > > Why are we even using a struct pid for this? Does anyone know?
> > >
> >
> > Can it be related to "fork" support?
>
> Not sure..
>
> Ideally we want to hold the struct mm, but we can't hold it long
> term, so pid is a surrogate for that.
>
> > > I'm surprised that struct task isn't held in the struct ib_umem..
> > >
> >
> > I think that this code can be removed and all accesses to mm_struct can
> > be done with "current->mm".
>
> That sounds wrong for fork support, as the mm used in destroy MUST
> exactly match the mm used in create..
>
> How does this accounting work in fork anyhow?

We are not supporting fork, so this is why I proposed to remove it.

Thanks

>
> Jason

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrrWDUACgkQ5GN7iDZy
WKf4sw//c7zy4xf0dcdK6BLTm21txkqjxdQ15RBej3Il0DRP0WrALvXQrSwdx+zK
0BdcLcY6jCnsLEeDLbttp6H2uPgx6vXH64B7rJjKBWquw5ry0dPs5fEFCbNljSyK
wMHzstFh5E+SU/Nd6Y3kBFyyFVoje8bpry4sQR4+8dv6+ynEs0hM0Biw2d9o2yIi
fPIdxJLDJr0p6BouW7QfvV1QYdLYWgDu4o5MUk/FLIt70Fb20cldOrsz8RXsBXss
EOPl/ZFbfQMWj1srqd+TWFn+ZcmkMwsMioHjceSdy2Gl0HmuRrZBidxYdO/xVr9H
7hiRKHVsDK1l5AggI22DqnE4JO0KpFWXatzgCiOlpk/mof7fVmaOvY9dHNDZIEQO
io8Wn9VufL9afs2+2q/DvY5sloWDBFExVdYG8bh4C6t0naw30/l9fxcK0w1fZedL
XvtDHQJxgxgqrle36VQrN2lJQENSMUCAHK+HbzeKflLDlM1YfUvPWAu/2EW9OISk
InZeKzvWXgtjDu722wUgQ/d7QYiQJnCxqWciknlAi7hOBN++FqLlBiFAS4Sho+gx
iFId3QACZnrmBc1goyEipJRGMBVNlIe5a6XPVASIHqcZ9mbxofxlKiYBeLA+3bjU
UZQWztUzL9udAPUhpMGnxaLFx+q41r1NzqXku0qUonCaFjrVG0U=
=ztQs
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
