From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/umem: use tgid instead of pid in ib_umem structure
Date: Fri, 4 May 2018 16:39:29 +0300
Message-ID: <20180504133929.GF4473@mtr-leonro.local>
References: <1525356274-736-1-git-send-email-lidongchen@tencent.com>
 <20180503153310.GA9738@ziepe.ca>
 <20180503181235.GB4473@mtr-leonro.local>
 <20180503182656.GB14956@ziepe.ca>
 <20180503184301.GD4473@mtr-leonro.local>
 <20180503220148.GC14956@ziepe.ca>
 <CAOGPPbfwOHy547d3attGxMW=muRhHGRhxxtnoSDd_SZYu_c3fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOGPPbfwOHy547d3attGxMW=muRhHGRhxxtnoSDd_SZYu_c3fg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 858585 jemmy <jemmy858585@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, dledford@redhat.com, akpm@linux-foundation.org, qing.huang@oracle.com, artemyko@mellanox.com, dan.j.williams@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, adido@mellanox.com, Gal Shachaf <galsha@mellanox.com>, Aviad Yehezkel <aviadye@mellanox.com>, Lidong Chen <lidongchen@tencent.com>
List-Id: linux-rdma@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2018 at 04:32:38PM +0800, 858585 jemmy wrote:
> On Fri, May 4, 2018 at 6:01 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > On Thu, May 03, 2018 at 09:43:01PM +0300, Leon Romanovsky wrote:
> >> On Thu, May 03, 2018 at 12:26:56PM -0600, Jason Gunthorpe wrote:
> >> > On Thu, May 03, 2018 at 09:12:35PM +0300, Leon Romanovsky wrote:
> >> > > On Thu, May 03, 2018 at 09:33:10AM -0600, Jason Gunthorpe wrote:
> >> > > > On Thu, May 03, 2018 at 10:04:34PM +0800, Lidong Chen wrote:
> >> > > > > The userspace may invoke ibv_reg_mr and ibv_dereg_mr by different threads.
> >> > > > > If when ibv_dereg_mr invoke and the thread which invoked ibv_reg_mr has
> >> > > > > exited, get_pid_task will return NULL, ib_umem_release does not decrease
> >> > > > > mm->pinned_vm. This patch fixes it by use tgid.
> >> > > > >
> >> > > > > Signed-off-by: Lidong Chen <lidongchen@tencent.com>
> >> > > > >  drivers/infiniband/core/umem.c | 12 ++++++------
> >> > > > >  include/rdma/ib_umem.h         |  2 +-
> >> > > > >  2 files changed, 7 insertions(+), 7 deletions(-)
> >> > > >
> >> > > > Why are we even using a struct pid for this? Does anyone know?
> >> > > >
> >> > >
> >> > > Can it be related to "fork" support?
> >> >
> >> > Not sure..
> >> >
> >> > Ideally we want to hold the struct mm, but we can't hold it long
> >> > term, so pid is a surrogate for that.
> >> >
> >> > > > I'm surprised that struct task isn't held in the struct ib_umem..
> >> > > >
> >> > >
> >> > > I think that this code can be removed and all accesses to mm_struct can
> >> > > be done with "current->mm".
> >> >
> >> > That sounds wrong for fork support, as the mm used in destroy MUST
> >> > exactly match the mm used in create..
> >> >
> >> > How does this accounting work in fork anyhow?
> >>
> >> We are not supporting fork, so this is why I proposed to remove it.
> >
> > Er, the new kabi certainly can call reg and dereg across a fork
>
> what is the expect behavior after fork?
> I write a test code, the dereg just return EACCES in the child
> process. and have no effect.

Did you do reg/dereg over write() interface? If yes, this is expected
behaviour of "not-supported fork()". A couple of months/years ago, your
test program would work, but we closed this option due to security
constraints.

Thanks

>
> >
> > Jason

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrsYpEACgkQ5GN7iDZy
WKf/JhAAomy9HNZLRJ3JuVjnHS6HOzqPb47MDlJsPBHuzATxG1uA2lphJJTzCkbo
aKkX8bnkO7NkwiJpTtwV8GY9Es3ZeJBlyAOC9Ox+UU+zhFHxfZ49cRSPVGcM2RYV
rmw4yaSSMfvt9Rvgb/mVelqj5OBqQOkbs/JfkXLTxj/hCz832AYTsdMAhdOWcV4Z
PhcVCahSVEAeyUtleDLXadAG6YMwY+W1UzmG8ud3MMfExKj7tKO2TGxZusg2NVFM
kmTrCmI8JcizmoldSmQUQPqv0BlDbNf2FxeZqftjEyNa0AodQ08xPtLMhHJPW36A
Pr9INm45/qADPfUoi/GMp8SKxj2pqRQc5tYhqd5Xv++f+l2tldXmgHRZ4A6KjwSE
tlCMArm5siwNfifZEFTx5SaOjkX0WlfNzO2NMmLjLh/hefH2KqSNwzY2RaNr3Daf
CMRP5B2j1TjcbJJsmjdKcnpkL+NUBKC8unnlgae9R8RWEbr3ttXMCv2YSLLXuKN7
EgoZkgo5P9fSGFrCnUtiYmcw/+kZ7M/GS72pBHt41wwrTwX1oOl7aT5MaVcj/9OW
1C2l0bzr4L/BELqdruJ3S/Q7kUfHdK2Oe4ViL/Zl53pxUIQdeR5cBYN2GNMZBHfY
iZqD57g2NeW1uvPSaNrpqZKPGWLTvJHq04r5MQF28kynubQ0TSc=
=pDG3
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
