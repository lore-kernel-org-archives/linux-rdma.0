From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Mon, 24 Sep 2018 20:37:22 -0600
Message-ID: <20180925023722.GA32600@ziepe.ca>
References: <20180924195716.30848-1-natechancellor@gmail.com>
 <CAKwvOdkr+ovYgmqWENHkCcAWMC+xC6NYne6SBycq_KXscpHxEQ@mail.gmail.com>
 <20180924222737.GA26973@flashbox>
 <CAKwvOdkZ-0k4BhXYz0wj3wXNyy95nKFe9aYXxXveLafuviGG2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdkZ-0k4BhXYz0wj3wXNyy95nKFe9aYXxXveLafuviGG2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 24, 2018 at 03:29:38PM -0700, Nick Desaulniers wrote:
> On Mon, Sep 24, 2018 at 3:27 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > On Mon, Sep 24, 2018 at 03:24:36PM -0700, Nick Desaulniers wrote:
> > > On Mon, Sep 24, 2018 at 12:57 PM Nathan Chancellor
> > > <natechancellor@gmail.com> wrote:
> > > >
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
> > > >
> > > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > > index e463d3007a35..f6f4d9e3c8ed 100644
> > > > +++ b/include/rdma/ib_verbs.h
> > > > @@ -1149,7 +1149,7 @@ struct ib_qp_init_attr {
> > > >         struct ib_qp_cap        cap;
> > > >         enum ib_sig_type        sq_sig_type;
> > > >         enum ib_qp_type         qp_type;
> > > > -       enum ib_qp_create_flags create_flags;
> > > > +       u32                     create_flags;
> > >
> > > I think it might be better to just have explicit casts at the
> > > assignment.  What do the maintainers think?
> > >
> >
> > That's fine with me, I tend to explicitly cast if it is only one
> > location but it certainly makes sense in this case as well. I'll
> > wait for the maintainers to weigh in before sending a v2.
> 
> Yeah, I mean my opinion on this might seem arbitrary, but based on the
> pattern and the comment in ib_qp_create_flags, those enum values are
> reserved to be "subclassed" in a sense, so they should always be in
> sync or this code will have bigger problems.

One should not use an 'enum' type name for bitfield storage, as once
you start or'ing things together the values no longer fall on the
enum. Some compilers and tools even give warnings in this case, ie

   enum x foo = X_A | X_B;

Is an assignment from 'int' to an 'enum x' with an implicit cast.

For this reason, usually bitfield enum declarations should be
anonymous.

Jason
