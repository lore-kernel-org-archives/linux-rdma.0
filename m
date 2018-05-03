From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/umem: use tgid instead of pid in ib_umem structure
Date: Thu, 3 May 2018 21:12:35 +0300
Message-ID: <20180503181235.GB4473@mtr-leonro.local>
References: <1525356274-736-1-git-send-email-lidongchen@tencent.com>
 <20180503153310.GA9738@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180503153310.GA9738@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lidong Chen <jemmy858585@gmail.com>, dledford@redhat.com, akpm@linux-foundation.org, qing.huang@oracle.com, artemyko@mellanox.com, dan.j.williams@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, adido@mellanox.com, galsha@mellanox.com, aviadye@mellanox.com, Lidong Chen <lidongchen@tencent.com>
List-Id: linux-rdma@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2018 at 09:33:10AM -0600, Jason Gunthorpe wrote:
> On Thu, May 03, 2018 at 10:04:34PM +0800, Lidong Chen wrote:
> > The userspace may invoke ibv_reg_mr and ibv_dereg_mr by different threads.
> > If when ibv_dereg_mr invoke and the thread which invoked ibv_reg_mr has
> > exited, get_pid_task will return NULL, ib_umem_release does not decrease
> > mm->pinned_vm. This patch fixes it by use tgid.
> >
> > Signed-off-by: Lidong Chen <lidongchen@tencent.com>
> > ---
> >  drivers/infiniband/core/umem.c | 12 ++++++------
> >  include/rdma/ib_umem.h         |  2 +-
> >  2 files changed, 7 insertions(+), 7 deletions(-)
>
> Why are we even using a struct pid for this? Does anyone know?
>

Can it be related to "fork" support?

> I'm surprised that struct task isn't held in the struct ib_umem..
>

I think that this code can be removed and all accesses to mm_struct can
be done with "current->mm".

Thanks

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrrUQsACgkQ5GN7iDZy
WKfR1Q/8DLu4PQs5ddrqAwgwm+I8uKnXuhKvgeliiGFgi+uHNP+BUipP6Lq2dxZR
aGjdBRfnHNZ/wWfI5zdE9H6nU4cY5BALpeMUvvr550ck3XGshqiPuuSQCb6b+o9F
+gP4GahIdp/Wipg42rYxplfThIcHdyd1CM3CT3mb5DNUV4kw1ij3YVYcq/lYC6b8
xxMrkR5ta5G6wY2RcPxLW5RlCw3y9Y8V9qG5hXk8J0JIebWI4K0hfhLgIkSlLxk2
RB6yyqQ1pwUyL6YU8MdBimbdPduI/T69bg32VijeISxmdMrCuoW75L1Wlu8Ttpg+
jcsFWJby331+DWwAMBDafRg2gCewM8qsIlhygUA42fKChnj1ZFMRefsPtysCm/5H
7h/VejPhhQyJUW6GD4/lTGBd865PQEBe9hcXy9zOOXoGDwGzXGmzJwugSPEgEbCs
CNqMgTiVRLy2XD/B9v6P8iR2VewdhfF7X4vKwtLUCpwwSbtncAwPmniWdZ4/EsMG
JukAmEnv2C309KJX0lIFzwldG4n2fHNYlkJSsHCjdBZ5ryCXXhH2V+XDv8wZNorx
vy3GERitHqp8ZWaK+WEIcw+i3XjdVXiQ+EHuHf3jlB5Rj2WAY9u7frTxOqfPVBxY
aE0SGN4Q/pFoskUaWlK/HyK4Fp98tzwtfJ4vC+cFtBh/h7UlxX0=
=Qew0
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
