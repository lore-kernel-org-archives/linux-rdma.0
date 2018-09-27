From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Thu, 27 Sep 2018 13:28:49 -0700
Message-ID: <20180927202849.GA11120@flashbox>
References: <20180924195716.30848-1-natechancellor@gmail.com>
 <CAKwvOdkr+ovYgmqWENHkCcAWMC+xC6NYne6SBycq_KXscpHxEQ@mail.gmail.com>
 <20180924222737.GA26973@flashbox>
 <CAKwvOdkZ-0k4BhXYz0wj3wXNyy95nKFe9aYXxXveLafuviGG2w@mail.gmail.com>
 <20180925023722.GA32600@ziepe.ca>
 <20180927010803.GA7640@flashbox>
 <20180927044826.GC24889@ziepe.ca>
 <CAKwvOdnmg2XY6K-8jTna3EKR1Nx04gOm6ZoywUwQO_CSANR_jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdnmg2XY6K-8jTna3EKR1Nx04gOm6ZoywUwQO_CSANR_jg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 01:13:31PM -0700, Nick Desaulniers wrote:
> On Wed, Sep 26, 2018 at 9:48 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Wed, Sep 26, 2018 at 06:08:03PM -0700, Nathan Chancellor wrote:
> > > On Mon, Sep 24, 2018 at 08:37:22PM -0600, Jason Gunthorpe wrote:
> > > > On Mon, Sep 24, 2018 at 03:29:38PM -0700, Nick Desaulniers wrote:
> > > > > On Mon, Sep 24, 2018 at 3:27 PM Nathan Chancellor
> > > > > <natechancellor@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Sep 24, 2018 at 03:24:36PM -0700, Nick Desaulniers wrote:
> > > > > > > On Mon, Sep 24, 2018 at 12:57 PM Nathan Chancellor
> > > > > > > <natechancellor@gmail.com> wrote:
> > > > > > > >
> > > > > > > > Clang warns when one enumerated type is implicitly converted to another.
> > > > > > > >
> > > > > > > > drivers/infiniband/hw/mlx4/mad.c:1811:41: warning: implicit conversion
> > > > > > > > from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> > > > > > > > type 'enum ib_qp_create_flags' [-Wenum-conversion]
> > > > > > > >                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_TUNNEL_QP;
> > > > > > > >                                                     ~ ^~~~~~~~~~~~~~~~~~~~~~~
> > > > > > > >
> > > > > > > > drivers/infiniband/hw/mlx4/mad.c:1819:41: warning: implicit conversion
> > > > > > > > from enumeration type 'enum mlx4_ib_qp_flags' to different enumeration
> > > > > > > > type 'enum ib_qp_create_flags' [-Wenum-conversion]
> > > > > > > >                 qp_init_attr.init_attr.create_flags = MLX4_IB_SRIOV_SQP;
> > > > > > > >                                                     ~ ^~~~~~~~~~~~~~~~~
> > > > > > > >
> > > > > > > > The type mlx4_ib_qp_flags explicitly provides supplemental values to the
> > > > > > > > type ib_qp_create_flags. Make that clear to Clang by changing the
> > > > > > > > create_flags type to u32.
> > > > > > > >
> > > > > > > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > > > > > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > > > > > >  include/rdma/ib_verbs.h | 2 +-
> > > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > >
> > > > > > > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > > > > > > index e463d3007a35..f6f4d9e3c8ed 100644
> > > > > > > > +++ b/include/rdma/ib_verbs.h
> > > > > > > > @@ -1149,7 +1149,7 @@ struct ib_qp_init_attr {
> > > > > > > >         struct ib_qp_cap        cap;
> > > > > > > >         enum ib_sig_type        sq_sig_type;
> > > > > > > >         enum ib_qp_type         qp_type;
> > > > > > > > -       enum ib_qp_create_flags create_flags;
> > > > > > > > +       u32                     create_flags;
> > > > > > >
> > > > > > > I think it might be better to just have explicit casts at the
> > > > > > > assignment.  What do the maintainers think?
> > > > > > >
> > > > > >
> > > > > > That's fine with me, I tend to explicitly cast if it is only one
> > > > > > location but it certainly makes sense in this case as well. I'll
> > > > > > wait for the maintainers to weigh in before sending a v2.
> > > > >
> > > > > Yeah, I mean my opinion on this might seem arbitrary, but based on the
> > > > > pattern and the comment in ib_qp_create_flags, those enum values are
> > > > > reserved to be "subclassed" in a sense, so they should always be in
> > > > > sync or this code will have bigger problems.
> > > >
> > > > One should not use an 'enum' type name for bitfield storage, as once
> > > > you start or'ing things together the values no longer fall on the
> > > > enum. Some compilers and tools even give warnings in this case, ie
> > > >
> > > >    enum x foo = X_A | X_B;
> > > >
> > > > Is an assignment from 'int' to an 'enum x' with an implicit cast.
> > > >
> > > > For this reason, usually bitfield enum declarations should be
> > > > anonymous.
> > > >
> > > > Jason
> > >
> > > Hi Jason,
> > >
> > > I apologize for not understanding but how should I adjust my patch so
> > > that it is acceptable? Do you want the explicit casts like Nick
> > > suggested?
> >
> > No, I think your original patch is fine, I was waiting to see if you
> > or Nick disagreed with my assessment on bitfields..
> 
> It wasn't clear to me whether you were ack'ing or nack'ing the patch.
> If we don't change the patch to explicit casts, shouldn't the change
> be to make create_flags an int? (note: signedness)
> 
> -- 
> Thanks,
> ~Nick Desaulniers

Neither ib_qp_create_flags nor mlx4_ib_qp_flags have negative values, is
signedness necessary?

Nathan
