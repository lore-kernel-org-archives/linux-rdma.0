From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Thu, 27 Sep 2018 15:42:24 -0700
Message-ID: <CAKwvOd=qNZsfSFJUFZqBbSYt4T_T7TudohzhTqpigvDAHek78A@mail.gmail.com>
References: <20180924195716.30848-1-natechancellor@gmail.com>
 <CAKwvOdkr+ovYgmqWENHkCcAWMC+xC6NYne6SBycq_KXscpHxEQ@mail.gmail.com>
 <20180924222737.GA26973@flashbox> <CAKwvOdkZ-0k4BhXYz0wj3wXNyy95nKFe9aYXxXveLafuviGG2w@mail.gmail.com>
 <20180925023722.GA32600@ziepe.ca> <20180927010803.GA7640@flashbox>
 <20180927044826.GC24889@ziepe.ca> <CAKwvOdnmg2XY6K-8jTna3EKR1Nx04gOm6ZoywUwQO_CSANR_jg@mail.gmail.com>
 <20180927202849.GA11120@flashbox> <CAKwvOdnMOcdKPNHwKbcsg8rJX3_hDTgY752Nb4hgMC2D4p5aRg@mail.gmail.com>
 <20180927222821.GC28301@ziepe.ca> <1538087622.226558.8.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1538087622.226558.8.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bvanassche@acm.org
Cc: jgg@ziepe.ca, Nathan Chancellor <natechancellor@gmail.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 3:33 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On Thu, 2018-09-27 at 16:28 -0600, Jason Gunthorpe wrote:
> > On Thu, Sep 27, 2018 at 01:34:16PM -0700, Nick Desaulniers wrote:
> >
> > > > Neither ib_qp_create_flags nor mlx4_ib_qp_flags have negative values, is
> > > > signedness necessary?
> > >
> > > enums are by default restricted to the range of ints.
> >
> > That's not quite right, the compiler sizes the enum to be able to fit
> > the largest value contained within, today that is int, but if we added
> > 1<<31, then it would become larger.
>
> Hi Jason,
>
> Are you perhaps confusing C and C++? For C++, an enumeration whose underlying
> type is not fixed, the underlying type is an integral type that can represent
> all the enumerator values defined in the enumeration. For C however I think
> that enumeration values are restricted to what fits in an int.
>
> Bart.
>

To quote the sacred texts (ANSIIISO9899-1990):

6.5.2.2 Enumeration specifiers
The expression that defines the value of an enumeration constant shall
be an integral constant
expression that has a value representable as an int.
-- 
Thanks,
~Nick Desaulniers
