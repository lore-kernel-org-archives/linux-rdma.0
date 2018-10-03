From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Wed, 3 Oct 2018 17:01:01 -0600
Message-ID: <20181003230101.GC3466@ziepe.ca>
References: <20180924195716.30848-1-natechancellor@gmail.com>
 <20181003223518.GA8700@ziepe.ca>
 <CAKwvOdnvXDtBAw_6_MSOEst3DBjbr8w6Pv6b4i=pC50s=gcq3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdnvXDtBAw_6_MSOEst3DBjbr8w6Pv6b4i=pC50s=gcq3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 03, 2018 at 03:53:58PM -0700, Nick Desaulniers wrote:
> On Wed, Oct 3, 2018 at 3:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Mon, Sep 24, 2018 at 12:57:16PM -0700, Nathan Chancellor wrote:
> > > Clang warns when one enumerated type is implicitly converted to another.
> > >
> > > drivers/infiniband/hw/mlx4/mad.c:1811:41: warning: implicit conversion
> > > from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> > > type 'enum ib_qp_create_flags' [-Wenum-conversion]
> > >                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_TUNNEL_QP;
> > >                                                     ~ ^~~~~~~~~~~~~~~~~~~~~~~
> > >
> > > drivers/infiniband/hw/mlx4/mad.c:1819:41: warning: implicit conversion
> > > from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> > > type 'enum ib_qp_create_flags' [-Wenum-conversion]
> > >                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_SQP;
> > >                                                     ~ ^~~~~~~~~~~~~~~~~
> > >
> > > The type mlx4_ib_qp_flags explicitly provides supplemental values to the
> > > type ib_qp_create_flags. Make that clear to Clang by changing the
> > > create_flags type to u32.
> > >
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > >  include/rdma/ib_verbs.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Applied to for-next, thanks
> >
> > BTW, how are you compiling with clang?
> 
> https://github.com/ClangBuiltLinux/linux/wiki/Steps-for-compiling-the-kernel-with-Clang
> try it out, let us know bugs you find here:
> https://github.com/ClangBuiltLinux/linux/issues

Oh I see, you are doing ARM64!

> Still looking into the case you pointed out earlier.  I suspect the
> signedness of enums was undefined in c90, then defined as
> implementation specific in c99 (though I'm still researching that
> book report).  Thanks for your insights!

C enums details are a topic that seems more confusing every time it
gets brought up :(

Jason
