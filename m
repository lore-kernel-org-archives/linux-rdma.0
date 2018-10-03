From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Wed, 3 Oct 2018 16:09:10 -0700
Message-ID: <CAKwvOdmFy1t0MrcD1WKq1pKc0MiV2iTRgAbpvU0sbNUR63P3Zg@mail.gmail.com>
References: <20180924195716.30848-1-natechancellor@gmail.com>
 <20181003223518.GA8700@ziepe.ca> <CAKwvOdnvXDtBAw_6_MSOEst3DBjbr8w6Pv6b4i=pC50s=gcq3Q@mail.gmail.com>
 <20181003230101.GC3466@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003230101.GC3466@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@ziepe.ca
Cc: Nathan Chancellor <natechancellor@gmail.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 3, 2018 at 4:01 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Oct 03, 2018 at 03:53:58PM -0700, Nick Desaulniers wrote:
> > On Wed, Oct 3, 2018 at 3:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Mon, Sep 24, 2018 at 12:57:16PM -0700, Nathan Chancellor wrote:
> > > > Clang warns when one enumerated type is implicitly converted to another.
> > > >
> > > > drivers/infiniband/hw/mlx4/mad.c:1811:41: warning: implicit conversion
> > > > from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> > > > type 'enum ib_qp_create_flags' [-Wenum-conversion]
> > > >                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_TUNNEL_QP;
> > > >                                                     ~ ^~~~~~~~~~~~~~~~~~~~~~~
> > > >
> > > > drivers/infiniband/hw/mlx4/mad.c:1819:41: warning: implicit conversion
> > > > from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> > > > type 'enum ib_qp_create_flags' [-Wenum-conversion]
> > > >                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_SQP;
> > > >                                                     ~ ^~~~~~~~~~~~~~~~~
> > > >
> > > > The type mlx4_ib_qp_flags explicitly provides supplemental values to the
> > > > type ib_qp_create_flags. Make that clear to Clang by changing the
> > > > create_flags type to u32.
> > > >
> > > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > >  include/rdma/ib_verbs.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > Applied to for-next, thanks
> > >
> > > BTW, how are you compiling with clang?
> >
> > https://github.com/ClangBuiltLinux/linux/wiki/Steps-for-compiling-the-kernel-with-Clang
> > try it out, let us know bugs you find here:
> > https://github.com/ClangBuiltLinux/linux/issues
>
> Oh I see, you are doing ARM64!

Well, it's the first arch I'm focusing on.  X86_64 and ARM32 are also
a priority.  Open source contributors are filing bugs against powerpc,
x86, and even risc-v.  I'm helping them with code review or putting
them in contact with the relevant parties.

We're going to talk more about this effort at Linux Plumbers
Conference in November if you're going.

>
> > Still looking into the case you pointed out earlier.  I suspect the
> > signedness of enums was undefined in c90, then defined as
> > implementation specific in c99 (though I'm still researching that
> > book report).  Thanks for your insights!
>
> C enums details are a topic that seems more confusing every time it
> gets brought up :(
>
> Jason



-- 
Thanks,
~Nick Desaulniers
